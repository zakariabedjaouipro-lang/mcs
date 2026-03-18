import 'package:flutter_test/flutter_test.dart';
import 'package:mcs/core/models/role_model.dart';
import 'package:mcs/core/services/role_based_authentication_service.dart';

void main() {
  group('RoleBasedAuthenticationService', () {
    late RoleBasedAuthenticationService service;

    setUp(() {
      service = RoleBasedAuthenticationService();
    });

    group('getAllRoles', () {
      test('should return list of all roles', () async {
        final roles = await service.getAllRoles();
        expect(roles, isNotEmpty);
        expect(roles.length, greaterThan(0));
      });

      test('should contain super_admin role', () async {
        final roles = await service.getAllRoles();
        final superAdminExists = roles.any((r) => r.name == 'super_admin');
        expect(superAdminExists, true);
      });

      test('should contain required roles', () async {
        final roles = await service.getAllRoles();
        final requiredRoles = [
          'super_admin',
          'admin',
          'doctor',
          'patient',
          'receptionist',
          'nurse',
          'lab_technician',
          'pharmacist'
        ];

        for (final roleName in requiredRoles) {
          final exists = roles.any((r) => r.name == roleName);
          expect(exists, true, reason: 'Role $roleName should exist');
        }
      });
    });

    group('getPublicRoles', () {
      test('should return only public roles', () async {
        final roles = await service.getPublicRoles();
        expect(roles, isNotEmpty);
        // Patient should be public
        final patientExists = roles.any((r) => r.name == 'patient');
        expect(patientExists, true);
      });

      test('should exclude non-public roles', () async {
        final roles = await service.getPublicRoles();
        // Super admin should not be public
        final superAdminExists = roles.any((r) => r.name == 'super_admin');
        expect(superAdminExists, false);
      });
    });

    group('Role properties', () {
      test('should have valid role structure', () async {
        final roles = await service.getAllRoles();
        for (final role in roles) {
          expect(role.id, isNotEmpty);
          expect(role.name, isNotEmpty);
          expect(role.displayNameEn, isNotEmpty);
          expect(role.displayNameAr, isNotEmpty);
          expect(role.requiresApproval, isNotNull);
          expect(role.createdAt, isNotNull);
        }
      });

      test('super_admin should require approval', () async {
        final roles = await service.getAllRoles();
        final superAdmin = roles.firstWhere((r) => r.name == 'super_admin');
        expect(superAdmin.requiresApproval, true);
      });

      test('patient should not require approval', () async {
        final roles = await service.getAllRoles();
        final patient = roles.firstWhere((r) => r.name == 'patient');
        expect(patient.requiresApproval, false);
      });
    });
  });
}
