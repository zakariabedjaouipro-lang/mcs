import 'package:flutter/material.dart';
import 'package:mcs/core/extensions/context_extensions.dart';

/// Admin Employees Screen
class AdminEmployeesScreen extends StatefulWidget {
  const AdminEmployeesScreen({super.key});

  @override
  State<AdminEmployeesScreen> createState() => _AdminEmployeesScreenState();
}

class _AdminEmployeesScreenState extends State<AdminEmployeesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('employees')),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle sorting/filtering
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'name',
                child: Text(context.translateSafe('sort_by_name')),
              ),
              PopupMenuItem(
                value: 'department',
                child: Text(context.translateSafe('sort_by_department')),
              ),
              PopupMenuItem(
                value: 'status',
                child: Text(context.translateSafe('sort_by_status')),
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
                hintText: context.translateSafe('search_employees'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildEmployeesList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeesList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _getEmployees().length,
      itemBuilder: (context, index) {
        final employee = _getEmployees()[index];
        return _buildEmployeeCard(context, employee);
      },
    );
  }

  Widget _buildEmployeeCard(BuildContext context, Employee employee) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to employee details
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          employee.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(context, employee.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            employee.status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.work, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          employee.position,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          employee.phone,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.email, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            employee.email,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'on leave':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

// Mock data classes
class Employee {
  Employee({
    required this.name,
    required this.position,
    required this.phone,
    required this.email,
    required this.status,
    required this.department,
    required this.clinic,
    required this.yearsOfExperience,
  });
  final String name;
  final String position;
  final String phone;
  final String email;
  final String status;
  final String department;
  final String clinic;
  final int yearsOfExperience;
}

List<Employee> _getEmployees() {
  return [
    Employee(
      name: 'Mohamed Hassan',
      position: 'Receptionist',
      phone: '+971 50 123 4567',
      email: 'mohamed.hassan@clinic.com',
      status: 'Active',
      department: 'Front Desk',
      clinic: 'Al Noor Medical Center',
      yearsOfExperience: 5,
    ),
    Employee(
      name: 'Fatima Ali',
      position: 'Nurse',
      phone: '+971 50 987 6543',
      email: 'fatima.ali@clinic.com',
      status: 'Active',
      department: 'Nursing',
      clinic: 'Al Noor Medical Center',
      yearsOfExperience: 7,
    ),
    Employee(
      name: 'Omar Khalid',
      position: 'Lab Technician',
      phone: '+971 50 555 1234',
      email: 'omar.khalid@clinic.com',
      status: 'On Leave',
      department: 'Laboratory',
      clinic: 'Al Noor Medical Center',
      yearsOfExperience: 4,
    ),
    Employee(
      name: 'Aisha Ahmed',
      position: 'Pharmacist',
      phone: '+971 50 777 8888',
      email: 'aisha.ahmed@clinic.com',
      status: 'Active',
      department: 'Pharmacy',
      clinic: 'Al Noor Medical Center',
      yearsOfExperience: 6,
    ),
    Employee(
      name: 'Youssef Omar',
      position: 'Administrator',
      phone: '+971 50 999 0000',
      email: 'youssef.omar@clinic.com',
      status: 'Pending',
      department: 'Administration',
      clinic: 'Al Noor Medical Center',
      yearsOfExperience: 10,
    ),
  ];
}
