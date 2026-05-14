# 🗓️ FINANCE TRACKER — REVISED ROADMAP
## Tập Trung Xin Việc Nhanh · Vừa Build Vừa Apply

**Ngày hiện tại:** ~Ngày 73-78 (V2.3 đang làm)  
**Trạng thái:** V2.1 (Categories) ✅ · V2.2 (Goals/Wallets) ✅ · V2.3 (AI + Wallet mở rộng) 🚧

---

## 🚨 Thực Tế Cần Nhìn Thẳng

```
Kế hoạch cũ (requirements.md): 12 tuần × 5h/ngày = 300h
Thực tế của bạn: 1h/ngày × 6 ngày = ~6h/tuần

→ Những gì requirements.md mô tả cần 12 tuần full-time
→ Với pace hiện tại = 50+ tuần (gần 1 năm)
→ Không thể chờ xong hết mới nộp CV

Portfolio HIỆN TẠI (V2.2) đã ĐỦ để apply junior:
✅ Full-stack thực sự (React 18 + Spring Boot 3 + PostgreSQL)
✅ JWT Authentication với plan-based claims
✅ Spring AOP (senior-level thinking)
✅ Database design (6 bảng, FK, indexes, Flyway)
✅ CI/CD tự động (GitHub Actions + Railway + Vercel)
✅ Unit Testing (JUnit 5 + Mockito + Vitest)
✅ Responsive UI (mobile + desktop)
✅ Deployed và live

Nhà tuyển dụng junior KHÔNG đợi bạn làm xong V3.
Họ muốn thấy: bạn có thể code không?
              bạn hiểu cái mình làm không?
              bạn có thể làm việc nhóm không?
```

---

## 📅 Lịch Mới — Song Song: Build + Apply

### 🔴 NGAY BÂY GIỜ (Tuần này + tuần tới)

```
Việc làm NGAY không đợi:
1. Cập nhật CV (3 phiên bản theo file cv_descriptions.md)
2. Tạo/cập nhật LinkedIn với project showcase
3. Nộp CV cho 5 công ty đầu tiên

Không cần app hoàn thiện để nộp CV.
Bạn đã có live demo + GitHub + CI badge.
```

### 🟡 TUẦN 73-78 (Hiện tại — V2.3 Wallet + AI Cơ Bản)

```
Priority: Hoàn thiện những gì đang dang dở
→ Wallet NORMAL/DEBT logic đúng thực tế ✅ (đang làm)
→ WalletSelector required trong AddTransactionModal ✅
→ WalletSummaryWidget trên Dashboard ✅
→ AI Settings (Gemini key input) ✅

SKIP hoặc đẩy về sau:
❌ Voice input (tốn thời gian, ít value cho CV)
❌ AI Chat page (phức tạp, không ảnh hưởng interview)
❌ AI usage counter (over-engineering ở giai đoạn này)
```

### 🟡 TUẦN 79-84 — Transaction Mở Rộng + Export

```
Day 79-80: Thêm TRANSFER transaction type
  → transactions.type: INCOME | EXPENSE | TRANSFER
  → TransactionItem UI: màu vàng cho TRANSFER
  → Filter tab: Tất cả | Chi tiêu | Thu nhập | Chuyển khoản

Day 81-82: Export PDF/Excel
  → Apache POI cho Excel (1-2 file)
  → Chọn date range → download
  → Đây là feature dễ demo trong interview

Day 83-84: Category parent/child cơ bản
  → Thêm parent_category_id (nullable) vào categories
  → 4 parent seed: Sinh hoạt | Phát sinh | Cố định | Đầu tư
  → Free: chỉ dùng parent (không tạo con)
  → Plus: tạo thêm con, max 20 mỗi loại
```

### 🟡 TUẦN 85-90 — Budget + PayOS

```
Day 85-86: Budget per category (đơn giản)
  → Thêm monthly_budget vào categories
  → Warning khi chi > 80%, block khi > 100%
  → UI giống hình ngan_sach.jpg bạn gửi

Day 87-88: PayOS cơ bản
  → Chỉ cần tạo payment link
  → Webhook handler để activate Plus/Premium
  → Không cần full subscription management ngay

Day 89-90: Buffer + Tag v2.3
```

### 🟢 TUẦN 91+ — Sau Khi Có Việc Làm Thêm

```
Làm lúc rảnh, không áp lực deadline:
→ Household Tracker (phức tạp nhất)
→ AI nâng cao (voice input, image)
→ React Native mobile app
→ Microservices architecture (cho học hỏi)
→ AWS EC2 deployment
```

---

## 📋 Thứ Tự Ưu Tiên Khi Apply

### Mục Tiêu Thực Tế

```
Tháng 1-2 sau khi cập nhật CV:
→ Apply 3-5 vị trí/tuần
→ Mục tiêu: 1-2 buổi phỏng vấn/tháng
→ Không cần perfect → cần consistent

Loại công ty phù hợp nhất ngay bây giờ:
✅ Startup 10-50 người (ít quy trình, học nhanh)
✅ Agency/outsourcing (nhiều project, học rộng)
✅ Product company nhỏ-vừa (product sense)

Tránh lúc đầu:
❌ Big tech/bank (quy trình dài, yêu cầu cao)
❌ Công ty chỉ dùng 1 tech (không match stack)
```

### Job Sites Ưu Tiên

```
1. ITViec.com          — nhiều việc HCM, filter tốt
2. TopDev.vn           — chất lượng cao hơn
3. LinkedIn            — network + headhunter
4. Vietnamworks IT     — volume lớn
5. CareerBuilder.vn    — thêm option
```

---

## 🎯 Điều Chỉnh Scope Từ requirements.md

### Giữ Lại (Valuable cho CV)

```
✅ Wallet/Goal system (đang làm)
✅ Category with parent/child
✅ Budget management (đơn giản)
✅ Transaction export Excel/PDF
✅ TRANSFER transaction type
✅ AI cơ bản (Gemini parse text)
✅ PayOS payment (basic flow)
```

### Đẩy Về Sau / Đơn Giản Hóa

```
🔄 Household Tracker → V3, sau khi có việc
🔄 React Native mobile → Sau khi stable web
🔄 Microservices → Quá phức tạp, monolith là đúng
🔄 Redis cache → Premature optimization
🔄 AWS EC2 → Railway đủ tốt cho portfolio
🔄 Testcontainers → JUnit + Mockito đủ cho junior
🔄 85% code coverage → Không thực tế với 1h/ngày
🔄 Voice input → Phức tạp, ít ROI cho interview
```

---

## 💡 Mindset Quan Trọng

```
"Done is better than perfect"

Finance Tracker V2.2 của bạn đã:
→ Phức tạp hơn 90% portfolio của junior candidate khác
→ Có CI/CD (nhiều junior không có)
→ Có unit test (nhiều junior bỏ qua)
→ Có plan gating system (thể hiện tư duy senior-level)
→ Deployed và live (không phải localhost)

Bạn không cần thêm feature để xin được việc.
Bạn cần: nộp đơn, chuẩn bị phỏng vấn, và tự tin.

Khi đã có offer → tiếp tục build → portfolio sẽ càng ngày càng tốt.
```

---

## ✅ Action Items Ngay Hôm Nay

```
□ Cập nhật CV theo 1 trong 3 phiên bản (file cv_descriptions)
□ Cập nhật LinkedIn: thêm Finance Tracker vào Featured
□ Commit code hiện tại với message rõ ràng
□ Tìm 10 công ty phù hợp trên ITViec/TopDev
□ Nộp 3 đơn đầu tiên trong tuần này
```
