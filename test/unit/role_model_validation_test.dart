import 'package:flutter_test/flutter_test.dart';
import 'package:mcs/core/models/role_model.dart';

void main() {
  group('Authentication System Validation', () {
    group('RoleModel Functionality', () {
      test('should create and serialize role correctly', () {
        final role = RoleModel(
          id: 'role-doctor-001',
          name: 'doctor',
          displayNameAr: 'طبيب',
          displayNameEn: 'Doctor',
          requiresApproval: true,
          requires2FA: false,
          requiresEmailVerification: true,
          description: 'Medical Doctor',
          descriptionEn: 'A licensed medical professional',
          createdAt: DateTime.parse('2026-03-18T00:00:00Z'),
        );

        expect(role.name, 'doctor');
        expect(role.displayNameEn, 'Doctor');
        expect(role.displayNameAr, 'طبيب');
        expect(role.requiresApproval, true);
        expect(role.requires2FA, false);
      });

      test('should convert role to JSON', () {
        final role = RoleModel(
          id: 'role-patient-001',
          name: 'patient',
          displayNameAr: 'مريض',
          displayNameEn: 'Patient',
          requiresApproval: false,
          requires2FA: false,
          requiresEmailVerification: true,
          createdAt: DateTime.parse('2026-03-18T00:00:00Z'),
        );

        final json = role.toJson();

        expect(json['id'], 'role-patient-001');
        expect(json['name'], 'patient');
        expect(json['requires_approval'], false);
        expect(json['requires_email_verification'], true);
      });

      test('should reconstruct role from JSON', () {
        final json = {
          'id': 'role-admin-001',
          'name': 'admin',
          'display_name_ar': 'مسؤول',
          'display_name_en': 'Admin',
          'requires_approval': true,
          'requires_2fa': false,
          'requires_email_verification': true,
          'description': 'System Administrator',
          'description_en': 'System Administrator English',
          'created_at': '2026-03-18T00:00:00Z',
        };

        final role = RoleModel.fromJson(json);

        expect(role.id, 'role-admin-001');
        expect(role.name, 'admin');
        expect(role.displayNameEn, 'Admin');
        expect(role.displayNameAr, 'مسؤول');
        expect(role.requiresApproval, true);
      });

      test('should support role equality', () {
        final role1 = RoleModel(
          id: 'role-123',
          name: 'doctor',
          displayNameAr: 'طبيب',
          displayNameEn: 'Doctor',
          requiresApproval: true,
          requires2FA: false,
          requiresEmailVerification: true,
          createdAt: DateTime.parse('2026-03-18T00:00:00Z'),
        );

        final role2 = RoleModel(
          id: 'role-123',
          name: 'doctor',
          displayNameAr: 'طبيب',
          displayNameEn: 'Doctor',
          requiresApproval: true,
          requires2FA: false,
          requiresEmailVerification: true,
          createdAt: DateTime.parse('2026-03-18T00:00:00Z'),
        );

        expect(role1, equals(role2));
      });

      test('should identify different roles correctly', () {
        final patient = RoleModel(
          id: 'role-patient',
          name: 'patient',
          displayNameAr: 'مريض',
          displayNameEn: 'Patient',
          requiresApproval: false,
          requires2FA: false,
          requiresEmailVerification: true,
        );

        final admin = RoleModel(
          id: 'role-admin',
          name: 'admin',
          displayNameAr: 'مسؤول',
          displayNameEn: 'Admin',
          requiresApproval: true,
          requires2FA: true,
          requiresEmailVerification: true,
        );

        expect(patient.name, 'patient');
        expect(admin.name, 'admin');
        expect(patient.requiresApproval, false);
        expect(admin.requiresApproval, true);
        expect(patient.requires2FA, false);
        expect(admin.requires2FA, true);
      });
    });

    group('Bilingual Support', () {
      test('should support Arabic and English display names', () {
        final roles = [
          ('doctor', 'طبيب', 'Doctor'),
          ('patient', 'مريض', 'Patient'),
          ('nurse', 'ممرضة', 'Nurse'),
          ('admin', 'مسؤول', 'Admin'),
          ('receptionist', 'موظفة استقبال', 'Receptionist'),
        ];

        for (final (name, ar, en) in roles) {
          final role = RoleModel(
            id: 'role-$name',
            name: name,
            displayNameAr: ar,
            displayNameEn: en,
            requiresApproval: false,
            requires2FA: false,
            requiresEmailVerification: true,
          );

          expect(role.displayNameAr, ar);
          expect(role.displayNameEn, en);
        }
      });

      test('should preserve localization in JSON round trip', () {
        final role = RoleModel(
          id: 'role-test',
          name: 'test_role',
          displayNameAr: 'دور اختبار',
          displayNameEn: 'Test Role',
          requiresApproval: false,
          requires2FA: false,
          requiresEmailVerification: true,
        );

        final json = role.toJson();
        final restored = RoleModel.fromJson(json);

        expect(restored.displayNameAr, 'دور اختبار');
        expect(restored.displayNameEn, 'Test Role');
      });
    });

    group('Role Configuration Options', () {
      test('should track approval requirements', () {
        final roles = [
          ('patient', false),
          ('doctor', true),
          ('nurse', true),
          ('admin', true),
          ('super_admin', true),
        ];

        for (final (name, needsApproval) in roles) {
          final role = RoleModel(
            id: 'role-$name',
            name: name,
            displayNameAr: 'دور',
            displayNameEn: 'Role',
            requiresApproval: needsApproval,
            requires2FA: false,
            requiresEmailVerification: true,
          );

          expect(role.requiresApproval, needsApproval,
              reason: '$name approval setting incorrect');
        }
      });

      test('should track 2FA requirements', () {
        final adminRole = RoleModel(
          id: 'role-admin',
          name: 'admin',
          displayNameAr: 'مسؤول',
          displayNameEn: 'Admin',
          requiresApproval: true,
          requires2FA: true,
          requiresEmailVerification: true,
        );

        final patientRole = RoleModel(
          id: 'role-patient',
          name: 'patient',
          displayNameAr: 'مريض',
          displayNameEn: 'Patient',
          requiresApproval: false,
          requires2FA: false,
          requiresEmailVerification: true,
        );

        expect(adminRole.requires2FA, true);
        expect(patientRole.requires2FA, false);
      });

      test('should track email verification requirements', () {
        final role = RoleModel(
          id: 'role-user',
          name: 'user',
          displayNameAr: 'المستخدم',
          displayNameEn: 'User',
          requiresApproval: false,
          requires2FA: false,
          requiresEmailVerification: true,
        );

        expect(role.requiresEmailVerification, true);
      });
    });
  });
}
