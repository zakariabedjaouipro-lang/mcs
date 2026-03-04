/// Patient Profile Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/models/user_model.dart';
import 'package:mcs/core/widgets/custom_button.dart';
import 'package:mcs/core/widgets/custom_text_field.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';

/// Patient profile screen
class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _bloodTypeController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  
  DateTime? _dateOfBirth;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(LoadProfile());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bloodTypeController.dispose();
    _allergiesController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('profile')),
      ),
      body: BlocListener<PatientBloc, PatientState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _user = state.user;
            _populateFields(state.user);
          } else if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context).translate('profile_updated')),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is PatientError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<PatientBloc, PatientState>(
          builder: (context, state) {
            if (state is PatientLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    _buildProfileHeader(),
                    const SizedBox(height: 24),
                    
                    // Personal Information
                    _buildSection(
                      AppLocalizations.of(context).translate('personal_information'),
                      [
                        _buildNameField(),
                        const SizedBox(height: 16),
                        _buildPhoneField(),
                        const SizedBox(height: 16),
                        _buildDateOfBirthField(),
                        const SizedBox(height: 16),
                        _buildAddressField(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Medical Information
                    _buildSection(
                      AppLocalizations.of(context).translate('medical_information'),
                      [
                        _buildBloodTypeField(),
                        const SizedBox(height: 16),
                        _buildAllergiesField(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Emergency Contact
                    _buildSection(
                      AppLocalizations.of(context).translate('emergency_contact'),
                      [
                        _buildEmergencyContactField(),
                        const SizedBox(height: 16),
                        _buildEmergencyPhoneField(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Update Button
                    CustomButton(
                      text: AppLocalizations.of(context).translate('update_profile'),
                      onPressed: _updateProfile,
                    ),
                    const SizedBox(height: 16),
                    
                    // Change Password Button
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to change password screen
                      },
                      icon: const Icon(Icons.lock),
                      label: Text(AppLocalizations.of(context).translate('change_password')),
                    ),
                    const SizedBox(height: 16),
                    
                    // Social Accounts
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to social accounts screen
                      },
                      icon: const Icon(Icons.link),
                      label: Text(AppLocalizations.of(context).translate('link_social_accounts')),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  _user?.name.substring(0, 1).toUpperCase() ?? 'U',
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    onPressed: () {
                      // TODO: Implement profile photo upload
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _user?.name ?? 'User Name',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            _user?.email ?? 'user@example.com',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      controller: _nameController,
      label: AppLocalizations.of(context).translate('full_name'),
      hintText: AppLocalizations.of(context).translate('enter_full_name'),
      prefixIcon: Icons.person,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppLocalizations.of(context).translate('please_enter_name');
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return CustomTextField(
      controller: _phoneController,
      label: AppLocalizations.of(context).translate('phone'),
      hintText: AppLocalizations.of(context).translate('enter_phone'),
      prefixIcon: Icons.phone,
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppLocalizations.of(context).translate('please_enter_phone');
        }
        return null;
      },
    );
  }

  Widget _buildDateOfBirthField() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _dateOfBirth ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          setState(() {
            _dateOfBirth = date;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).translate('date_of_birth'),
          hintText: AppLocalizations.of(context).translate('select_date_of_birth'),
          prefixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
        ),
        child: Text(
          _dateOfBirth != null
              ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
              : '',
        ),
      ),
    );
  }

  Widget _buildAddressField() {
    return CustomTextField(
      controller: _addressController,
      label: AppLocalizations.of(context).translate('address'),
      hintText: AppLocalizations.of(context).translate('enter_address'),
      prefixIcon: Icons.location_on,
      maxLines: 2,
    );
  }

  Widget _buildBloodTypeField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).translate('blood_type'),
        hintText: AppLocalizations.of(context).translate('select_blood_type'),
        prefixIcon: const Icon(Icons.bloodtype),
        border: const OutlineInputBorder(),
      ),
      value: _bloodTypeController.text.isEmpty ? null : _bloodTypeController.text,
      items: const [
        DropdownMenuItem(value: 'A+', child: Text('A+')),
        DropdownMenuItem(value: 'A-', child: Text('A-')),
        DropdownMenuItem(value: 'B+', child: Text('B+')),
        DropdownMenuItem(value: 'B-', child: Text('B-')),
        DropdownMenuItem(value: 'AB+', child: Text('AB+')),
        DropdownMenuItem(value: 'AB-', child: Text('AB-')),
        DropdownMenuItem(value: 'O+', child: Text('O+')),
        DropdownMenuItem(value: 'O-', child: Text('O-')),
      ],
      onChanged: (value) {
        _bloodTypeController.text = value ?? '';
      },
    );
  }

  Widget _buildAllergiesField() {
    return CustomTextField(
      controller: _allergiesController,
      label: AppLocalizations.of(context).translate('allergies'),
      hintText: AppLocalizations.of(context).translate('enter_allergies'),
      prefixIcon: Icons.warning,
      maxLines: 3,
    );
  }

  Widget _buildEmergencyContactField() {
    return CustomTextField(
      controller: _emergencyContactController,
      label: AppLocalizations.of(context).translate('emergency_contact_name'),
      hintText: AppLocalizations.of(context).translate('enter_emergency_contact'),
      prefixIcon: Icons.person,
    );
  }

  Widget _buildEmergencyPhoneField() {
    return CustomTextField(
      controller: _emergencyPhoneController,
      label: AppLocalizations.of(context).translate('emergency_contact_phone'),
      hintText: AppLocalizations.of(context).translate('enter_emergency_phone'),
      prefixIcon: Icons.phone,
      keyboardType: TextInputType.phone,
    );
  }

  void _populateFields(UserModel user) {
    _nameController.text = user.name;
    _phoneController.text = user.phone ?? '';
    _addressController.text = user.address ?? '';
    _bloodTypeController.text = user.bloodType ?? '';
    _allergiesController.text = user.allergies ?? '';
    _emergencyContactController.text = user.emergencyContact ?? '';
    _emergencyPhoneController.text = user.emergencyPhone ?? '';
    _dateOfBirth = user.dateOfBirth;
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<PatientBloc>().add(UpdateProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
        dateOfBirth: _dateOfBirth,
        bloodType: _bloodTypeController.text.trim().isEmpty ? null : _bloodTypeController.text.trim(),
        allergies: _allergiesController.text.trim().isEmpty ? null : _allergiesController.text.trim(),
        emergencyContact: _emergencyContactController.text.trim().isEmpty ? null : _emergencyContactController.text.trim(),
        emergencyPhone: _emergencyPhoneController.text.trim().isEmpty ? null : _emergencyPhoneController.text.trim(),
      ));
    }
  }
}