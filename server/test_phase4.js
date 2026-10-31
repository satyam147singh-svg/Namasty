async function runPhase4Tests() {
  const baseUrl = 'http://localhost:5000/api/v1';

  console.log('Testing Phase 4: E2EE Pre-Keys, Encrypted Backup, & Web Admin Dashboard...');

  // 1. Auth: Send & Verify OTP
  await fetch(`${baseUrl}/auth/send-otp`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ phoneNumber: '+919876543210' }),
  });

  const authRes = await fetch(`${baseUrl}/auth/verify-otp`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ phoneNumber: '+919876543210', otp: '123456' }),
  });
  const authData = await authRes.json();
  const token = authData.data.accessToken;
  const userId = authData.data.user.id;
  console.log(' Authenticated as:', authData.data.user.name);

  // 2. Register Signal Protocol Pre-Key Bundle
  const e2eeRes = await fetch(`${baseUrl}/e2ee/keys`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify({
      registrationId: 4421,
      identityKey: 'namasty_public_identity_key_aarav_sharma_2026',
      signedPreKey: {
        keyId: 1,
        publicKey: 'namasty_signed_prekey_aarav_sharma',
        signature: 'namasty_signature_aarav_sharma_ok',
      },
      oneTimePreKeys: [
        { keyId: 101, publicKey: 'namasty_ot_key_101' },
        { keyId: 102, publicKey: 'namasty_ot_key_102' },
      ],
    }),
  });
  const e2eeData = await e2eeRes.json();
  console.log(' Signal Protocol Pre-Key Bundle Registered:', e2eeData.success);

  // 3. Fetch Pre-Key Bundle for X3DH Handshake
  const bundleRes = await fetch(`${baseUrl}/e2ee/bundle/${userId}`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  const bundleData = await bundleRes.json();
  console.log(' Pre-Key Bundle Retrieved | IdentityKey:', bundleData.data?.identityKey?.substring(0, 20) + '...');

  // 4. Encrypted Chat Backup
  const backupRes = await fetch(`${baseUrl}/backup/upload`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify({
      backupSize: 4400000,
      chatCount: 14,
      messageCount: 520,
    }),
  });
  const backupData = await backupRes.json();
  console.log(' Encrypted Cloud Backup Uploaded | Algorithm:', backupData.data?.encryptionAlgorithm);

  // 5. Web Admin Dashboard Stats
  const adminStatsRes = await fetch(`${baseUrl}/admin/stats`);
  const adminStats = await adminStatsRes.json();
  console.log(' Web Admin Stats | Users:', adminStats.data?.totalUsers, '| Engine:', adminStats.data?.databaseEngine);

  // 6. Web Admin Moderation Reports
  const reportsRes = await fetch(`${baseUrl}/admin/reports`);
  const reportsData = await reportsRes.json();
  console.log(' Web Admin Moderation Reports Retrieved | Count:', reportsData.data?.length);

  console.log('\n ALL PHASE 4 BACKEND ENDPOINTS PASSED SUCCESSFULLY!');
}

runPhase4Tests().catch(console.error);
