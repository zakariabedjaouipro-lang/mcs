/// Advanced Role-Based Authentication Service
/// خدمة المصادقة المتقدمة متعددة المستويات
library;

import 'dart:developer';

import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/core/errors/exceptions.dart';
import 'package:mcs/core/models/registration_request_model.dart';
import 'package:mcs/core/models/role_model.dart';
import 'package:mcs/core/models/role_permissions_model.dart';
import 'package:mcs/core/models/user_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoleBasedAuthenticationService {
  RoleBasedAuthenticationService({
    SupabaseClient? client,
  }) : _client = client ?? SupabaseConfig.client;

  final SupabaseClient _client;

  /// Get all available roles
  Future<List<RoleModel>> getAllRoles() async {
    try {
      log('جاري استرجاع قائمة الأدوار...',
          name: 'RoleBasedAuthService.getAllRoles');

      final response = await _client.from('roles').select();

      final roles = (response as List)
          .map((role) => RoleModel.fromJson(role as Map<String, dynamic>))
          .toList();

      log('تم استرجاع ${roles.length} أدوار',
          name: 'RoleBasedAuthService.getAllRoles');

      return roles;
    } catch (e) {
      log('خطأ في استرجاع الأدوار: $e',
          name: 'RoleBasedAuthService.getAllRoles', level: 1000);
      throw ServerException(message: 'فشل استرجاع الأدوار: $e');
    }
  }

  /// Get role by ID
  Future<RoleModel> getRoleById(String roleId) async {
    try {
      final response =
          await _client.from('roles').select().eq('id', roleId).single();

      return RoleModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      log('خطأ في استرجاع الدور: $e',
          name: 'RoleBasedAuthService.getRoleById', level: 1000);
      throw ServerException(message: 'فشل استرجاع الدور: $e');
    }
  }

  /// Get public roles (roles available for general registration)
  Future<List<RoleModel>> getPublicRoles() async {
    try {
      final allRoles = await getAllRoles();
      // Filter roles that don't require approval
      return allRoles.where((role) => !role.requiresApproval).toList();
    } catch (e) {
      log('خطأ في استرجاع الأدوار العامة: $e',
          name: 'RoleBasedAuthService.getPublicRoles', level: 1000);
      throw ServerException(message: 'فشل استرجاع الأدوار العامة: $e');
    }
  }

  /// Get role permissions
  Future<RolePermissions> getRolePermissions(String roleId) async {
    try {
      log('جاري استرجاع صلاحيات الدور: $roleId',
          name: 'RoleBasedAuthService.getRolePermissions');

      final response =
          await _client.from('role_permissions').select().eq('role_id', roleId);

      final permissions = (response as List)
          .map((p) => RolePermission.fromJson(p as Map<String, dynamic>))
          .toList();

      log('تم استرجاع ${permissions.length} صلاحية',
          name: 'RoleBasedAuthService.getRolePermissions');

      return RolePermissions(roleId: roleId, permissions: permissions);
    } catch (e) {
      log('خطأ في استرجاع الصلاحيات: $e',
          name: 'RoleBasedAuthService.getRolePermissions', level: 1000);
      throw ServerException(message: 'فشل استرجاع الصلاحيات: $e');
    }
  }

  /// Create registration request (for roles requiring approval)
  Future<RegistrationRequest> createRegistrationRequest({
    required String userId,
    required String roleId,
    Map<String, dynamic>? requestedData,
  }) async {
    try {
      log('جاري إنشاء طلب تسجيل للمستخدم: $userId',
          name: 'RoleBasedAuthService.createRegistrationRequest');

      final response = await _client
          .from('registration_requests')
          .insert({
            'user_id': userId,
            'role_id': roleId,
            'status': 'pending',
            'requested_data': requestedData,
          })
          .select()
          .single();

      final request =
          RegistrationRequest.fromJson(response as Map<String, dynamic>);

      log('تم إنشاء طلب التسجيل: ${request.id}',
          name: 'RoleBasedAuthService.createRegistrationRequest');

      return request;
    } catch (e) {
      log('خطأ في إنشاء طلب التسجيل: $e',
          name: 'RoleBasedAuthService.createRegistrationRequest', level: 1000);
      throw ServerException(message: 'فشل إنشاء طلب التسجيل: $e');
    }
  }

  /// Get registration request by ID
  Future<RegistrationRequest> getRegistrationRequest(String requestId) async {
    try {
      final response = await _client
          .from('registration_requests')
          .select()
          .eq('id', requestId)
          .single();

      return RegistrationRequest.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      log('خطأ في استرجاع طلب التسجيل: $e',
          name: 'RoleBasedAuthService.getRegistrationRequest', level: 1000);
      throw ServerException(message: 'فشل استرجاع طلب التسجيل: $e');
    }
  }

  /// Get user's registration request
  Future<RegistrationRequest?> getUserRegistrationRequest(String userId) async {
    try {
      final response = await _client
          .from('registration_requests')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(1);

      if ((response as List).isEmpty) return null;

      return RegistrationRequest.fromJson(response[0] as Map<String, dynamic>);
    } catch (e) {
      log('خطأ في استرجاع طلب التسجيل للمستخدم: $e',
          name: 'RoleBasedAuthService.getUserRegistrationRequest', level: 1000);
      return null;
    }
  }

  /// Get all pending registration requests (for admin)
  Future<List<RegistrationRequest>> getPendingRegistrationRequests() async {
    try {
      log('جاري استرجاع طلبات التسجيل المعلقة...',
          name: 'RoleBasedAuthService.getPendingRegistrationRequests');

      final response = await _client
          .from('registration_requests')
          .select()
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      final requests = (response as List)
          .map((r) => RegistrationRequest.fromJson(r as Map<String, dynamic>))
          .toList();

      log('تم استرجاع ${requests.length} طلب معلق',
          name: 'RoleBasedAuthService.getPendingRegistrationRequests');

      return requests;
    } catch (e) {
      log('خطأ في استرجاع الطلبات المعلقة: $e',
          name: 'RoleBasedAuthService.getPendingRegistrationRequests',
          level: 1000);
      throw ServerException(message: 'فشل استرجاع الطلبات المعلقة: $e');
    }
  }

  /// Approve registration request
  Future<RegistrationRequest> approveRegistrationRequest({
    required String requestId,
    required String reviewedBy,
  }) async {
    try {
      log('جاري إعتماد طلب التسجيل: $requestId',
          name: 'RoleBasedAuthService.approveRegistrationRequest');

      final response = await _client
          .from('registration_requests')
          .update({
            'status': 'approved',
            'reviewed_by': reviewedBy,
            'reviewed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', requestId)
          .select()
          .single();

      final updatedRequest =
          RegistrationRequest.fromJson(response as Map<String, dynamic>);

      log('تم إعتماد طلب التسجيل: ${updatedRequest.id}',
          name: 'RoleBasedAuthService.approveRegistrationRequest');

      return updatedRequest;
    } catch (e) {
      log('خطأ في إعتماد طلب التسجيل: $e',
          name: 'RoleBasedAuthService.approveRegistrationRequest', level: 1000);
      throw ServerException(message: 'فشل إعتماد طلب التسجيل: $e');
    }
  }

  /// Reject registration request
  Future<RegistrationRequest> rejectRegistrationRequest({
    required String requestId,
    required String reviewedBy,
    required String rejectionReason,
  }) async {
    try {
      log('جاري رفض طلب التسجيل: $requestId',
          name: 'RoleBasedAuthService.rejectRegistrationRequest');

      final response = await _client
          .from('registration_requests')
          .update({
            'status': 'rejected',
            'reviewed_by': reviewedBy,
            'reviewed_at': DateTime.now().toIso8601String(),
            'rejection_reason': rejectionReason,
          })
          .eq('id', requestId)
          .select()
          .single();

      final updatedRequest =
          RegistrationRequest.fromJson(response as Map<String, dynamic>);

      log('تم رفض طلب التسجيل: ${updatedRequest.id}',
          name: 'RoleBasedAuthService.rejectRegistrationRequest');

      return updatedRequest;
    } catch (e) {
      log('خطأ في رفض طلب التسجيل: $e',
          name: 'RoleBasedAuthService.rejectRegistrationRequest', level: 1000);
      throw ServerException(message: 'فشل رفض طلب التسجيل: $e');
    }
  }

  /// Create user profile
  Future<UserProfile> createUserProfile({
    required String userId,
    required String email,
    required String fullName,
    String? phone,
    String? roleId,
    String registrationStatus = 'active',
  }) async {
    try {
      log('جاري إنشاء ملف المستخدم: $userId',
          name: 'RoleBasedAuthService.createUserProfile');

      final response = await _client
          .from('user_profiles')
          .insert({
            'id': userId,
            'email': email,
            'full_name': fullName,
            'phone': phone,
            'role_id': roleId,
            'registration_status': registrationStatus,
          })
          .select()
          .single();

      final profile = UserProfile.fromJson(response as Map<String, dynamic>);

      log('تم إنشاء ملف المستخدم: ${profile.id}',
          name: 'RoleBasedAuthService.createUserProfile');

      return profile;
    } catch (e) {
      log('خطأ في إنشاء ملف المستخدم: $e',
          name: 'RoleBasedAuthService.createUserProfile', level: 1000);
      throw ServerException(message: 'فشل إنشاء ملف المستخدم: $e');
    }
  }

  /// Get user profile
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;

      return UserProfile.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      log('خطأ في استرجاع ملف المستخدم: $e',
          name: 'RoleBasedAuthService.getUserProfile', level: 1000);
      return null;
    }
  }

  /// Verify email
  Future<bool> verifyEmailForUser(String userId) async {
    try {
      log('جاري تحديث التحقق من البريد للمستخدم: $userId',
          name: 'RoleBasedAuthService.verifyEmailForUser');

      await _client.from('user_profiles').update({
        'email_verified_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      log('تم تحديث التحقق من البريد',
          name: 'RoleBasedAuthService.verifyEmailForUser');

      return true;
    } catch (e) {
      log('خطأ في تحديث التحقق من البريد: $e',
          name: 'RoleBasedAuthService.verifyEmailForUser', level: 1000);
      throw ServerException(message: 'فشل تحديث التحقق من البريد: $e');
    }
  }

  /// Enable 2FA for user
  Future<bool> enable2FAForUser(String userId) async {
    try {
      log('جاري تفعيل المصادقة الثنائية للمستخدم: $userId',
          name: 'RoleBasedAuthService.enable2FAForUser');

      await _client.from('user_profiles').update({
        'is_2fa_enabled': true,
      }).eq('id', userId);

      log('تم تفعيل المصادقة الثنائية',
          name: 'RoleBasedAuthService.enable2FAForUser');

      return true;
    } catch (e) {
      log('خطأ في تفعيل المصادقة الثنائية: $e',
          name: 'RoleBasedAuthService.enable2FAForUser', level: 1000);
      throw ServerException(message: 'فشل تفعيل المصادقة الثنائية: $e');
    }
  }

  /// Check if email verification is required for role
  bool isEmailVerificationRequiredForRole(RoleModel role) {
    return role.requiresEmailVerification;
  }

  /// Check if 2FA is required for role
  bool is2FARequiredForRole(RoleModel role) {
    return role.requires2FA;
  }

  /// Check if approval is required for role
  bool isApprovalRequiredForRole(RoleModel role) {
    return role.requiresApproval;
  }
}
