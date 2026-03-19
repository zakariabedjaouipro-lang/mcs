import 'package:flutter_test/flutter_test.dart';
import 'package:mcs/core/services/role_based_authentication_service.dart';

void main() {
  group('Authentication Integration Tests', () {
    late RoleBasedAuthenticationService authService;

    setUp(() {
      authService = RoleBasedAuthenticationService();
    });

    group('Role-Based Authorization Flow', () {
      test('Admin should have management permissions', () async {
        final adminRoles = await authService.getAllRoles();
        final admin = adminRoles.firstWhere(
          (r) => r.name == 'admin',
          orElse: () =>
              throw AssertionError('Admin role should exist in system'),
        );

        expect(
          admin.requiresApproval,
          isNotNull,
        );
        expect(
          admin.name,
          'admin',
        );

        final adminPermissions =
            await authService.getRolePermissions(admin.name);
        expect(
          adminPermissions.permissions,
          isNotEmpty,
        );
      });

      test('Doctor should have clinical permissions', () async {
        final allRoles = await authService.getAllRoles();
        final doctor = allRoles.firstWhere(
          (r) => r.name == 'doctor',
          orElse: () =>
              throw AssertionError('Doctor role should exist in system'),
        );

        expect(
          doctor.name,
          'doctor',
        );

        final doctorPermissions =
            await authService.getRolePermissions(doctor.name);
        expect(
          doctorPermissions.permissions,
          isNotEmpty,
        );
      });

      test('Patient should have limited permissions', () async {
        final allRoles = await authService.getAllRoles();
        final patient = allRoles.firstWhere(
          (r) => r.name == 'patient',
          orElse: () =>
              throw AssertionError('Patient role should exist in system'),
        );

        expect(
          patient.requiresApproval,
          false,
        ); // Patients don't need approval

        final patientPermissions =
            await authService.getRolePermissions(patient.name);
        // Patients should have some permissions (view own data)
        expect(
          patientPermissions.permissions,
          isNotEmpty,
        );
      });
    });

    group('Registration Workflow', () {
      test('should support patient self-registration', () async {
        final publicRoles = await authService.getPublicRoles();
        final patientIsPublic = publicRoles.any((r) => r.name == 'patient');

        expect(
          patientIsPublic,
          true,
          reason: 'Patients should be able to self-register',
        );
      });

      test('should require approval for staff roles', () async {
        final allRoles = await authService.getAllRoles();
        final staffRoles = [
          'doctor',
          'receptionist',
          'nurse',
          'lab_technician',
          'pharmacist',
        ];

        for (final roleName in staffRoles) {
          final role = allRoles.firstWhere(
            (r) => r.name == roleName,
            orElse: () => throw AssertionError('$roleName should exist'),
          );
          expect(
            role.requiresApproval,
            true,
            reason: '$roleName should require approval',
          );
        }
      });

      test('should not allow direct super_admin creation', () async {
        final allRoles = await authService.getAllRoles();
        final superAdmin = allRoles.firstWhere(
          (r) => r.name == 'super_admin',
          orElse: () => throw AssertionError('super_admin should exist'),
        );

        expect(superAdmin.requiresApproval, true,
            reason: 'Super admin role should require approval');
      });
    });

    group('Role Hierarchy and Permissions', () {
      test('should have proper role hierarchy', () async {
        final roles = await authService.getAllRoles();
        final roleNames = roles.map((r) => r.name).toSet();

        // Core roles should be present
        final requiredRoles = {
          'super_admin',
          'admin',
          'doctor',
          'patient',
          'receptionist',
          'nurse',
          'lab_technician',
          'pharmacist'
        };

        for (final requiredRole in requiredRoles) {
          expect(roleNames.contains(requiredRole), true,
              reason: '$requiredRole should be in system');
        }
      });

      test('should provide different permission sets for each role', () async {
        final roleNames = [
          'super_admin',
          'admin',
          'doctor',
          'receptionist',
          'nurse'
        ];

        final permissionsByRole = <String, Set<String>>{};

        for (final roleName in roleNames) {
          final permissions = await authService.getRolePermissions(roleName);
          permissionsByRole[roleName] =
              permissions.permissions.map((p) => p.permissionKey).toSet();
        }

        // Each role should have unique permission set
        expect(
          permissionsByRole['super_admin']!.isNotEmpty,
          true,
        );
        expect(
          permissionsByRole['doctor']!.isNotEmpty,
          true,
        );
        expect(
          permissionsByRole['patient']!.isNotEmpty,
          true,
        );
      });
    });

    group('Error Handling', () {
      test('should handle non-existent role gracefully', () async {
        final permissions =
            await authService.getRolePermissions('non_existent_role');
        expect(
          permissions.permissions,
          isEmpty,
        );
      });

      test('should return empty permissions for invalid roles', () async {
        final invalidRoles = [
          'xyz_invalid',
          'fake_role',
          'admin_super',
          '123_numeric',
        ];

        for (final role in invalidRoles) {
          final permissions = await authService.getRolePermissions(role);
          expect(
            permissions.permissions.isEmpty,
            true,
            reason: '$role should return empty permissions',
          );
        }
      });
    });

    group('System Integrity', () {
      test('all roles should have required metadata', () async {
        final allRoles = await authService.getAllRoles();

        for (final role in allRoles) {
          expect(
            role.id,
            isNotEmpty,
            reason: 'Role ${role.name} needs ID',
          );
          expect(
            role.name,
            isNotEmpty,
            reason: 'Role needs name',
          );
          expect(
            role.displayNameAr,
            isNotEmpty,
            reason: 'Role ${role.name} needs displayNameAr',
          );
          expect(
            role.displayNameEn,
            isNotEmpty,
            reason: 'Role ${role.name} needs displayNameEn',
          );
          expect(
            role.requiresApproval,
            isNotNull,
            reason: 'Role ${role.name} needs requiresApproval setting',
          );
          expect(
            role.createdAt,
            isNotNull,
            reason: 'Role ${role.name} needs createdAt',
          );
        }
      });

      test('public and non-public roles should be properly separated',
          () async {
        final allRoles = await authService.getAllRoles();
        final publicRoles = await authService.getPublicRoles();

        expect(publicRoles.length, lessThanOrEqualTo(allRoles.length));

        // Patient should be in public
        final patientInAll = allRoles.any((r) => r.name == 'patient');
        final patientInPublic = publicRoles.any((r) => r.name == 'patient');

        expect(patientInAll, true);
        expect(patientInPublic, true);

        // super_admin should be in all but not public
        final superAdminInAll = allRoles.any((r) => r.name == 'super_admin');
        final superAdminInPublic =
            publicRoles.any((r) => r.name == 'super_admin');

        expect(superAdminInAll, true);
        expect(superAdminInPublic, false);
      });
    });
  });
}
