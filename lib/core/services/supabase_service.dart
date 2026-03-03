/// Wrapper around common Supabase client operations.
///
/// Provides helper methods for querying tables, calling RPCs,
/// and accessing storage — with unified error handling.
library;

import 'dart:developer';

import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/core/errors/exceptions.dart' as app;
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  final SupabaseClient _client;

  // ── Table Query ──────────────────────────────────────────

  /// Returns a query builder for the given [table].
  SupabaseQueryBuilder from(String table) => _client.from(table);

  // ── RPC (Edge Functions / DB Functions) ──────────────────

  /// Calls a Postgres function via `rpc()`.
  Future<dynamic> rpc(
    String functionName, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _client.rpc(functionName, params: params);
      return response;
    } catch (e, st) {
      _logError('rpc($functionName)', e, st);
      throw _mapException(e);
    }
  }

  // ── Storage ──────────────────────────────────────────────

  /// Returns a reference to a storage [bucket].
  StorageFileApi storage(String bucket) => _client.storage.from(bucket);

  // ── Realtime ─────────────────────────────────────────────

  /// Subscribes to realtime changes on a [table].
  RealtimeChannel channel(String name) => _client.channel(name);

  // ── CRUD Helpers ─────────────────────────────────────────

  /// Fetches all rows from [table] with optional filters.
  Future<List<Map<String, dynamic>>> fetchAll(
    String table, {
    String? select,
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    try {
      dynamic query = _client.from(table).select(select ?? '*');

      if (filters != null) {
        for (final entry in filters.entries) {
          query = query.eq(entry.key, entry.value as Object);
        }
      }

      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 20) - 1);
      }

      final data = await query;
      return List<Map<String, dynamic>>.from(data as List);
    } catch (e, st) {
      _logError('fetchAll($table)', e, st);
      throw _mapException(e);
    }
  }

  /// Fetches a single row by [id] from [table].
  Future<Map<String, dynamic>> fetchById(
    String table,
    String id, {
    String? select,
  }) async {
    try {
      final data =
          await _client.from(table).select(select ?? '*').eq('id', id).single();
      return data;
    } catch (e, st) {
      _logError('fetchById($table, $id)', e, st);
      throw _mapException(e);
    }
  }

  /// Inserts a new row into [table].
  Future<Map<String, dynamic>> insert(
    String table,
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _client.from(table).insert(data).select().single();
      return result;
    } catch (e, st) {
      _logError('insert($table)', e, st);
      throw _mapException(e);
    }
  }

  /// Updates a row in [table] by [id].
  Future<Map<String, dynamic>> update(
    String table,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final result =
          await _client.from(table).update(data).eq('id', id).select().single();
      return result;
    } catch (e, st) {
      _logError('update($table, $id)', e, st);
      throw _mapException(e);
    }
  }

  /// Deletes a row from [table] by [id].
  Future<void> delete(String table, String id) async {
    try {
      await _client.from(table).delete().eq('id', id);
    } catch (e, st) {
      _logError('delete($table, $id)', e, st);
      throw _mapException(e);
    }
  }

  // ── Error Handling ───────────────────────────────────────

  void _logError(String operation, Object error, StackTrace st) {
    log(
      'SupabaseService.$operation failed: $error',
      name: 'SupabaseService',
      error: error,
      stackTrace: st,
    );
  }

  app.AppException _mapException(Object error) {
    if (error is PostgrestException) {
      final code = int.tryParse(error.code ?? '');
      if (code == 404 || error.message.contains('not found')) {
        return app.NotFoundException(message: error.message);
      }
      if (code == 401) {
        return app.SessionExpiredException(message: error.message);
      }
      if (code == 403) {
        return app.UnauthorizedException(message: error.message);
      }
      return app.ServerException(
        message: error.message,
        statusCode: code,
      );
    }
    if (error is AuthException) {
      return app.AuthException(
        message: error.message,
        statusCode: int.tryParse(error.statusCode ?? ''),
      );
    }
    if (error is app.AppException) {
      return error;
    }
    return app.ServerException(message: error.toString());
  }
}
