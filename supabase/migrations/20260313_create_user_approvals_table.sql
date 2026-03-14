-- Create auth schema for Supabase compatibility
CREATE SCHEMA IF NOT EXISTS auth;

-- Create user_approvals table
-- جدول طلبات موافقة المستخدمين
create table if not exists public.user_approvals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  email text not null,
  full_name text not null,
  role text not null,
  registration_type text not null check (registration_type in ('email', 'google', 'facebook')),
  status text not null check (status in ('pending', 'approved', 'rejected')) default 'pending',
  created_at timestamptz default now(),
  approved_at timestamptz,
  rejected_at timestamptz,
  approval_notes text,
  rejection_reason text,
  unique(user_id)
);

-- Enable RLS
alter table public.user_approvals enable row level security;

-- Create indexes
create index if not exists idx_user_approvals_user_id on public.user_approvals(user_id);
create index if not exists idx_user_approvals_status on public.user_approvals(status);
create index if not exists idx_user_approvals_created_at on public.user_approvals(created_at desc);

-- RLS Policies

-- Policy 1: Users can read their own approval record
create policy "Users can read own approval"
  on public.user_approvals
  for select
  using (auth.uid() = user_id);

-- Policy 2: Super admins can read all records
create policy "Super admin can read all approvals"
  on public.user_approvals
  for select
  using (
    (select raw_user_meta_data->>'role' from auth.users where id = auth.uid()) = 'super_admin'
  );

-- Policy 3: Super admins can update records
create policy "Super admin can update approval status"
  on public.user_approvals
  for update
  using (
    (select raw_user_meta_data->>'role' from auth.users where id = auth.uid()) = 'super_admin'
  )
  with check (
    (select raw_user_meta_data->>'role' from auth.users where id = auth.uid()) = 'super_admin'
  );

-- Policy 4: Clinic admins can read approvals for their clinic (if clinic_id is available)
create policy "Clinic admin can read pending approvals"
  on public.user_approvals
  for select
  using (
    (select raw_user_meta_data->>'role' from auth.users where id = auth.uid()) = 'clinic_admin'
    and status = 'pending'
  );

-- Policy 5: System can insert on signup
create policy "Enable insert on user approvals for authenticated users"
  on public.user_approvals
  for insert
  with check (true);

-- Grant permissions
grant select on public.user_approvals to authenticated;
grant select, update on public.user_approvals to authenticated;
