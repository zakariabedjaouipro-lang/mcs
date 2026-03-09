/// WebRTC Service
/// Handles WebRTC peer connections and media streams for video calls
library;

import 'package:flutter_webrtc/flutter_webrtc.dart';

/// WebRTC service for managing peer connections and media streams
class WebRTCService {
  /// STUN server for NAT traversal
  static const String _stunServer = 'stun:stun.l.google.com:19302';

  /// Local media stream
  MediaStream? localStream;

  /// Remote media stream
  MediaStream? remoteStream;

  /// RTCPeerConnection for the current session
  RTCPeerConnection? peerConnection;

  /// Initialize the WebRTC peer connection
  Future<void> initializePeerConnection() async {
    final configuration = {
      'iceServers': [
        {
          'urls': [_stunServer],
        },
      ],
    };

    peerConnection = await createPeerConnection(configuration);
  }

  /// Get local media stream (audio + video)
  Future<MediaStream?> getLocalStream({
    bool audio = true,
    bool video = true,
  }) async {
    try {
      final constraints = <String, dynamic>{
        'audio': audio,
        'video': video
            ? <String, dynamic>{
                'mandatory': <String, dynamic>{
                  'minWidth': 320,
                  'minHeight': 240,
                  'minFrameRate': 15,
                },
                'facingMode': 'user',
                'optional': <dynamic>[],
              }
            : false,
      };

      localStream = await navigator.mediaDevices.getUserMedia(constraints);

      if (peerConnection != null && localStream != null) {
        for (final track in localStream!.getTracks()) {
          await peerConnection!.addTrack(track, localStream!);
        }
      }

      return localStream;
    } catch (e) {
      rethrow;
    }
  }

  /// Add ICE candidate
  Future<bool> addCandidate(RTCIceCandidate candidate) async {
    if (peerConnection == null) return false;
    try {
      await peerConnection!.addCandidate(candidate);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Create offer for peer connection
  Future<RTCSessionDescription?> createOffer() async {
    if (peerConnection == null) return null;
    try {
      final offer = await peerConnection!.createOffer();
      await peerConnection!.setLocalDescription(offer);
      return offer;
    } catch (e) {
      return null;
    }
  }

  /// Create answer for peer connection
  Future<RTCSessionDescription?> createAnswer() async {
    if (peerConnection == null) return null;
    try {
      final answer = await peerConnection!.createAnswer();
      await peerConnection!.setLocalDescription(answer);
      return answer;
    } catch (e) {
      return null;
    }
  }

  /// Set remote description
  Future<bool> setRemoteDescription(RTCSessionDescription description) async {
    if (peerConnection == null) return false;
    try {
      await peerConnection!.setRemoteDescription(description);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Close the peer connection and cleanup resources
  Future<void> closePeerConnection() async {
    try {
      // Stop all local tracks
      if (localStream != null) {
        for (final track in localStream!.getTracks()) {
          await track.stop();
        }
      }

      // Close peer connection
      if (peerConnection != null) {
        await peerConnection!.close();
      }

      localStream = null;
      remoteStream = null;
      peerConnection = null;
    } catch (e) {
      rethrow;
    }
  }

  /// Set remote stream
  // This is a public field now, no setter needed

  /// Get stats from peer connection
  Future<List<StatsReport>?> getStats() async {
    if (peerConnection == null) return null;
    try {
      return await peerConnection!.getStats();
    } catch (e) {
      return null;
    }
  }
}
