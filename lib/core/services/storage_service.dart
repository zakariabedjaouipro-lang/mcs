/// File storage service backed by Supabase Storage.
///
/// Handles uploading, deleting, and generating public URLs
/// for files in various storage buckets.
library;

import 'dart:developer';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/core/errors/exceptions.dart';

class StorageService {
  StorageService({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  final SupabaseClient _client;

  // ── Upload ───────────────────────────────────────────────

  /// Uploads a file to [bucket] at [path] from raw bytes.
  ///
  /// Returns the storage path of the uploaded file.
  Future<String> uploadBytes({
    required String bucket,
    required String path,
    required Uint8List bytes,
    String? contentType,
    bool upsert = true,
  }) async {
    try {
      final result = await _client.storage.from(bucket).uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: contentType,
              upsert: upsert,
            ),
          );
      log('Uploaded $path to $bucket', name: 'StorageService');
      return result;
    } catch (e, st) {
      log(
        'Upload failed ($bucket/$path): $e',
        name: 'StorageService',
        error: e,
        stackTrace: st,
      );
      throw ServerException(message: 'File upload failed: $e');
    }
  }

  // ── Delete ───────────────────────────────────────────────

  /// Deletes one or more files from [bucket].
  Future<void> deleteFiles({
    required String bucket,
    required List<String> paths,
  }) async {
    try {
      await _client.storage.from(bucket).remove(paths);
      log(
        'Deleted ${paths.length} file(s) from $bucket',
        name: 'StorageService',
      );
    } catch (e, st) {
      log(
        'Delete failed ($bucket): $e',
        name: 'StorageService',
        error: e,
        stackTrace: st,
      );
      throw ServerException(message: 'File deletion failed: $e');
    }
  }

  // ── Public URL ───────────────────────────────────────────

  /// Returns a permanent public URL for a file in [bucket] at [path].
  String getPublicUrl({
    required String bucket,
    required String path,
  }) {
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  // ── Signed URL ───────────────────────────────────────────

  /// Creates a time-limited signed URL (default 1 hour).
  Future<String> getSignedUrl({
    required String bucket,
    required String path,
    int expiresInSeconds = 3600,
  }) async {
    try {
      return await _client.storage
          .from(bucket)
          .createSignedUrl(path, expiresInSeconds);
    } catch (e, st) {
      log(
        'Signed URL failed ($bucket/$path): $e',
        name: 'StorageService',
        error: e,
        stackTrace: st,
      );
      throw ServerException(message: 'Signed URL creation failed: $e');
    }
  }

  // ── List Files ───────────────────────────────────────────

  /// Lists files in [bucket] under [path].
  Future<List<FileObject>> listFiles({
    required String bucket,
    String path = '',
  }) async {
    try {
      return await _client.storage.from(bucket).list(path: path);
    } catch (e, st) {
      log(
        'List files failed ($bucket/$path): $e',
        name: 'StorageService',
        error: e,
        stackTrace: st,
      );
      throw ServerException(message: 'List files failed: $e');
    }
  }
}
