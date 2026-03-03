/// Video call service for managing video consultations.
library;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for managing video calls using Agora RTC Engine.
class VideoCallService {
  static const String _appId = 'YOUR_AGORA_APP_ID';
  static const String _appCertificate = 'YOUR_AGORA_APP_CERTIFICATE';

  RtcEngine? _engine;
  String? _channelName;
  String? _token;
  int? _localUid;
  final List<int> _remoteUids = [];

  /// Get the current Agora RTC engine instance.
  RtcEngine? get engine => _engine;

  /// Get the current channel name.
  String? get channelName => _channelName;

  /// Get the current local user ID.
  int? get localUid => _localUid;

  /// Get the list of remote user IDs.
  List<int> get remoteUids => List.unmodifiable(_remoteUids);

  /// Check if a call is currently active.
  bool get isInCall => _engine != null && _channelName != null;

  /// Initialize the Agora RTC engine.
  Future<void> initialize({
    required Function(String) onError,
    required Function(int) onJoinChannelSuccess,
    required Function(int, int) onUserJoined,
    required Function(int, int) onUserOffline,
  }) async {
    if (_engine != null) {
      debugPrint('VideoCallService: Engine already initialized');
      return;
    }

    try {
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(RtcEngineContext(
        appId: _appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));

      // Set event handlers
      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onError: (ErrorCodeType err, String msg) {
            debugPrint('VideoCallService: Error $err - $msg');
            onError(msg);
          },
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint('VideoCallService: Joined channel ${connection.channelId}');
            _localUid = connection.localUid;
            onJoinChannelSuccess(connection.localUid);
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint('VideoCallService: Remote user $remoteUid joined');
            _remoteUids.add(remoteUid);
            onUserJoined(remoteUid, elapsed);
          },
          onUserOffline: (RtcConnection connection, int remoteUid,
              int reason) {
            debugPrint('VideoCallService: Remote user $remoteUid offline');
            _remoteUids.remove(remoteUid);
            onUserOffline(remoteUid, reason);
          },
        ),
      );

      debugPrint('VideoCallService: Engine initialized successfully');
    } catch (e) {
      debugPrint('VideoCallService: Initialization error - $e');
      rethrow;
    }
  }

  /// Generate a token for the channel.
  Future<String> generateToken({
    required String channelName,
    required int uid,
    required int expireTime,
  }) async {
    try {
      // For now, use a placeholder token
      // In production, this should call your backend server
      // which will generate the token using Agora's Token Builder
      final response = await Supabase.instance.client.functions.invoke(
        'generate-agora-token',
        body: {
          'channelName': channelName,
          'uid': uid,
          'expireTime': expireTime,
        },
      );

      final token = response.data['token'] as String?;
      if (token == null || token.isEmpty) {
        throw Exception('Failed to generate token');
      }

      return token;
    } catch (e) {
      debugPrint('VideoCallService: Token generation error - $e');
      // Fallback: return a temporary token for development
      return '006$_appId${_uidToString(uid)}${_generateRandomToken()}';
    }
  }

  /// Join a video call channel.
  Future<void> joinChannel({
    required String channelName,
    required String token,
    required int uid,
    ClientRoleType role = ClientRoleType.clientRoleBroadcaster,
  }) async {
    if (_engine == null) {
      throw Exception('Engine not initialized. Call initialize() first.');
    }

    try {
      _channelName = channelName;
      _token = token;

      await _engine!.setClientRole(role: role);
      await _engine!.joinChannel(
        token: token,
        channelId: channelName,
        uid: uid,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );

      debugPrint('VideoCallService: Joined channel $channelName');
    } catch (e) {
      debugPrint('VideoCallService: Join channel error - $e');
      rethrow;
    }
  }

  /// Leave the current channel.
  Future<void> leaveChannel() async {
    if (_engine == null) return;

    try {
      await _engine!.leaveChannel();
      _channelName = null;
      _token = null;
      _localUid = null;
      _remoteUids.clear();

      debugPrint('VideoCallService: Left channel');
    } catch (e) {
      debugPrint('VideoCallService: Leave channel error - $e');
      rethrow;
    }
  }

  /// Enable/disable local video.
  Future<void> enableLocalVideo(bool enabled) async {
    if (_engine == null) return;

    try {
      await _engine!.enableLocalVideo(enabled);
      debugPrint('VideoCallService: Local video ${enabled ? "enabled" : "disabled"}');
    } catch (e) {
      debugPrint('VideoCallService: Enable local video error - $e');
    }
  }

  /// Enable/disable local audio.
  Future<void> enableLocalAudio(bool enabled) async {
    if (_engine == null) return;

    try {
      await _engine!.enableLocalAudio(enabled);
      debugPrint('VideoCallService: Local audio ${enabled ? "enabled" : "disabled"}');
    } catch (e) {
      debugPrint('VideoCallService: Enable local audio error - $e');
    }
  }

  /// Mute/unmute local audio stream.
  Future<void> muteLocalAudioStream(bool muted) async {
    if (_engine == null) return;

    try {
      await _engine!.muteLocalAudioStream(muted);
      debugPrint('VideoCallService: Local audio ${muted ? "muted" : "unmuted"}');
    } catch (e) {
      debugPrint('VideoCallService: Mute local audio error - $e');
    }
  }

  /// Mute/unmute local video stream.
  Future<void> muteLocalVideoStream(bool muted) async {
    if (_engine == null) return;

    try {
      await _engine!.muteLocalVideoStream(muted);
      debugPrint('VideoCallService: Local video ${muted ? "muted" : "unmuted"}');
    } catch (e) {
      debugPrint('VideoCallService: Mute local video error - $e');
    }
  }

  /// Mute/unmute remote audio stream.
  Future<void> muteRemoteAudioStream(int uid, bool muted) async {
    if (_engine == null) return;

    try {
      await _engine!.muteRemoteAudioStream(uid, mute: muted);
      debugPrint('VideoCallService: Remote audio for $uid ${muted ? "muted" : "unmuted"}');
    } catch (e) {
      debugPrint('VideoCallService: Mute remote audio error - $e');
    }
  }

  /// Mute/unmute remote video stream.
  Future<void> muteRemoteVideoStream(int uid, bool muted) async {
    if (_engine == null) return;

    try {
      await _engine!.muteRemoteVideoStream(uid, mute: muted);
      debugPrint('VideoCallService: Remote video for $uid ${muted ? "muted" : "unmuted"}');
    } catch (e) {
      debugPrint('VideoCallService: Mute remote video error - $e');
    }
  }

  /// Switch camera.
  Future<void> switchCamera() async {
    if (_engine == null) return;

    try {
      await _engine!.switchCamera();
      debugPrint('VideoCallService: Camera switched');
    } catch (e) {
      debugPrint('VideoCallService: Switch camera error - $e');
    }
  }

  /// Release the engine resources.
  Future<void> release() async {
    if (_engine == null) return;

    try {
      await leaveChannel();
      await _engine!.release();
      _engine = null;

      debugPrint('VideoCallService: Engine released');
    } catch (e) {
      debugPrint('VideoCallService: Release engine error - $e');
    }
  }

  /// Convert UID to string for token generation.
  String _uidToString(int uid) {
    return uid.toString().padLeft(10, '0');
  }

  /// Generate a random token for development purposes.
  String _generateRandomToken() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    final sb = StringBuffer();
    for (var i = 0; i < 32; i++) {
      sb.write(chars[(random + i) % chars.length]);
    }
    return sb.toString();
  }

  /// Dispose of the service.
  void dispose() {
    release();
  }
}