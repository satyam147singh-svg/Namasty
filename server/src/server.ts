import http from 'http';
import { Server } from 'socket.io';
import { createApp } from './app';
import { config } from './config';
import { connectDatabase } from './database/db';
import { setupSocketHandlers } from './sockets/chat.socket';
import { setupCallSocketHandlers } from './sockets/call.socket';

const startServer = async () => {
  // Connect to MongoDB
  await connectDatabase();

  const app = createApp();
  const server = http.createServer(app);

  // Setup Socket.IO with CORS
  const io = new Server(server, {
    cors: {
      origin: config.clientOrigin,
      methods: ['GET', 'POST'],
      credentials: true,
    },
    pingTimeout: 60000,
    pingInterval: 25000,
  });

  // Attach real-time messaging & WebRTC signaling handlers
  setupSocketHandlers(io);
  setupCallSocketHandlers(io);

  server.listen(config.port, () => {
    console.log(`
=============================================================
  🕊️  NAMASTY - MESSENGER BACKEND RUNNING
  Tagline: "Namasty! Baat karo, dil se."
  Database:    MongoDB (${config.mongoUri})
  Environment: ${config.nodeEnv}
  REST API:    http://localhost:${config.port}/api/v1
  WebSocket:   ws://localhost:${config.port}
  Health:      http://localhost:${config.port}/health
=============================================================
    `);
  });
};

startServer().catch((err) => {
  console.error('Fatal Server Error:', err);
  process.exit(1);
});
