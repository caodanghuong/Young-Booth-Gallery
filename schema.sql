-- ============================================================
-- Young Booth Gallery — Supabase schema (chạy lại nhiều lần đều an toàn)
-- Supabase → SQL Editor → New query → dán hết → Run
-- ============================================================

-- 1) Bảng dữ liệu (object lưu trong cột jsonb "data")
create table if not exists albums (
  id text primary key,
  created_at bigint,
  data jsonb not null default '{}'::jsonb
);
create table if not exists settings (
  id text primary key,
  data jsonb not null default '{}'::jsonb
);
create table if not exists reviews (
  id text primary key,
  album_id text,
  at bigint,
  data jsonb not null default '{}'::jsonb
);
create table if not exists bookings (
  id text primary key,
  at bigint,
  data jsonb not null default '{}'::jsonb
);

-- 2) Bật Row Level Security
alter table albums   enable row level security;
alter table settings enable row level security;
alter table reviews  enable row level security;
alter table bookings enable row level security;

-- 3) Policies (xoá cũ rồi tạo lại -> chạy lại an toàn)
drop policy if exists "albums read"    on albums;
drop policy if exists "albums write"   on albums;
create policy "albums read"    on albums   for select using (true);
create policy "albums write"   on albums   for all to authenticated using (true) with check (true);

drop policy if exists "settings read"  on settings;
drop policy if exists "settings write" on settings;
create policy "settings read"  on settings for select using (true);
create policy "settings write" on settings for all to authenticated using (true) with check (true);

drop policy if exists "reviews read"   on reviews;
drop policy if exists "reviews insert" on reviews;
drop policy if exists "reviews update" on reviews;
drop policy if exists "reviews delete" on reviews;
create policy "reviews read"   on reviews  for select using (true);
create policy "reviews insert" on reviews  for insert to anon, authenticated with check (true);
create policy "reviews update" on reviews  for update to anon, authenticated using (true) with check (true);
create policy "reviews delete" on reviews  for delete to authenticated using (true);

drop policy if exists "bookings insert" on bookings;
drop policy if exists "bookings read"   on bookings;
drop policy if exists "bookings update" on bookings;
drop policy if exists "bookings delete" on bookings;
create policy "bookings insert" on bookings for insert to anon, authenticated with check (true);
create policy "bookings read"   on bookings for select to authenticated using (true);
create policy "bookings update" on bookings for update to authenticated using (true) with check (true);
create policy "bookings delete" on bookings for delete to authenticated using (true);

-- 4) Realtime (bỏ qua nếu đã thêm)
do $$ begin alter publication supabase_realtime add table albums;   exception when others then null; end $$;
do $$ begin alter publication supabase_realtime add table settings; exception when others then null; end $$;
do $$ begin alter publication supabase_realtime add table reviews;  exception when others then null; end $$;
do $$ begin alter publication supabase_realtime add table bookings; exception when others then null; end $$;

-- 5) Storage policies cho bucket ảnh 'photos' (nhớ tạo bucket 'photos' Public trong Storage)
drop policy if exists "photos public read"  on storage.objects;
drop policy if exists "photos admin insert" on storage.objects;
drop policy if exists "photos admin update" on storage.objects;
drop policy if exists "photos admin delete" on storage.objects;
create policy "photos public read"  on storage.objects for select using (bucket_id = 'photos');
create policy "photos admin insert" on storage.objects for insert to authenticated with check (bucket_id = 'photos');
create policy "photos admin update" on storage.objects for update to authenticated using (bucket_id = 'photos');
create policy "photos admin delete" on storage.objects for delete to authenticated using (bucket_id = 'photos');

-- 6) Làm mới cache API (PostgREST)
notify pgrst, 'reload schema';
