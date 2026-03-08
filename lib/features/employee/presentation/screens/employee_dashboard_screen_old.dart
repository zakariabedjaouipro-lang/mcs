import 'package:flutter/material.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Employee Dashboard',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildStatsGrid(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildTodayAppointments(),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================
  // Stats Cards
  // ===============================

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _StatCard(
          title: "Patients",
          value: "128",
          icon: Icons.people,
          color: Colors.blue,
        ),
        _StatCard(
          title: "Appointments",
          value: "42",
          icon: Icons.calendar_today,
          color: Colors.green,
        ),
        _StatCard(
          title: "Pending",
          value: "8",
          icon: Icons.hourglass_bottom,
          color: Colors.orange,
        ),
        _StatCard(
          title: "Completed",
          value: "30",
          icon: Icons.check_circle,
          color: Colors.purple,
        ),
      ],
    );
  }

  // ===============================
  // Quick Actions
  // ===============================

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _ActionButton(
              label: "Add Patient",
              icon: Icons.person_add,
            ),
            _ActionButton(
              label: "New Appointment",
              icon: Icons.add_circle,
            ),
            _ActionButton(
              label: "Scan Lab",
              icon: Icons.qr_code_scanner,
            ),
            _ActionButton(
              label: "Reports",
              icon: Icons.bar_chart,
            ),
          ],
        ),
      ],
    );
  }

  // ===============================
  // Today Appointments
  // ===============================

  Widget _buildTodayAppointments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Appointments",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _appointmentTile("Ahmed Benali", "10:00 AM"),
        _appointmentTile("Sara Mohamed", "11:30 AM"),
        _appointmentTile("Yacine Haddad", "02:15 PM"),
      ],
    );
  }

  Widget _appointmentTile(String name, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(name),
        subtitle: Text(time),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

// ===============================
// Stat Card Widget
// ===============================

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(title),
          ],
        ),
      ),
    );
  }
}

// ===============================
// Quick Action Button
// ===============================

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const _ActionButton({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Ink(
          decoration: const ShapeDecoration(
            color: Colors.blue,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: () {},
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
