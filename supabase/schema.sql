-- OSS MMR Office — Supabase schema
-- V1: register surat masuk, surat keluar, jadwal, and simple profiles.
-- No document/file storage is used.

create extension if not exists pgcrypto;

-- Profiles: one row per authenticated internal user.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Permanent register number: never reuse a number after deletion.
create sequence if not exists public.incoming_letters_register_no_seq;
create sequence if not exists public.outgoing_letters_register_no_seq;

create table if not exists public.incoming_letters (
  id uuid primary key default gen_random_uuid(),
  register_no bigint not null default nextval('public.incoming_letters_register_no_seq'),
  tanggal_terima date not null,
  terima_dari text not null,
  tanggal_surat date,
  nomor_surat text,
  perihal text not null,
  ditujukan_kepada text,
  lampiran text,
  kode text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.outgoing_letters (
  id uuid primary key default gen_random_uuid(),
  register_no bigint not null default nextval('public.outgoing_letters_register_no_seq'),
  tanggal date not null,
  nomor_surat text,
  dari text,
  diterima text,
  kepada text,
  perihal text not null,
  lampiran text,
  kode text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.schedules (
  id uuid primary key default gen_random_uuid(),
  tanggal date not null,
  jam time,
  kegiatan text not null,
  lokasi text,
  keterangan text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Indexes for common register/dashboard queries.
create index if not exists incoming_letters_tanggal_terima_idx on public.incoming_letters (tanggal_terima desc);
create index if not exists outgoing_letters_tanggal_idx on public.outgoing_letters (tanggal desc);
create index if not exists schedules_tanggal_jam_idx on public.schedules (tanggal asc, jam asc);

-- Automatic profile creation when a new Auth user is created.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data->>'full_name', new.email));
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

-- Updated-at helper.
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_profiles_updated_at on public.profiles;
create trigger set_profiles_updated_at
before update on public.profiles
for each row execute procedure public.set_updated_at();

drop trigger if exists set_incoming_letters_updated_at on public.incoming_letters;
create trigger set_incoming_letters_updated_at
before update on public.incoming_letters
for each row execute procedure public.set_updated_at();

drop trigger if exists set_outgoing_letters_updated_at on public.outgoing_letters;
create trigger set_outgoing_letters_updated_at
before update on public.outgoing_letters
for each row execute procedure public.set_updated_at();

drop trigger if exists set_schedules_updated_at on public.schedules;
create trigger set_schedules_updated_at
before update on public.schedules
for each row execute procedure public.set_updated_at();

-- RLS: authenticated users only. Both internal accounts have the same access.
alter table public.profiles enable row level security;
alter table public.incoming_letters enable row level security;
alter table public.outgoing_letters enable row level security;
alter table public.schedules enable row level security;

drop policy if exists "authenticated users can read profiles" on public.profiles;
create policy "authenticated users can read profiles"
on public.profiles for select to authenticated using (true);

drop policy if exists "authenticated users can update own profile" on public.profiles;
create policy "authenticated users can update own profile"
on public.profiles for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

drop policy if exists "authenticated users can manage incoming letters" on public.incoming_letters;
create policy "authenticated users can manage incoming letters"
on public.incoming_letters for all to authenticated using (true) with check (true);

drop policy if exists "authenticated users can manage outgoing letters" on public.outgoing_letters;
create policy "authenticated users can manage outgoing letters"
on public.outgoing_letters for all to authenticated using (true) with check (true);

drop policy if exists "authenticated users can manage schedules" on public.schedules;
create policy "authenticated users can manage schedules"
on public.schedules for all to authenticated using (true) with check (true);

-- Notes:
-- 1. Create exactly two users manually in Supabase Auth; public sign-up is disabled in the app.
-- 2. Do not create a Supabase Storage bucket for V1.
-- 3. Excel formatting is handled by the frontend export layer, matching the office register format.
