const { sql, getPool } = require('../config/db');

const columnCache = new Map();

async function getColumns(table) {
    if (columnCache.has(table)) return columnCache.get(table);
    const pool = await getPool();
    const result = await pool.request()
        .input('t', table)
        .query('SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @t');
    const cols = new Set(result.recordset.map(r => r.COLUMN_NAME));
    columnCache.set(table, cols);
    return cols;
}

async function validateBody(table, body) {
    if (!body || typeof body !== 'object' || Array.isArray(body)) {
        return { error: 'El cuerpo debe ser un objeto JSON' };
    }
    const keys = Object.keys(body);
    if (keys.length === 0) {
        return { error: 'El cuerpo de la petición está vacío' };
    }
    const valid = await getColumns(table);
    const invalid = keys.filter(k => !valid.has(k));
    if (invalid.length > 0) {
        return { error: `Columnas no válidas para ${table}: ${invalid.join(', ')}` };
    }
    return { keys };
}

async function getIdentityColumn(table) {
    const pool = await getPool();
    const result = await pool.request()
        .input('t', table)
        .query('SELECT name FROM sys.identity_columns WHERE object_id = OBJECT_ID(@t)');
    return result.recordset.length > 0 ? result.recordset[0].name : null;
}

function statusFor(err) {
    return [245, 8114, 8115, 8169].includes(err.number) ? 400 : 500;
}

function crudFactory(router, { table, pk, insertTrigger = false }) {
    const pkCols = Array.isArray(pk) ? pk : [pk];

    router.get('/', async (req, res) => {
        try {
            const pool = await getPool();
            const result = await pool.request().query(`SELECT * FROM ${table}`);
            res.json(result.recordset);
        } catch (err) {
            res.status(500).json({ error: err.message });
        }
    });

    router.get('/:id', async (req, res) => {
        try {
            const ids = req.params.id.split(',');
            if (ids.length !== pkCols.length) {
                return res.status(400).json({ error: `Se esperan ${pkCols.length} valor(es) de id: ${pkCols.join(',')}` });
            }
            const pool = await getPool();
            const request = pool.request();
            const where = pkCols.map((col, i) => {
                request.input(col, ids[i]);
                return `${col} = @${col}`;
            }).join(' AND ');
            const result = await request.query(`SELECT * FROM ${table} WHERE ${where}`);
            if (result.recordset.length === 0) {
                return res.status(404).json({ error: `${table} no encontrado` });
            }
            res.json(result.recordset[0]);
        } catch (err) {
            res.status(statusFor(err)).json({ error: err.message });
        }
    });

    router.post('/', async (req, res) => {
        try {
            const check = await validateBody(table, req.body);
            if (check.error) return res.status(400).json({ error: check.error });

            const pool = await getPool();
            const request = pool.request();
            const columns = check.keys;
            columns.forEach(col => request.input(col, req.body[col]));
            const colList = columns.join(', ');
            const paramList = columns.map(c => '@' + c).join(', ');

            let query;
            if (insertTrigger) {
                const clientSendsPk = pkCols.every(c => columns.includes(c));
                const where = clientSendsPk
                    ? pkCols.map(c => `${c} = @${c}`).join(' AND ')
                    : `${pkCols[0]} = SCOPE_IDENTITY()`;
                query = `INSERT INTO ${table} (${colList}) VALUES (${paramList}); SELECT * FROM ${table} WHERE ${where}`;
            } else {
                query = `INSERT INTO ${table} (${colList}) OUTPUT INSERTED.* VALUES (${paramList})`;
            }

            const result = await request.query(query);
            res.status(201).json(result.recordset[0]);
        } catch (err) {
            res.status(400).json({ error: err.message });
        }
    });

    router.post('/bulk', async (req, res) => {
        const rows = req.body;
        if (!Array.isArray(rows) || rows.length === 0) {
            return res.status(400).json({ error: 'El cuerpo debe ser un arreglo JSON con al menos un registro' });
        }
        const historico = req.query.historico === 'true';
        let tx;
        let identityOn = false;
        try {
            const pool = await getPool();
            const identityCol = await getIdentityColumn(table);
            await getColumns(table);
            const usaIdentity = identityCol !== null &&
                rows.some(r => r && Object.prototype.hasOwnProperty.call(r, identityCol));

            tx = new sql.Transaction(pool);
            await tx.begin();
            if (historico) {
                await new sql.Request(tx).query(`DISABLE TRIGGER ALL ON ${table}`);
            }
            if (usaIdentity) {
                await new sql.Request(tx).query(`SET IDENTITY_INSERT ${table} ON`);
                identityOn = true;
            }

            for (let i = 0; i < rows.length; i++) {
                const check = await validateBody(table, rows[i]);
                if (check.error) {
                    throw new Error(`Registro ${i + 1}: ${check.error}`);
                }
                const request = new sql.Request(tx);
                check.keys.forEach(col => request.input(col, rows[i][col]));
                const colList = check.keys.join(', ');
                const paramList = check.keys.map(c => '@' + c).join(', ');
                try {
                    const antes = usaIdentity ? `SET IDENTITY_INSERT ${table} ON; ` : '';
                    const despues = usaIdentity ? `; SET IDENTITY_INSERT ${table} OFF` : '';
                    await request.query(`${antes}INSERT INTO ${table} (${colList}) VALUES (${paramList})${despues}`);
                } catch (err) {
                    throw new Error(`Registro ${i + 1}: ${err.message}`);
                }
            }

            if (usaIdentity) {
                await new sql.Request(tx).query(`SET IDENTITY_INSERT ${table} OFF`);
                identityOn = false;
            }
            if (historico) {
                await new sql.Request(tx).query(`ENABLE TRIGGER ALL ON ${table}`);
            }
            await tx.commit();
            res.status(201).json({
                insertados: rows.length,
                modo: historico ? 'historico: triggers desactivados solo durante la carga' : 'normal'
            });
        } catch (err) {
            try { if (identityOn && tx) await new sql.Request(tx).query(`SET IDENTITY_INSERT ${table} OFF`); } catch (_) {}
            try { if (tx) await tx.rollback(); } catch (_) {}
            res.status(400).json({ error: err.message, insertados: 0 });
        }
    });

    router.put('/:id', async (req, res) => {
        try {
            const ids = req.params.id.split(',');
            if (ids.length !== pkCols.length) {
                return res.status(400).json({ error: `Se esperan ${pkCols.length} valor(es) de id: ${pkCols.join(',')}` });
            }
            const check = await validateBody(table, req.body);
            if (check.error) return res.status(400).json({ error: check.error });

            const pool = await getPool();
            const request = pool.request();
            pkCols.forEach((col, i) => request.input(col, ids[i]));
            const columns = check.keys;
            columns.forEach(col => request.input('u_' + col, req.body[col]));

            const setClause = columns.map(col => `${col} = @u_${col}`).join(', ');
            const whereClause = pkCols.map(col => `${col} = @${col}`).join(' AND ');

            const result = await request.query(
                `UPDATE ${table} SET ${setClause} OUTPUT INSERTED.* WHERE ${whereClause}`
            );
            if (result.recordset.length === 0) {
                return res.status(404).json({ error: `${table} no encontrado` });
            }
            res.json(result.recordset[0]);
        } catch (err) {
            res.status(400).json({ error: err.message });
        }
    });

    router.delete('/:id', async (req, res) => {
        try {
            const ids = req.params.id.split(',');
            if (ids.length !== pkCols.length) {
                return res.status(400).json({ error: `Se esperan ${pkCols.length} valor(es) de id: ${pkCols.join(',')}` });
            }
            const pool = await getPool();
            const request = pool.request();
            const where = pkCols.map((col, i) => {
                request.input(col, ids[i]);
                return `${col} = @${col}`;
            }).join(' AND ');
            const result = await request.query(`DELETE FROM ${table} WHERE ${where}`);
            if (result.rowsAffected[0] === 0) {
                return res.status(404).json({ error: `${table} no encontrado` });
            }
            res.status(204).send();
        } catch (err) {
            res.status(400).json({ error: err.message });
        }
    });
}

crudFactory.validateBody = validateBody;
module.exports = crudFactory;
