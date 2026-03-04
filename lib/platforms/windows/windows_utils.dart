/// Windows-specific utilities and helpers for the Windows platform.
library;

import 'dart:io';

import 'package:flutter/foundation.dart';

abstract class WindowsUtils {
  // ── File System Utilities ────────────────────────────────

  /// Get the user's home directory path.
  static String getHomePath() {
    if (kIsWeb) return '';
    return Platform.environment['USERPROFILE'] ?? '';
  }

  /// Get the application data directory for storing app-specific files.
  static String getAppDataPath() {
    if (kIsWeb) return '';
    final appData = Platform.environment['APPDATA'];
    return appData ?? '';
  }

  /// Get the local application data directory (LocalAppData).
  static String getLocalAppDataPath() {
    if (kIsWeb) return '';
    final localAppData = Platform.environment['LOCALAPPDATA'];
    return localAppData ?? '';
  }

  /// Get the temporary files directory.
  static String getTempPath() {
    if (kIsWeb) return '';
    final temp = Platform.environment['TEMP'];
    return temp ?? '';
  }

  /// Get the documents directory path.
  static String getDocumentsPath() {
    if (kIsWeb) return '';
    final docs = Platform.environment['USERPROFILE'];
    return docs != null ? '$docs\\Documents' : '';
  }

  /// Get the downloads directory path.
  static String getDownloadsPath() {
    if (kIsWeb) return '';
    final userProfile = Platform.environment['USERPROFILE'];
    return userProfile != null ? '$userProfile\\Downloads' : '';
  }

  /// Convert forward slashes to backslashes (Windows format).
  static String convertToWindowsPath(String path) {
    if (kIsWeb) return path;
    return path.replaceAll('/', r'\');
  }

  /// Convert backslashes to forward slashes (cross-platform format).
  static String convertToCrossPlatformPath(String path) {
    return path.replaceAll(r'\', '/');
  }

  /// Check if a file or directory exists.
  static bool pathExists(String path) {
    if (kIsWeb) return false;
    try {
      final file = File(path);
      if (file.existsSync()) return true;
      final dir = Directory(path);
      return dir.existsSync();
    } catch (e) {
      return false;
    }
  }

  /// Create a directory recursively.
  static Future<Directory?> createDirectory(String path) async {
    if (kIsWeb) return null;
    try {
      final dir = Directory(path);
      return await dir.create(recursive: true);
    } catch (e) {
      return null;
    }
  }

  /// Get file extension from path.
  static String getFileExtension(String filePath) {
    if (filePath.isEmpty) return '';
    final lastDot = filePath.lastIndexOf('.');
    if (lastDot < 0) return '';
    return filePath.substring(lastDot + 1).toLowerCase();
  }

  /// Get file name from path (without extension).
  static String getFileNameWithoutExtension(String filePath) {
    if (filePath.isEmpty) return '';
    var name = filePath.split(r'\').last.split('/').last;
    final lastDot = name.lastIndexOf('.');
    if (lastDot > 0) name = name.substring(0, lastDot);
    return name;
  }

  // ── Registry Utilities ───────────────────────────────────

  /// Check if a Windows registry key exists.
  /// Note: This is a placeholder - actual registry access requires Windows-specific packages.
  static bool registryKeyExists(String hive, String path, String key) {
    // In a real implementation, you would use windows_registry package
    // or call Windows API via FFI to check registry values
    return false;
  }

  /// Get a value from Windows registry.
  /// Note: This is a placeholder - actual registry access requires Windows-specific packages.
  static String? getRegistryValue(String hive, String path, String key) {
    // In a real implementation, you would use windows_registry package
    // Example hives: HKEY_LOCAL_MACHINE, HKEY_CURRENT_USER
    // Example paths: SOFTWARE\\MyApp, SYSTEM\\CurrentControlSet
    return null;
  }

  /// Set a value in Windows registry.
  /// Note: This is a placeholder - actual registry access requires Windows-specific packages.
  static bool setRegistryValue(
    String hive,
    String path,
    String key,
    String value,
  ) {
    // In a real implementation, you would use windows_registry package
    // to set registry values for configuration persistence
    return false;
  }

  // ── System Information ───────────────────────────────────

  /// Get Windows version information.
  static String getWindowsVersion() {
    if (kIsWeb) return '';
    try {
      final result = Process.runSync(
        'cmd',
        ['/c', 'wmic os get caption'],
        runInShell: true,
      );
      final output = result.stdout.toString().trim();
      final lines = output.split('\n');
      return lines.length > 1 ? lines[1].trim() : '';
    } catch (e) {
      return '';
    }
  }

  /// Get Windows build number.
  static String getWindowsBuildNumber() {
    if (kIsWeb) return '';
    try {
      final result = Process.runSync(
        'cmd',
        ['/c', 'wmic os get buildnumber'],
        runInShell: true,
      );
      final output = result.stdout.toString().trim();
      final lines = output.split('\n');
      return lines.length > 1 ? lines[1].trim() : '';
    } catch (e) {
      return '';
    }
  }

  /// Check if running on Windows 10 or later.
  static bool isWindows10OrLater() {
    if (kIsWeb) return false;
    try {
      final buildNumber = int.tryParse(getWindowsBuildNumber()) ?? 0;
      return buildNumber >= 10240; // Windows 10 build number
    } catch (e) {
      return false;
    }
  }

  // ── App-Specific Utilities ───────────────────────────────

  /// Check if the app is running in debug mode on Windows.
  static bool isDebugMode() => kDebugMode;

  /// Get the number of CPU cores.
  static int getProcessorCount() {
    if (kIsWeb) return 1;
    return Platform.numberOfProcessors;
  }

  /// Get the operating system name.
  static String getOSInfo() {
    if (kIsWeb) return 'Web';
    return Platform.operatingSystem;
  }

  /// Open a file dialog (requires window_manager integration).
  /// This is a placeholder for file dialog functionality.
  static Future<String?> openFileDialog({
    String? initialDirectory,
    List<String>? allowedExtensions,
  }) async {
    // In a real implementation, use file_picker package
    // or desktop_window with native APIs
    return null;
  }

  /// Save a file dialog (requires window_manager integration).
  /// This is a placeholder for save dialog functionality.
  static Future<String?> saveFileDialog({
    String? suggestedName,
    String? initialDirectory,
  }) async {
    // In a real implementation, use file_picker package
    // or desktop_window with native APIs
    return null;
  }

  /// Launch a file with its default application.
  static Future<bool> openFileWithDefaultApp(String filePath) async {
    if (kIsWeb) return false;
    try {
      final result = await Process.run(
        'cmd',
        ['/c', 'start', filePath],
        runInShell: true,
      );
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  /// Show a Windows context menu at the given position.
  /// This is a placeholder for context menu functionality.
  static Future<String?> showContextMenu(
    double x,
    double y, {
    required List<String> items,
  }) async {
    // In a real implementation, use Windows native APIs via FFI
    // to show context menus at specific screen positions
    return null;
  }
}
