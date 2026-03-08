/// Patient Book Appointment Screen
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/models/clinic_model.dart';
import 'package:mcs/core/models/doctor_model.dart';
import 'package:mcs/core/models/specialty_model.dart';
import 'package:mcs/core/widgets/custom_button.dart';
import 'package:mcs/core/widgets/custom_text_field.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';

/// Patient book appointment screen with multi-step booking flow
class PatientBookAppointmentScreen extends StatefulWidget {
  const PatientBookAppointmentScreen({super.key});

  @override
  State<PatientBookAppointmentScreen> createState() =>
      _PatientBookAppointmentScreenState();
}

class _PatientBookAppointmentScreenState
    extends State<PatientBookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();

  // Step tracking
  int _currentStep = 0;

  // Form data
  String? _selectedCountry;
  String? _selectedRegion;
  String? _selectedSpecialty;
  String? _selectedDoctor;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  bool _requestRemoteSession = false;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('')),
      ),
      body: BlocListener<PatientBloc, PatientState>(
        listener: (context, state) {
          if (state is AppointmentBooked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  context.translateSafe('appointment_booked_success'),
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is PatientError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: _currentStep < 5 ? _nextStep : _submitAppointment,
            onStepCancel: _currentStep > 0 ? _previousStep : null,
            steps: [
              _buildStep1(),
              _buildStep2(),
              _buildStep3(),
              _buildStep4(),
              _buildStep5(),
              _buildStep6(),
            ],
          ),
        ),
      ),
    );
  }

  Step _buildStep1() {
    return Step(
      title: Text(context.translateSafe('')),
      content: Column(
        children: [
          // TODO: Load countries from database
          _buildCountryDropdown(),
        ],
      ),
      isActive: _currentStep >= 0,
    );
  }

  Step _buildStep2() {
    return Step(
      title: Text(context.translateSafe('')),
      content: Column(
        children: [
          // TODO: Load regions based on selected country
          _buildRegionDropdown(),
        ],
      ),
      isActive: _currentStep >= 1,
    );
  }

  Step _buildStep3() {
    return Step(
      title: Text(context.translateSafe('')),
      content: Column(
        children: [
          // TODO: Load specialties from database
          _buildSpecialtyDropdown(),
        ],
      ),
      isActive: _currentStep >= 2,
    );
  }

  Step _buildStep4() {
    return Step(
      title: Text(context.translateSafe('')),
      content: Column(
        children: [
          // TODO: Load doctors based on selected specialty
          _buildDoctorDropdown(),
        ],
      ),
      isActive: _currentStep >= 3,
    );
  }

  Step _buildStep5() {
    return Step(
      title: Text(context.translateSafe('')),
      content: Column(
        children: [
          _buildDatePicker(),
          const SizedBox(height: 16),
          _buildTimeSlotPicker(),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: Text(
              context.translateSafe(''),
            ),
            subtitle: Text(
              context.translateSafe('remote_session_description'),
            ),
            value: _requestRemoteSession,
            onChanged: (value) {
              setState(() {
                _requestRemoteSession = value ?? false;
              });
            },
          ),
        ],
      ),
      isActive: _currentStep >= 4,
    );
  }

  Step _buildStep6() {
    return Step(
      title: Text(context.translateSafe('')),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _notesController,
            label: context.translateSafe(''),
            maxLines: 3,
          ),
        ],
      ),
      isActive: _currentStep >= 5,
    );
  }

  Widget _buildCountryDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: context.translateSafe(''),
        border: const OutlineInputBorder(),
      ),
      initialValue: _selectedCountry,
      items: const [
        DropdownMenuItem(value: 'DZ', child: Text('الجزائر')),
        DropdownMenuItem(value: 'US', child: Text('United States')),
        DropdownMenuItem(value: 'FR', child: Text('France')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedCountry = value;
          _selectedRegion = null;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.translateSafe('please_select_country');
        }
        return null;
      },
    );
  }

  Widget _buildRegionDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: context.translateSafe(''),
        border: const OutlineInputBorder(),
      ),
      initialValue: _selectedRegion,
      items: const [
        DropdownMenuItem(value: '01', child: Text('الجزائر العاصمة')),
        DropdownMenuItem(value: '31', child: Text('وهران')),
        DropdownMenuItem(value: '25', child: Text('قسنطينة')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedRegion = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.translateSafe('');
        }
        return null;
      },
    );
  }

  Widget _buildSpecialtyDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: context.translateSafe(''),
        border: const OutlineInputBorder(),
      ),
      initialValue: _selectedSpecialty,
      items: const [
        DropdownMenuItem(value: 'cardiology', child: Text('أمراض القلب')),
        DropdownMenuItem(value: 'pediatrics', child: Text('طب الأطفال')),
        DropdownMenuItem(value: 'dermatology', child: Text('الأمراض الجلدية')),
        DropdownMenuItem(value: 'neurology', child: Text('الأعصاب')),
        DropdownMenuItem(value: 'orthopedics', child: Text('العظام')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedSpecialty = value;
          _selectedDoctor = null;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.translateSafe('please_select_specialty');
        }
        return null;
      },
    );
  }

  Widget _buildDoctorDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: context.translateSafe(''),
        border: const OutlineInputBorder(),
      ),
      initialValue: _selectedDoctor,
      items: const [
        DropdownMenuItem(value: 'dr1', child: Text('د. أحمد محمد')),
        DropdownMenuItem(value: 'dr2', child: Text('د. فاطمة علي')),
        DropdownMenuItem(value: 'dr3', child: Text('د. محمد خالد')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedDoctor = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.translateSafe('');
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(const Duration(days: 1)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );
        if (date != null) {
          setState(() {
            _selectedDate = date;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: context.translateSafe(''),
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          _selectedDate != null
              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
              : context.translateSafe(''),
        ),
      ),
    );
  }

  Widget _buildTimeSlotPicker() {
    final timeSlots = [
      '09:00',
      '09:30',
      '10:00',
      '10:30',
      '11:00',
      '11:30',
      '14:00',
      '14:30',
      '15:00',
      '15:30',
      '16:00',
      '16:30',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.translateSafe(''),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: timeSlots.map((slot) {
            return ChoiceChip(
              label: Text(slot),
              selected: _selectedTimeSlot == slot,
              onSelected: (selected) {
                setState(() {
                  _selectedTimeSlot = selected ? slot : null;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.translateSafe(''),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            _buildSummaryRow(
              context.translateSafe(''),
              _selectedCountry ?? '-',
            ),
            _buildSummaryRow(
              context.translateSafe(''),
              _selectedRegion ?? '-',
            ),
            _buildSummaryRow(
              context.translateSafe(''),
              _selectedSpecialty ?? '-',
            ),
            _buildSummaryRow(
              context.translateSafe(''),
              _selectedDoctor ?? '-',
            ),
            _buildSummaryRow(
              context.translateSafe(''),
              _selectedDate != null
                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                  : '-',
            ),
            _buildSummaryRow(
              context.translateSafe(''),
              _selectedTimeSlot ?? '-',
            ),
            _buildSummaryRow(
              context.translateSafe(''),
              _requestRemoteSession
                  ? context.translateSafe('')
                  : context.translateSafe(''),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    setState(() {
      _currentStep--;
    });
  }

  void _submitAppointment() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTimeSlot != null) {
      context.read<PatientBloc>().add(
            BookAppointment(
              clinicId: 'clinic_001', // TODO: Get from selected region/doctor
              doctorId: _selectedDoctor!,
              appointmentDate: _selectedDate!,
              timeSlot: _selectedTimeSlot!,
              appointmentType: _requestRemoteSession ? 'remote' : 'in_person',
              notes: _notesController.text.trim().isEmpty
                  ? null
                  : _notesController.text.trim(),
            ),
          );
    }
  }
}
