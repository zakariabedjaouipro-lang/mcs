# MCS - Migration Strategy
## Deterministic Numbering & Execution Approach

**Date:** March 4, 2026  
**Version:** 1.0  
**Strategy:** Full Baseline Reset  
**Status:** AWAITING APPROVAL

---

## 1️⃣ Migration Strategy Decision

### Strategy: FULL BASELINE RESET ✅

**Decision:** We will execute a **full baseline reset** with a single fresh migration set.

**Rationale:**
- ✅ Zero production data exists
- ✅ Zero active users impacted
- ✅ Eliminates all legacy confusion
- ✅ Provides clean slate
- ✅ Deterministic numbering guaranteed
- ✅ No backward compatibility concerns

**Rejected Alternative:** Incremental Modifications
- ❌ Would perpetuate technical debt
- ❌ Complex numbering strategy required
- ❌ Risk of migration conflicts
- ❌ Harder to validate
- ❌ More error-prone

---

## 2️⃣ Deterministic Numbering Strategy

### Numbering Convention

```
PREFIX + PHASE + SEQUENCE = MIGRATION_NUMBER

PREFIX:  "v2_" (Version 2 baseline)
PHASE:    "P01-P08" (8 phases)
SEQUENCE: "001-999" (up to 999 migrations per phase)
```

### Example Format

```
v2_P01_001_create_enums.sql
v2_P01_002_create_countries_table.sql
v2_P01_003_create_regions_table.sql
v2_P01_004_create_users_table.sql

v2_P02_001_create_specialties_table.sql
v2_P02_002_create_clinics_table.sql
v2_P02_003_create_subscriptions_table.sql

v2_P03_001_create_doctors_table.sql
...
```

### Complete Migration List

```
┌─────────────────────────────────────────────────────────────────┐
│                     V2 BASELINE MIGRATION LIST                   │
└─────────────────────────────────────────────────────────────────┘

PHASE 1: FOUNDATION (4 migrations)
├─ v2_P01_001_create_enums.sql
├─ v2_P01_002_create_countries_table.sql
├─ v2_P01_003_create_regions_table.sql
└─ v2_P01_004_create_users_table.sql

PHASE 2: CORE (3 migrations)
├─ v2_P02_001_create_specialties_table.sql
├─ v2_P02_002_create_clinics_table.sql
└─ v2_P02_003_create_subscriptions_table.sql

PHASE 3: MEDICAL (4 migrations)
├─ v2_P03_001_create_doctors_table.sql
├─ v2_P03_002_create_patients_table.sql
├─ v2_P03_003_create_employees_table.sql
└─ v2_P03_004_create_clinic_staff_table.sql

PHASE 4: CLINICAL (6 migrations)
├─ v2_P04_001_create_appointments_table.sql
├─ v2_P04_002_create_prescriptions_table.sql
├─ v2_P04_003_create_prescription_items_table.sql
├─ v2_P04_004_create_lab_results_table.sql
├─ v2_P04_005_create_vital_signs_table.sql
└─ v2_P04_006_create_video_sessions_table.sql

PHASE 5: ADMINISTRATIVE (5 migrations)
├─ v2_P05_001_create_invoices_table.sql
├─ v2_P05_002_create_invoice_items_table.sql
├─ v2_P05_003_create_inventory_table.sql
├─ v2_P05_004_create_inventory_transactions_table.sql
└─ v2_P05_005_create_reports_table.sql

PHASE 6: SUBSCRIPTION (2 migrations)
├─ v2_P06_001_create_subscription_codes_table.sql
└─ v2_P06_002_create_exchange_rates_table.sql

PHASE 7: NOTIFICATIONS (3 migrations)
├─ v2_P07_001_create_notifications_table.sql
├─ v2_P07_002_create_notification_settings_table.sql
└─ v2_P07_003_create_autism_assessments_table.sql

PHASE 8: SUPPORT (1 migration)
└─ v2_P08_001_create_bug_reports_table.sql

TOTAL: 28 migrations
```

### Migration Numbering Rules

**Rule 1: Sequential by Phase**
- Migrations within each phase are numbered sequentially (001, 002, 003...)
- No gaps in numbering within phases
- No renumbering after creation

**Rule 2: Phase-Based Grouping**
- Migrations are grouped by dependency phase
- Each phase represents a logical layer
- Phases must be executed in order

**Rule 3: Immutable Naming**
- Once created, migration names never change
- Never rename migrations
- Never delete migrations (only add new ones)

**Rule 4: Version Prefix**
- All v2 baseline migrations start with `v2_`
- Future v3 migrations would start with `v3_`
- Clear version separation

---

## 3️⃣ Legacy Migration Handling

### Current State

```
EXISTING MIGRATIONS (TO BE ARCHIVED):
├─ 001_create_enums.sql
├─ 002_create_users_table.sql
├─ 003_create_clinics_table.sql
├─ 004_create_doctors_table.sql [DUPLICATE]
├─ 005_create_patients_table.sql
├─ 006_create_appointments_table.sql
├─ 007_create_employees_table.sql
├─ 008_create_prescriptions_table.sql
├─ 009_create_invoices_table.sql
├─ 010_create_inventory_table.sql
├─ 011_create_lab_results_table.sql
├─ 012_create_notifications_table.sql
├─ 013_create_video_sessions_table.sql
├─ 014_create_reports_table.sql
├─ 015_create_subscription_codes_table.sql
├─ 016_create_exchange_rates_table.sql
├─ 017_create_doctors_table.sql [DUPLICATE]
└─ 018_create_specialties_table.sql

TOTAL: 18 migrations (with duplicate)
```

### Archive Strategy

**Step 1: Create Archive Directory**
```bash
mkdir -p supabase/migrations/archive/v1_legacy
```

**Step 2: Move Legacy Migrations**
```bash
# Move all existing migrations to archive
mv supabase/migrations/*.sql supabase/migrations/archive/v1_legacy/
```

**Step 3: Create Archive Manifest**
```bash
# Create manifest documenting archived migrations
echo "Legacy v1 migrations archived on $(date)" > supabase/migrations/archive/v1_legacy/MANIFEST.txt
```

**Step 4: Create New v2 Migrations**
```bash
# Create fresh v2 migration files
# (See complete list above)
```

### Archive Content

```
supabase/migrations/
├─ archive/
│  └─ v1_legacy/
│     ├─ MANIFEST.txt
│     ├─ 001_create_enums.sql
│     ├─ 002_create_users_table.sql
│     ├─ ... (all 18 legacy migrations)
│     └─ 018_create_specialties_table.sql
├─ v2_P01_001_create_enums.sql
├─ v2_P01_002_create_countries_table.sql
├─ ... (all 28 v2 migrations)
└─ v2_P08_001_create_bug_reports_table.sql
```

---

## 4️⃣ Database Reset Procedure

### Pre-Reset Checklist

- [ ] Archive existing migrations
- [ ] Backup current database schema (if exists)
- [ ] Document current database state
- [ ] Confirm no production data exists
- [ ] Confirm no active users
- [ ] Prepare rollback plan

### Reset Commands

```sql
-- Step 1: Connect to PostgreSQL
\c postgres

-- Step 2: Drop existing database (if exists)
DROP DATABASE IF EXISTS mcs_dev;

-- Step 3: Create fresh database
CREATE DATABASE mcs_dev
  WITH OWNER = postgres
  ENCODING = 'UTF8'
  LC_COLLATE = 'en_US.UTF-8'
  LC_CTYPE = 'en_US.UTF-8'
  TEMPLATE = template0;

-- Step 4: Connect to new database
\c mcs_dev

-- Step 5: Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Step 6: Execute migrations in order
-- (Use Supabase CLI or manual execution)
```

### Migration Execution Order

```bash
# Using Supabase CLI
supabase db reset

# Or manual execution
for migration in v2_*.sql; do
  echo "Executing $migration..."
  psql -d mcs_dev -f "$migration"
  if [ $? -ne 0 ]; then
    echo "ERROR: Migration $migration failed"
    exit 1
  fi
done
```

---

## 5️⃣ Validation Strategy

### Post-Migration Validation

**Validation 1: Schema Verification**
```sql
-- Verify all tables created
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Expected: 27 tables
```

**Validation 2: UUID Verification**
```sql
-- Verify all primary keys are UUID
SELECT 
  table_name,
  column_name,
  data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND column_name = 'id'
  AND data_type != 'uuid'
ORDER BY table_name;

-- Expected: 0 results (all PKs should be UUID)
```

**Validation 3: Foreign Key Verification**
```sql
-- Verify all foreign keys are UUID
SELECT 
  tc.table_name,
  kcu.column_name,
  cc.data_type
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.columns cc
  ON kcu.table_name = cc.table_name
  AND kcu.column_name = cc.column_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND cc.data_type != 'uuid'
ORDER BY tc.table_name, kcu.column_name;

-- Expected: 0 results (all FKs should be UUID)
```

**Validation 4: Index Verification**
```sql
-- Verify all indexes created
SELECT 
  schemaname,
  tablename,
  indexname
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- Expected: 80+ indexes
```

**Validation 5: RLS Verification**
```sql
-- Verify RLS enabled on all tables
SELECT 
  tablename,
  rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
  AND rowsecurity = false
ORDER BY tablename;

-- Expected: 0 results (all tables should have RLS enabled)
```

**Validation 6: Enum Verification**
```sql
-- Verify all enums created
SELECT typname
FROM pg_type
WHERE typtype = 'e'
ORDER BY typname;

-- Expected: 14 enums
```

### Automated Validation Script

```sql
-- Create validation function
CREATE OR REPLACE FUNCTION validate_schema()
RETURNS TABLE(validation_type TEXT, result TEXT, details TEXT) AS $$
BEGIN
  -- Validation 1: Table count
  RETURN QUERY
  SELECT 
    'table_count'::TEXT,
    CASE 
      WHEN (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public') = 27 
      THEN 'PASS' 
      ELSE 'FAIL' 
    END,
    'Expected 27 tables, got ' || (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public')::TEXT;
  
  -- Validation 2: UUID primary keys
  RETURN QUERY
  SELECT 
    'uuid_primary_keys'::TEXT,
    CASE 
      WHEN (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = 'public' AND column_name = 'id' AND data_type != 'uuid') = 0 
      THEN 'PASS' 
      ELSE 'FAIL' 
    END,
    'Expected 0 non-UUID primary keys, got ' || (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = 'public' AND column_name = 'id' AND data_type != 'uuid')::TEXT;
  
  -- Validation 3: UUID foreign keys
  RETURN QUERY
  SELECT 
    'uuid_foreign_keys'::TEXT,
    CASE 
      WHEN (SELECT COUNT(*) FROM information_schema.table_constraints tc
            JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name
            JOIN information_schema.columns cc ON kcu.table_name = cc.table_name AND kcu.column_name = cc.column_name
            WHERE tc.constraint_type = 'FOREIGN KEY' AND cc.data_type != 'uuid') = 0 
      THEN 'PASS' 
      ELSE 'FAIL' 
    END,
    'Expected 0 non-UUID foreign keys, got ' || (SELECT COUNT(*) FROM information_schema.table_constraints tc
            JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name
            JOIN information_schema.columns cc ON kcu.table_name = cc.table_name AND kcu.column_name = cc.column_name
            WHERE tc.constraint_type = 'FOREIGN KEY' AND cc.data_type != 'uuid')::TEXT;
  
  -- Validation 4: RLS enabled
  RETURN QUERY
  SELECT 
    'rls_enabled'::TEXT,
    CASE 
      WHEN (SELECT COUNT(*) FROM pg_tables WHERE schemaname = 'public' AND rowsecurity = false) = 0 
      THEN 'PASS' 
      ELSE 'FAIL' 
    END,
    'Expected 0 tables without RLS, got ' || (SELECT COUNT(*) FROM pg_tables WHERE schemaname = 'public' AND rowsecurity = false)::TEXT;
  
  -- Validation 5: Enum count
  RETURN QUERY
  SELECT 
    'enum_count'::TEXT,
    CASE 
      WHEN (SELECT COUNT(*) FROM pg_type WHERE typtype = 'e') = 14 
      THEN 'PASS' 
      ELSE 'FAIL' 
    END,
    'Expected 14 enums, got ' || (SELECT COUNT(*) FROM pg_type WHERE typtype = 'e')::TEXT;
END;
$$ LANGUAGE plpgsql;

-- Run validation
SELECT * FROM validate_schema();
```

---

## 6️⃣ Rollback Strategy

### Rollback Triggers

**Automatic Rollback Conditions:**
- ❌ Any migration fails to execute
- ❌ Schema validation fails
- ❌ UUID validation fails
- ❌ RLS validation fails
- ❌ Data type mismatch detected

### Rollback Procedure

```sql
-- Step 1: Drop failed database
DROP DATABASE IF EXISTS mcs_dev;

-- Step 2: Restore from backup (if available)
-- OR

-- Step 3: Re-run migrations from scratch
-- (Use fresh database creation)
```

### Rollback Validation

```sql
-- Verify database is clean
SELECT 
  'Database is clean' AS status,
  (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public') AS table_count;

-- Expected: 0 tables
```

---

## 7️⃣ Migration Dependency Graph

```
┌─────────────────────────────────────────────────────────────────┐
│                 V2 MIGRATION DEPENDENCY GRAPH                    │
└─────────────────────────────────────────────────────────────────┘

v2_P01_001_create_enums.sql (NO DEPENDENCIES)
  ↓
v2_P01_002_create_countries_table.sql (DEPENDS ON: none)
  ↓
v2_P01_003_create_regions_table.sql (DEPENDS ON: v2_P01_002)
  ↓
v2_P01_004_create_users_table.sql (DEPENDS ON: none)
  ↓
v2_P02_001_create_specialties_table.sql (DEPENDS ON: none)
  ↓
v2_P02_002_create_clinics_table.sql (DEPENDS ON: v2_P01_002, v2_P01_003)
  ↓
v2_P02_003_create_subscriptions_table.sql (DEPENDS ON: none)
  ↓
v2_P03_001_create_doctors_table.sql (DEPENDS ON: v2_P01_004, v2_P02_001, v2_P02_002)
  ↓
v2_P03_002_create_patients_table.sql (DEPENDS ON: v2_P01_004, v2_P02_002)
  ↓
v2_P03_003_create_employees_table.sql (DEPENDS ON: v2_P01_004, v2_P02_002)
  ↓
v2_P03_004_create_clinic_staff_table.sql (DEPENDS ON: v2_P01_004, v2_P02_002, v2_P03_003)
  ↓
v2_P04_001_create_appointments_table.sql (DEPENDS ON: v2_P03_001, v2_P03_002, v2_P02_002)
  ↓
v2_P04_002_create_prescriptions_table.sql (DEPENDS ON: v2_P03_001, v2_P03_002, v2_P04_001, v2_P02_002)
  ↓
v2_P04_003_create_prescription_items_table.sql (DEPENDS ON: v2_P04_002)
  ↓
v2_P04_004_create_lab_results_table.sql (DEPENDS ON: v2_P03_001, v2_P03_002, v2_P04_001, v2_P02_002)
  ↓
v2_P04_005_create_vital_signs_table.sql (DEPENDS ON: v2_P03_001, v2_P03_002, v2_P04_001, v2_P02_002)
  ↓
v2_P04_006_create_video_sessions_table.sql (DEPENDS ON: v2_P04_001, v2_P03_001, v2_P03_002, v2_P02_002)
  ↓
v2_P05_001_create_invoices_table.sql (DEPENDS ON: v2_P03_001, v2_P03_002, v2_P04_001, v2_P02_002)
  ↓
v2_P05_002_create_invoice_items_table.sql (DEPENDS ON: v2_P05_001)
  ↓
v2_P05_003_create_inventory_table.sql (DEPENDS ON: v2_P02_002)
  ↓
v2_P05_004_create_inventory_transactions_table.sql (DEPENDS ON: v2_P05_003)
  ↓
v2_P05_005_create_reports_table.sql (DEPENDS ON: v2_P02_002, v2_P01_004)
  ↓
v2_P06_001_create_subscription_codes_table.sql (DEPENDS ON: v2_P02_002)
  ↓
v2_P06_002_create_exchange_rates_table.sql (DEPENDS ON: none)
  ↓
v2_P07_001_create_notifications_table.sql (DEPENDS ON: v2_P01_004)
  ↓
v2_P07_002_create_notification_settings_table.sql (DEPENDS ON: v2_P01_004)
  ↓
v2_P07_003_create_autism_assessments_table.sql (DEPENDS ON: v2_P03_001, v2_P03_002, v2_P02_002)
  ↓
v2_P08_001_create_bug_reports_table.sql (DEPENDS ON: v2_P01_004)
```

### Dependency Rules

**Rule 1: Phase Dependencies**
- Phase N can only depend on Phase N-1 or earlier
- No forward dependencies within same phase
- No circular dependencies

**Rule 2: Table Dependencies**
- Child tables created after parent tables
- Foreign key references only to existing tables
- No forward references

**Rule 3: Execution Order**
- Phases executed sequentially (P01 → P02 → ... → P08)
- Within each phase, migrations executed sequentially (001 → 002 → 003)
- No parallel execution

---

## 8️⃣ Migration File Template

### Standard Template

```sql
-- Migration: {TABLE_NAME} table creation
-- Purpose: {PURPOSE_DESCRIPTION}
-- Version: v2_P{PHASE}_{SEQUENCE}
-- Created: {DATE}
-- Dependencies: {LIST_OF_DEPENDENCIES}

-- ══════════════════════════════════════════════════════════════════════════════
-- Table Creation
-- ══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS {table_name} (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    -- columns
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

CREATE INDEX idx_{table_name}_{column} ON {table_name}({column});

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security
-- ══════════════════════════════════════════════════════════════════════════════

ALTER TABLE {table_name} ENABLE ROW LEVEL SECURITY;

-- Policy: {POLICY_NAME}
CREATE POLICY "{policy_name}"
  ON {table_name} FOR {OPERATION}
  USING ({CONDITION});

-- ══════════════════════════════════════════════════════════════════════════════
-- Triggers
-- ══════════════════════════════════════════════════════════════════════════════

CREATE TRIGGER update_{table_name}_updated_at
  BEFORE UPDATE ON {table_name}
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE {table_name} IS '{TABLE_PURPOSE}';
COMMENT ON COLUMN {table_name}.{column} IS '{COLUMN_PURPOSE}';
```

---

## 9️⃣ Execution Timeline

### Phase-by-Phase Execution

| Phase | Migrations | Duration | Validation |
|-------|------------|----------|------------|
| P01: Foundation | 4 | 5 min | Schema, UUID, RLS |
| P02: Core | 3 | 5 min | FKs, Indexes |
| P03: Medical | 4 | 8 min | Complex FKs |
| P04: Clinical | 6 | 12 min | Complex relationships |
| P05: Administrative | 5 | 10 min | Business logic |
| P06: Subscription | 2 | 5 min | Financial data |
| P07: Notifications | 3 | 6 min | User-facing |
| P08: Support | 1 | 3 min | System tables |

**Total Execution Time:** ~54 minutes

### Validation Checkpoints

**After Each Phase:**
1. ✅ Migration execution successful
2. ✅ Tables created correctly
3. ✅ Indexes created correctly
4. ✅ RLS policies enabled
5. ✅ Foreign keys valid

**After All Phases:**
1. ✅ Complete schema validation
2. ✅ UUID verification
3. ✅ RLS verification
4. ✅ Data type verification
5. ✅ Performance verification

---

## 🔟 Summary

### Strategy Confirmed

✅ **Full Baseline Reset**  
✅ **Deterministic Numbering** (v2_P{PHASE}_{SEQUENCE})  
✅ **Archive Legacy Migrations**  
✅ **Zero Legacy Confusion**  
✅ **Clean Slate Foundation**

### Key Benefits

✅ No backward compatibility concerns  
✅ No migration conflicts  
✅ Easy to validate  
✅ Clear version separation  
✅ Deterministic execution  
✅ Easy rollback

### Next Steps

1. ✅ Review migration strategy
2. ✅ Approve or request changes
3. ✅ Begin execution upon approval
4. ✅ Execute migrations in order
5. ✅ Validate after each phase
6. ✅ Rollback on failure

---

**Strategy Version:** 1.0  
**Status:** AWAITING APPROVAL  
**Total Migrations:** 28  
**Total Execution Time:** ~54 minutes  
**Rollback Available:** YES