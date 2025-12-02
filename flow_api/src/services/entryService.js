import Entry from '../models/Entry.js';

// Funciones puras para validación
const validateEntryData = (data) => {
  const errors = [];
  
  if (!data.description || typeof data.description !== 'string') {
    errors.push('El campo description es requerido y debe ser un string');
  }
  
  if (!data.expectedArrival) {
    errors.push('El campo expectedArrival es requerido');
  } else if (!(data.expectedArrival instanceof Date) && isNaN(Date.parse(data.expectedArrival))) {
    errors.push('El campo expectedArrival debe ser una fecha válida');
  }
  
  if (!data.createdBy || typeof data.createdBy !== 'string') {
    errors.push('El campo createdBy es requerido y debe ser un string');
  }
  
  return {
    isValid: errors.length === 0,
    errors
  };
};

// Servicio para obtener todas las entries
export const getAllEntries = async (createdBy) => {
  try {
    const query = createdBy ? { createdBy } : {};
    const entries = await Entry.find(query).sort({ createdAt: -1 });
    return {
      success: true,
      data: entries
    };
  } catch (error) {
    return {
      success: false,
      error: error.message
    };
  }
};

// Servicio para obtener una entry por _id
export const getEntryById = async (_id) => {
  try {
    const entry = await Entry.findById(_id);
    if (!entry) {
      return {
        success: false,
        error: 'Entry no encontrada'
      };
    }
    return {
      success: true,
      data: entry
    };
  } catch (error) {
    return {
      success: false,
      error: error.message
    };
  }
};

// Servicio para crear una entry
export const createEntry = async (entryData) => {
  const validation = validateEntryData(entryData);
  
  if (!validation.isValid) {
    return {
      success: false,
      error: validation.errors.join(', ')
    };
  }
  
  try {
    const expectedArrival = new Date(entryData.expectedArrival);
    const newEntry = new Entry({
      description: entryData.description,
      expectedArrival,
      createdBy: entryData.createdBy
    });
    
    const savedEntry = await newEntry.save();
    return {
      success: true,
      data: savedEntry
    };
  } catch (error) {
    return {
      success: false,
      error: error.message
    };
  }
};

// Servicio para actualizar una entry
export const updateEntry = async (_id, updateData) => {
  try {
    const entry = await Entry.findById(_id);
    if (!entry) {
      return {
        success: false,
        error: 'Entry no encontrada'
      };
    }
    
    // Validar datos de actualización si se proporcionan
    if (updateData.expectedArrival) {
      const date = new Date(updateData.expectedArrival);
      if (isNaN(date.getTime())) {
        return {
          success: false,
          error: 'expectedArrival debe ser una fecha válida'
        };
      }
      updateData.expectedArrival = date;
    }
    
    // Actualizar campos permitidos
    Object.keys(updateData).forEach(key => {
      if (['description', 'expectedArrival', 'createdBy'].includes(key)) {
        entry[key] = updateData[key];
      }
    });
    
    const updatedEntry = await entry.save();
    return {
      success: true,
      data: updatedEntry
    };
  } catch (error) {
    return {
      success: false,
      error: error.message
    };
  }
};

// Servicio para eliminar una entry
export const deleteEntry = async (_id) => {
  try {
    const entry = await Entry.findByIdAndDelete(_id);
    if (!entry) {
      return {
        success: false,
        error: 'Entry no encontrada'
      };
    }
    return {
      success: true,
      data: { message: 'Entry eliminada exitosamente' }
    };
  } catch (error) {
    return {
      success: false,
      error: error.message
    };
  }
};

