/// WebRTC Service
/// Handles WebRTC peer connections and media streams for video calls
library;

import 'package:flutter_webrtc/flutter_webrtc.dart';

/// WebRTC service for managing peer connections and media streams
class WebRTCService {
  /// STUN server for NAT traversal
  static const String _stunServer = 'stun:stun.l.google.com:19302';

  /// RTCPeerConnection for the current session
  RTCPeerConnection? _peerConnection;

  /// Local media stream
  MediaStream? _localStream;

  /// Remote media stream
  MediaStream? _remoteStream;

  /// Get the local media stream
  MediaStream? get localStream => _localStream;

  /// Get the remote media stream
  MediaStream? get remoteStream => _remoteStream;

  /// Get the peer connection
  RTCPeerConnection? get peerConnection => _peerConnection;

  /// Initialize the WebRTC peer connection
  Future<void> initializePeerConnection() async {
    final configuration = {
      'iceServers': [
        {
          'urls': [_stunServer],
        },
      ],
    };

    _peerConnection = await createPeerConnection(configuration);
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

      _localStream = await navigator.mediaDevices.getUserMedia(constraints);

      if (_peerConnection != null && _localStream != null) {
        for (final track in _localStream!.getTracks()) {
          await _peerConnection!.addTrack(track, _localStream!);
        }
      }

      return _localStream;
    } catch (e) {
      rethrow;
    }
  }

  /// Add ICE candidate
  Future<bool> addCandidate(RTCIceCandidate candidate) async {
    if (_peerConnection == null) return false;
    try {
      await _peerConnection!.addCandidate(candidate);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Create offer for peer connection
  Future<RTCSessionDescription?> createOffer() async {
    if (_peerConnection == null) return null;
    try {
      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      return offer;
    } catch (e) {
      return null;
    }
  }

  /// Create answer for peer connection
  Future<RTCSessionDescription?> createAnswer() async {
    if (_peerConnection == null) return null;
    try {
      final answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      return answer;
    } catch (e) {
      return null;
    }
  }

  /// Set remote description
  Future<bool> setRemoteDescription(RTCSessionDescription description) async {
    if (_peerConnection == null) return false;
    try {
      await _peerConnection!.setRemoteDescription(description);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Close the peer connection and cleanup resources
  Future<void> closePeerConnection() async {
    try {
      // Stop all local tracks
      if (_localStream != null) {
        for (final track in _localStream!.getTracks()) {
          await track.stop();
        }
      }

      // Close peer connection
      if (_peerConnection != null) {
        await _peerConnection!.close();
      }

      _localStream = null;
      _remoteStream = null;
      _peerConnection = null;
    } catch (e) {
      rethrow;
    }
  }

  /// Set remote stream
  set remoteStream(MediaStream? stream) {
    _remoteStream = stream;
  }

  /// Get stats from peer connection
  Future<List<StatsReport>?> getStats() async {
    if (_peerConnection == null) return null;
    try {
      return await _peerConnection!.getStats();
    } catch (e) {
      return null;
    }
  }
}
