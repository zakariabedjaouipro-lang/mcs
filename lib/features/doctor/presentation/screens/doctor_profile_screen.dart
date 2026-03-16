import 'package:flutter/material.dart';
import 'package:mcs/core/extensions/context_extensions.dart';

/// Doctor Profile Screen
class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('profile')),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Edit profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildPersonalInfoCard(),
            const SizedBox(height: 16),
            _buildProfessionalInfoCard(),
            const SizedBox(height: 16),
            _buildScheduleCard(),
            const SizedBox(height: 16),
            _buildEmergencyContactCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
            ),
            child: const CircleAvatar(
              radius: 58,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Dr. Ahmed Mohamed',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Cardiologist • 10+ years experience',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.translateSafe('personal_information'),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            _buildInfoRow(
              Icons.person,
              context.translateSafe('full_name'),
              'Ahmed Mohamed Hassan',
            ),
            _buildInfoRow(
              Icons.cake,
              context.translateSafe('date_of_birth'),
              '1984-05-15',
            ),
            _buildInfoRow(
              Icons.male,
              context.translateSafe('gender'),
              context.translateSafe('male'),
            ),
            _buildInfoRow(
              Icons.email,
              context.translateSafe('email'),
              'ahmed.mohamed@hospital.com',
            ),
            _buildInfoRow(
              Icons.phone,
              context.translateSafe('phone'),
              '+971 50 123 4567',
            ),
            _buildInfoRow(
              Icons.location_on,
              context.translateSafe('address'),
              'Dubai, UAE',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.translateSafe('professional_information'),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            _buildInfoRow(
              Icons.work,
              context.translateSafe('specialty'),
              'Cardiology',
            ),
            _buildInfoRow(
              Icons.business,
              context.translateSafe('hospital_clinic'),
              'Dubai Hospital',
            ),
            _buildInfoRow(
              Icons.calendar_today,
              context.translateSafe('years_of_experience'),
              '10+ years',
            ),
            _buildInfoRow(
              Icons.school,
              context.translateSafe('education'),
              'MD from Harvard Medical School',
            ),
            _buildInfoRow(
              Icons.verified,
              context.translateSafe('license_number'),
              'MED-12345',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.translateSafe('schedule'),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            _buildScheduleRow('Monday', '9:00 AM - 5:00 PM'),
            _buildScheduleRow('Tuesday', '9:00 AM - 5:00 PM'),
            _buildScheduleRow('Wednesday', '9:00 AM - 5:00 PM'),
            _buildScheduleRow('Thursday', '9:00 AM - 5:00 PM'),
            _buildScheduleRow('Friday', '9:00 AM - 1:00 PM'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContactCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.translateSafe('emergency_contact'),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            _buildInfoRow(
              Icons.contact_phone,
              context.translateSafe('contact_name'),
              'Sarah Hassan',
            ),
            _buildInfoRow(
              Icons.phone,
              context.translateSafe('contact_phone'),
              '+971 50 987 6543',
            ),
            _buildInfoRow(
              Icons.family_restroom,
              context.translateSafe('relationship'),
              'Spouse',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(String day, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              day,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              time,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
