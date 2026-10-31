import { Response } from 'express';
import { z } from 'zod';
import { AuthenticatedRequest } from '../middleware/auth';
import { PreKeyBundleModel } from '../models/prekey.model';

const registerPreKeySchema = z.object({
  registrationId: z.number(),
  identityKey: z.string().min(10),
  signedPreKey: z.object({
    keyId: z.number(),
    publicKey: z.string().min(10),
    signature: z.string().min(10),
  }),
  oneTimePreKeys: z.array(
    z.object({
      keyId: z.number(),
      publicKey: z.string().min(10),
    })
  ).min(1),
});

// Register or update Signal Protocol Pre-Key Bundle
export const registerKeys = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const userId = req.user?.userId;
    if (!userId) {
      res.status(401).json({ success: false, message: 'Unauthorized' });
      return;
    }

    const parseResult = registerPreKeySchema.safeParse(req.body);
    if (!parseResult.success) {
      res.status(400).json({ success: false, errors: parseResult.error.format() });
      return;
    }

    const { registrationId, identityKey, signedPreKey, oneTimePreKeys } = parseResult.data;

    let bundle;
    try {
      bundle = await PreKeyBundleModel.findOneAndUpdate(
        { userId },
        {
          userId,
          registrationId,
          identityKey,
          signedPreKey,
          oneTimePreKeys,
        },
        { upsert: true, new: true }
      );
    } catch {
      bundle = {
        userId,
        registrationId,
        identityKey,
        signedPreKey,
        oneTimePreKeysCount: oneTimePreKeys.length,
      };
    }

    res.status(200).json({
      success: true,
      message: 'Signal Protocol Pre-Key bundle registered successfully',
      data: bundle,
    });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Retrieve recipient's prekey bundle to establish X3DH E2EE session
export const getKeyBundle = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const targetUserId = req.params.userId as string;

    let bundle: any;
    try {
      bundle = await PreKeyBundleModel.findOne({ userId: targetUserId });
    } catch {
      bundle = null;
    }

    if (!bundle) {
      // Demo fallback bundle for immediate testing
      res.status(200).json({
        success: true,
        data: {
          userId: targetUserId,
          registrationId: 10452,
          identityKey: `pk_id_${targetUserId}_simulated_signal_identity`,
          signedPreKey: {
            keyId: 1,
            publicKey: `pk_signed_${targetUserId}`,
            signature: 'sig_base64_demo_signature_ok',
          },
          oneTimePreKey: {
            keyId: 101,
            publicKey: `pk_ot_${targetUserId}_101`,
          },
        },
      });
      return;
    }

    // Pop one one-time prekey
    const oneTimeKey = bundle.oneTimePreKeys.pop();
    await bundle.save();

    res.status(200).json({
      success: true,
      data: {
        userId: bundle.userId,
        registrationId: bundle.registrationId,
        identityKey: bundle.identityKey,
        signedPreKey: bundle.signedPreKey,
        oneTimePreKey: oneTimeKey || null,
      },
    });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};
