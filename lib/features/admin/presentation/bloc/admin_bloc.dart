import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/models/clinic_model.dart';
import 'package:mcs/core/models/subscription_model.dart';
import 'package:mcs/core/services/supabase_service.dart';
import 'package:mcs/features/admin/presentation/bloc/admin_event.dart';
import 'package:mcs/features/admin/presentation/bloc/admin_state.dart';

/// Admin BLoC for managing Super Admin operations
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc(this._supabaseService) : super(const AdminInitial()) {
    on<GenerateSubscriptionCode>(_onGenerateSubscriptionCode);
    on<LoadSubscriptionCodes>(_onLoadSubscriptionCodes);
    on<ActivateSubscriptionCode>(_onActivateSubscriptionCode);
    on<LoadClinics>(_onLoadClinics);
    on<CreateClinic>(_onCreateClinic);
    on<UpdateClinic>(_onUpdateClinic);
    on<DeactivateClinic>(_onDeactivateClinic);
    on<LoadExchangeRates>(_onLoadExchangeRates);
    on<UpdateExchangeRate>(_onUpdateExchangeRate);
    on<LoadDashboardStats>(_onLoadDashboardStats);
  }
  final SupabaseService _supabaseService;

  // ── Subscription Handlers ───────────────────────────────────

  Future<void> _onGenerateSubscriptionCode(
    GenerateSubscriptionCode event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());
    try {
      final code = _generateUniqueCode();

      final subscription = SubscriptionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        code: code,
        type: event.type,
        priceUsd: event.priceUsd,
        priceEur: event.priceEur,
        priceDzd: event.priceDzd,
        createdAt: DateTime.now(),
      );

      await _supabaseService.insert(
        'subscription_codes',
        subscription.toJson(),
      );

      emit(const AdminSuccess('تم إنشاء كود الاشتراك بنجاح'));
      add(const LoadSubscriptionCodes());
    } catch (e) {
      emit(AdminError('فشل إنشاء كود الاشتراك: $e'));
    }
  }

  Future<void> _onLoadSubscriptionCodes(
    LoadSubscriptionCodes event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());
    try {
      final data = await _supabaseService.fetchAll(
        'subscription_codes',
        orderBy: 'created_at',
        ascending: false,
      );

      final subscriptions = data.map(SubscriptionModel.fromJson).toList();

      emit(SubscriptionCodesLoaded(subscriptions));
    } catch (e) {
      emit(AdminError('فشل تحميل أكواد الاشتراك: $e'));
    }
  }

  Future<void> _onActivateSubscriptionCode(
    ActivateSubscriptionCode event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());
    try {
      // Get subscription code
      final codes = await _supabaseService.fetchAll(
        'subscription_codes',
        filters: {'code': event.code},
      );

      if (codes.isEmpty) {
        emit(const AdminError('كود الاشتراك غير صحيح'));
        return;
      }

      final subscription = SubscriptionModel.fromJson(codes.first);

      if (subscription.isUsed) {
        emit(const AdminError('كود الاشتراك مستخدم بالفعل'));
        return;
      }

      // Update subscription code as used
      await _supabaseService.update(
        'subscription_codes',
        subscription.id,
        {
          'is_used': true,
          'clinic_id': event.clinicId,
          'used_at': DateTime.now().toIso8601String(),
        },
      );

      // Update clinic subscription
      final startDate = DateTime.now();
      final endDate = subscription.getEndDate(startDate);

      await _supabaseService.update(
        'clinics',
        event.clinicId,
        {
          'is_trial': false,
          'subscription_type': subscription.type.toDbValue(),
          'subscription_start_date': startDate.toIso8601String(),
          'subscription_end_date': endDate.toIso8601String(),
          'is_active': true,
        },
      );

      emit(const AdminSuccess('تم تفعيل الاشتراك بنجاح'));
      add(const LoadSubscriptionCodes());
    } catch (e) {
      emit(AdminError('فشل تفعيل كود الاشتراك: $e'));
    }
  }

  // ── Clinic Handlers ────────────────────────────────────────

  Future<void> _onLoadClinics(
    LoadClinics event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());
    try {
      final data = await _supabaseService.fetchAll(
        'clinics',
        orderBy: 'created_at',
        ascending: false,
      );

      final clinics = data.map(ClinicModel.fromJson).toList();

      emit(ClinicsLoaded(clinics));
    } catch (e) {
      emit(AdminError('فشل تحميل العيادات: $e'));
    }
  }

  Future<void> _onCreateClinic(
    CreateClinic event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());
    try {
      final clinic = ClinicModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        email: event.email,
        phone: event.phone,
        country: event.country,
        region: event.region,
        address: event.address,
        description: event.description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _supabaseService.insert('clinics', clinic.toJson());

      emit(const AdminSuccess('تم إنشاء العيادة بنجاح'));
      add(const LoadClinics());
    } catch (e) {
      emit(AdminError('فشل إنشاء العيادة: $e'));
    }
  }

  Future<void> _onUpdateClinic(
    UpdateClinic event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());
    try {
      final updates = <String, dynamic>{};

      if (event.name != null) updates['name'] = event.name;
      if (event.email != null) updates['email'] = event.email;
      if (event.phone != null) updates['phone'] = event.phone;
      if (event.address != null) updates['address'] = event.address;
      if (event.description != null) updates['description'] = event.description;
      if (event.logoUrl != null) updates['logo_url'] = event.logoUrl;
      if (event.isActive != null) updates['is_active'] = event.isActive;
      updates['updated_at'] = DateTime.now().toIso8601String();

      await _supabaseService.update('clinics', event.clinicId, updates);

      emit(const AdminSuccess('تم تحديث العيادة بنجاح'));
      add(const LoadClinics());
    } catch (e) {
      emit(AdminError('فشل تحديث العيادة: $e'));
    }
  }

  Future<void> _onDeactivateClinic(
    DeactivateClinic event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());
    try {
      await _supabaseService.update(
        'clinics',
        event.clinicId,
        {'is_active': false, 'updated_at': DateTime.now().toIso8601String()},
      );

      emit(const AdminSuccess('تم إلغاء تفعيل العيادة بنجاح'));
      add(const LoadClinics());
    } catch (e) {
      emit(AdminError('فشل إلغاء تفعيل العيادة: $e'));
    }
  }

  // ── Currency Handlers ───────────────────────────────────────

  Future<void> _onLoadExchangeRates(
    LoadExchangeRates event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());
    try {
      final data = await _supabaseService.fetchAll(
        'exchange_rates',
        filters: {'is_active': true},
      );

      final rates = <String, double>{};

      // Group by from_currency and get the most recent rate for each pair
      final latestRates = <String, Map<String, dynamic>>{};
      for (final item in data) {
        final fromCurrency = item['from_currency'] as String;
        final toCurrency = item['to_currency'] as String;
        final effectiveDate = DateTime.parse(item['effective_date'] as String);
        final key = '${fromCurrency}_$toCurrency';

        // Keep only the most recent rate for each pair
        if (!latestRates.containsKey(key) ||
            effectiveDate.isAfter(
              DateTime.parse(
                latestRates[key]!['effective_date'] as String,
              ),
            )) {
          latestRates[key] = item;
        }
      }

      // Build rates map with 'FROM_TO' keys
      for (final rate in latestRates.values) {
        final key = '${rate['from_currency']}_${rate['to_currency']}';
        rates[key] = (rate['rate'] as num).toDouble();
      }

      emit(ExchangeRatesLoaded(rates));
    } catch (e) {
      emit(AdminError('فشل تحميل أسعار الصرف: $e'));
    }
  }

  Future<void> _onUpdateExchangeRate(
    UpdateExchangeRate event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());
    try {
      // Insert new exchange rate record with UUID
      final exchangeRateData = {
        'from_currency': event.fromCurrency,
        'to_currency': event.toCurrency,
        'rate': event.rate,
        'effective_date': DateTime.now().toIso8601String(),
        'is_active': true,
      };

      await _supabaseService.insert('exchange_rates', exchangeRateData);

      emit(const AdminSuccess('تم تحديث سعر الصرف بنجاح'));
      add(const LoadExchangeRates());
    } catch (e) {
      emit(AdminError('فشل تحديث سعر الصرف: $e'));
    }
  }

  // ── Stats Handlers ──────────────────────────────────────────

  Future<void> _onLoadDashboardStats(
    LoadDashboardStats event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());
    try {
      final clinicsData = await _supabaseService.fetchAll('clinics');
      final clinics = clinicsData.map(ClinicModel.fromJson).toList();

      final activeSubs =
          clinics.where((c) => c.isActive && !c.isTrialActive).length;
      final trialSubs = clinics.where((c) => c.isTrialActive).length;
      final expiredSubs = clinics.where((c) => c.isSubscriptionExpired).length;

      final totalRevenue = clinics.fold<double>(0, (sum, clinic) {
        if (clinic.isTrial) return sum;
        return sum + clinic.subscriptionType.priceUsd;
      });

      // Get total users from user table
      final usersData = await _supabaseService.fetchAll('users');

      emit(
        DashboardStatsLoaded(
          totalClinics: clinics.length,
          activeSubscriptions: activeSubs,
          trialSubscriptions: trialSubs,
          expiredSubscriptions: expiredSubs,
          totalRevenueUsd: totalRevenue,
          totalUsers: usersData.length,
        ),
      );
    } catch (e) {
      emit(AdminError('فشل تحميل الإحصائيات: $e'));
    }
  }

  // ── Helpers ─────────────────────────────────────────────────

  String _generateUniqueCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 1000 + (timestamp % 1000)).toString();
    return 'MCS-${random.substring(random.length - 12)}'.toUpperCase();
  }
}

