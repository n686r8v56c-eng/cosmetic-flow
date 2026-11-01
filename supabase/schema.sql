-- Execute once in Supabase SQL Editor. Never use service_role in browser.
create table if not exists public.makeup_flow_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.makeup_flow_data enable row level security;
drop policy if exists "Users can read own makeup data" on public.makeup_flow_data;
create policy "Users can read own makeup data" on public.makeup_flow_data for select to authenticated using ((select auth.uid())=user_id);
drop policy if exists "Users can insert own makeup data" on public.makeup_flow_data;
create policy "Users can insert own makeup data" on public.makeup_flow_data for insert to authenticated with check ((select auth.uid())=user_id);
drop policy if exists "Users can update own makeup data" on public.makeup_flow_data;
create policy "Users can update own makeup data" on public.makeup_flow_data for update to authenticated using ((select auth.uid())=user_id) with check ((select auth.uid())=user_id);
