import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
import morgan from 'morgan';

import apiRoutes from './routes/apiRoutes.js';

dotenv.config();
const app = express();

// Middleware global
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

// Routing
app.use('/', apiRoutes);

// Global error handler
app.use((err, req, res, next) => {
  console.error('🔥 Internal Server Error:', err);
  res.status(500).json({ error: 'Terjadi kesalahan di server' });
});

// Start server
const PORT = process.env.PORT || 8000;
app.listen(PORT, () => {
  console.log(`🚀 Server berjalan di http://localhost:${PORT}`);
});
