import 'package:flutter_test/flutter_test.dart';
import 'package:mcs/core/models/role_model.dart';
import 'package:mcs/core/models/role_permissions_model.dart';
import 'package:mcs/core/models/registration_request_model.dart';

void main() {
  group('Core Authentication Models', () {
    group('RoleModel', () {
      test('should create RoleModel with bilingual display names', () {
        final role = RoleModel(
          id: 'test-id',
          name: 'doctor',
          displayNameAr: 'طبيب',
          displayNameEn: 'Doctor',
          description: 'Medical doctor role',
          descriptionEn: 'A licensed medical doctor',
          requiresApproval: true,
          requires2FA: false,
          requiresEmailVerification: true,
          createdAt: DateTime.now(),
        );

        expect(role.id, 'test-id');
        expect(role.name, 'doctor');
        expect(role.displayNameAr, 'طبيب');
        expect(role.displayNameEn, 'Doctor');
        expect(role.requiresApproval, true);
      });

      test('should support equality comparison', () {
        final now = DateTime.now();
        final role1 = RoleModel(
          id: 'test-id',
          name: 'doctor',
          displayNameAr: 'طبيب',
          displayNameEn: 'Doctor',
          description: 'Medical doctor role',
          descriptionEn: 'A licensed medical doctor',
          requiresApproval: true,
          requires2FA: false,
          requiresEmailVerification: true,
          createdAt: now,
        );

        final role2 = RoleModel(
          id: 'test-id',
          name: 'doctor',
          displayNameAr: 'طبيب',
          displayNameEn: 'Doctor',
          description: 'Medical doctor role',
          descriptionEn: 'A licensed medical doctor',
          requiresApproval: true,
          requires2FA: false,
          requiresEmailVerification: true,
          createdAt: now,
        );

        expect(role1, equals(role2));
      });

      test('should convert to/from JSON', () {
        final role = RoleModel(
          id: 'test-id',
          name: 'doctor',
          displayNameAr: 'طبيب',
          displayNameEn: 'Doctor',
          description: 'Medical doctor role',
          descriptionEn: 'A licensed medical doctor',
          requiresApproval: true,
          requires2FA: false,
          requiresEmailVerification: true,
          createdAt: DateTime.parse('2026-03-18T00:00:00Z'),
        );

        final json = role.toJson();
        expect(json['id'], 'test-id');
        expect(json['name'], 'doctor');
        expect(json['requires_approval'], true);
      });
    });

    group('RolePermission', () {
      test('should create role permission with correct fields', () {
        final permission = RolePermission(
          id: 'perm-123',
          roleId: 'doctor-role',
          permissionKey: 'patients.create',
          isAllowed: true,
          createdAt: DateTime.now(),
        );

        expect(permission.id, 'perm-123');
        expect(permission.roleId, 'doctor-role');
        expect(permission.permissionKey, 'patients.create');
        expect(permission.isAllowed, true);
      });

      test('should support JSON serialization', () {
        final permission = RolePermission(
          id: 'perm-123',
          roleId: 'doctor-role',
          permissionKey: 'patients.create',
          isAllowed: true,
          createdAt: DateTime.parse('2026-03-18T00:00:00Z'),
        );

        final json = permission.toJson();
        expect(json['id'], 'perm-123');
        expect(json['permission_key'], 'patients.create');
        expect(json['is_allowed'], true);
      });
    });

    group('RolePermissions Collection', () {
      test('should create role permissions collection', () {
        final perm1 = RolePermission(
          id: 'p1',
          roleId: 'doctor',
          permissionKey: 'patients.view',
          isAllowed: true,
        );
        final perm2 = RolePermission(
          id: 'p2',
          roleId: 'doctor',
          permissionKey: 'prescriptions.create',
          isAllowed: true,
        );

        final permissions = RolePermissions(
          roleId: 'doctor-role',
          permissions: [perm1, perm2],
        );

        expect(permissions.roleId, 'doctor-role');
        expect(permissions.permissions.length, 2);
      });

      test('should support empty permission list', () {
        final permissions = RolePermissions(
          roleId: 'guest-role',
          permissions: [],
        );

        expect(permissions.permissions, isEmpty);
      });
    });

    group('RegistrationRequest', () {
      test('should create registration request with correct status', () {
        final request = RegistrationRequest(
          id: 'req-123',
          userId: 'user-456',
          roleId: 'doctor-role',
          status: RegistrationRequestStatus.pending,
          createdAt: DateTime.now(),
          rejectionReason: null,
        );

        expect(request.id, 'req-123');
        expect(request.userId, 'user-456');
        expect(request.roleId, 'doctor-role');
        expect(request.status, RegistrationRequestStatus.pending);
        expect(request.rejectionReason, isNull);
      });

      test('should support different status values', () {
        final statuses = [
          RegistrationRequestStatus.pending,
          RegistrationRequestStatus.approved,
          RegistrationRequestStatus.rejected,
        ];

        for (final status in statuses) {
          final request = RegistrationRequest(
            id: 'req-id',
            userId: 'user-id',
            roleId: 'doctor-role',
            status: status,
            createdAt: DateTime.now(),
            rejectionReason: null,
          );

          expect(request.status, status);
        }
      });

      test('should include rejection reason when rejected', () {
        final request = RegistrationRequest(
          id: 'req-123',
          userId: 'user-456',
          roleId: 'doctor-role',
          status: RegistrationRequestStatus.rejected,
          createdAt: DateTime.now(),
          rejectionReason: 'Invalid credentials',
        );

        expect(request.status, RegistrationRequestStatus.rejected);
        expect(request.rejectionReason, 'Invalid credentials');
      });
    });
  });
}
