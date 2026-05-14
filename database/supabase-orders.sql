-- ============================================================================
-- ТОЛЬКО PostgreSQL (Supabase). НЕ выполняйте этот файл в MySQL / phpMyAdmin —
-- синтаксис другой (uuid, timestamptz, jsonb, RLS, gen_random_uuid — это Postgres).
--
-- Где запускать: https://supabase.com → ваш проект → SQL Editor → New query
-- → вставить весь файл → Run.
-- ============================================================================
-- После выполнения: Authentication → Users → создайте пользователя (email/пароль для админки сайта).

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  payload jsonb not null
);

create index if not exists orders_created_at_idx on public.orders (created_at desc);

alter table public.orders enable row level security;

grant usage on schema public to anon, authenticated;
grant insert on table public.orders to anon;
grant select, delete on table public.orders to authenticated;

drop policy if exists "orders_insert_anon" on public.orders;
create policy "orders_insert_anon"
  on public.orders for insert
  to anon
  with check (true);

drop policy if exists "orders_select_auth" on public.orders;
create policy "orders_select_auth"
  on public.orders for select
  to authenticated
  using (true);

drop policy if exists "orders_delete_auth" on public.orders;
create policy "orders_delete_auth"
  on public.orders for delete
  to authenticated
  using (true);
