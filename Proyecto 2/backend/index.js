const express = require('express');
const cors = require('cors');
require('dotenv').config();

const routes = require('./routes');

const app = express();
app.use(cors());
app.use(express.json({ limit: '50mb' }));

app.use('/api', routes);

app.get('/', (req, res) => {
    res.json({ mensaje: 'API Comercial La Estrella funcionando' });
});

app.use((err, req, res, next) => {
    if (err.type === 'entity.parse.failed') {
        return res.status(400).json({ error: 'JSON mal formado en el cuerpo de la petición' });
    }
    res.status(500).json({ error: 'Error interno del servidor' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
