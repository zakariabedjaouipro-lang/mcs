import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/db_constants.dart';
import '../../core/models/user_approval_model.dart';
import '../../core/services/supabase_service.dart';

/// Remote data source for approval operations
/// مصدر البيانات البعيد لعمليات الموافقة
abstract class ApprovalRemoteDataSource {
  /// Get all pending approval requests
  Future<List<UserApprovalModel>> getPendingApprovals();

  /// Get a single approval request
  Future<UserApprovalModel> getApprovalRequest(String userId);

  /// Approve a user
  Future<void> approveUser({
    required String userId,
    String? approvalNotes,
  });

  /// Reject a user
  Future<void> rejectUser({
    required String userId,
    required String rejectionReason,
  });

  /// Get approval requests by status
  Future<List<UserApprovalModel>> getApprovalsByStatus(String status);

  /// Get approval requests by role
  Future<List<UserApprovalModel>> getApprovalsByRole(String role);
}

/// Implementation of ApprovalRemoteDataSource
class ApprovalRemoteDataSourceImpl implements ApprovalRemoteDataSource {
  const ApprovalRemoteDataSourceImpl({
    required this.supabaseService,
    required this.supabaseClient,
  });

  final SupabaseService supabaseService;
  final SupabaseClient supabaseClient;

  @override
  Future<List<UserApprovalModel>> getPendingApprovals() async {
    try {
      final response = await supabaseClient
          .from(DbTables.userApprovals)
          .select()
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((json) => UserApprovalModel.fromJson(
                Map<String, dynamic>.from(json as Map),
              ))
          .toList();
    } on PostgrestException catch (e) {
      throw _mapPostgrestException(e);
    } catch (e) {
      throw Exception('Failed to fetch pending approvals: $e');
    }
  }

  @override
  Future<UserApprovalModel> getApprovalRequest(String userId) async {
    try {
      final response = await supabaseClient
          .from(DbTables.userApprovals)
          .select()
          .eq('user_id', userId)
          .single();

      return UserApprovalModel.fromJson(
        Map<String, dynamic>.from(response as Map),
      );
    } on PostgrestException catch (e) {
      throw _mapPostgrestException(e);
    } catch (e) {
      throw Exception('Failed to fetch approval request: $e');
    }
  }

  @override
  Future<void> approveUser({
    required String userId,
    String? approvalNotes,
  }) async {
    try {
      // Update approval request record
      await supabaseClient.from(DbTables.userApprovals).update({
        'status': 'approved',
        'approved_at': DateTime.now().toIso8601String(),
        'approval_notes': approvalNotes,
      }).eq('user_id', userId);

      // Update user metadata to mark as approved
      final user = await supabaseClient.auth.admin.getUserById(userId);
      final metadata = Map<String, dynamic>.from(user.userMetadata ?? {});
      metadata['approvalStatus'] = 'approved';

      await supabaseClient.auth.admin.updateUserById(
        userId,
        attributes: AdminUserAttributes(
          userMetadata: metadata,
        ),
      );
    } on PostgrestException catch (e) {
      throw _mapPostgrestException(e);
    } catch (e) {
      throw Exception('Failed to approve user: $e');
    }
  }

  @override
  Future<void> rejectUser({
    required String userId,
    required String rejectionReason,
  }) async {
    try {
      // Update approval request record
      await supabaseClient.from(DbTables.userApprovals).update({
        'status': 'rejected',
        'rejected_at': DateTime.now().toIso8601String(),
        'rejection_reason': rejectionReason,
      }).eq('user_id', userId);

      // Update user metadata to mark as rejected
      final user = await supabaseClient.auth.admin.getUserById(userId);
      final metadata = Map<String, dynamic>.from(user.userMetadata ?? {});
      metadata['approvalStatus'] = 'rejected';

      await supabaseClient.auth.admin.updateUserById(
        userId,
        attributes: AdminUserAttributes(
          userMetadata: metadata,
        ),
      );
    } on PostgrestException catch (e) {
      throw _mapPostgrestException(e);
    } catch (e) {
      throw Exception('Failed to reject user: $e');
    }
  }

  @override
  Future<List<UserApprovalModel>> getApprovalsByStatus(String status) async {
    try {
      final response = await supabaseClient
          .from(DbTables.userApprovals)
          .select()
          .eq('status', status)
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((json) => UserApprovalModel.fromJson(
                Map<String, dynamic>.from(json as Map),
              ))
          .toList();
    } on PostgrestException catch (e) {
      throw _mapPostgrestException(e);
    } catch (e) {
      throw Exception('Failed to fetch approvals by status: $e');
    }
  }

  @override
  Future<List<UserApprovalModel>> getApprovalsByRole(String role) async {
    try {
      final response = await supabaseClient
          .from(DbTables.userApprovals)
          .select()
          .eq('role', role)
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((json) => UserApprovalModel.fromJson(
                Map<String, dynamic>.from(json as Map),
              ))
          .toList();
    } on PostgrestException catch (e) {
      throw _mapPostgrestException(e);
    } catch (e) {
      throw Exception('Failed to fetch approvals by role: $e');
    }
  }

  /// Map Postgrest exceptions to app exceptions
  Exception _mapPostgrestException(PostgrestException e) {
    if (e.code == '404') {
      return Exception('Not found');
    } else if (e.code == '409') {
      return Exception('Conflict');
    }
    return Exception('Database error: ${e.message}');
  }
}
