import { Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import { v4 as uuidv4 } from 'uuid';
import { z } from 'zod';
import { inMemoryDb } from '../database/db';
import { config } from '../config';
import { User, AuthTokenPayload } from '../types';

const sendOtpSchema = z.object({
  phoneNumber: z.string().min(8).max(18),
  countryCode: z.string().min(1).max(6).default('+91'),
});

const verifyOtpSchema = z.object({
  phoneNumber: z.string().min(8).max(18),
  otp: z.string().length(6),
  name: z.string().min(1).max(100).optional(),
});

export const sendOtp = async (req: Request, res: Response): Promise<void> => {
  try {
    const parseResult = sendOtpSchema.safeParse(req.body);
    if (!parseResult.success) {
      res.status(400).json({ success: false, errors: parseResult.error.format() });
      return;
    }

    const { phoneNumber, countryCode } = parseResult.data;
    // Development default OTP is '123456' for seamless sandbox testing
    const otpCode = config.nodeEnv === 'production' ? Math.floor(100000 + Math.random() * 900000).toString() : '123456';
    const expiresAt = Date.now() + 5 * 60 * 1000; // 5 mins

    inMemoryDb.otps.set(phoneNumber, { code: otpCode, expiresAt });

    console.log(`[AUTH] Sent OTP ${otpCode} to ${countryCode}${phoneNumber}`);

    res.status(200).json({
      success: true,
      message: 'OTP sent successfully.',
      sandboxOtp: config.nodeEnv !== 'production' ? otpCode : undefined,
    });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const verifyOtp = async (req: Request, res: Response): Promise<void> => {
  try {
    const parseResult = verifyOtpSchema.safeParse(req.body);
    if (!parseResult.success) {
      res.status(400).json({ success: false, errors: parseResult.error.format() });
      return;
    }

    const { phoneNumber, otp, name } = parseResult.data;
    const storedOtpRecord = inMemoryDb.otps.get(phoneNumber);

    if (!storedOtpRecord || storedOtpRecord.code !== otp || Date.now() > storedOtpRecord.expiresAt) {
      res.status(400).json({ success: false, message: 'Invalid or expired OTP code.' });
      return;
    }

    // Clear used OTP
    inMemoryDb.otps.delete(phoneNumber);

    // Find or create user
    let userId = inMemoryDb.phoneToUserId.get(phoneNumber);
    let user: User;

    if (userId && inMemoryDb.users.has(userId)) {
      user = inMemoryDb.users.get(userId)!;
      if (name && !user.name) {
        user.name = name;
        user.updatedAt = new Date();
      }
    } else {
      userId = uuidv4();
      user = {
        id: userId,
        phoneNumber,
        countryCode: '+91',
        name: name || 'Namasty User',
        about: 'Namasty! Baat karo, dil se.',
        avatarUrl: `https://api.dicebear.com/7.x/bottts/svg?seed=${phoneNumber}`,
        isOnline: true,
        lastSeen: new Date(),
        status: 'active',
        createdAt: new Date(),
        updatedAt: new Date(),
      };
      inMemoryDb.users.set(userId, user);
      inMemoryDb.phoneToUserId.set(phoneNumber, userId);
    }

    // Sign JWT Tokens
    const payload: AuthTokenPayload = { userId: user.id, phoneNumber: user.phoneNumber };
    const accessToken = jwt.sign(payload, config.jwtSecret, { expiresIn: '15d' });
    const refreshToken = jwt.sign(payload, config.jwtRefreshSecret, { expiresIn: '60d' });

    res.status(200).json({
      success: true,
      message: 'Authentication successful.',
      data: {
        user,
        accessToken,
        refreshToken,
      },
    });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};
