# 🛠️ PHASE 3 IMPLEMENTATION CHECKLIST

## Phase 3: Dashboard Integration & Real Data Connection

**Estimated Duration**: 2-3 hours  
**Priority**: HIGH  
**Blocker**: None (Phase 2 complete)

---

## Step 1: Update Router (15 min)

### Current State
```dart
GoRoute(
  path: '/clinic/dashboard',
  builder: (context, state) => const ClinicDashboard(),
)
```

### What to Change
Add `BlocProvider` wrapper around each dashboard:

```dart
GoRoute(
  path: '/clinic/dashboard',
  builder: (context, state) => BlocProvider(
    create: (context) => sl<ClinicBloc>(),
    child: const ClinicDashboard(),
  ),
)
```

### Routes to Update (7 total)
1. `/clinic/dashboard` → Wrap with `BlocProvider<ClinicBloc>`
2. `/nurse/dashboard` → Wrap with `BlocProvider<NurseBloc>`
3. `/receptionist/dashboard` → Wrap with `BlocProvider<ReceptionistBloc>`
4. `/pharmacist/dashboard` → Wrap with `BlocProvider<PharmacistBloc>`
5. `/lab/dashboard` → Wrap with `BlocProvider<LabTechnicianBloc>`
6. `/radiology/dashboard` → Wrap with `BlocProvider<RadioGrapherBloc>`
7. `/relative/dashboard` → Wrap with `BlocProvider<RelativeBloc>`

### File to Modify
`lib/core/config/router.dart` - Find each route definition and add wrapper

---

## Step 2: Update Dashboard Screens (30 min)

### What Each Dashboard Needs

#### 2.1 Add Imports
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/features/clinic/presentation/bloc/clinic_bloc.dart';
```

#### 2.2 Update initState
```dart
@override
void initState() {
  super.initState();
  // Dispatch load event to BLoC
  context.read<ClinicBloc>().add(
    LoadClinicStatsEvent(clinicId: _clinicId),
  );
}
```

#### 2.3 Wrap UI with BlocBuilder
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Clinic Dashboard')),
    body: BlocBuilder<ClinicBloc, ClinicState>(
      builder: (context, state) {
        if (state is ClinicLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is ClinicStatsLoaded) {
          return SingleChildScrollView(
            child: Column(
              children: [
                StatCard(
                  title: 'Total Doctors',
                  value: state.totalDoctors.toString(),
                ),
                StatCard(
                  title: 'Total Patients',
                  value: state.totalPatients.toString(),
                ),
                StatCard(
                  title: 'Today Appointments',
                  value: state.todayAppointments.toString(),
                ),
                StatCard(
                  title: 'Active Doctors',
                  value: state.activeDoctors.toString(),
                ),
              ],
            ),
          );
        }
        
        if (state is ClinicError) {
          return ErrorWidget(
            icon: Icons.error_outline,
            title: 'Error',
            message: state.message,
            onRetry: () {
              context.read<ClinicBloc>().add(
                LoadClinicStatsEvent(clinicId: _clinicId),
              );
            },
          );
        }
        
        return const SizedBox();
      },
    ),
  );
}
```

### Dashboards to Update (All displayed as templates)

| Dashboard | BLoC | Events to Dispatch | States to Handle |
|-----------|------|-------------------|------------------|
| ClinicDashboard | ClinicBloc | LoadClinicStatsEvent | ClinicStatsLoaded |
| NurseDashboard | NurseBloc | LoadNurseDataEvent | NurseDataLoaded |
| ReceptionistDashboard | ReceptionistBloc | LoadReceptionistDataEvent | ReceptionistDataLoaded |
| PharmacistDashboard | PharmacistBloc | LoadPharmacistDataEvent | PharmacistDataLoaded |
| LabDashboard | LabTechnicianBloc | LoadLabDataEvent | LabTechnicianDataLoaded |
| RadioGraphyDashboard | RadioGrapherBloc | LoadRadiographerDataEvent | RadioGrapherDataLoaded |
| RelativeDashboard | RelativeBloc | LoadRelativeDataEvent | RelativeDataLoaded |

### Files to Modify
```
lib/features/clinic/presentation/screens/clinic_dashboard.dart
lib/features/nurse/presentation/screens/nurse_dashboard.dart
lib/features/receptionist/presentation/screens/receptionist_dashboard.dart
lib/features/pharmacist/presentation/screens/pharmacist_dashboard.dart
lib/features/lab/presentation/screens/lab_dashboard.dart
lib/features/radiology/presentation/screens/radiographer_dashboard.dart
lib/features/relative/presentation/screens/relative_dashboard.dart
```

---

## Step 3: Test with Mock Data (10 min)

### What to Test
```bash
# 1. Run the app
flutter run -d chrome

# 2. Navigate to each role dashboard
# - TestUser (Admin)
# - Click "Clinic Dashboard" → Should show mock stats
# - Click "Nurse Dashboard" → Should show nurse data
# - etc.

# 3. Verify
- ✅ Dashboards load without errors
- ✅ Mock data displays correctly
- ✅ Loading states show briefly
- ✅ No type errors or warnings
```

### Expected Mock Data
- **Clinic**: 15 doctors, 120 patients, 24 appointments, 12 active doctors
- **Nurse**: 12 assigned patients, 8 today tasks, 5 pending appointments
- **Receptionist**: 24 today appointments, 3 new patients, 7 pending schedules
- **Pharmacist**: 15 pending prescriptions, 4 low stock medicines, 542 total inventory
- **Lab Technician**: 18 pending tests, 12 completed today, 6 pending reports
- **Radiographer**: 9 pending requests, 11 completed scans, 5 reports ready
- **Relative**: 3 patients, 2 upcoming appointments, 8 medical records

---

## Step 4: Create Missing Repositories (1 hour)

### For Each Role, Create:

#### 4.1 Repository Interface
**File**: `lib/features/{role}/domain/repositories/{role}_repository.dart`

```dart
abstract class NurseRepository {
  Future<Either<Failure, Map<String, dynamic>>> getNurseData(String nurseId);
}
```

#### 4.2 Repository Implementation
**File**: `lib/features/{role}/data/repositories/{role}_repository_impl.dart`

```dart
class NurseRepositoryImpl implements NurseRepository {
  final SupabaseService _supabaseService;
  
  NurseRepositoryImpl(this._supabaseService);
  
  @override
  Future<Either<Failure, Map<String, dynamic>>> getNurseData(String nurseId) async {
    try {
      // Fetch from Supabase tables
      final assignedPatients = await _supabaseService.fetchAll(
        'patient_assignments',
        filters: {'nurse_id': nurseId},
      );
      
      final todayTasks = await _supabaseService.fetchAll(
        'nurse_tasks',
        filters: {'nurse_id': nurseId, 'date': DateTime.now()},
      );
      
      final pendingAppointments = await _supabaseService.fetchAll(
        'appointments',
        filters: {'assigned_nurse': nurseId, 'status': 'pending'},
      );
      
      return Right({
        'assignedPatients': assignedPatients.length,
        'todayTasks': todayTasks.length,
        'pendingAppointments': pendingAppointments.length,
      });
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

### Repositories to Create (6)

| Role | Interface | Implementation |
|------|-----------|-----------------|
| Nurse | `nurse_repository.dart` | `nurse_repository_impl.dart` |
| Receptionist | `receptionist_repository.dart` | `receptionist_repository_impl.dart` |
| Pharmacist | `pharmacist_repository.dart` | `pharmacist_repository_impl.dart` |
| Lab Technician | `lab_technician_repository.dart` | `lab_technician_repository_impl.dart` |
| Radiographer | `radiographer_repository.dart` | `radiographer_repository_impl.dart` |
| Relative | `relative_repository.dart` | `relative_repository_impl.dart` |

### Locations
```
lib/features/{role}/domain/repositories/{role}_repository.dart
lib/features/{role}/data/repositories/{role}_repository_impl.dart
```

---

## Step 5: Connect Repositories to BLoCs (30 min)

### Update Each BLoC to Use Repository

#### Before (Mock Data):
```dart
Future<void> _onLoadData(LoadNurseDataEvent event, Emitter<NurseState> emit) async {
  emit(NurseLoading());
  await Future<void>.delayed(const Duration(milliseconds: 500));
  emit(NurseDataLoaded(
    assignedPatients: 12,
    todayTasks: 8,
    pendingAppointments: 5,
  ));
}
```

#### After (Real Data):
```dart
Future<void> _onLoadData(LoadNurseDataEvent event, Emitter<NurseState> emit) async {
  emit(NurseLoading());
  
  final result = await _nurseRepository.getNurseData(event.nurseId);
  
  result.fold(
    (failure) => emit(NurseError(message: failure.message)),
    (data) => emit(NurseDataLoaded(
      assignedPatients: data['assignedPatients'] as int,
      todayTasks: data['todayTasks'] as int,
      pendingAppointments: data['pendingAppointments'] as int,
    )),
  );
}
```

### BLoCs to Update
```
lib/features/nurse/presentation/bloc/nurse_bloc.dart
lib/features/receptionist/presentation/bloc/receptionist_bloc.dart
lib/features/pharmacist/presentation/bloc/pharmacist_bloc.dart
lib/features/lab/presentation/bloc/lab_technician_bloc.dart
lib/features/radiology/presentation/bloc/radiographer_bloc.dart
lib/features/relative/presentation/bloc/relative_bloc.dart
```

---

## Step 6: Register Repositories in DI (10 min)

### Update `injection_container.dart`

Add after existing registrations:

```dart
// Nurse
..registerLazySingleton<NurseRepository>(
  () => NurseRepositoryImpl(sl<SupabaseService>()),
)

// Receptionist
..registerLazySingleton<ReceptionistRepository>(
  () => ReceptionistRepositoryImpl(sl<SupabaseService>()),
)

// Pharmacist
..registerLazySingleton<PharmacistRepository>(
  () => PharmacistRepositoryImpl(sl<SupabaseService>()),
)

// Lab Technician
..registerLazySingleton<LabTechnicianRepository>(
  () => LabTechnicianRepositoryImpl(sl<SupabaseService>()),
)

// Radiographer
..registerLazySingleton<RadioGrapherRepository>(
  () => RadioGrapherRepositoryImpl(sl<SupabaseService>()),
)

// Relative
..registerLazySingleton<RelativeRepository>(
  () => RelativeRepositoryImpl(sl<SupabaseService>()),
)
```

Then update BLoC registrations to use repositories:

```dart
..registerFactory(() => NurseBloc(sl<NurseRepository>()))
..registerFactory(() => ReceptionistBloc(sl<ReceptionistRepository>()))
// ... etc for all 6 roles
```

---

## Step 7: Update SupabaseService (if needed)

### Verify These Methods Exist
```dart
Future<List<Map<String, dynamic>>> fetchAll(
  String tableName, {
  Map<String, dynamic>? filters,
  String? orderBy,
  bool descending = false,
})

Future<Map<String, dynamic>?> fetchOne(
  String tableName,
  String id,
)

Future<void> update(
  String tableName,
  Map<String, dynamic> data,
)
```

If not, add them to `lib/core/services/supabase_service.dart`

---

## Step 8: Test Complete System (20 min)

### Verification Checklist

```bash
# 1. Run anlayzer
flutter analyze
# Expected: ✅ 0 errors

# 2. Build web
flutter build web
# Expected: ✅ Build successful

# 3. Run app
flutter run -d chrome

# 4. Test Each Dashboard
- [ ] Navigate to Clinic Dashboard → Data loads
- [ ] Navigate to Nurse Dashboard → Data loads
- [ ] Navigate to Receptionist Dashboard → Data loads
- [ ] Navigate to Pharmacist Dashboard → Data loads
- [ ] Navigate to Lab Dashboard → Data loads
- [ ] Navigate to Radiology Dashboard → Data loads
- [ ] Navigate to Relative Dashboard → Data loads

# 5. Error Handling
- [ ] Try loading with invalid IDs → Error state displays
- [ ] Refresh data → Updates correctly
- [ ] Switch between roles → No cross-contamination

# 6. Performance
- [ ] Data loads in < 2 seconds
- [ ] No memory leaks observed
- [ ] No console warnings
```

---

## 📋 Quick Reference: Common Tasks

### Add BlocProvider
```dart
BlocProvider(
  create: (context) => sl<YourBloc>(),
  child: YourScreen(),
)
```

### Dispatch Event
```dart
context.read<YourBloc>().add(YourEvent());
```

### Listen to State
```dart
BlocBuilder<YourBloc, YourState>(
  builder: (context, state) {
    // Build UI based on state
  },
)
```

### Register in DI
```dart
..registerFactory(() => YourBloc(sl<YourRepository>()))
```

---

## ⏱️ Time Breakdown

| Task | Time | Status |
|------|------|--------|
| Step 1: Update Router | 15 min | ⏳ |
| Step 2: Update Dashboards | 30 min | ⏳ |
| Step 3: Test Mock Data | 10 min | ⏳ |
| Step 4: Create Repositories | 60 min | ⏳ |
| Step 5: Connect to BLoCs | 30 min | ⏳ |
| Step 6: Update DI | 10 min | ⏳ |
| Step 7: Verify Services | 5 min | ⏳ |
| Step 8: Full System Test | 20 min | ⏳ |
| **Total** | **180 min** | **3 hours** |

---

## 🎯 Success Criteria

✅ All 10 role dashboards load without errors  
✅ Each dashboard displays role-specific data  
✅ Data updates when events are dispatched  
✅ Error states handled gracefully  
✅ No type errors or compilation warnings  
✅ BLoC instantiation with DI works smoothly  
✅ Mock data displays correctly during testing  
✅ Real Supabase data displays after repository integration  

---

**Status**: Ready to implement  
**Blocker**: None  
**Estimated Completion**: 3 hours  

Start with **Step 1** and follow the checklist in order!
