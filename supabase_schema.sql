-- MELATE 6/56 · Supabase PostgreSQL · ejecutar completo en SQL Editor
create extension if not exists pgcrypto;

create table if not exists public.evaluaciones (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 created_at timestamptz not null default now(),
 draw_date date not null,
 observed_numbers smallint[] not null check (cardinality(observed_numbers)=6),
 observed_rank bigint not null check (observed_rank between 1 and 32468436),
 global_score double precision not null check (global_score between 0 and 100),
 mean_hits double precision not null,
 mean_substitution_distance double precision not null,
 mean_hamming_distance double precision not null,
 mean_normalized_hamming double precision not null check (mean_normalized_hamming between 0 and 1),
 distance_residual double precision not null,
 baseline_mean_score double precision not null,
 baseline_p50 double precision not null,
 baseline_p90 double precision not null,
 baseline_p95 double precision not null,
 baseline_p99 double precision not null,
 baseline_tail_probability double precision not null check (baseline_tail_probability between 0 and 1),
 simulation_repetitions integer not null,
 method_version text not null
);
create table if not exists public.predicciones (
 id bigint generated always as identity primary key,
 evaluation_id uuid not null references public.evaluaciones(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,
 position smallint not null check(position between 1 and 24),
 numbers smallint[] not null check(cardinality(numbers)=6),
 combinatorial_rank bigint not null check(combinatorial_rank between 1 and 32468436),
 weight double precision not null default 1 check(weight>0),
 hits smallint not null check(hits between 0 and 6),
 score double precision not null check(score between 0 and 100),
 substitution_distance smallint not null check(substitution_distance between 0 and 6),
 hamming_distance smallint not null check(hamming_distance in (0,2,4,6,8,10,12)),
 normalized_distance double precision not null check(normalized_distance between 0 and 1),
 unique(evaluation_id,position), unique(evaluation_id,combinatorial_rank)
);
create index if not exists evaluaciones_user_date_idx on public.evaluaciones(user_id,draw_date desc);
create index if not exists predicciones_eval_idx on public.predicciones(evaluation_id);

alter table public.evaluaciones enable row level security;
alter table public.predicciones enable row level security;
revoke all on public.evaluaciones from anon; revoke all on public.predicciones from anon;
grant usage on schema public to authenticated;
grant select,insert,delete on public.evaluaciones to authenticated;
grant select,insert,delete on public.predicciones to authenticated;
drop policy if exists "Users manage own evaluations" on public.evaluaciones;
drop policy if exists "Users manage own predictions" on public.predicciones;
create policy "Users manage own evaluations" on public.evaluaciones for all to authenticated using ((select auth.uid())=user_id) with check ((select auth.uid())=user_id);
create policy "Users manage own predictions" on public.predicciones for all to authenticated using ((select auth.uid())=user_id) with check ((select auth.uid())=user_id);

grant usage, select on all sequences in schema public to authenticated;
