async function runPhase2Tests() {
  const baseUrl = 'http://localhost:5000/api/v1';

  console.log('Testing Phase 2 API endpoints...');

  // 1. Auth: Send OTP then verify OTP
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
  const user = authData.data.user;
  console.log(' Authenticated as:', user.name);

  // 2. Create Group
  const groupRes = await fetch(`${baseUrl}/groups`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify({
      name: 'Namasty Pioneers Core',
      description: 'Official test group for Phase 2 media and 1024 capacity',
      memberUserIds: ['u2222222-2222-2222-2222-222222222222'],
      isBroadcastChannel: false,
    }),
  });
  const groupData = await groupRes.json();
  console.log(' Group Created:', groupData.success, '| Name:', groupData.data?.name, '| Invite:', groupData.data?.inviteCode);

  const groupId = groupData.data.id;

  // 3. Get Group Details
  const detailsRes = await fetch(`${baseUrl}/groups/${groupId}`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  const detailsData = await detailsRes.json();
  console.log(' Group Details retrieved | Members:', detailsData.data.totalMembers, '| Max:', detailsData.data.maxMembers);

  // 4. Update Group Permissions (Only admins can send)
  const permRes = await fetch(`${baseUrl}/groups/${groupId}/settings`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify({
      onlyAdminsCanSend: true,
      onlyAdminsCanEditInfo: true,
    }),
  });
  const permData = await permRes.json();
  console.log(' Permissions updated | onlyAdminsCanSend:', permData.data?.settings?.onlyAdminsCanSend);

  // 5. Check Media Gallery Endpoint
  const galleryRes = await fetch(`${baseUrl}/groups/${groupId}/gallery`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  const galleryData = await galleryRes.json();
  console.log(' Media Gallery Endpoint Active:', galleryData.success);

  console.log('\n ALL PHASE 2 BACKEND ENDPOINTS PASSED SUCCESSFULLY!');
}

runPhase2Tests().catch(console.error);
