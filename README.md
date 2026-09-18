# Young Booth Gallery 📸

Website gallery ảnh sự kiện (kiểu photobooth.vn) cho thương hiệu **Young Booth** — *"Bắt trọn khoảnh khắc"*.

- **Bản chạy (Artifact):** https://claude.ai/artifact/5CpGrUj9ucqXcrZJmEGVfY
- **Mã nguồn:** `index.html` (một file duy nhất)

---

## 1. Công nghệ

- **HTML + CSS + JavaScript thuần** (vanilla, không framework).
- Thư viện ngoài duy nhất: **JSZip** (tải tất cả ảnh dạng .zip) + **Google Fonts** (Baloo 2, Bricolage Grotesque, Figtree, Space Mono).
- **Lưu trữ:** dùng *runtime capabilities* của Claude Artifact — không cần server/DB riêng:
  - `db`  → lưu album, cấu hình, đánh giá, đơn đặt booth.
  - `assets` → lưu file ảnh upload.
  - `user` → nhận biết admin. `downloads` → tải ảnh/zip.

> ⚠️ **Quan trọng:** vì phần lưu trữ là `window.claude.*` của nền tảng Artifact,
> mở trực tiếp `index.html` bằng trình duyệt (file://) sẽ **hiện giao diện nhưng
> KHÔNG lưu/đọc được dữ liệu** (album, đơn, đánh giá). Để chạy đầy đủ, dùng bản
> Artifact ở link trên, hoặc chuyển sang bản có backend (xem mục 5).

---

## 2. Tính năng

**Khách:**
- Trang chủ: lưới album sự kiện + ô tìm kiếm.
- Trang album: ảnh bìa lớn, lưới ảnh (masonry), **lightbox** phóng to (◀ ▶ / phím mũi tên / Esc), **trình chiếu**.
- **Tải 1 ảnh** / **Tải tất cả (.zip)**, **Chia sẻ**.
- **Đánh giá & góp ý**: chấm 1–5 sao + nhận xét cho từng sự kiện.
- **Đặt booth**: form dễ thương (loại sự kiện, số khách, ngân sách, ngày, địa điểm, lời nhắn) + confetti khi gửi.
- Chế độ **sáng / tối**.

**Admin (chủ sở hữu Artifact):**
- Tạo album, **upload ảnh**, đặt ảnh bìa, xóa ảnh/album.
- ⚙️ **Cấu hình liên hệ**: mô tả, email, SĐT, website, địa chỉ, TikTok/Facebook/Instagram/YouTube (hiện ở hero + footer).
- 📥 **Hộp đơn đặt booth** (chuông báo số đơn mới, đánh dấu đã xử lý / xóa).
- 👁 **Xem như Khách** để kiểm tra giao diện khách.

**Hiệu ứng:** tiêu đề "lấy nét" (focus-pull); cụm chữ luân phiên *khoảnh khắc ↔ Young Booth* đổi qua 30 màu; thẻ/ảnh hiện lên mượt. Tôn trọng *prefers-reduced-motion*.

---

## 3. Cấu trúc dữ liệu (để tham chiếu khi làm backend)

Các "collection" trong `db`:

| Đường dẫn | Nội dung |
|---|---|
| `albums/<id>` | `{ title, location, date, coverId, demo, createdAt, photos:[{id, assetId, w, h, at}] }` |
| `settings/site` | `{ about, email, phone, website, address, tiktok, facebook, instagram, youtube }` |
| `reviews/<albumId>_<uid>` | `{ albumId, uid, rating(1-5), name, text, at }` |
| `bookings/<auto>` | `{ name, phone, eventType, guests, budget, date, location, message, at, status }` |

Ảnh gốc lưu ở `assets`, tham chiếu bằng `assetId` (hiển thị qua `/_blob/<assetId>`).

---

## 4. Chỉnh sửa

Mọi thứ nằm trong `index.html`:
- `<style>` ở đầu file: màu thương hiệu (biến `--accent`), bố cục, animation.
- `<script>` cuối file: toàn bộ logic (render, form, đánh giá, đặt booth, đổi chữ...).

Sửa xong, nếu muốn cập nhật bản Artifact thì publish lại file này lên cùng URL.

---

## 5. Nâng cấp lên public (khách ngoài + email tự động)

Giữ nguyên ~90% code này, chỉ thay lớp lưu trữ:

1. **Frontend:** deploy `index.html` lên **Vercel/Netlify** (miễn phí).
2. **Dữ liệu + ảnh:** thay `window.claude.use('db'/'assets')` bằng **Supabase** (Postgres + Storage) hoặc Firebase.
3. **Email tự động:** đơn đặt booth gửi qua **Resend / EmailJS** vào hộp thư của bạn.
4. **Tên miền** riêng (vd `younggallery.vn`).

---

*Made with vanilla HTML/CSS/JS • Young Booth — Bắt trọn khoảnh khắc.*
