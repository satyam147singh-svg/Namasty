# Namasty - Messenger 🕊️
> *"Namasty! Baat karo, dil se."*  
> **Package ID:** `com.namasty.messenger`  
> **Brand Theme:** Sky Blue (Aasmani) - 100% Original, Zero Green

---

## 🌟 Deliverables Completed in Phase 1

1. **System Architecture & Database Schema**
   - High-level architecture with Mermaid diagram in `ARCHITECTURE_AND_SCHEMA.md`.
   - Production PostgreSQL DDL schema with relational tables: `users`, `pre_keys`, `chats`, `chat_participants`, `messages`, `message_statuses`, `message_reactions`, `user_contacts`.
   - Evaluation of PostgreSQL vs MongoDB (PostgreSQL selected with partitioned messages & JSONB).

2. **Backend (Node.js + Express + TypeScript + Socket.IO)**
   - Modular clean architecture with TypeScript in `server/`.
   - Real-time Socket.IO handler in `server/src/sockets/chat.socket.ts` (presence, typing indicators, delivery ticks, read receipts, emoji reactions).
   - JWT authentication, OTP verification sandbox (`123456`), user profiles, contact sync, and chat controllers.
   - Built with fallback in-memory store and seed users (`Aarav`, `Priya`, `Rohan`) for instant zero-friction local testing.

3. **Flutter Mobile Client (iOS / Android / Tablet / Desktop)**
   - Clean Architecture in `mobile/`.
   - **Sky Blue (Aasmani) Theme System** (`mobile/lib/core/theme/namasty_theme.dart`):
     - Primary: `#87CEEB` (Sky Blue)
     - Primary dark: `#4BA3D3`
     - Background tint: `#E8F6FD`
     - Surface: `#F4FAFE` (Light mode) / `#0E1A24` (Dark mode)
     - Active sidebar item pill highlight: `#D6EFFB`
     - Sent message bubbles: Sky blue gradient (`#87CEEB` to `#B3E5FC`)
     - Received bubbles: Clean white with soft shadow
     - Zero green anywhere in the application.
   - **Original Vector Brand Identity**:
     - Custom-drawn Namasty Logo (`mobile/lib/core/widgets/namasty_logo.dart` and `mobile/assets/icons/namasty_logo.svg`) featuring the folded-hands (Anjali Mudra / Namaste) motif inside a sky blue speech bubble.
   - **Sidebar Navigation Shell (NO Tabs)**:
     - Top-left hamburger toggle button (`mobile/lib/features/navigation/presentation/widgets/namasty_shell.dart`).
     - Animated slide-in drawer with gradient header, user profile photo, name, and status.
     - 5 Sidebar items in exact requested order:
       1. Chats
       2. Status
       3. Groups
       4. Calls
       5. Profile
     - Active item highlighted with `#D6EFFB` pill background.
     - Swipe-left, tap-outside or tap toggle to close.
     - Responsive Rail mode for tablets and desktop screens.
     - Rounded-square Floating Action Button (FAB).
   - **Splash Screen**:
     - Sky blue gradient with animated Namasty logo and "Namasty! Baat karo, dil se." greeting.
   - **Phone Auth & Profile Setup**:
     - Step 1: Phone number entry (+91).
     - Step 2: 6-digit OTP verification.
     - Step 3: Name & About profile configuration.
   - **1-to-1 Chat System**:
     - Chat list cards with rounded corners (16-20px), rounded-square avatar, unread badges, pin indicators (max 3), search filter.
     - Chat conversation screen with floating rounded input bar, tail-less sky blue gradient bubbles, 1 tick / 2 ticks / blue ticks status, typing simulation, reply banner, and emoji reactions.

---

## 🚀 How to Run and Test Phase 1

### 1. Run the Backend API & WebSocket Server

```bash
# Navigate to the server directory
cd server

# Start the TypeScript development server with hot-reload
npm run dev
```

*The server will boot up on `http://localhost:5000` with both REST API endpoints and Socket.IO real-time gateways.*

#### Test REST API Endpoints:
- **Health Check:**
  ```bash
  curl http://localhost:5000/health
  ```
- **Send OTP (Sandbox default is 123456):**
  ```bash
  curl -X POST http://localhost:5000/api/v1/auth/send-otp -H "Content-Type: application/json" -d "{\"phoneNumber\": \"+919876543210\"}"
  ```
- **Verify OTP:**
  ```bash
  curl -X POST http://localhost:5000/api/v1/auth/verify-otp -H "Content-Type: application/json" -d "{\"phoneNumber\": \"+919876543210\", \"otp\": \"123456\"}"
  ```

---

### 2. Run the Flutter Mobile App

```bash
# Navigate to mobile directory
cd mobile

# Fetch Flutter dependencies
flutter pub get

# Run on connected device, emulator, or Chrome
flutter run
```

---

## 🌟 Deliverables Completed in Phase 2

1. **Rich Media Messaging & Storage Pipeline**
   - **Voice Messages:** Real-time audio waveform player widget with interactive bar heights, play/pause scrubber, and 1.0x / 1.5x / 2.0x playback speed toggling (`mobile/lib/features/chat/presentation/widgets/voice_message_bubble.dart`).
   - **Image & Video Messages:** Rounded message bubbles with preview thumbnails, video duration badge, caption, and full-screen pinch-to-zoom media viewer (`mobile/lib/features/chat/presentation/widgets/image_message_bubble.dart`).
   - **Documents:** Attachment bubbles showing file type badge (PDF, DOCX, ZIP), file size, and download action (`mobile/lib/features/chat/presentation/widgets/document_message_bubble.dart`).
   - **Location:** Map preview card with pin coordinates, title, and address (`mobile/lib/features/chat/presentation/widgets/location_message_bubble.dart`).
   - **Contacts:** Contact card with avatar, name, phone, and direct "Message Contact" action (`mobile/lib/features/chat/presentation/widgets/contact_message_bubble.dart`).
   - **Attachment Bottom Sheet:** Sky Blue picker for Gallery, Camera, Document, Audio, Location, and Contact (`mobile/lib/features/chat/presentation/widgets/chat_attachment_sheet.dart`).
   - **Per-Chat Media Gallery:** Multi-tab screen categorizing "Media", "Docs", and "Links" (`mobile/lib/features/chat/presentation/screens/media_gallery_screen.dart`).
   - **Media Upload Backend:** Multer file storage, audio waveform synthesis (0..100 bars), static `/uploads` serving, and S3 upload architecture (`server/src/controllers/media.controller.ts`).

2. **Full Group Chats & Communities (Up to 1024 Members)**
   - **Group Creation Flow:** Multi-contact selection with search, selected user chips, group name, avatar, description, and broadcast toggle (`mobile/lib/features/groups/presentation/screens/create_group_screen.dart`).
   - **Group Info & Management Screen:** Member count (up to 1024), admin badges, add participants, make admin, dismiss as admin, remove member, leave group (`mobile/lib/features/groups/presentation/screens/group_info_screen.dart`).
   - **Admin Permissions & Broadcast Channels:** Toggle "Only Admins Can Send" and "Only Admins Can Edit Info".
   - **Invite via Link:** Sharable invite links (`https://namasty.app/join/grp-...`) and copy-to-clipboard modal.
   - **Seen-By List:** Modal sheet displaying which members read the message with exact timestamps (`mobile/lib/features/chat/presentation/widgets/message_seen_dialog.dart`).

---

## 🚀 How to Run and Test Phase 2

### 1. Run Automated Phase 2 Backend Verification
```bash
cd server
node test_phase2.js
```
*Tests authentication, group creation with up to 1024 members, invite code generation, permission updates (onlyAdminsCanSend), and the media gallery endpoint.*

### 2. Test Media & Groups on the Flutter App
```bash
cd mobile
flutter run
```
1. Open the sidebar and select **Groups** (Option 3).
2. Tap **"Create New Group"** ➔ Select contacts ➔ Set Group Name & Description ➔ Tap **"Create"**.
3. Tap on the group to open the conversation:
   - Tap the paperclip icon to open the **Sky Blue Attachment Sheet** (Voice, Image, Doc, Location, Contact).
   - Long press any sent message to view the **Seen-By List**.
   - Tap the group header to open **Group Info**: test Admin toggles, invite link sharing, member promotion, and media gallery.

---

## 🌟 Deliverables Completed in Phase 3

1. **24-Hour Disappearing Status Stories (Sidebar Option 2)**
   - **Text & Media Status Composer:** Text composer with palette picker (Namasty Sky Blue `#87CEEB`, Dark Navy `#0E1A24`, Primary Dark `#4BA3D3`, Coral, Lavender) and privacy controls (`mobile/lib/features/status/presentation/screens/create_status_screen.dart`).
   - **Story Viewer Screen:** Full-screen viewer with segmented top progress bars (5s auto-advance, hold to pause, tap left/right to navigate, swipe-up for viewers sheet) (`mobile/lib/features/status/presentation/screens/story_viewer_screen.dart`).
   - **Viewers List (Seen-By):** Tracks who viewed the status with timestamps.
   - **24-Hour MongoDB TTL Auto-Purge:** Mongoose index `{ expiresAt: 1 }, { expireAfterSeconds: 0 }` automatically purges expired stories (`server/src/models/status.model.ts`).
   - **Sky Blue Ring Indicators:** Unviewed stories display a sky blue border ring around contact avatars.

2. **WebRTC Voice & Video Calling (Sidebar Option 4)**
   - **Active Voice & Video Call Screen:** Controls to mute mic, toggle speaker, switch front/rear camera, toggle video off/on, end call (`mobile/lib/features/calls/presentation/screens/active_call_screen.dart`).
   - **Group Calls (Up to 8 Participants):** Split video grid accommodating up to 8 live peer connections with PiP preview for self.
   - **Incoming Call Screen:** Full-screen incoming call notification with pulsing sky blue ripple waves, caller details, and accept/decline buttons (`mobile/lib/features/calls/presentation/screens/incoming_call_screen.dart`).
   - **WebRTC Signaling Gateway:** Socket.IO signaling server managing SDP offers, answers, Trickle ICE candidates, and group call rooms (`server/src/sockets/call.socket.ts`).
   - **STUN & TURN Server Config:** Endpoint returning Google STUN and Coturn TURN configurations for peer NAT traversal (`server/src/controllers/call.controller.ts`).
   - **Call History:** Comprehensive call logs (incoming, outgoing, missed with red arrow indicator) and one-tap call back action (`mobile/lib/features/calls/presentation/screens/calls_screen.dart`).

---

## 🚀 How to Run and Test Phase 3

### 1. Run Automated Phase 3 Backend Verification
```bash
cd server
node test_phase3.js
```
*Tests 24h status creation with MongoDB TTL, status feed retrieval, WebRTC ICE servers configuration, call logging, and call history retrieval.*

### 2. Test in the Flutter App
```bash
cd mobile
flutter run
```
1. **Status Stories:**
   - Tap **Status** (Sidebar Option 2).
   - Tap **"My Status"** or the pen FAB to compose a text status with the sky blue color palette.
   - Tap on any contact status to view the story viewer with top segmented progress bars. Hold to pause, swipe up to view viewers.
2. **WebRTC Voice & Video Calls:**
   - Tap **Calls** (Sidebar Option 4).
   - Tap the ring icon at the top or the FAB to **Simulate Incoming Call** (tests full-screen incoming call UI with pulsing waves).
   - Tap **Accept** to enter the **Active Call Screen**: test mute, speaker, camera flip, and end call.
   - Tap **"Start Group Video Call"** to test the 8-participant split video grid.

---

---

## 🌟 Deliverables Completed in Phase 4

1. **End-to-End Encryption (Signal Protocol & Double Ratchet)**
   - **X3DH Pre-Key Bundle Architecture:** Mongoose collection and REST API to publish and retrieve pre-key bundles (Identity Key, Signed Pre-Key + signature, One-Time Pre-Keys) (`server/src/models/prekey.model.ts`, `server/src/controllers/e2ee.controller.ts`).
   - **Flutter E2EE Cryptographic Engine:** Double Ratchet session state, Whisper Envelope formatting, AES-256-GCM message encryption/decryption, and 60-digit safety numbers calculation (`mobile/lib/core/security/e2ee_service.dart`).
   - **Pre-Key Endpoints:** `POST /api/v1/e2ee/keys` and `GET /api/v1/e2ee/bundle/:userId`.

2. **Encrypted Chat Backup & Restore**
   - **Cloud Backup API:** Encrypted cloud backup upload with hash verification and latest backup metadata retrieval (`server/src/controllers/backup.controller.ts`).
   - **Mobile Backup Management Screen:** Visual stats on last backup date, size, account, manual "Back Up Now" action, auto-backup frequency (Off, Daily, Weekly, Monthly), and "Back up over Wi-Fi only" toggle (`mobile/lib/features/settings/presentation/screens/chat_backup_screen.dart`).

3. **Privacy, Security & App Settings**
   - **Settings Hub:** Clean modern settings hub (`mobile/lib/features/settings/presentation/screens/settings_screen.dart`) integrated with the Namasty sidebar drawer. Includes quick-switch language modal (English, हिन्दी, Hinglish), custom notification rules, chat settings, and storage stats.
   - **Security Settings Screen:** App Lock toggle (Biometric / PIN), Screenshot Blocking toggle (protects confidential chats from screen capture), Two-step verification PIN configuration, and Active Web Sessions manager (`mobile/lib/features/settings/presentation/screens/security_settings_screen.dart`).

4. **Web Admin Dashboard (`/admin`)**
   - **Original Sky Blue UI:** Responsive, modern web portal styled in Namasty's signature palette (`server/public/admin/index.html`).
   - **Real-Time Analytics Metrics:** Total Registered Users, Active Chats, Messages Sent Today, Ongoing WebRTC Calls, and System Uptime.
   - **Interactive User Management:** Search, view user status (Active / Suspended), and one-click instant suspend/reactivate toggles.
   - **Spam & Moderation Queue:** Review user reports with reported reason, reporter details, and "Dismiss" or "Suspend User" actions.
   - **Admin API Endpoints:** `GET /api/v1/admin/stats`, `GET /api/v1/admin/users`, `PUT /api/v1/admin/users/:userId/ban`, `GET /api/v1/admin/reports` (`server/src/controllers/admin.controller.ts`).

---

## 🚀 How to Run and Test Phase 4

### 1. Run Automated Phase 4 Backend Verification
```bash
cd server
node test_phase4.js
```
*Tests E2EE pre-key bundle registration, pre-key retrieval, encrypted backup upload, admin metrics calculation, and moderation report moderation.*

### 2. Access the Web Admin Dashboard
1. Ensure the server is running (`npm run dev` in `server/`).
2. Open your browser and navigate to:
   ```
   http://localhost:5000/admin
   ```
3. Experience the full Sky Blue administrative console:
   - Monitor live user count, chats, messages, and calls.
   - Toggle suspension on demo accounts (`Priya Patel`, `Rohan Verma`).
   - Review and resolve moderation reports.

### 3. Test Security & Backup on the Flutter App
```bash
cd mobile
flutter run
```
1. Open the sidebar and tap the **Settings** button in the drawer footer.
2. Navigate to **Privacy & Security**:
   - Toggle **App Lock** (PIN / Biometric authentication simulation).
   - Toggle **Block Screenshots** (enables secure screen window flags).
   - Set up **Two-Step Verification PIN**.
3. Navigate to **Chat Backup**:
   - Tap **"Back Up Now"** to trigger client-side encryption and upload to the backup server.
   - Change auto-backup frequency to **Daily** and toggle **"Over Wi-Fi only"**.

