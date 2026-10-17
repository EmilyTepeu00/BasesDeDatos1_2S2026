const sql = require('mssql');
require('dotenv').config();

const config = {
    server: process.env.DB_SERVER,
    port: parseInt(process.env.DB_PORT, 10),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE,
    options: {
        encrypt: true,
        trustServerCertificate: true
    }
};

let pool;

async function getPool() {
    if (pool) return pool;
    pool = await sql.connect(config);
    console.log('Conectado a SQL Server:', process.env.DB_DATABASE);
    return pool;
}

module.exports = { sql, getPool };
