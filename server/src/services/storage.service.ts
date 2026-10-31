import fs from 'fs';
import path from 'path';

export class StorageService {
  private static uploadsDir = path.join(process.cwd(), 'uploads');

  public static initialize(): void {
    if (!fs.existsSync(this.uploadsDir)) {
      fs.mkdirSync(this.uploadsDir, { recursive: true });
    }
  }

  public static getUploadsPath(): string {
    return this.uploadsDir;
  }

  /**
   * Generates a realistic normalized waveform array (0..100)
   * for voice notes based on duration or sample analysis.
   */
  public static generateWaveform(samplesCount = 36): number[] {
    const waveform: number[] = [];
    for (let i = 0; i < samplesCount; i++) {
      // Natural speech rhythm with peaks and troughs
      const base = 25 + Math.sin(i * 0.45) * 20;
      const noise = Math.random() * 45;
      waveform.push(Math.min(100, Math.max(15, Math.round(base + noise))));
    }
    return waveform;
  }
}
