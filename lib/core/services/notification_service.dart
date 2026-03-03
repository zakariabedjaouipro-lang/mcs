/// Push & local notification service.
///
/// Uses Firebase Cloud Messaging for push notifications and
/// flutter_local_notifications for foreground / local alerts.
library;

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localPlugin,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _local = localPlugin ?? FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _local;

  // ── Android Notification Channel ─────────────────────────
  static const _androidChannel = AndroidNotificationChannel(
    'mcs_default',
    'MCS Notifications',
    description: 'Default notification channel for MCS',
    importance: Importance.high,
  );

  // ── Initialization ───────────────────────────────────────

  /// Call once at app startup.
  Future<void> initialize() async {
    // Request permissions (iOS / web).
    await _requestPermission();

    // Configure local notifications.
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
    );

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalTap,
    );

    // Create the Android channel.
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // Listen to foreground messages.
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Listen to background-tap (app was in background, user tapped).
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    log('NotificationService initialized', name: 'NotificationService');
  }

  // ── Permission ───────────────────────────────────────────

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission();
    log(
      'Notification permission: ${settings.authorizationStatus}',
      name: 'NotificationService',
    );
  }

  // ── FCM Token ────────────────────────────────────────────

  /// Returns the current FCM device token.
  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      log('Failed to get FCM token: $e', name: 'NotificationService');
      return null;
    }
  }

  /// Stream that emits whenever the FCM token is refreshed.
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  // ── Show Local Notification ──────────────────────────────

  /// Displays a local notification immediately.
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.high,
      priority: Priority.high,
    );
    const darwinDetails = DarwinNotificationDetails();
    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _local.show(id, title, body, details, payload: payload);
  }

  // ── Topic Subscription ──────────────────────────────────

  /// Subscribes the device to a FCM [topic].
  Future<void> subscribeToTopic(String topic) =>
      _messaging.subscribeToTopic(topic);

  /// Unsubscribes the device from a FCM [topic].
  Future<void> unsubscribeFromTopic(String topic) =>
      _messaging.unsubscribeFromTopic(topic);

  // ── Handlers ─────────────────────────────────────────────

  void _onForegroundMessage(RemoteMessage message) {
    log(
      'Foreground message: ${message.notification?.title}',
      name: 'NotificationService',
    );

    final notification = message.notification;
    if (notification == null) return;

    showLocalNotification(
      id: message.hashCode,
      title: notification.title ?? '',
      body: notification.body ?? '',
      payload: message.data.toString(),
    );
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    log(
      'Message opened app: ${message.data}',
      name: 'NotificationService',
    );
    // Navigation based on message.data will be handled by the router
    // or a dedicated deep-link handler in later phases.
  }

  void _onLocalTap(NotificationResponse response) {
    log(
      'Local notification tapped: ${response.payload}',
      name: 'NotificationService',
    );
  }
}
