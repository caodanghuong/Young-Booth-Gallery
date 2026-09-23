# Hướng dẫn public Young Booth Gallery (Supabase + hosting)

Mục tiêu: ai cũng vào link công khai, mọi tính năng chạy (album/upload ảnh/đánh giá/đơn đặt booth/đăng nhập admin thật/email).

Kiến trúc: `index.html` (tĩnh) + **Supabase** (database + storage ảnh + auth) + (tuỳ chọn) **EmailJS** gửi email đơn.

---

## Bước 1 — Tạo project Supabase (miễn phí)
1. Vào https://supabase.com → đăng nhập → **New project** (đặt tên, chọn region gần VN như Singapore, đặt Database password).
2. Đợi ~1 phút cho project khởi tạo.

## Bước 2 — Tạo bảng dữ liệu
1. Vào **SQL Editor → New query**.
2. Dán toàn bộ nội dung file **`schema.sql`** (phần bảng + policies + realtime).
3. **Storage:** vào **Storage → New bucket** → tên `photos` → bật **Public bucket** → Create.
4. Quay lại SQL Editor chạy **phần 5** trong `schema.sql` (storage policies) — hoặc chạy cả file 1 lần sau khi đã tạo bucket.

## Bước 3 — Lấy 2 khoá công khai
Vào **Project Settings → API**, copy:
- **Project URL**  (vd `https://abcdxyz.supabase.co`)
- **anon public** key (chuỗi `eyJ...`)

> 2 khoá này *được phép để công khai* trong code (bảo mật đã do RLS lo). KHÔNG dùng `service_role` key.

## Bước 4 — Tạo tài khoản admin
Vào **Authentication → Users → Add user** → nhập **email + mật khẩu** cho admin (đây chính là tài khoản đăng nhập quản trị trên web). Tick "Auto confirm".

## Bước 5 — Cắm khoá vào code
Mở `index.html`, tìm khối `CẤU HÌNH` ở đầu `<script>` và điền:
```js
const SUPABASE_URL='https://abcdxyz.supabase.co';
const SUPABASE_ANON_KEY='eyJ....(anon key)';
```
(Tuỳ chọn email tự động — xem Bước 7.)

## Bước 6 — Đưa lên hosting công khai
Chọn 1 trong 3 (đều miễn phí):

**A. GitHub Pages** — repo → Settings → Pages → Source: `Deploy from a branch` → Branch `main` `/root` → Save. Link: `https://caodanghuong.github.io/Young-Booth-Gallery/`.

**B. Netlify** — netlify.com → Add new site → Import from GitHub → chọn repo → Deploy. (Hoặc kéo-thả thư mục.)

**C. Vercel** — vercel.com → New Project → Import repo → Deploy.

> Sau khi cắm khoá ở Bước 5, nhớ `git add -A && git commit -m "config supabase" && git push` để hosting cập nhật.

## Bước 7 (tuỳ chọn) — Email tự động khi có đơn đặt booth
1. https://www.emailjs.com → tạo **Service** (nối Gmail của bạn) + **Template** (dùng biến `{{name}} {{phone}} {{event_type}} {{guests}} {{budget}} {{date}} {{location}} {{message}} {{to_email}}`).
2. Lấy **Public Key / Service ID / Template ID**, điền vào `index.html`:
```js
const EMAILJS={publicKey:'xxx',serviceId:'service_xxx',templateId:'template_xxx'};
```
Nếu để trống, đơn vẫn **luôn lưu vào Hộp đơn admin**; nút gửi sẽ mở email soạn sẵn (mailto) thay cho gửi tự động.

---

## Xong!
- Khách mở link → xem album, tải ảnh, đánh giá, đặt booth.
- Bạn bấm nút đăng nhập (góc phải header) → email + mật khẩu ở Bước 4 → quản trị: tạo album, upload ảnh, cấu hình liên hệ, xem đơn.
- Đơn/đánh giá lưu ở Supabase (Table Editor) và hiện realtime trên web.

## Sự cố thường gặp
- **Ảnh không tải lên được / bị chặn:** kiểm tra bucket `photos` đã Public và đã chạy storage policies (Bước 2.4).
- **Đăng nhập báo sai:** kiểm tra user đã tạo ở Authentication và đã confirm.
- **Không lưu được album:** đảm bảo đã đăng nhập admin (ghi cần quyền `authenticated`).
- **Trang trắng:** mở Console (F12) xem lỗi; thường do dán sai `SUPABASE_URL`/`anon key`.
