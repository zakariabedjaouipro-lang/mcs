/// Employee Repository Implementation
library;

import 'package:dartz/dartz.dart';
import 'package:mcs/core/errors/exceptions.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/models/employee_model.dart';
import 'package:mcs/core/models/inventory_model.dart';
import 'package:mcs/core/models/invoice_model.dart';
import 'package:mcs/core/models/patient_model.dart';
import 'package:mcs/core/services/notification_service.dart';
import 'package:mcs/core/services/supabase_service.dart';
import 'package:mcs/features/employee/domain/repositories/employee_repository.dart';

/// Employee repository implementation
/// Handles all employee-related data operations including profile, patients,
/// appointments, inventory, invoices, and notifications.
class EmployeeRepositoryImpl implements EmployeeRepository {
  /// Constructor
  EmployeeRepositoryImpl(
    this._supabaseService,
    this._notificationService,
  );

  final SupabaseService _supabaseService;
  final NotificationService _notificationService;

  // PROFILE MANAGEMENT

  @override
  Future<Either<Failure, EmployeeModel>> getEmployeeProfile() async {
    try {
      final userId = _supabaseService.currentUserId;
      if (userId == null) {
        throw const ServerException(message: 'User not authenticated');
      }

      final response = await _supabaseService.fetchAll(
        'employees',
        filters: {'user_id': userId},
      );

      if (response.isEmpty) {
        throw const ServerException(message: 'Employee profile not found');
      }

      return Right(EmployeeModel.fromJson(response.first));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to load employee profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, EmployeeModel>> updateEmployeeProfile(
    EmployeeModel profile,
  ) async {
    try {
      final response = await _supabaseService.update(
        'employees',
        profile.id,
        profile.toJson(),
      );
      return Right(EmployeeModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update employee profile: $e'),
      );
    }
  }

  // PATIENT MANAGEMENT

  @override
  Future<Either<Failure, List<PatientModel>>> getPatients() async {
    try {
      final response = await _supabaseService.fetchAll('patients');
      final patients = response.map(PatientModel.fromJson).toList();
      return Right(patients);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load patients: $e'));
    }
  }

  @override
  Future<Either<Failure, PatientModel>> getPatientDetails(
    String patientId,
  ) async {
    try {
      final response = await _supabaseService.fetchById('patients', patientId);
      return Right(PatientModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to load patient details: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> registerPatient(
    Map<String, dynamic> patientData,
  ) async {
    try {
      await _supabaseService.insert('patients', patientData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to register patient: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePatient(
    String patientId,
    Map<String, dynamic> patientData,
  ) async {
    try {
      await _supabaseService.update('patients', patientId, patientData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update patient: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PatientModel>>> searchPatients(
    String query,
  ) async {
    try {
      final response = await _supabaseService.fetchAll('patients');
      // Filter patients locally by searching in their data
      final filteredPatients =
          response.map(PatientModel.fromJson).where((patient) {
        // Search can be customized based on PatientModel properties
        return patient.id.toLowerCase().contains(query.toLowerCase());
      }).toList();
      return Right(filteredPatients);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to search patients: $e'));
    }
  }

  // APPOINTMENT MANAGEMENT

  @override
  Future<Either<Failure, List<AppointmentModel>>> getAppointments({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    try {
      final filters = <String, dynamic>{};
      if (status != null) {
        filters['status'] = status;
      }

      final response = await _supabaseService.fetchAll(
        'appointments',
        filters: filters,
      );

      var appointments = response.map(AppointmentModel.fromJson).toList();
      if (startDate != null || endDate != null) {
        appointments = appointments.where((appointment) {
          if (startDate != null &&
              appointment.appointmentDate.isBefore(startDate)) {
            return false;
          }
          if (endDate != null && appointment.appointmentDate.isAfter(endDate)) {
            return false;
          }
          return true;
        }).toList();
      }

      return Right(appointments);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load appointments: $e'));
    }
  }

  @override
  Future<Either<Failure, AppointmentModel>> getAppointmentDetails(
    String appointmentId,
  ) async {
    try {
      final response = await _supabaseService.fetchById(
        'appointments',
        appointmentId,
      );
      return Right(AppointmentModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to load appointment details: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> bookAppointment(
    Map<String, dynamic> appointmentData,
  ) async {
    try {
      await _supabaseService.insert('appointments', appointmentData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to book appointment: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAppointment(
    String appointmentId,
    String reason,
  ) async {
    try {
      await _supabaseService.update(
        'appointments',
        appointmentId,
        {
          'status': 'cancelled',
          'cancellation_reason': reason,
        },
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to cancel appointment: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> rescheduleAppointment(
    String appointmentId,
    DateTime newDateTime,
  ) async {
    try {
      await _supabaseService.update(
        'appointments',
        appointmentId,
        {
          'appointment_date': newDateTime.toIso8601String(),
          'status': 'rescheduled',
        },
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to reschedule appointment: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> checkInPatient(String appointmentId) async {
    try {
      await _supabaseService.update(
        'appointments',
        appointmentId,
        {
          'status': 'checked_in',
          'checked_in_at': DateTime.now().toIso8601String(),
        },
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to check in patient: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> checkOutPatient(String appointmentId) async {
    try {
      await _supabaseService.update(
        'appointments',
        appointmentId,
        {
          'status': 'completed',
          'checked_out_at': DateTime.now().toIso8601String(),
        },
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to check out patient: $e'));
    }
  }

  // VITAL SIGNS MANAGEMENT

  @override
  Future<Either<Failure, void>> recordVitalSigns(
    String patientId,
    Map<String, dynamic> vitalSigns,
  ) async {
    try {
      final data = {
        ...vitalSigns,
        'patient_id': patientId,
        'recorded_at': DateTime.now().toIso8601String(),
      };
      await _supabaseService.insert('vital_signs', data);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to record vital signs: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPatientVitalSigns(
    String patientId,
  ) async {
    try {
      final response = await _supabaseService.fetchAll(
        'vital_signs',
        filters: {'patient_id': patientId},
      );

      if (response.isEmpty) {
        return const Right({});
      }

      return Right(response.first);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to load patient vital signs: $e'),
      );
    }
  }

  // LAB RESULTS MANAGEMENT

  @override
  Future<Either<Failure, void>> uploadLabResult(
    Map<String, dynamic> labResult,
  ) async {
    try {
      await _supabaseService.insert('lab_results', labResult);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to upload lab result: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getLabResults(
    String patientId,
  ) async {
    try {
      final response = await _supabaseService.fetchAll(
        'lab_results',
        filters: {'patient_id': patientId},
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load lab results: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateLabResult(
    String resultId,
    Map<String, dynamic> resultData,
  ) async {
    try {
      await _supabaseService.update('lab_results', resultId, resultData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update lab result: $e'));
    }
  }

  // INVENTORY MANAGEMENT

  @override
  Future<Either<Failure, List<InventoryModel>>> getInventory() async {
    try {
      final response = await _supabaseService.fetchAll('inventory');
      final items = response.map(InventoryModel.fromJson).toList();
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load inventory: $e'));
    }
  }

  @override
  Future<Either<Failure, InventoryModel>> getInventoryItem(
    String itemId,
  ) async {
    try {
      final response = await _supabaseService.fetchById('inventory', itemId);
      return Right(InventoryModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to load inventory item: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> addInventoryItem(
    Map<String, dynamic> itemData,
  ) async {
    try {
      await _supabaseService.insert('inventory', itemData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to add inventory item: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateInventoryItem(
    String itemId,
    Map<String, dynamic> itemData,
  ) async {
    try {
      await _supabaseService.update('inventory', itemId, itemData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update inventory item: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteInventoryItem(String itemId) async {
    try {
      await _supabaseService.delete('inventory', itemId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to delete inventory item: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> recordInventoryTransaction(
    Map<String, dynamic> transactionData,
  ) async {
    try {
      final data = {
        ...transactionData,
        'transaction_date': DateTime.now().toIso8601String(),
      };
      await _supabaseService.insert('inventory_transactions', data);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to record inventory transaction: $e',
        ),
      );
    }
  }

  // INVOICE MANAGEMENT

  @override
  Future<Either<Failure, List<InvoiceModel>>> getInvoices({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    try {
      final filters = <String, dynamic>{};
      if (status != null) {
        filters['status'] = status;
      }

      final response = await _supabaseService.fetchAll(
        'invoices',
        filters: filters,
      );

      var invoices = response.map(InvoiceModel.fromJson).toList();

      if (startDate != null || endDate != null) {
        invoices = invoices.where((invoice) {
          if (startDate != null && invoice.createdAt.isBefore(startDate)) {
            return false;
          }
          if (endDate != null && invoice.createdAt.isAfter(endDate)) {
            return false;
          }
          return true;
        }).toList();
      }

      return Right(invoices);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load invoices: $e'));
    }
  }

  @override
  Future<Either<Failure, InvoiceModel>> getInvoiceDetails(
    String invoiceId,
  ) async {
    try {
      final response = await _supabaseService.fetchById('invoices', invoiceId);
      return Right(InvoiceModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to load invoice details: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> createInvoice(
    Map<String, dynamic> invoiceData,
  ) async {
    try {
      final data = {
        ...invoiceData,
        'created_at': DateTime.now().toIso8601String(),
        'status': 'draft',
      };
      await _supabaseService.insert('invoices', data);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to create invoice: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateInvoice(
    String invoiceId,
    Map<String, dynamic> invoiceData,
  ) async {
    try {
      await _supabaseService.update('invoices', invoiceId, invoiceData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update invoice: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> processPayment(
    String invoiceId,
    Map<String, dynamic> paymentData,
  ) async {
    try {
      await _supabaseService.update(
        'invoices',
        invoiceId,
        {
          'status': 'paid',
          'paid_at': DateTime.now().toIso8601String(),
        },
      );

      final payment = {
        ...paymentData,
        'invoice_id': invoiceId,
        'payment_date': DateTime.now().toIso8601String(),
      };
      await _supabaseService.insert('payments', payment);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to process payment: $e'));
    }
  }

  // STATISTICS & NOTIFICATIONS

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats() async {
    try {
      final patientsResponse = await _supabaseService.fetchAll('patients');
      final totalPatients = patientsResponse.length;

      final appointmentsResponse =
          await _supabaseService.fetchAll('appointments');
      final totalAppointments = appointmentsResponse.length;

      final now = DateTime.now();
      final todayAppointments = appointmentsResponse.where((a) {
        final dateStr = a['appointment_date'] as String?;
        if (dateStr == null) return false;
        final date = DateTime.parse(dateStr);
        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
      }).length;

      final pendingAppointments =
          appointmentsResponse.where((a) => a['status'] == 'pending').length;

      final completedAppointments =
          appointmentsResponse.where((a) => a['status'] == 'completed').length;

      return Right({
        'total_patients': totalPatients,
        'total_appointments': totalAppointments,
        'today_appointments': todayAppointments,
        'pending_appointments': pendingAppointments,
        'completed_appointments': completedAppointments,
      });
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to load dashboard stats: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> sendNotificationToPatient(
    String patientId,
    String title,
    String body,
  ) async {
    try {
      await _supabaseService.fetchById('patients', patientId);
      await _notificationService.showLocalNotification(
        id: patientId.hashCode,
        title: title,
        body: body,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to send notification: $e'),
      );
    }
  }
}
