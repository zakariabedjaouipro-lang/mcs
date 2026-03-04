# WebRTC Signaling Server Setup

## Overview
This document explains how to set up a Node.js signaling server for WebRTC video calls.

## Prerequisites
- Node.js (v18 or higher)
- npm or yarn

## Installation

### 1. Create a new Node.js project
```bash
mkdir mcs-signaling-server
cd mcs-signaling-server
npm init -y
```

### 2. Install dependencies
```bash
npm install express socket.io cors
npm install --save-dev nodemon
```

### 3. Create the server file
Create `server.js` with the following code:

```javascript
const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const cors = require('cors');

const app = express();
app.use(cors());

const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  },
});

// Store active users and calls
const users = new Map();
const calls = new Map();

// Socket.IO connection handling
io.on('connection', (socket) => {
  console.log('User connected:', socket.id);

  // User joins
  socket.on('join', ({ userId }) => {
    users.set(socket.id, userId);
    console.log('User joined:', userId);
  });

  // Start a call
  socket.on('call', ({ callerId, calleeId, callId }) => {
    const calleeSocketId = Array.from(users.entries()).find(
      ([_, id]) => id === calleeId
    )?.[0];

    if (calleeSocketId) {
      io.to(calleeSocketId).emit('incoming-call', {
        callerId,
        callId,
      });
      calls.set(callId, { callerId, calleeId, status: 'calling' });
    } else {
      socket.emit('call-rejected', { callId, reason: 'User not found' });
    }
  });

  // Accept call
  socket.on('accept-call', ({ callerId, calleeId, callId }) => {
    const callerSocketId = Array.from(users.entries()).find(
      ([_, id]) => id === callerId
    )?.[0];

    if (callerSocketId) {
      io.to(callerSocketId).emit('call-accepted', { callId });
      calls.set(callId, { callerId, calleeId, status: 'connected' });
    }
  });

  // Reject call
  socket.on('reject-call', ({ callerId, calleeId, callId }) => {
    const callerSocketId = Array.from(users.entries()).find(
      ([_, id]) => id === callerId
    )?.[0];

    if (callerSocketId) {
      io.to(callerSocketId).emit('call-rejected', { callId });
      calls.delete(callId);
    }
  });

  // WebRTC Signaling
  socket.on('offer', ({ sdp, callerId, calleeId, callId }) => {
    const calleeSocketId = Array.from(users.entries()).find(
      ([_, id]) => id === calleeId
    )?.[0];

    if (calleeSocketId) {
      io.to(calleeSocketId).emit('offer', { sdp, callerId, callId });
    }
  });

  socket.on('answer', ({ sdp, callerId, calleeId, callId }) => {
    const callerSocketId = Array.from(users.entries()).find(
      ([_, id]) => id === callerId
    )?.[0];

    if (callerSocketId) {
      io.to(callerSocketId).emit('answer', { sdp, calleeId, callId });
    }
  });

  socket.on('ice-candidate', ({ candidate, targetId }) => {
    const targetSocketId = Array.from(users.entries()).find(
      ([_, id]) => id === targetId
    )?.[0];

    if (targetSocketId) {
      io.to(targetSocketId).emit('ice-candidate', { candidate });
    }
  });

  // End call
  socket.on('end-call', ({ callerId, calleeId, callId }) => {
    const otherUserId = socket.id === callerId ? calleeId : callerId;
    const otherSocketId = Array.from(users.entries()).find(
      ([_, id]) => id === otherUserId
    )?.[0];

    if (otherSocketId) {
      io.to(otherSocketId).emit('call-ended', { callId });
    }
    calls.delete(callId);
  });

  // Disconnect
  socket.on('disconnect', () => {
    const userId = users.get(socket.id);
    users.delete(socket.id);
    console.log('User disconnected:', userId);
  });
});

const PORT = process.env.PORT || 3001;
server.listen(PORT, () => {
  console.log(`Signaling server running on port ${PORT}`);
});
```

### 4. Update package.json
```json
{
  "name": "mcs-signaling-server",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "cors": "^2.8.5",
    "express": "^4.18.2",
    "socket.io": "^4.7.2"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  }
}
```

## Running the Server

### Development
```bash
npm run dev
```

### Production
```bash
npm start
```

The server will run on `http://localhost:3001` by default.

## Update Flutter App

Update the signaling URL in `webrtc_video_call_service.dart`:

```dart
static const String _signalingUrl = 'http://YOUR_SERVER_URL:3001';
```

For local development:
```dart
static const String _signalingUrl = 'http://localhost:3001';
```

For production (replace with your server URL):
```dart
static const String _signalingUrl = 'https://your-signaling-server.com';
```

## Deployment Options

### 1. Vercel
```bash
npm install -g vercel
vercel
```

### 2. Heroku
```bash
heroku create mcs-signaling
git push heroku main
```

### 3. AWS EC2 / DigitalOcean / VPS
Deploy the Node.js server to any VPS provider.

## Security Considerations

1. **Authentication**: Implement user authentication
2. **HTTPS**: Use HTTPS in production for WebRTC
3. **Rate Limiting**: Add rate limiting to prevent abuse
4. **CORS**: Configure CORS properly for production

## Troubleshooting

### Connection Issues
- Check firewall settings
- Verify the signaling server URL
- Ensure both users are connected to the signaling server

### Ice Connection Failed
- Add more STUN/TURN servers
- Check network connectivity
- Verify ICE candidates are being exchanged

### Audio/Video Not Working
- Check camera/microphone permissions
- Verify media constraints
- Test with different browsers/devices