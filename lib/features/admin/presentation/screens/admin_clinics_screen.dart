import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mcs/core/models/clinic_model.dart';
import 'package:mcs/core/models/country_model.dart';
import 'package:mcs/core/models/region_model.dart';
import 'package:mcs/core/services/supabase_service.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/features/admin/presentation/bloc/index.dart';

/// Admin Clinics Management Screen
class AdminClinicsScreen extends StatelessWidget {
  const AdminClinicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseService = SupabaseService();
    return BlocProvider(
      create: (_) => AdminBloc(supabaseService),
      child: const AdminClinicsView(),
    );
  }
}

class AdminClinicsView extends StatefulWidget {
  const AdminClinicsView({super.key});

  @override
  State<AdminClinicsView> createState() => _AdminClinicsViewState();
}

class _AdminClinicsViewState extends State<AdminClinicsView> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(const LoadClinics());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة العيادات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AdminBloc>().add(const LoadClinics()),
            tooltip: 'تحديث',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ClinicsLoaded) {
            if (state.clinics.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_hospital_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد عيادات مسجلة بعد',
                      style: TextStyles.bodyMedium.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }
            return _clinicsGrid(clinics: state.clinics);
          }

          if (state is AdminError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('جاري تحميل البيانات...'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddClinicDialog(context),
        icon: const Icon(Icons.add_business),
        label: const Text('إضافة عيادة'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _clinicsGrid({required List<ClinicModel> clinics}) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.75,
        ),
        itemCount: clinics.length,
        itemBuilder: (context, index) {
          final clinic = clinics[index];
          return _clinicCard(clinic);
        },
      ),
    );
  }

  Widget _clinicCard(ClinicModel clinic) {
    final isExpired = clinic.isSubscriptionExpired;
    final daysRemaining = clinic.daysRemaining;

    return Card(
      elevation: isExpired ? 0 : 2,
      color: isExpired ? Colors.grey[100] : null,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: clinic.logoUrl != null
                        ? Colors.transparent
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: clinic.logoUrl != null
                      ? ClipOval(
                          child: Image.network(
                            clinic.logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.local_hospital,
                                color: AppColors.primary,
                                size: 32,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.local_hospital,
                          color: AppColors.primary,
                          size: 32,
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clinic.name,
                        style: TextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        clinic.email,
                        style: TextStyles.bodySmall.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(clinic),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    Icons.location_on,
                    '${clinic.country} - ${clinic.region}',
                  ),
                  _buildInfoRow(
                    Icons.phone,
                    clinic.phone,
                  ),
                  if (clinic.isTrialActive)
                    _buildInfoRow(
                      Icons.science,
                      'اشتراك تجريبي',
                    ),
                  if (!isExpired && clinic.subscriptionEndDate != null)
                    _buildInfoRow(
                      Icons.access_time,
                      'ينتهي خلال $daysRemaining يوم',
                    ),
                  if (isExpired)
                    _buildInfoRow(
                      Icons.warning,
                      'اشتراك منتهي',
                      color: Colors.red,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showClinicDetails(context, clinic),
                    icon: const Icon(Icons.info_outline),
                    label: const Text('التفاصيل'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showEditClinicDialog(context, clinic),
                    icon: const Icon(Icons.edit),
                    label: const Text('تعديل'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ClinicModel clinic) {
    Color badgeColor;
    String badgeText;

    if (!clinic.isActive) {
      badgeColor = Colors.grey;
      badgeText = 'معطّل';
    } else if (clinic.isSubscriptionExpired) {
      badgeColor = Colors.red;
      badgeText = 'منتهي';
    } else if (clinic.isSubscriptionExpiringSoon) {
      badgeColor = Colors.orange;
      badgeText = 'ينتهي قريباً';
    } else if (clinic.isTrialActive) {
      badgeColor = Colors.blue;
      badgeText = 'تجريبي';
    } else {
      badgeColor = Colors.green;
      badgeText = 'نشط';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        badgeText,
        style: TextStyles.bodySmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color ?? Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyles.bodySmall.copyWith(
                color: color ?? Colors.grey[700],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddClinicDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final descriptionController = TextEditingController();

    final supabaseService = SupabaseService();

    String? selectedCountryId;
    String? selectedRegionId;

    // Fetch countries
    final countriesData = await supabaseService.fetchAll(
      'countries',
      filters: {'is_supported': true},
      orderBy: 'name',
    );

    if (!context.mounted) return;

    final countries = (countriesData as List)
        .map(
          (e) => CountryModel.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();

    var regions = <RegionModel>[];

    if (countries.isNotEmpty) {
      selectedCountryId = countries.first.id;

      final regionsData = await supabaseService.fetchAll(
        'regions',
        filters: {'country_id': selectedCountryId},
        orderBy: 'name',
      );

      if (!context.mounted) return;

      regions = (regionsData as List)
          .map(
            (e) => RegionModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();

      if (regions.isNotEmpty) {
        selectedRegionId = regions.first.id;
      }
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('إضافة عيادة جديدة'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم العيادة *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedCountryId,
                  decoration: const InputDecoration(
                    labelText: 'الدولة *',
                    border: OutlineInputBorder(),
                  ),
                  items: countries
                      .map(
                        (CountryModel country) => DropdownMenuItem(
                          value: country.id,
                          child: Text(country.getName('ar')),
                        ),
                      )
                      .toList(),
                  onChanged: (value) async {
                    if (value == null) return;

                    setDialogState(() {
                      selectedCountryId = value;
                      selectedRegionId = null;
                      regions = <RegionModel>[];
                    });

                    final regionsData = await supabaseService.fetchAll(
                      'regions',
                      filters: {'country_id': value},
                      orderBy: 'name',
                    );

                    if (!dialogContext.mounted) return;

                    setDialogState(() {
                      regions = (regionsData as List)
                          .map(
                            (e) => RegionModel.fromJson(
                              e as Map<String, dynamic>,
                            ),
                          )
                          .toList();

                      if (regions.isNotEmpty) {
                        selectedRegionId = regions.first.id;
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedRegionId,
                  decoration: const InputDecoration(
                    labelText: 'المنطقة *',
                    border: OutlineInputBorder(),
                  ),
                  items: regions
                      .map(
                        (RegionModel region) => DropdownMenuItem(
                          value: region.id,
                          child: Text(region.getName('ar')),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedRegionId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'العنوان',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'الوصف',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('إضافة'),
            ),
          ],
        ),
      ),
    );

    if (!context.mounted) return;

    if ((result ?? false) &&
        selectedCountryId != null &&
        selectedRegionId != null) {
      final selectedCountry = countries.firstWhere(
        (CountryModel c) => c.id == selectedCountryId,
      );

      final selectedRegion = regions.firstWhere(
        (RegionModel r) => r.id == selectedRegionId,
      );

      context.read<AdminBloc>().add(
            CreateClinic(
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              phone: phoneController.text.trim(),
              country: selectedCountry.getName('ar'),
              region: selectedRegion.getName('ar'),
              address: addressController.text.trim(),
              description: descriptionController.text.trim(),
            ),
          );
    }
  }

  Future<void> _showClinicDetails(
      BuildContext context, ClinicModel clinic) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(clinic.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem(
                Icons.email,
                'البريد الإلكتروني',
                clinic.email,
              ),
              _buildDetailItem(
                Icons.phone,
                'رقم الهاتف',
                clinic.phone,
              ),
              _buildDetailItem(
                Icons.location_on,
                'الموقع',
                '${clinic.country} - ${clinic.region}',
              ),
              if (clinic.address != null)
                _buildDetailItem(
                  Icons.map,
                  'العنوان',
                  clinic.address!,
                ),
              if (clinic.description != null)
                _buildDetailItem(
                  Icons.description,
                  'الوصف',
                  clinic.description!,
                ),
              const Divider(height: 32),
              _buildDetailItem(
                Icons.access_time,
                'تاريخ التسجيل',
                _formatDate(clinic.createdAt!),
              ),
              if (clinic.updatedAt != null)
                _buildDetailItem(
                  Icons.update,
                  'آخر تحديث',
                  _formatDate(clinic.updatedAt!),
                ),
              const Divider(height: 32),
              Text(
                'حالة الاشتراك',
                style: TextStyles.titleMedium,
              ),
              const SizedBox(height: 16),
              _buildDetailItem(
                Icons.card_membership,
                'النوع',
                clinic.subscriptionType.label('ar'),
              ),
              _buildDetailItem(
                Icons.science,
                'فترة تجريبية تنتهي خلال ${clinic.daysRemaining} يوم',
              ),
              if (clinic.isSubscriptionExpired)
                _buildDetailItem(
                  Icons.warning,
                  'الاشتراك منتهي',
                ),
              if (!clinic.isActive)
                _buildDetailItem(
                  Icons.block,
                  'الحالة',
                  'معطّل',
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String label, [
    String value = '',
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyles.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                if (value.isNotEmpty)
                  Text(
                    value,
                    style: TextStyles.bodyMedium.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _showEditClinicDialog(
      BuildContext context, ClinicModel clinic) async {
    final nameController = TextEditingController(text: clinic.name);
    final emailController = TextEditingController(text: clinic.email);
    final phoneController = TextEditingController(text: clinic.phone);
    final addressController = TextEditingController(text: clinic.address ?? '');
    final descriptionController =
        TextEditingController(text: clinic.description ?? '');

    final supabaseService = SupabaseService();

    String? selectedCountryId;
    String? selectedRegionId;

    // Fetch countries
    final countriesData = await supabaseService.fetchAll(
      'countries',
      filters: {'is_supported': true},
      orderBy: 'name',
    );

    if (!context.mounted) return;

    final countries = (countriesData as List)
        .map(
          (e) => CountryModel.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();

    var regions = <RegionModel>[];

    // Set initial country and region
    final initialCountry = countries.cast<CountryModel?>().firstWhere(
          (c) => c?.getName('ar') == clinic.country,
          orElse: () => null,
        );
    if (initialCountry != null) {
      selectedCountryId = initialCountry.id;

      final regionsData = await supabaseService.fetchAll(
        'regions',
        filters: {'country_id': selectedCountryId},
        orderBy: 'name',
      );

      if (!context.mounted) return;

      regions = (regionsData as List)
          .map(
            (e) => RegionModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();

      final initialRegion = regions.cast<RegionModel?>().firstWhere(
            (r) => r?.getName('ar') == clinic.region,
            orElse: () => null,
          );
      if (initialRegion != null) {
        selectedRegionId = initialRegion.id;
      } else if (regions.isNotEmpty) {
        selectedRegionId = regions.first.id;
      }
    } else if (countries.isNotEmpty) {
      selectedCountryId = countries.first.id;

      final regionsData = await supabaseService.fetchAll(
        'regions',
        filters: {'country_id': selectedCountryId},
        orderBy: 'name',
      );

      if (!context.mounted) return;

      regions = (regionsData as List)
          .map(
            (e) => RegionModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();

      if (regions.isNotEmpty) {
        selectedRegionId = regions.first.id;
      }
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('تعديل العيادة'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم العيادة *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedCountryId,
                  decoration: const InputDecoration(
                    labelText: 'الدولة *',
                    border: OutlineInputBorder(),
                  ),
                  items: countries
                      .map(
                        (CountryModel country) => DropdownMenuItem(
                          value: country.id,
                          child: Text(country.getName('ar')),
                        ),
                      )
                      .toList(),
                  onChanged: (value) async {
                    if (value == null) return;

                    setDialogState(() {
                      selectedCountryId = value;
                      selectedRegionId = null;
                      regions = <RegionModel>[];
                    });

                    final regionsData = await supabaseService.fetchAll(
                      'regions',
                      filters: {'country_id': value},
                      orderBy: 'name',
                    );

                    if (!dialogContext.mounted) return;

                    setDialogState(() {
                      regions = (regionsData as List)
                          .map(
                            (e) => RegionModel.fromJson(
                              e as Map<String, dynamic>,
                            ),
                          )
                          .toList();

                      if (regions.isNotEmpty) {
                        selectedRegionId = regions.first.id;
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedRegionId,
                  decoration: const InputDecoration(
                    labelText: 'المنطقة *',
                    border: OutlineInputBorder(),
                  ),
                  items: regions
                      .map(
                        (RegionModel region) => DropdownMenuItem(
                          value: region.id,
                          child: Text(region.getName('ar')),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedRegionId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'العنوان',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'الوصف',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );

    if (!context.mounted) return;

    if ((result ?? false) &&
        selectedCountryId != null &&
        selectedRegionId != null) {
      final selectedCountry = countries.firstWhere(
        (CountryModel c) => c.id == selectedCountryId,
      );

      final selectedRegion = regions.firstWhere(
        (RegionModel r) => r.id == selectedRegionId,
      );

      context.read<AdminBloc>().add(
            UpdateClinic(
              clinicId: clinic.id,
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              phone: phoneController.text.trim(),
              address: addressController.text.trim(),
              description: descriptionController.text.trim(),
            ),
          );
    }
  }
}
