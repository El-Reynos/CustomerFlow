// Middleware para manejo de errores
export const errorHandler = (err, req, res, next) => {
  console.error('Error:', err);
  
  res.status(err.status || 500).json({
    success: false,
    error: err.message || 'Error interno del servidor'
  });
};

// Middleware para manejar rutas no encontradas
export const notFoundHandler = (req, res) => {
  res.status(404).json({
    success: false,
    error: 'Ruta no encontrada'
  });
};

