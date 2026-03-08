import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mcs/core/extensions/context_extensions.dart';
import 'package:mcs/core/models/user_model.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('profile')),
        centerTitle: true,
      ),
      body: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          final user = _extractUser(state);

          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _ProfileHeader(user: user),
                const SizedBox(height: 24),
                _InfoCard(
                  title: context.translateSafe('personal_information'),
                  children: [
                    _InfoTile(
                      icon: Icons.person,
                      label: context.translateSafe('full_name'),
                      value: user.name ?? '',
                    ),
                    _InfoTile(
                      icon: Icons.email,
                      label: context.translateSafe('email'),
                      value: user.email ?? '',
                    ),
                    _InfoTile(
                      icon: Icons.phone,
                      label: context.translateSafe('phone'),
                      value: user.phone ?? '',
                    ),
                    _InfoTile(
                      icon: Icons.location_on,
                      label: context.translateSafe('address'),
                      value: user.address ?? '',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _InfoCard(
                  title: context.translateSafe('medical_information'),
                  children: [
                    _InfoTile(
                      icon: Icons.bloodtype,
                      label: context.translateSafe('blood_type'),
                      value: user.bloodType ?? '-',
                    ),
                    _InfoTile(
                      icon: Icons.warning,
                      label: context.translateSafe('allergies'),
                      value: user.allergies ?? '-',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _InfoCard(
                  title: context.translateSafe('emergency_contact'),
                  children: [
                    _InfoTile(
                      icon: Icons.contact_phone,
                      label: context.translateSafe('contact_name'),
                      value: user.emergencyContact ?? '-',
                    ),
                    _InfoTile(
                      icon: Icons.phone_in_talk,
                      label: context.translateSafe('contact_phone'),
                      value: user.emergencyContact ?? '-',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  UserModel? _extractUser(PatientState state) {
    try {
      final dynamic s = state;
      return s.user as UserModel?;
    } catch (_) {
      return null;
    }
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final name = user.name ?? '';
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            letter,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          user.email ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}
