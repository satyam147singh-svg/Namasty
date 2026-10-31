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

## 📋 What's Coming in Phase 3
- **Status (Sidebar option 2):** Text, image, and video 24h disappearing status stories, viewers list, privacy controls.
- **WebRTC Voice & Video Calls (Sidebar option 4):** 1-to-1 and group calls (up to 8 participants), signaling server, call history, incoming call screen.
