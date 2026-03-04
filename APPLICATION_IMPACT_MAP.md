# MCS - Application Impact Map
## Database → Models → Services → Screens

**Date:** March 4, 2026  
**Version:** 1.0  
**Scope:** Complete Application Layer Impact Analysis  
**Status:** AWAITING APPROVAL

---

## 1️⃣ Impact Analysis Overview

### Impact Summary

```
┌─────────────────────────────────────────────────────────────────┐
│                     IMPACT SUMMARY                              │
├─────────────────────────────────────────────────────────────────┤
│                                                             │
│  Database Tables Changed:      7 tables                     │
│  Models Affected:             4 models                      │
│  Services Affected:           3 services                    │
│  BLoCs Affected:              2 BLoCs                       │
│  Screens Affected:            5 screens                     │
│                                                             │
│  Total Files to Update:       14 files                      │
│  Estimated Effort:            16 hours                      │
│  Risk Level:                  MEDIUM                        │
│                                                             │
└─────────────────────────────────────────────────────────────────┘
```

### Impact Categories

**HIGH IMPACT** (Requires significant changes):
- DoctorModel (specialtyId type change)
- Doctor-related screens
- AdminBloc (subscription codes, exchange rates)

**MEDIUM IMPACT** (Requires moderate changes):
- SubscriptionModel (id type change)
- ExchangeRateModel (id type change)
- Admin screens

**LOW IMPACT** (Minimal changes):
- New CountryModel and RegionModel
- Helper functions and utilities

---

## 2️⃣ Database Table to Model Mapping

### Table 1: specialties

**Database Changes:**
- PRIMARY KEY: TEXT → UUID
- No other column changes

**Model Impact:**
```
File: lib/core/models/specialty_model.dart
Changes:
  - id: String → String (UUID string, no Dart type change)
  - fromJson(): No change (already handles UUID as String)
  - toJson(): No change (already handles UUID as String)
  - copyWith(): No change

Impact: LOW
Reason: Dart uses String for UUID, no type system changes needed
```

**Services Impact:**
```
File: lib/core/services/supabase_service.dart
Changes:
  - No changes needed (already handles UUID as String)

Impact: NONE
Reason: Service layer already UUID-agnostic
```

**Screens Impact:**
```
Files: 
  - lib/features/admin/presentation/screens/admin_clinics_screen.dart
  - lib/features/doctor/presentation/screens/doctor_profile_screen.dart

Changes:
  - No changes needed (UUID treated as String)

Impact: NONE
Reason: UI layer already UUID-agnostic
```

---

### Table 2: subscription_codes

**Database Changes:**
- PRIMARY KEY: TEXT → UUID
- clinic_id: TEXT → UUID (FK)

**Model Impact:**
```
File: lib/core/models/subscription_model.dart
Changes:
  - id: String → String (UUID string, no Dart type change)
  - clinicId: String → String (UUID string, no Dart type change)
  - fromJson(): No change
  - toJson(): No change
  - copyWith(): No change

Impact: LOW
Reason: Dart uses String for UUID, no type system changes needed
```

**Services Impact:**
```
File: lib/core/services/supabase_service.dart
Changes:
  - No changes needed

Impact: NONE
Reason: Service layer already UUID-agnostic
```

**BLoCs Impact:**
```
File: lib/features/admin/presentation/bloc/admin_bloc.dart
Changes:
  - _onGenerateSubscriptionCode(): No change
  - _onLoadSubscriptionCodes(): No change
  - _onActivateSubscriptionCode(): No change

Impact: NONE
Reason: BLoC already treats IDs as String
```

**Screens Impact:**
```
File: lib/features/admin/presentation/screens/admin_subscriptions_screen.dart
Changes:
  - No changes needed

Impact: NONE
Reason: UI layer already UUID-agnostic
```

---

### Table 3: exchange_rates

**Database Changes:**
- PRIMARY KEY: TEXT → UUID
- No other column changes

**Model Impact:**
```
File: lib/core/models/exchange_rate_model.dart
Changes:
  - id: String → String (UUID string, no Dart type change)
  - fromJson(): No change
  - toJson(): No change
  - copyWith(): No change

Impact: LOW
Reason: Dart uses String for UUID, no type system changes needed
```

**Services Impact:**
```
File: lib/core/services/supabase_service.dart
Changes:
  - No changes needed

Impact: NONE
Reason: Service layer already UUID-agnostic
```

**BLoCs Impact:**
```
File: lib/features/admin/presentation/bloc/admin_bloc.dart
Changes:
  - _onLoadExchangeRates(): No change
  - _onUpdateExchangeRate(): Update ID generation
    OLD: '${event.fromCurrency}_to_${event.toCurrency}'
    NEW: Must use UUID instead of composite key

Impact: MEDIUM
Reason: Need to change ID generation strategy
```

**Screens Impact:**
```
File: lib/features/admin/presentation/screens/admin_currencies_screen.dart
Changes:
  - _showEditRateDialog(): Update rate ID handling
    OLD: Uses composite key as ID
    NEW: Must use UUID from database

Impact: MEDIUM
Reason: Need to fetch and use UUID instead of composite key
```

---

### Table 4: doctors

**Database Changes:**
- PRIMARY KEY: UUID (already UUID, no change)
- specialty_id: INT → UUID (FK)

**Model Impact:**
```
File: lib/core/models/doctor_model.dart
Changes:
  - specialtyId: int → String (UUID string)
  - fromJson(): Update type casting
    OLD: specialtyId: json['specialty_id'] as int
    NEW: specialtyId: json['specialty_id'] as String
  - toJson(): Update type
    OLD: 'specialty_id': specialtyId
    NEW: 'specialty_id': specialtyId
  - copyWith(): Update type
    OLD: int? specialtyId
    NEW: String? specialtyId

Impact: HIGH
Reason: Type system change (int → String)
```

**Services Impact:**
```
File: lib/core/services/supabase_service.dart
Changes:
  - No changes needed

Impact: NONE
Reason: Service layer already UUID-agnostic
```

**BLoCs Impact:**
```
Files:
  - lib/features/admin/presentation/bloc/admin_bloc.dart
  - lib/features/doctor/presentation/bloc/doctor_bloc.dart (if exists)

Changes:
  - Any doctor-related queries: No change
  - Any specialty filtering: Update type handling

Impact: LOW
Reason: Most BLoC operations already UUID-agnostic
```

**Screens Impact:**
```
Files:
  - lib/features/admin/presentation/screens/admin_clinics_screen.dart
  - lib/features/doctor/presentation/screens/doctor_profile_screen.dart
  - lib/features/doctor/presentation/screens/doctor_list_screen.dart (if exists)

Changes:
  - Any specialty display: No change (display name, not ID)
  - Any specialty filtering: Update type handling

Impact: LOW
Reason: UI displays specialty names, not IDs
```

---

### Table 5: countries (NEW)

**Database Changes:**
- NEW TABLE
- PRIMARY KEY: UUID

**Model Impact:**
```
File: lib/core/models/country_model.dart (NEW)
Changes:
  - Create new model
  - Fields: id, name, nameAr, iso2Code, iso3Code, phoneCode, currencyCode, isActive
  - Methods: fromJson(), toJson(), copyWith()

Impact: HIGH
Reason: New model creation required
```

**Services Impact:**
```
File: lib/core/services/supabase_service.dart
Changes:
  - No changes needed (generic CRUD already supports new tables)

Impact: NONE
Reason: Service layer is table-agnostic
```

**Screens Impact:**
```
Files:
  - lib/features/admin/presentation/screens/admin_clinics_screen.dart
  - lib/features/auth/presentation/screens/register_screen.dart

Changes:
  - Add country selection dropdown
  - Update clinic creation form
  - Update user registration form

Impact: MEDIUM
Reason: Need to add country selection UI
```

---

### Table 6: regions (NEW)

**Database Changes:**
- NEW TABLE
- PRIMARY KEY: UUID
- FK: country_id (UUID)

**Model Impact:**
```
File: lib/core/models/region_model.dart (NEW)
Changes:
  - Create new model
  - Fields: id, countryId, name, nameAr, code, isActive
  - Methods: fromJson(), toJson(), copyWith()

Impact: HIGH
Reason: New model creation required
```

**Services Impact:**
```
File: lib/core/services/supabase_service.dart
Changes:
  - No changes needed

Impact: NONE
Reason: Service layer is table-agnostic
```

**Screens Impact:**
```
Files:
  - lib/features/admin/presentation/screens/admin_clinics_screen.dart
  - lib/features/auth/presentation/screens/register_screen.dart

Changes:
  - Add region selection dropdown (dependent on country)
  - Update clinic creation form
  - Update user registration form

Impact: MEDIUM
Reason: Need to add region selection UI with country dependency
```

---

### Table 7: subscriptions (NEW)

**Database Changes:**
- NEW TABLE
- PRIMARY KEY: UUID

**Model Impact:**
```
File: lib/core/models/subscription_model.dart
Changes:
  - Update existing model
  - Add fields for subscription type reference
  - Update methods if needed

Impact: MEDIUM
Reason: Model already exists, needs updates
```

**Services Impact:**
```
File: lib/core/services/supabase_service.dart
Changes:
  - No changes needed

Impact: NONE
Reason: Service layer is table-agnostic
```

**BLoCs Impact:**
```
File: lib/features/admin/presentation/bloc/admin_bloc.dart
Changes:
  - Update clinic subscription handling
  - Add subscription type reference

Impact: MEDIUM
Reason: Need to update subscription activation logic
```

**Screens Impact:**
```
Files:
  - lib/features/admin/presentation/screens/admin_subscriptions_screen.dart
  - lib/features/admin/presentation/screens/admin_clinics_screen.dart

Changes:
  - Update subscription display
  - Update subscription activation

Impact: LOW
Reason: UI already handles subscription types
```

---

## 3️⃣ Complete File Impact List

### Models (4 files)

| File | Changes | Impact | Effort |
|------|---------|--------|--------|
| `lib/core/models/doctor_model.dart` | specialtyId: int → String | HIGH | 2h |
| `lib/core/models/subscription_model.dart` | Update for new subscriptions table | MEDIUM | 1h |
| `lib/core/models/exchange_rate_model.dart` | No type changes (UUID as String) | LOW | 0.5h |
| `lib/core/models/country_model.dart` | NEW FILE | HIGH | 2h |
| `lib/core/models/region_model.dart` | NEW FILE | HIGH | 2h |

**Total Models Effort:** 7.5 hours

### Services (1 file)

| File | Changes | Impact | Effort |
|------|---------|--------|--------|
| `lib/core/services/supabase_service.dart` | No changes needed | NONE | 0h |

**Total Services Effort:** 0 hours

### BLoCs (2 files)

| File | Changes | Impact | Effort |
|------|---------|--------|--------|
| `lib/features/admin/presentation/bloc/admin_bloc.dart` | Update exchange rate ID generation | MEDIUM | 2h |
| `lib/features/doctor/presentation/bloc/doctor_bloc.dart` | Update specialty handling (if exists) | LOW | 1h |

**Total BLoCs Effort:** 3 hours

### Screens (5 files)

| File | Changes | Impact | Effort |
|------|---------|--------|--------|
| `lib/features/admin/presentation/screens/admin_currencies_screen.dart` | Update exchange rate ID handling | MEDIUM | 2h |
| `lib/features/admin/presentation/screens/admin_subscriptions_screen.dart` | No changes needed | NONE | 0h |
| `lib/features/admin/presentation/screens/admin_clinics_screen.dart` | Add country/region selection | MEDIUM | 2h |
| `lib/features/doctor/presentation/screens/doctor_profile_screen.dart` | Update specialty handling | LOW | 1h |
| `lib/features/auth/presentation/screens/register_screen.dart` | Add country/region selection | MEDIUM | 2h |

**Total Screens Effort:** 7 hours

---

## 4️⃣ Detailed Change Specifications

### Change 1: DoctorModel specialtyId Type

**Current Code:**
```dart
class DoctorModel extends Equatable {
  const DoctorModel({
    required this.id,
    required this.userId,
    required this.clinicId,
    required this.specialtyId,  // CURRENT: int
    // ...
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      clinicId: json['clinic_id'] as String,
      specialtyId: json['specialty_id'] as int,  // CURRENT: int
      // ...
    );
  }

  final int specialtyId;  // CURRENT: int

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'clinic_id': clinicId,
      'specialty_id': specialtyId,  // CURRENT: int
      // ...
    };
  }

  DoctorModel copyWith({
    String? id,
    String? userId,
    String? clinicId,
    int? specialtyId,  // CURRENT: int
    // ...
  }) {
    return DoctorModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clinicId: clinicId ?? this.clinicId,
      specialtyId: specialtyId ?? this.specialtyId,  // CURRENT: int
      // ...
    );
  }
}
```

**Updated Code:**
```dart
class DoctorModel extends Equatable {
  const DoctorModel({
    required this.id,
    required this.userId,
    required this.clinicId,
    required this.specialtyId,  // UPDATED: String
    // ...
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      clinicId: json['clinic_id'] as String,
      specialtyId: json['specialty_id'] as String,  // UPDATED: String
      // ...
    );
  }

  final String specialtyId;  // UPDATED: String

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'clinic_id': clinicId,
      'specialty_id': specialtyId,  // UPDATED: String
      // ...
    };
  }

  DoctorModel copyWith({
    String? id,
    String? userId,
    String? clinicId,
    String? specialtyId,  // UPDATED: String
    // ...
  }) {
    return DoctorModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clinicId: clinicId ?? this.clinicId,
      specialtyId: specialtyId ?? this.specialtyId,  // UPDATED: String
      // ...
    );
  }
}
```

**Impact Analysis:**
- ✅ Breaking change for specialtyId type
- ✅ All doctor specialty lookups must use String
- ✅ No database query changes needed (UUID as String)
- ✅ No UI changes needed (displays specialty name, not ID)

---

### Change 2: AdminBloc Exchange Rate ID Generation

**Current Code:**
```dart
Future<void> _onUpdateExchangeRate(
  UpdateExchangeRate event,
  Emitter<AdminState> emit,
) async {
  emit(const AdminLoading());
  try {
    await _supabaseService.update(
      'exchange_rates',
      '${event.fromCurrency}_to_${event.toCurrency}',  // CURRENT: Composite key
      {'rate': event.rate, 'updated_at': DateTime.now().toIso8601String()},
    );

    emit(const AdminSuccess('تم تحديث سعر الصرف بنجاح'));
    add(const LoadExchangeRates());
  } catch (e) {
    emit(AdminError('فشل تحديث سعر الصرف: $e'));
  }
}
```

**Updated Code:**
```dart
Future<void> _onUpdateExchangeRate(
  UpdateExchangeRate event,
  Emitter<AdminState> emit,
) async {
  emit(const AdminLoading());
  try {
    // Fetch exchange rate by from/to currencies
    final rates = await _supabaseService.fetchAll(
      'exchange_rates',
      filters: {
        'from_currency': event.fromCurrency,
        'to_currency': event.toCurrency,
      },
    );

    if (rates.isEmpty) {
      emit(const AdminError('سعر الصرف غير موجود'));
      return;
    }

    final rateId = rates.first['id'] as String;  // UPDATED: Use UUID

    await _supabaseService.update(
      'exchange_rates',
      rateId,  // UPDATED: Use UUID instead of composite key
      {'rate': event.rate, 'updated_at': DateTime.now().toIso8601String()},
    );

    emit(const AdminSuccess('تم تحديث سعر الصرف بنجاح'));
    add(const LoadExchangeRates());
  } catch (e) {
    emit(AdminError('فشل تحديث سعر الصرف: $e'));
  }
}
```

**Impact Analysis:**
- ✅ Must fetch rate by currencies first
- ✅ Use UUID for update operation
- ✅ No UI changes needed (already fetches rates)

---

### Change 3: AdminCurrenciesScreen Rate ID Handling

**Current Code:**
```dart
Future<void> _showEditRateDialog(BuildContext context, Map<String, dynamic> rate) async {
  final rateController = TextEditingController(text: rate['rate'].toString());

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('تعديل سعر الصرف'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_getCurrencyInfo(rate['from'])} إلى ${_getCurrencyInfo(rate['to'])}',
            style: TextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: rateController,
            decoration: const InputDecoration(
              labelText: 'سعر الصرف *',
              border: OutlineInputBorder(),
              suffixText: 'X',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('حفظ التغييرات'),
        ),
      ],
    ),
  );

  if ((result ?? false) && context.mounted) {
    context.read<AdminBloc>().add(UpdateExchangeRate(
      fromCurrency: rate['from'] as String,
      toCurrency: rate['to'] as String,
      rate: double.parse(rateController.text),
    ));
  }
}
```

**Updated Code:**
```dart
Future<void> _showEditRateDialog(BuildContext context, Map<String, dynamic> rate) async {
  final rateController = TextEditingController(text: rate['rate'].toString());

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('تعديل سعر الصرف'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_getCurrencyInfo(rate['from_currency'])} إلى ${_getCurrencyInfo(rate['to_currency'])}',  // UPDATED: Use correct keys
            style: TextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: rateController,
            decoration: const InputDecoration(
              labelText: 'سعر الصرف *',
              border: OutlineInputBorder(),
              suffixText: 'X',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('حفظ التغييرات'),
        ),
      ],
    ),
  );

  if ((result ?? false) && context.mounted) {
    context.read<AdminBloc>().add(UpdateExchangeRate(
      fromCurrency: rate['from_currency'] as String,  // UPDATED: Use correct key
      toCurrency: rate['to_currency'] as String,  // UPDATED: Use correct key
      rate: double.parse(rateController.text),
    ));
  }
}
```

**Impact Analysis:**
- ✅ Update database field keys (from_currency, to_currency)
- ✅ No logic changes needed
- ✅ BLoC handles UUID conversion

---

### Change 4: New CountryModel

**New File:**
```dart
/// Country data model mapped to the `countries` Supabase table.
library;

import 'package:equatable/equatable.dart';

class CountryModel extends Equatable {
  const CountryModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.iso2Code,
    required this.iso3Code,
    required this.phoneCode,
    required this.currencyCode,
    this.isActive = true,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      iso2Code: json['iso2_code'] as String,
      iso3Code: json['iso3_code'] as String,
      phoneCode: json['phone_code'] as String,
      currencyCode: json['currency_code'] as String,
      isActive: (json['is_active'] as bool?) ?? true,
    );
  }

  final String id;
  final String name;
  final String? nameAr;
  final String iso2Code;
  final String iso3Code;
  final String phoneCode;
  final String currencyCode;
  final bool isActive;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'iso2_code': iso2Code,
      'iso3_code': iso3Code,
      'phone_code': phoneCode,
      'currency_code': currencyCode,
      'is_active': isActive,
    };
  }

  CountryModel copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? iso2Code,
    String? iso3Code,
    String? phoneCode,
    String? currencyCode,
    bool? isActive,
  }) {
    return CountryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      iso2Code: iso2Code ?? this.iso2Code,
      iso3Code: iso3Code ?? this.iso3Code,
      phoneCode: phoneCode ?? this.phoneCode,
      currencyCode: currencyCode ?? this.currencyCode,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Display name based on locale
  String displayName(String locale) => locale == 'ar' ? (nameAr ?? name) : name;

  /// Flag emoji from ISO2 code
  String get flagEmoji {
    final codePoints = iso2Code.toUpperCase().codeUnits.map((unit) {
      return unit + 0x1F1A5;
    }).toList();
    return String.fromCharCodes(codePoints);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        nameAr,
        iso2Code,
        iso3Code,
        phoneCode,
        currencyCode,
        isActive,
      ];
}
```

**Impact Analysis:**
- ✅ New model creation
- ✅ No breaking changes to existing code
- ✅ Optional integration with existing screens

---

### Change 5: New RegionModel

**New File:**
```dart
/// Region data model mapped to the `regions` Supabase table.
library;

import 'package:equatable/equatable.dart';

class RegionModel extends Equatable {
  const RegionModel({
    required this.id,
    required this.countryId,
    required this.name,
    required this.nameAr,
    required this.code,
    this.isActive = true,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'] as String,
      countryId: json['country_id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      code: json['code'] as String,
      isActive: (json['is_active'] as bool?) ?? true,
    );
  }

  final String id;
  final String countryId;
  final String name;
  final String? nameAr;
  final String code;
  final bool isActive;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country_id': countryId,
      'name': name,
      'name_ar': nameAr,
      'code': code,
      'is_active': isActive,
    };
  }

  RegionModel copyWith({
    String? id,
    String? countryId,
    String? name,
    String? nameAr,
    String? code,
    bool? isActive,
  }) {
    return RegionModel(
      id: id ?? this.id,
      countryId: countryId ?? this.countryId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      code: code ?? this.code,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Display name based on locale
  String displayName(String locale) => locale == 'ar' ? (nameAr ?? name) : name;

  @override
  List<Object?> get props => [
        id,
        countryId,
        name,
        nameAr,
        code,
        isActive,
      ];
}
```

**Impact Analysis:**
- ✅ New model creation
- ✅ No breaking changes to existing code
- ✅ Optional integration with existing screens

---

## 5️⃣ Testing Strategy

### Unit Tests

**Test 1: DoctorModel specialtyId Type**
```dart
test('DoctorModel should handle UUID specialtyId', () {
  final doctor = DoctorModel.fromJson({
    'id': '550e8400-e29b-41d4-a716-446655440000',
    'user_id': '550e8400-e29b-41d4-a716-446655440001',
    'clinic_id': '550e8400-e29b-41d4-a716-446655440002',
    'specialty_id': '550e8400-e29b-41d4-a716-446655440003',  // UUID as String
    // ... other fields
  });

  expect(doctor.specialtyId, isA<String>());  // Should be String
  expect(doctor.specialtyId, '550e8400-e29b-41d4-a716-446655440003');
});
```

**Test 2: CountryModel Serialization**
```dart
test('CountryModel should serialize correctly', () {
  final country = CountryModel(
    id: '550e8400-e29b-41d4-a716-446655440000',
    name: 'Algeria',
    nameAr: 'الجزائر',
    iso2Code: 'DZ',
    iso3Code: 'DZA',
    phoneCode: '+213',
    currencyCode: 'DZD',
  );

  final json = country.toJson();
  expect(json['id'], '550e8400-e29b-41d4-a716-446655440000');
  expect(json['name'], 'Algeria');
  expect(json['iso2_code'], 'DZ');
});
```

### Integration Tests

**Test 1: AdminBloc Exchange Rate Update**
```dart
test('AdminBloc should update exchange rate using UUID', () async {
  // Setup
  final mockSupabaseService = MockSupabaseService();
  final bloc = AdminBloc(mockSupabaseService);

  // Mock fetchAll to return rate with UUID
  when(mockSupabaseService.fetchAll('exchange_rates', filters: any))
      .thenAnswer((_) async => [
            {
              'id': '550e8400-e29b-41d4-a716-446655440000',  // UUID
              'from_currency': 'USD',
              'to_currency': 'EUR',
              'rate': 0.92,
            }
          ]);

  // Mock update to use UUID
  when(mockSupabaseService.update(
    'exchange_rates',
    '550e8400-e29b-41d4-a716-446655440000',  // UUID
    any,
  )).thenAnswer((_) async => {});

  // Act
  bloc.add(UpdateExchangeRate(
    fromCurrency: 'USD',
    toCurrency: 'EUR',
    rate: 0.93,
  ));

  // Assert
  await expectLater(
    bloc.stream,
    emitsInOrder([
      isA<AdminLoading>(),
      isA<AdminSuccess>(),
    ]),
  );

  // Verify update was called with UUID
  verify(mockSupabaseService.update(
    'exchange_rates',
    '550e8400-e29b-41d4-a716-446655440000',  // UUID
    argThat(isA<Map<String, dynamic>>()),
  ));
});
```

---

## 6️⃣ Rollback Plan

### Rollback Triggers

**Automatic Rollback:**
- ❌ Model compilation errors
- ❌ Service errors
- ❌ BLoC state errors
- ❌ Screen rendering errors

### Rollback Procedure

```bash
# Step 1: Revert model changes
git checkout lib/core/models/doctor_model.dart
git checkout lib/core/models/subscription_model.dart

# Step 2: Delete new models
rm lib/core/models/country_model.dart
rm lib/core/models/region_model.dart

# Step 3: Revert BLoC changes
git checkout lib/features/admin/presentation/bloc/admin_bloc.dart

# Step 4: Revert screen changes
git checkout lib/features/admin/presentation/screens/admin_currencies_screen.dart
git checkout lib/features/admin/presentation/screens/admin_clinics_screen.dart

# Step 5: Verify compilation
flutter analyze
```

---

## 7️⃣ Impact Summary

### Files to Update: 14 files

**Models (5 files):**
1. ✅ `lib/core/models/doctor_model.dart` - HIGH impact
2. ✅ `lib/core/models/subscription_model.dart` - MEDIUM impact
3. ✅ `lib/core/models/exchange_rate_model.dart` - LOW impact
4. ✅ `lib/core/models/country_model.dart` - NEW file
5. ✅ `lib/core/models/region_model.dart` - NEW file

**Services (1 file):**
6. ✅ `lib/core/services/supabase_service.dart` - NO impact

**BLoCs (2 files):**
7. ✅ `lib/features/admin/presentation/bloc/admin_bloc.dart` - MEDIUM impact
8. ✅ `lib/features/doctor/presentation/bloc/doctor_bloc.dart` - LOW impact

**Screens (6 files):**
9. ✅ `lib/features/admin/presentation/screens/admin_currencies_screen.dart` - MEDIUM impact
10. ✅ `lib/features/admin/presentation/screens/admin_subscriptions_screen.dart` - NO impact
11. ✅ `lib/features/admin/presentation/screens/admin_clinics_screen.dart` - MEDIUM impact
12. ✅ `lib/features/doctor/presentation/screens/doctor_profile_screen.dart` - LOW impact
13. ✅ `lib/features/doctor/presentation/screens/doctor_list_screen.dart` - LOW impact (if exists)
14. ✅ `lib/features/auth/presentation/screens/register_screen.dart` - MEDIUM impact

### Effort Breakdown

| Category | Files | Effort |
|----------|-------|--------|
| Models | 5 | 7.5h |
| Services | 1 | 0h |
| BLoCs | 2 | 3h |
| Screens | 6 | 7h |
| Testing | - | 3h |
| **Total** | **14** | **20.5h** |

### Risk Assessment

**HIGH RISK:**
- DoctorModel specialtyId type change (int → String)
- Breaking change for all doctor specialty operations

**MEDIUM RISK:**
- AdminBloc exchange rate ID generation
- Country/region selection UI

**LOW RISK:**
- New CountryModel and RegionModel
- Other model updates

### Mitigation Strategies

1. **Comprehensive Testing**
   - Unit tests for all model changes
   - Integration tests for BLoC changes
   - UI tests for screen changes

2. **Incremental Deployment**
   - Update models first
   - Update services second
   - Update BLoCs third
   - Update screens last

3. **Code Review**
   - Peer review all changes
   - Security review for type changes
   - Performance review for queries

---

## 8️⃣ Approval Checklist

### Pre-Change Checklist

- [ ] Impact map reviewed by technical lead
- [ ] Impact map reviewed by frontend team
- [ ] Impact map reviewed by backend team
- [ ] Risk assessment accepted
- [ ] Rollback plan documented
- [ ] Testing strategy approved
- [ ] Effort estimate confirmed
- [ ] Timeline approved

### Post-Change Checklist

- [ ] All models updated
- [ ] All BLoCs updated
- [ ] All screens updated
- [ ] Unit tests passing
- [ ] Integration tests passing
- [ ] UI tests passing
- [ ] Code review completed
- [ ] Documentation updated

---

## 9️⃣ Summary

### Key Findings

✅ **14 files** require updates  
✅ **20.5 hours** estimated effort  
✅ **1 breaking change** (DoctorModel specialtyId)  
✅ **2 new models** (Country, Region)  
✅ **Zero service changes** (UUID-agnostic)  
✅ **Moderate risk** overall  

### Next Steps

1. ✅ Review impact map
2. ✅ Approve or request changes
3. ✅ Begin model updates
4. ✅ Update BLoCs and screens
5. ✅ Test all changes
6. ✅ Deploy to staging

---

**Impact Map Version:** 1.0  
**Status:** AWAITING APPROVAL  
**Files Affected:** 14  
**Estimated Effort:** 20.5 hours  
**Risk Level:** MEDIUM