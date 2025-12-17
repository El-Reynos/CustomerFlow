import express from 'express';
import cors from 'cors';
import entryRoutes from './routes/entryRoutes.js';
import { errorHandler, notFoundHandler } from './middleware/errorHandler.js';
import { requestLogger } from './middleware/requestLogger.js';

const app = express();

// Middleware para CORS
app.use(cors());

// Middleware para parsing JSON
app.use(express.json());

// Middleware para logging
app.use(requestLogger);

// Rutas
app.use('/entries', entryRoutes);

// Ruta de salud
app.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'API funcionando correctamente' });
});

// Manejo de rutas no encontradas
app.use(notFoundHandler);

// Manejo de errores
app.use(errorHandler);

export default app;

