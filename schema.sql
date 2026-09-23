-- ============================================================
-- Young Booth Gallery — Supabase schema
-- Chạy toàn bộ file này trong Supabase → SQL Editor → New query → Run
-- ============================================================

-- 1) Bảng dữ liệu (lưu object dạng jsonb trong cột "data")
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

-- 3) Policies
-- Album & Cấu hình: ai cũng đọc, chỉ admin (đã đăng nhập) ghi
create policy "albums read"    on albums   for select using (true);
create policy "albums write"   on albums   for all to authenticated using (true) with check (true);
create policy "settings read"  on settings for select using (true);
create policy "settings write" on settings for all to authenticated using (true) with check (true);

-- Đánh giá: ai cũng đọc & gửi/sửa; chỉ admin xoá
create policy "reviews read"   on reviews  for select using (true);
create policy "reviews insert" on reviews  for insert to anon, authenticated with check (true);
create policy "reviews update" on reviews  for update to anon, authenticated using (true) with check (true);
create policy "reviews delete" on reviews  for delete to authenticated using (true);

-- Đơn đặt booth: ai cũng gửi; chỉ admin xem/sửa/xoá
create policy "bookings insert" on bookings for insert to anon, authenticated with check (true);
create policy "bookings read"   on bookings for select to authenticated using (true);
create policy "bookings update" on bookings for update to authenticated using (true) with check (true);
create policy "bookings delete" on bookings for delete to authenticated using (true);

-- 4) Realtime (để trang tự cập nhật khi có thay đổi)
alter publication supabase_realtime add table albums;
alter publication supabase_realtime add table settings;
alter publication supabase_realtime add table reviews;
alter publication supabase_realtime add table bookings;

-- 5) Storage policies cho bucket ảnh 'photos'
--    (Tạo bucket 'photos' + đặt Public trong Storage TRƯỚC khi chạy phần này)
create policy "photos public read" on storage.objects
  for select using (bucket_id = 'photos');
create policy "photos admin insert" on storage.objects
  for insert to authenticated with check (bucket_id = 'photos');
create policy "photos admin update" on storage.objects
  for update to authenticated using (bucket_id = 'photos');
create policy "photos admin delete" on storage.objects
  for delete to authenticated using (bucket_id = 'photos');
