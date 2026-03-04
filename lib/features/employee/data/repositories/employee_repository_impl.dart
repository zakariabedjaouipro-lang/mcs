/// Employee Repository Implementation
library;

import 'package:dartz/dartz.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/errors/exceptions.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/models/employee_model.dart';
import 'package:mcs/core/models/inventory_model.dart';
import 'package:mcs/core/models/invoice_model.dart';
import 'package:mcs/core/models/patient_model.dart';
import 'package:mcs/core/services/supabase_service.dart';
import 'package:mcs/features/employee/domain/repositories/employee_repository.dart';

/// Employee repository implementation
class EmployeeRepositoryImpl implements EmployeeRepository {
  final SupabaseService _supabaseService;

  EmployeeRepositoryImpl(this._supabaseService);

  @override
  Future<Either<Failure, EmployeeModel>> getEmployeeProfile() async {
    try {
      final userId = _supabaseService.currentUserId;
      if (userId == null) {
        throw const ServerException('User not authenticated');
      }

      final response = await _supabaseService.fetchAll(
        'employees',
        filters: {'user_id': userId},
      );

      if (response.isEmpty) {
        throw const ServerException('Employee profile not found');
      }

      return Right(EmployeeModel.fromJson(response.first));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to load employee profile: $e'));
    }
  }

  @override
  Future<Either<Failure, EmployeeModel>> updateEmployeeProfile(EmployeeModel profile) async {
    try {
      final response = await _supabaseService.update(
        'employees',
        profile.id,
        profile.toJson(),
      );
      return Right(EmployeeModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update employee profile: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PatientModel>>> getPatients() async {
    try {
      final response = await _supabaseService.fetchAll('patients');
      final patients = response.map((json) => PatientModel.fromJson(json)).toList();
      return Right(patients);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to load patients: $e'));
    }
  }

  @override
  Future<Either<Failure, PatientModel>> getPatientDetails(String patientId) async {
    try {
      final response = await _supabaseService.fetchById('patients', patientId);
      return Right(PatientModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to load patient details: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> registerPatient(Map<String, dynamic> patientData) async {
    try {
      await _supabaseService.insert('patients', patientData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to register patient: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePatient(String patientId, Map<String, dynamic> patientData) async {
    try {
      await _supabaseService.update('patients', patientId, patientData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update patient: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PatientModel>>> searchPatients(String query) async {
    try {
      final response = await _supabaseService.fetchAll(
        'patients',
        filters: {'name': query},
      );

      final patients = response.map((json) => PatientModel.fromJson(json)).toList();
      return Right(patients);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to search patients: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentModel>>> getAppointments({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    try {
      Map<String, dynamic> filters = {};
      if (status != null) {
        filters['status'] = status;
      }

      final appointmentsResponse = await _supabaseService.fetchAll(
        'appointments',
        filters: filters,
      );

      final appointments = appointmentsResponse
          .map((json) => AppointmentModel.fromJson(json))
          .where((appointment) {
            if (startDate != null && appointment.appointmentDate.isBefore(startDate)) {
              return false;
            }
            if (endDate != null && appointment.appointmentDate.isAfter(endDate)) {
              return false;
            }
            return true;
          })
          .toList();

      return Right(appointments);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to load appointments: $e'));
    }
  }

  @override
  Future<Either<Failure, AppointmentModel>> getAppointmentDetails(String appointmentId) async {
    try {
      final response = await _supabaseService.fetchById('appointments', appointmentId);
      return Right(AppointmentModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to load appointment details: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> bookAppointment(Map<String, dynamic> appointmentData) async {
    try {
      await _supabaseService.insert('appointments', appointmentData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to book appointment: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAppointment(String appointmentId, String reason) async {
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
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to cancel appointment: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> rescheduleAppointment(String appointmentId, DateTime newDateTime) async {
    try {
      await _supabaseService.update(
        'appointments',
        appointmentId,
        {
          'appointment_date': newDateTime.toIso8601String(),
        },
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to reschedule appointment: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> checkInPatient(String appointmentId) async {
    try {
      await _supabaseService.update(
        'appointments',
        appointmentId,
        {
          'status': 'in_progress',
          'check_in_time': DateTime.now().toIso8601String(),
        },
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to check in patient: $e'));
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
          'check_out_time': DateTime.now().toIso8601String(),
        },
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to check out patient: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> recordVitalSigns(String patientId, Map<String, dynamic> vitalSigns) async {
    try {
      vitalSigns['patient_id'] = patientId;
      vitalSigns['recorded_at'] = DateTime.now().toIso8601String();
      await _supabaseService.insert('vital_signs', vitalSigns);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to record vital signs: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPatientVitalSigns(String patientId) async {
    try {
      final response = await _supabaseService.fetchAll(
        'vital_signs',
        filters: {'patient_id': patientId},
      );

      if (response.isEmpty) {
        return Right({});
      }

      return Right(response.first);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to load vital signs: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> uploadLabResult(Map<String, dynamic> labResult) async {
    try {
      await _supabaseService.insert('lab_results', labResult);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to upload lab result: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getLabResults(String patientId) async {
    try {
      final response = await _supabaseService.fetchAll(
        'lab_results',
        filters: {'patient_id': patientId},
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to load lab results: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateLabResult(String resultId, Map<String, dynamic> resultData) async {
    try {
      await _supabaseService.update('lab_results', resultId, resultData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update lab result: $e'));
    }
  }

  @override
  Future<Either<Failure, List<InventoryModel>>> getInventory() async {
    try {
      final response = await _supabaseService.fetchAll('inventory');
      final inventory = response.map((json) => InventoryModel.fromJson(json)).toList();
      return Right(inventory);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to load inventory: $e'));
    }
  }

  @override
  Future<Either<Failure, InventoryModel>> getInventoryItem(String itemId) async {
    try {
      final response = await _supabaseService.fetchById('inventory', itemId);
      return Right(InventoryModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to load inventory item: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addInventoryItem(Map<String, dynamic> itemData) async {
    try {
      await _supabaseService.insert('inventory', itemData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to add inventory item: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateInventoryItem(String itemId, Map<String, dynamic> itemData) async {
    try {
      await _supabaseService.update('inventory', itemId, itemData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update inventory item: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteInventoryItem(String itemId) async {
    try {
      await _supabaseService.delete('inventory', itemId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to delete inventory item: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> recordInventoryTransaction(Map<String, dynamic> transactionData) async {
    try {
      await _supabaseService.insert('inventory_transactions', transactionData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to record inventory transaction: $e'));
    }
  }

  @override
  Future<Either<Failure, List<InvoiceModel>>> getInvoices({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    try {
      Map<String, dynamic> filters = {};
      if (status != null) {
        filters['status'] = status;
      }

      final invoicesResponse = await _supabaseService.fetchAll(
        'invoices',
        filters: filters,
      );

      final invoices = invoicesResponse
          .map((json) => InvoiceModel.fromJson(json))
          .where((invoice) {
            if (startDate != null && invoice.invoiceDate.isBefore(startDate)) {
              return false;
            }
            if (endDate != null && invoice.invoiceDate.isAfter(endDate)) {
              return false;
            }
            return true;
          })
          .toList();

      return Right(invoices);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to load invoices: $e'));
    }
  }

  @override
  Future<Either<Failure, InvoiceModel>> getInvoiceDetails(String invoiceId) async {
    try {
      final response = await _supabaseService.fetchById('invoices', invoiceId);
      return Right(InvoiceModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to load invoice details: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> createInvoice(Map<String, dynamic> invoiceData) async {
    try {
      await _supabaseService.insert('invoices', invoiceData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to create invoice: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateInvoice(String invoiceId, Map<String, dynamic> invoiceData) async {
    try {
      await _supabaseService.update('invoices', invoiceId, invoiceData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update invoice: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> processPayment(String invoiceId, Map<String, dynamic> paymentData) async {
    try {
      await _supabaseService.update(
        'invoices',
        invoiceId,
        {
          'status': 'paid',
          'payment_date': DateTime.now().toIso8601String(),
          ...paymentData,
        },
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to process payment: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats() async {
    try {
      final appointmentsResponse = await _supabaseService.fetchAll('appointments');
      final patientsResponse = await _supabaseService.fetchAll('patients');
      final invoicesResponse = await _supabaseService.fetchAll('invoices');

      final stats = {
        'total_patients': patientsResponse.length,
        'total_appointments': appointmentsResponse.length,
        'today_appointments': appointmentsResponse.where((a) {
          final date = DateTime.parse(a['appointment_date']);
          return date.day == DateTime.now().day &&
                 date.month == DateTime.now().month &&
                 date.year == DateTime.now().year;
        }).length,
        'pending_appointments': appointmentsResponse.where((a) => a['status'] == 'pending').length,
        'total_invoices': invoicesResponse.length,
        'pending_invoices': invoicesResponse.where((i) => i['status'] == 'pending').length,
        'paid_invoices': invoicesResponse.where((i) => i['status'] == 'paid').length,
      };

      return Right(stats);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to load dashboard stats: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendNotificationToPatient(String patientId, String title, String body) async {
    try {
      // TODO: Implement notification sending
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to send notification: $e'));
    }
  }
}