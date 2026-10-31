import dotenv from 'dotenv';
dotenv.config();

export const config = {
  port: parseInt(process.env.PORT || '5000', 10),
  nodeEnv: process.env.NODE_ENV || 'development',
  jwtSecret: process.env.JWT_SECRET || 'namasty_sky_blue_secret_key_2026_super_secure',
  jwtRefreshSecret: process.env.JWT_REFRESH_SECRET || 'namasty_sky_blue_refresh_token_secret_2026',
  mongoUri: process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/namasty_messenger',
  useInMemoryFallback: process.env.USE_IN_MEMORY_FALLBACK !== 'false',
  redisHost: process.env.REDIS_HOST || '127.0.0.1',
  redisPort: parseInt(process.env.REDIS_PORT || '6379', 10),
  clientOrigin: process.env.CLIENT_ORIGIN || '*',
};
