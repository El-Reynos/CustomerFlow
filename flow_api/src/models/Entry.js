import mongoose from 'mongoose';

const entrySchema = new mongoose.Schema({
  description: {
    type: String,
    required: true
  },
  expectedArrival: {
    type: Date,
    required: true
  },
  createdBy: {
    type: String,
    required: true
  }
}, {
  timestamps: true
});

const Entry = mongoose.model('Entry', entrySchema);

export default Entry;

