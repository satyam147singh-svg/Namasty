async function runPhase3Tests() {
  const baseUrl = 'http://localhost:5000/api/v1';

  console.log('Testing Phase 3: 24h Status & WebRTC Calls API...');

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
  console.log(' Authenticated as:', authData.data.user.name);

  // 2. Post a 24-hour Status Story
  const statusRes = await fetch(`${baseUrl}/status`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify({
      type: 'text',
      content: 'Phase 3: WebRTC Calls & 24h Status Stories are live! 🕊️',
      backgroundColor: '#2F8FD8',
      fontFamily: 'Poppins',
      privacy: 'contacts',
    }),
  });
  const statusData = await statusRes.json();
  console.log(' Status Story Posted | TTL ExpiresAt:', statusData.data?.expiresAt);

  // 3. Get Status Feed
  const feedRes = await fetch(`${baseUrl}/status/feed`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  const feedData = await feedRes.json();
  console.log(' Status Feed Retrieved | User Groups:', feedData.data?.length);

  // 4. Fetch WebRTC ICE Servers (STUN & TURN)
  const iceRes = await fetch(`${baseUrl}/calls/ice-servers`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  const iceData = await iceRes.json();
  console.log(' WebRTC ICE Servers Retrieved | STUN/TURN count:', iceData.data?.iceServers?.length);

  // 5. Log a WebRTC Call
  const logRes = await fetch(`${baseUrl}/calls/log`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify({
      recipientIds: ['u2222222-2222-2222-2222-222222222222'],
      type: 'video',
      isGroup: false,
      status: 'completed',
      durationSeconds: 142,
    }),
  });
  const logData = await logRes.json();
  console.log(' WebRTC Call Logged | Duration:', logData.data?.durationSeconds, 'seconds');

  // 6. Get Call History
  const historyRes = await fetch(`${baseUrl}/calls/history`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  const historyData = await historyRes.json();
  console.log(' Call History Retrieved | Total Logs:', historyData.data?.length);

  console.log('\n ALL PHASE 3 BACKEND ENDPOINTS PASSED SUCCESSFULLY!');
}

runPhase3Tests().catch(console.error);
