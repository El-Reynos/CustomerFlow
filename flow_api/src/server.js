import app from './app.js';
import connectDatabase from './config/database.js';
import dotenv from 'dotenv';

dotenv.config();

const PORT = process.env.PORT || 8000;

// Conectar a la base de datos
connectDatabase();

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
  console.log(`📝 Endpoints disponibles:`);
  console.log(`   GET    /entries - Obtener todas las entries`);
  console.log(`   POST   /entries - Crear una nueva entry`);
  console.log(`   POST   /entries/:id - Actualizar una entry`);
  console.log(`   DELETE /entries/:id - Eliminar una entry`);
});

