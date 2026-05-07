# 💰 Finance Tracker
Monorepo chứa toàn bộ source code của Finance Tracker SaaS.

> Ứng dụng quản lý tài chính cá nhân với hệ thống 3 gói (Free/Plus/Premium), xây dựng cho thị trường Việt Nam.

- [![Backend CI]](https://github.com/diepAu13122001/finance-tracker-be/blob/main/.github/workflows/ci.yml)
- [![Frontend CI]](https://github.com/diepAu13122001/finance-tracker-fe/blob/main/.github/workflows/ci-frontend.yml)

- 🌐 **Live Demo:** [finance-tracker.vercel.app](https://finance-tracker-fe-rho.vercel.app)
- 📹 **Demo Video:** [YouTube](https://youtu.be/Q93rZEAsXcY)
- 📚 **API Docs:** [Swagger UI](https://finance-tracker-be.up.railway.app/swagger-ui.html)

---

## Cấu Trúc
```
FINANCE-TRACKER/
├── finance-tracker-be/   Backend (Spring Boot)
├── finance-tracker-fe/   Frontend (React)
├── docker-compose.yml    Chạy local với Docker
└── .env                  Environment variables (gitignored)
```

---

## Chạy Toàn Bộ Với Docker

```bash
cp .env.example .env
# Điền values vào .env

docker-compose up --build
# Frontend: http://localhost
# Backend:  http://localhost:8080
# Swagger:  http://localhost:8080/swagger-ui.html
```

---

## Development (Không Dùng Docker)

```bash
# Terminal 1 — Backend
cd finance-tracker-be
./mvnw spring-boot:run

# Terminal 2 — Frontend
cd finance-tracker-fe
npm run dev
```

---

## Chi Tiết Từng Service

- [Backend README](https://github.com/diepAu13122001/finance-tracker-be/blob/main/README.md)
- [Frontend README](https://github.com/diepAu13122001/finance-tracker-fe/blob/main/README.md)

## 👨‍💻 Tác Giả

**Diệp Âu**
[GitHub](https://github.com/diepau13122001) ·
[Email](mailto:diepau1312@gmail.com)
