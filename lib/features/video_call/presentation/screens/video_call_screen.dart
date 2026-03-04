/// Video Call Screen using WebRTC
library;

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mcs/core/services/video_call_service.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Video Call Screen
class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({
    required this.remoteUserId,
    required this.remoteUserName,
    super.key,
  });

  final String remoteUserId;
  final String remoteUserName;

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late VideoCallService _videoCallService;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  VideoCallState _callState = VideoCallState.idle;

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  bool _isCameraEnabled = true;
  bool _isMicrophoneEnabled = true;
  bool _isSpeakerEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    _videoCallService = VideoCallService();

    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    await _videoCallService.initialize(userId: userId);

    _videoCallService.localStream.listen((MediaStream stream) {
      setState(() {
        _localStream = stream;
        _localRenderer.srcObject = stream;
      });
    });

    _videoCallService.remoteStream.listen((MediaStream stream) {
      setState(() {
        _remoteStream = stream;
        _remoteRenderer.srcObject = stream;
      });
    });

    _videoCallService.callState.listen((VideoCallState state) {
      setState(() {
        _callState = state;
      });
    });

    // Start the call
    await _videoCallService.startCall(remoteUserId: widget.remoteUserId);
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _videoCallService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Remote video (fullscreen)
            if (_remoteStream != null)
              Positioned.fill(
                child: RTCVideoView(_remoteRenderer),
              )
            else
              _buildPlaceholder(),

            // Local video (picture-in-picture)
            if (_localStream != null)
              Positioned(
                top: 16,
                right: 16,
                width: 120,
                height: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: RTCVideoView(_localRenderer),
                ),
              ),

            // Top bar
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: _buildTopBar(),
            ),

            // Bottom controls
            Positioned(
              bottom: 32,
              left: 16,
              right: 16,
              child: _buildControls(),
            ),

            // Connection status
            Positioned(
              top: 80,
              left: 16,
              child: _buildConnectionStatus(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.primary,
              child: Text(
                widget.remoteUserName[0].toUpperCase(),
                style: TextStyles.heading1.copyWith(
                  color: Colors.white,
                  fontSize: 48,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.remoteUserName,
              style: TextStyles.heading3.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              _getConnectionStatusText(),
              style: TextStyles.body2.copyWith(color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        // Back button
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const Spacer(),
        // Duration timer
        if (_callState == VideoCallState.connected)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '00:00',
              style: TextStyle(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildConnectionStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_callState == VideoCallState.calling ||
              _callState == VideoCallState.incoming)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          const SizedBox(width: 8),
          Text(
            _getConnectionStatusText(),
            style: TextStyles.caption.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: _isMicrophoneEnabled ? Icons.mic : Icons.mic_off,
            color: _isMicrophoneEnabled ? Colors.white : Colors.red,
            onTap: () async {
              await _videoCallService.toggleMicrophone();
              setState(() => _isMicrophoneEnabled = !_isMicrophoneEnabled);
            },
          ),
          _buildControlButton(
            icon: _isCameraEnabled ? Icons.videocam : Icons.videocam_off,
            color: _isCameraEnabled ? Colors.white : Colors.red,
            onTap: () async {
              await _videoCallService.toggleVideo();
              setState(() => _isCameraEnabled = !_isCameraEnabled);
            },
          ),
          _buildControlButton(
            icon: Icons.flip_camera_ios,
            color: Colors.white,
            onTap: () async {
              await _videoCallService.toggleCamera();
            },
          ),
          _buildControlButton(
            icon: _isSpeakerEnabled ? Icons.volume_up : Icons.volume_off,
            color: _isSpeakerEnabled ? Colors.white : Colors.grey,
            onTap: () {
              setState(() => _isSpeakerEnabled = !_isSpeakerEnabled);
            },
          ),
          _buildControlButton(
            icon: Icons.call_end,
            color: Colors.red,
            backgroundColor: Colors.white,
            onTap: () async {
              await _videoCallService.endCall();
              if (mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    Color? backgroundColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 28,
        ),
      ),
    );
  }

  String _getConnectionStatusText() {
    switch (_callState) {
      case VideoCallState.idle:
        return 'Ready';
      case VideoCallState.calling:
        return 'Calling...';
      case VideoCallState.incoming:
        return 'Incoming call...';
      case VideoCallState.connected:
        return 'Connected';
      case VideoCallState.ended:
        return 'Call ended';
    }
  }

  Color _getStatusColor() {
    switch (_callState) {
      case VideoCallState.idle:
        return Colors.grey;
      case VideoCallState.calling:
      case VideoCallState.incoming:
        return AppColors.primary;
      case VideoCallState.connected:
        return Colors.green;
      case VideoCallState.ended:
        return Colors.red;
    }
  }
}

/// Incoming Call Screen
class IncomingCallScreen extends StatelessWidget {
  const IncomingCallScreen({
    required this.callerId,
    required this.callerName,
    required this.onAccept,
    required this.onReject,
    super.key,
  });

  final String callerId;
  final String callerName;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Caller avatar
              CircleAvatar(
                radius: 80,
                backgroundColor: AppColors.primary,
                child: Text(
                  callerName[0].toUpperCase(),
                  style: TextStyles.heading1.copyWith(
                    color: Colors.white,
                    fontSize: 64,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Caller name
              Text(
                callerName,
                style: TextStyles.heading2.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Incoming video call...',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 64),
              // Accept/Reject buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Reject button
                  GestureDetector(
                    onTap: onReject,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.call_end,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  // Accept button
                  GestureDetector(
                    onTap: onAccept,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.call,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
