/// WebRTC Video Call Service (Updated)
/// Uses WebRTC for peer-to-peer video calls with signaling via Socket.IO
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mcs/core/config/env.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:supabase_flutter/supabase_flutter.dart';


/// WebRTC Video Call Service
class VideoCallService {
  static String get _signalingUrl => Env.signalingUrl;

  io.Socket? _socket;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  final List<RTCIceCandidate> _remoteIceCandidates = [];
  String? _callId;
  String? _currentUserId;
  String? _remoteUserId;

  // Configuration for WebRTC
  final Map<String, dynamic> _configuration = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {'urls': 'stun:stun1.l.google.com:19302'},
      {'urls': 'stun:stun2.l.google.com:19302'},
    ],
  };

  final Map<String, dynamic> _constraints = {
    'audio': true,
    'video': {
      'mandatory': {
        'minWidth': '640',
        'minHeight': '480',
        'minFrameRate': '30',
      },
      'facingMode': 'user',
      'optional': [],
    },
  };

  // Streams
  final _localStreamController = StreamController<MediaStream>.broadcast();
  final _remoteStreamController = StreamController<MediaStream>.broadcast();
  final _callStateController = StreamController<VideoCallState>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  Stream<MediaStream> get localStream => _localStreamController.stream;
  Stream<MediaStream> get remoteStream => _remoteStreamController.stream;
  Stream<VideoCallState> get callState => _callStateController.stream;
  Stream<String> get errors => _errorController.stream;

  bool get isInCall => _peerConnection != null && _callId != null;
  String? get callId => _callId;

  /// Initialize the service
  Future<void> initialize({required String userId}) async {
    _currentUserId = userId;

    try {
      await _connectToSignalingServer();
      debugPrint('VideoCallService: Initialized successfully');
    } catch (e) {
      debugPrint('VideoCallService: Initialization error - $e');
      _errorController.add('Failed to initialize: $e');
      rethrow;
    }
  }

  /// Connect to signaling server
  Future<void> _connectToSignalingServer() async {
    _socket = io.io(
      _signalingUrl,
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    _socket!.connect();

    _socket!.on('connect', (_) {
      debugPrint('VideoCallService: Connected to signaling server');
      _socket!.emit('join', {'userId': _currentUserId});
    });

    _socket!.on('disconnect', (_) {
      debugPrint('VideoCallService: Disconnected from signaling server');
      _endCall();
    });

    _socket!.on('incoming-call', (data) async {
      debugPrint('VideoCallService: Incoming call from ${data['callerId']}');
      _remoteUserId = data['callerId'] as String?;
      _callId = data['callId'] as String?;
      _callStateController.add(VideoCallState.incoming);
    });

    _socket!.on('call-accepted', (data) async {
      debugPrint('VideoCallService: Call accepted');
      _callStateController.add(VideoCallState.connected);
      await _createPeerConnection();
      await _createOffer();
    });

    _socket!.on('call-rejected', (data) {
      debugPrint('VideoCallService: Call rejected');
      _callStateController.add(VideoCallState.ended);
      _errorController.add('Call was rejected');
    });

    _socket!.on('offer', (data) async {
      debugPrint('VideoCallService: Received offer');
      _callId = data['callId'] as String?;
      _remoteUserId = data['callerId'] as String?;

      await _createPeerConnection();
      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(data['sdp'] as String, 'offer'),
      );

      await _createAnswer();
    });

    _socket!.on('answer', (data) async {
      debugPrint('VideoCallService: Received answer');
      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(data['sdp'] as String, 'answer'),
      );
    });

    _socket!.on('ice-candidate', (data) async {
      debugPrint('VideoCallService: Received ICE candidate');
      final candidate = RTCIceCandidate(
        data['candidate'] as String,
        data['sdpMid'] as String?,
        data['sdpMLineIndex'] as int?,
      );

      if (_peerConnection != null) {
        await _peerConnection!.addCandidate(candidate);
      } else {
        _remoteIceCandidates.add(candidate);
      }
    });
  }

  /// Start a video call
  Future<void> startCall({required String remoteUserId}) async {
    if (_socket == null || !_socket!.connected) {
      throw Exception('Not connected to signaling server');
    }

    _remoteUserId = remoteUserId;
    _callId = 'call_${DateTime.now().millisecondsSinceEpoch}';

    try {
      await _createPeerConnection();
      await _getUserMedia();

      _socket!.emit('call', {
        'callerId': _currentUserId,
        'calleeId': remoteUserId,
        'callId': _callId ?? '',
      });

      _callStateController.add(VideoCallState.calling);
      debugPrint('VideoCallService: Call started');
    } catch (e) {
      debugPrint('VideoCallService: Start call error - $e');
      _errorController.add('Failed to start call: $e');
      rethrow;
    }
  }

  /// Accept an incoming call
  Future<void> acceptCall() async {
    if (_socket == null || !_socket!.connected) {
      throw Exception('Not connected to signaling server');
    }

    try {
      await _createPeerConnection();
      await _getUserMedia();

      _socket!.emit('accept-call', {
        'callerId': _remoteUserId ?? '',
        'calleeId': _currentUserId,
        'callId': _callId ?? '',
      });

      _callStateController.add(VideoCallState.connected);
      debugPrint('VideoCallService: Call accepted');
    } catch (e) {
      debugPrint('VideoCallService: Accept call error - $e');
      _errorController.add('Failed to accept call: $e');
      rethrow;
    }
  }

  /// Reject an incoming call
  Future<void> rejectCall() async {
    if (_socket == null) return;

    _socket!.emit('reject-call', {
      'callerId': _remoteUserId ?? '',
      'calleeId': _currentUserId,
      'callId': _callId ?? '',
    });

    _endCall();
    debugPrint('VideoCallService: Call rejected');
  }

  /// End the current call
  Future<void> endCall() async {
    if (_socket == null) return;

    _socket!.emit('end-call', {
      'callerId': _currentUserId,
      'calleeId': _remoteUserId ?? '',
      'callId': _callId ?? '',
    });

    _endCall();
    debugPrint('VideoCallService: Call ended');
  }

  /// Toggle camera
  Future<void> toggleCamera() async {
    if (_localStream == null) return;

    final videoTrack = _localStream!.getVideoTracks()[0];
    await Helper.switchCamera(videoTrack);
    debugPrint('VideoCallService: Camera toggled');
  }

  /// Toggle microphone
  Future<void> toggleMicrophone() async {
    if (_localStream == null) return;

    final audioTrack = _localStream!.getAudioTracks()[0];
    audioTrack.enabled = !audioTrack.enabled;
    debugPrint('VideoCallService: Microphone toggled');
  }

  /// Toggle video
  Future<void> toggleVideo() async {
    if (_localStream == null) return;

    final videoTrack = _localStream!.getVideoTracks()[0];
    videoTrack.enabled = !videoTrack.enabled;
    debugPrint('VideoCallService: Video toggled');
  }

  /// Create peer connection
  Future<void> _createPeerConnection() async {
    _peerConnection = await createPeerConnection(_configuration);

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      debugPrint('VideoCallService: ICE candidate generated');
      _socket!.emit('ice-candidate', {
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'targetId': _remoteUserId ?? '',
      });
    };

    _peerConnection!.onAddStream = (MediaStream stream) {
      debugPrint('VideoCallService: Remote stream added');
      _remoteStream = stream;
      _remoteStreamController.add(stream);
    };

    _peerConnection!.onIceConnectionState = (RTCIceConnectionState state) {
      debugPrint('VideoCallService: ICE connection state: $state');

      switch (state) {
        case RTCIceConnectionState.RTCIceConnectionStateNew:
        case RTCIceConnectionState.RTCIceConnectionStateChecking:
        case RTCIceConnectionState.RTCIceConnectionStateCompleted:
          break;
        case RTCIceConnectionState.RTCIceConnectionStateConnected:
          _callStateController.add(VideoCallState.connected);
        case RTCIceConnectionState.RTCIceConnectionStateDisconnected:
        case RTCIceConnectionState.RTCIceConnectionStateFailed:
        case RTCIceConnectionState.RTCIceConnectionStateClosed:
          _callStateController.add(VideoCallState.ended);
        default:
          break;
      }
    };
  }

  /// Create offer
  Future<void> _createOffer() async {
    final offer = await _peerConnection!.createOffer(_constraints);
    await _peerConnection!.setLocalDescription(offer);

    _socket!.emit('offer', {
      'sdp': offer.sdp,
      'callerId': _currentUserId,
      'calleeId': _remoteUserId ?? '',
      'callId': _callId ?? '',
    });
  }

  /// Create answer
  Future<void> _createAnswer() async {
    final answer = await _peerConnection!.createAnswer(_constraints);
    await _peerConnection!.setLocalDescription(answer);

    _socket!.emit('answer', {
      'sdp': answer.sdp,
      'callerId': _currentUserId,
      'calleeId': _remoteUserId ?? '',
      'callId': _callId ?? '',
    });
  }

  /// Get user media
  Future<void> _getUserMedia() async {
    try {
      _localStream = await navigator.mediaDevices.getUserMedia(_constraints);
      _localStreamController.add(_localStream!);

      if (_peerConnection != null) {
        _localStream!.getTracks().forEach((track) {
          _peerConnection!.addTrack(track, _localStream!);
        });
      }

      debugPrint('VideoCallService: User media obtained');
    } catch (e) {
      debugPrint('VideoCallService: Get user media error - $e');
      _errorController.add('Failed to access camera/microphone: $e');
      rethrow;
    }
  }

  /// End call internally
  void _endCall() {
    _localStream?.getTracks().forEach((track) => track.stop());
    _localStream?.dispose();
    _localStream = null;

    _remoteStream?.dispose();
    _remoteStream = null;

    _peerConnection?.close();
    _peerConnection = null;

    _callId = null;
    _remoteUserId = null;

    _callStateController.add(VideoCallState.ended);
  }

  /// Dispose resources
  void dispose() {
    _endCall();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;

    _localStreamController.close();
    _remoteStreamController.close();
    _callStateController.close();
    _errorController.close();
  }
}

/// Video call states
enum VideoCallState {
  idle,
  calling,
  incoming,
  connected,
  ended,
}
