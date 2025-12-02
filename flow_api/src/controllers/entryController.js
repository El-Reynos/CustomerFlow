import * as entryService from '../services/entryService.js';

// Controlador para obtener todas las entries
export const getAllEntries = async (req, res) => {
  const createdBy = req.query.createdBy;
  const result = await entryService.getAllEntries(createdBy);
  
  if (result.success) {
    res.status(200).json({
      success: true,
      data: result.data
    });
  } else {
    res.status(500).json({
      success: false,
      error: result.error
    });
  }
};

// Controlador para obtener una entry por id
export const getEntryById = async (req, res) => {
  const { id } = req.params;
  const result = await entryService.getEntryById(id);
  
  if (result.success) {
    res.status(200).json({
      success: true,
      data: result.data
    });
  } else {
    res.status(404).json({
      success: false,
      error: result.error
    });
  }
};

// Controlador para crear una entry
export const createEntry = async (req, res) => {
  const result = await entryService.createEntry(req.body);
  
  if (result.success) {
    res.status(201).json({
      success: true,
      data: result.data
    });
  } else {
    res.status(400).json({
      success: false,
      error: result.error
    });
  }
};

// Controlador para actualizar una entry
export const updateEntry = async (req, res) => {
  const { id } = req.params;
  const result = await entryService.updateEntry(id, req.body);
  
  if (result.success) {
    res.status(200).json({
      success: true,
      data: result.data
    });
  } else {
    res.status(404).json({
      success: false,
      error: result.error
    });
  }
};

// Controlador para eliminar una entry
export const deleteEntry = async (req, res) => {
  const { id } = req.params;
  const result = await entryService.deleteEntry(id);
  
  if (result.success) {
    res.status(200).json({
      success: true,
      data: result.data
    });
  } else {
    res.status(404).json({
      success: false,
      error: result.error
    });
  }
};

