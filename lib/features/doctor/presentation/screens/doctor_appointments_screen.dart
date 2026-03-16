import 'package:flutter/material.dart';
import 'package:mcs/core/extensions/context_extensions.dart';

/// Doctor Appointments Screen
class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  State<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen> {
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
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: context.translateSafe('today')),
                Tab(text: context.translateSafe('upcoming')),
                Tab(text: context.translateSafe('completed')),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _TodayAppointmentsTab(),
                  _UpcomingAppointmentsTab(),
                  _CompletedAppointmentsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayAppointmentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildAppointmentsList(context, _getTodayAppointments());
  }
}

class _UpcomingAppointmentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildAppointmentsList(context, _getUpcomingAppointments());
  }
}

class _CompletedAppointmentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildAppointmentsList(context, _getCompletedAppointments());
  }
}

Widget _buildAppointmentsList(
    BuildContext context, List<Appointment> appointments) {
  if (appointments.isEmpty) {
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
        ],
      ),
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: appointments.length,
    itemBuilder: (context, index) {
      final appointment = appointments[index];
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appointment.time,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(context, appointment.status)
                      .withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  appointment.status,
                  style: TextStyle(
                    color: _getStatusColor(context, appointment.status),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text(appointment.patientName)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.phone, size: 16),
              const SizedBox(width: 8),
              Text(appointment.phoneNumber),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            appointment.reason,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.call, size: 16),
                  label: Text(context.translateSafe('call')),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check, size: 16),
                  label: Text(context.translateSafe('start_visit')),
                  onPressed: () {},
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
  switch (status) {
    case 'Confirmed':
      return Colors.green;
    case 'Pending':
      return Colors.orange;
    case 'Completed':
      return Colors.blue;
    case 'Cancelled':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

// Mock data classes
class Appointment {
  final String time;
  final String patientName;
  final String phoneNumber;
  final String reason;
  final String status;

  Appointment({
    required this.time,
    required this.patientName,
    required this.phoneNumber,
    required this.reason,
    required this.status,
  });
}

List<Appointment> _getTodayAppointments() {
  return [
    Appointment(
      time: '09:00 AM',
      patientName: 'Ahmed Ali',
      phoneNumber: '+971 50 123 4567',
      reason: 'Regular checkup',
      status: 'Confirmed',
    ),
    Appointment(
      time: '10:30 AM',
      patientName: 'Fatima Mohamed',
      phoneNumber: '+971 50 987 6543',
      reason: 'Follow-up consultation',
      status: 'Confirmed',
    ),
    Appointment(
      time: '02:00 PM',
      patientName: 'Omar Hassan',
      phoneNumber: '+971 50 555 1234',
      reason: 'Prescription renewal',
      status: 'Pending',
    ),
  ];
}

List<Appointment> _getUpcomingAppointments() {
  return [
    Appointment(
      time: 'Tomorrow 10:00 AM',
      patientName: 'Sara Khalid',
      phoneNumber: '+971 50 111 2222',
      reason: 'New consultation',
      status: 'Confirmed',
    ),
    Appointment(
      time: 'Tomorrow 11:30 AM',
      patientName: 'Youssef Adel',
      phoneNumber: '+971 50 333 4444',
      reason: 'Vaccination',
      status: 'Confirmed',
    ),
  ];
}

List<Appointment> _getCompletedAppointments() {
  return [
    Appointment(
      time: 'Yesterday 11:00 AM',
      patientName: 'Layla Ahmed',
      phoneNumber: '+971 50 777 8888',
      reason: 'Annual checkup',
      status: 'Completed',
    ),
    Appointment(
      time: 'Yesterday 03:00 PM',
      patientName: 'Khalid Omar',
      phoneNumber: '+971 50 999 0000',
      reason: 'Consultation',
      status: 'Completed',
    ),
  ];
}
