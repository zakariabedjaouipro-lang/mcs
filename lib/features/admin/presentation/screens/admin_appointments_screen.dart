import 'package:flutter/material.dart';
import 'package:mcs/core/extensions/context_extensions.dart';

/// Admin Appointments Screen
class AdminAppointmentsScreen extends StatefulWidget {
  const AdminAppointmentsScreen({super.key});

  @override
  State<AdminAppointmentsScreen> createState() => _AdminAppointmentsScreenState();
}

class _AdminAppointmentsScreenState extends State<AdminAppointmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('appointments')),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle filter selection
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'today',
                child: Text(context.translateSafe('today')),
              ),
              PopupMenuItem(
                value: 'upcoming',
                child: Text(context.translateSafe('upcoming')),
              ),
              PopupMenuItem(
                value: 'all',
                child: Text(context.translateSafe('all')),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: context.translateSafe('search_appointments'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildAppointmentsList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _getAppointments().length,
      itemBuilder: (context, index) {
        final appointment = _getAppointments()[index];
        return _buildAppointmentCard(context, appointment);
      },
    );
  }

  Widget _buildAppointmentCard(BuildContext context, Appointment appointment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${appointment.date.day}/${appointment.date.month}/${appointment.date.year} ${appointment.time}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(context, appointment.status).withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    appointment.status,
                    style: TextStyle(
                      color: _getStatusColor(context, appointment.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    appointment.patientName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.person_2, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    appointment.doctorName,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.medical_services, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    appointment.specialty,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    appointment.patientPhone,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              appointment.reason,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.visibility, size: 16),
                    label: Text(context.translateSafe('view_details')),
                    onPressed: () {
                      // View appointment details
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit, size: 16),
                    label: Text(context.translateSafe('edit')),
                    onPressed: () {
                      // Edit appointment
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'no-show':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}

// Mock data classes
class Appointment {
  final DateTime date;
  final String time;
  final String patientName;
  final String doctorName;
  final String specialty;
  final String patientPhone;
  final String reason;
  final String status;

  Appointment({
    required this.date,
    required this.time,
    required this.patientName,
    required this.doctorName,
    required this.specialty,
    required this.patientPhone,
    required this.reason,
    required this.status,
  });
}

List<Appointment> _getAppointments() {
  return [
    Appointment(
      date: DateTime.now(),
      time: '09:00 AM',
      patientName: 'Ahmed Ali',
      doctorName: 'Dr. Mohamed Hassan',
      specialty: 'Cardiology',
      patientPhone: '+971 50 123 4567',
      reason: 'Regular checkup',
      status: 'Confirmed',
    ),
    Appointment(
      date: DateTime.now(),
      time: '10:30 AM',
      patientName: 'Fatima Mohamed',
      doctorName: 'Dr. Sarah Ahmed',
      specialty: 'Dermatology',
      patientPhone: '+971 50 987 6543',
      reason: 'Follow-up consultation',
      status: 'Confirmed',
    ),
    Appointment(
      date: DateTime.now().add(const Duration(days: 1)),
      time: '02:00 PM',
      patientName: 'Omar Hassan',
      doctorName: 'Dr. Ali Mohamed',
      specialty: 'Orthopedics',
      patientPhone: '+971 50 555 1234',
      reason: 'Prescription renewal',
      status: 'Pending',
    ),
  ];
}