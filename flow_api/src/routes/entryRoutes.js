import express from 'express';
import * as entryController from '../controllers/entryController.js';

const router = express.Router();

// GET /entries - Obtener todas las entries
router.get('/', entryController.getAllEntries);

// POST /entries - Crear una nueva entry
router.post('/', entryController.createEntry);

// POST /entries/:id - Actualizar una entry
router.post('/:id', entryController.updateEntry);

// DELETE /entries/:id - Eliminar una entry
router.delete('/:id', entryController.deleteEntry);

export default router;

