/// Patient Appointments Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/constants/app_routes.dart';
import 'package:mcs/core/enums/appointment_status.dart';
import 'package:mcs/core/extensions/context_extension.dart';
import 'package:mcs/core/extensions/safe_extensions.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';
import 'package:mcs/features/patient/presentation/screens/patient_book_appointment_screen.dart';

/// Patient appointments list screen
class PatientAppointmentsScreen extends StatefulWidget {
  const PatientAppointmentsScreen({super.key});

  @override
  State<PatientAppointmentsScreen> createState() =>
      _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState extends State<PatientAppointmentsScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // ✅ لا نستخدم context هنا
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ آمن تماماً هنا
    if (!_isInitialized) {
      context.read<PatientBloc>().add(LoadAppointments());
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('appointments')),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const PatientBookAppointmentScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          if (state is PatientLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AppointmentsLoaded) {
            if (state.appointments.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildAppointmentsList(state.appointments);
          } else if (state is PatientError) {
            return _buildErrorState(state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            context.translateSafe('no_appointments'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            context.translateSafe('book_first_appointment'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const PatientBookAppointmentScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: Text(context.tr('book_appointment')),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(List<AppointmentModel> appointments) {
    // Sort by date (upcoming first)
    final sortedAppointments = List<AppointmentModel>.from(appointments)
      ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedAppointments.length,
      itemBuilder: (context, index) {
        final appointment = sortedAppointments[index];
        return _buildAppointmentCard(appointment);
      },
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment) {
    final isUpcoming = appointment.appointmentDate.isAfter(DateTime.now());

    Color statusColor;
    String statusText;

    switch (appointment.status) {
      case AppointmentStatus.pending:
        statusColor = Colors.orange;
        statusText = context.translateSafe('pending');
      case AppointmentStatus.confirmed:
        statusColor = Colors.green;
        statusText = context.translateSafe('confirmed');
      case AppointmentStatus.cancelled:
        statusColor = Colors.red;
        statusText = context.translateSafe('cancelled');
      case AppointmentStatus.completed:
        statusColor = Colors.blue;
        statusText = context.translateSafe('completed');
      case AppointmentStatus.noShow:
        statusColor = Colors.grey;
        statusText = context.translateSafe('no_show');
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          context.push(AppRoutes.appointmentDetails(appointment.id));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${appointment.appointmentDate.day}/${appointment.appointmentDate.month}/${appointment.appointmentDate.year}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withAlphaSafe(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    appointment.timeSlot,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    appointment.type == AppointmentType.remote
                        ? Icons.video_call
                        : Icons.location_on,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    appointment.type == AppointmentType.remote
                        ? context.translateSafe('remote')
                        : context.translateSafe('in_person'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    appointment.doctorName ?? 'Doctor Name',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              if (appointment.notes != null &&
                  appointment.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  appointment.notes!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (isUpcoming) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.push(
                            AppRoutes.rescheduleAppointment(appointment.id),
                          );
                        },
                        icon: const Icon(Icons.schedule, size: 16),
                        label: Text(
                          context.translateSafe('reschedule'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showCancelDialog(appointment);
                        },
                        icon: const Icon(Icons.cancel, size: 16),
                        label: Text(
                          context.translateSafe('cancel'),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<PatientBloc>().add(LoadAppointments());
            },
            icon: const Icon(Icons.refresh),
            label: Text(context.translateSafe('retry')),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(AppointmentModel appointment) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.translateSafe('cancel_appointment')),
        content: Text(
          context.translateSafe('cancel_appointment_confirmation'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            },
            child: Text(context.translateSafe('no')),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context
                  .read<PatientBloc>()
                  .add(CancelAppointment(appointment.id));
            },
            child: Text(
              context.translateSafe('yes'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
