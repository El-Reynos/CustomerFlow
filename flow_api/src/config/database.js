import mongoose from 'mongoose';
import dotenv from 'dotenv';

dotenv.config();

const connectDatabase = async () => {
  try {
    const mongoUri = process.env.MONGODB_URI || 'mongodb://localhost:27017/flow_db';
    await mongoose.connect(mongoUri);
    console.log('✅ Base de datos conectada exitosamente');
  } catch (error) {
    console.error('❌ Error al conectar la base de datos:', error.message);
    process.exit(1);
  }
};

export default connectDatabase;

