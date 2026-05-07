# 💰 Finance Tracker

Ứng dụng quản lý tài chính cá nhân với hệ thống 3 gói (Free/Plus/Premium),
xây dựng cho thị trường Việt Nam.

- [![Backend CI]](https://github.com/diepAu13122001/finance-tracker-be/blob/main/.github/workflows/ci-frontend.yml)
- [![Frontend CI]](https://github.com/diepAu13122001/finance-tracker-fe/blob/main/.github/workflows/ci-frontend.yml)

- 🌐 **Live Demo:** [finance-tracker.vercel.app](https://finance-tracker-fe-rho.vercel.app)
- 📹 **Demo Video:** [YouTube](https://youtu.be/Q93rZEAsXcY)
- 📚 **API Docs:** [Swagger UI](https://finance-tracker-be.up.railway.app/swagger-ui.html)

---

## ✨ Tính Năng V1

| Tính năng        | Free | Plus     | Premium |
| ---------------- | ---- | -------- | ------- |
| Giao dịch/tháng  | 50   | ∞        | ∞       |
| Biểu đồ cơ bản   | ✅   | ✅       | ✅      |
| Filter giao dịch | ✅   | ✅       | ✅      |
| Danh mục         | ❌   | ✅       | ✅      |
| AI Assistant     | ❌   | 20/tháng | ∞       |
| Đồ dùng gia đình | ❌   | ❌       | ✅      |

---

## 🛠 Tech Stack

**Backend:** Spring Boot 3.3 · Java 21 · PostgreSQL 16 · Flyway · Spring Security · JWT

**Frontend:** React 18 · TypeScript · Vite · TailwindCSS · TanStack Query · Zustand · Recharts

**DevOps:** Docker · Railway · Vercel · GitHub Actions

---

## 🏗 Kiến Trúc

```
┌─────────────────┐         ┌──────────────────┐         ┌────────────────┐
│  React Frontend │ ──────> │  Spring Boot API │ ──────> │  PostgreSQL    │
│  (Vercel)       │  HTTPS  │  (Railway)        │  JDBC   │  (Railway)     │
│                 │ <────── │                  │ <────── │                │
└─────────────────┘   JSON  └──────────────────┘         └────────────────┘
```

**Plan Gating:**

- Backend: `@RequiresPlan("PLUS")` annotation + AOP Aspect
- Frontend: `<PlanGate requires="PLUS">` component + `usePlan()` hook

---

## 🚀 Chạy Local

### Yêu Cầu

- Java 21+, Maven 3.9+
- Node.js 20+, npm 10+
- PostgreSQL 15+

### Backend

```bash
git clone https://github.com/diepAu13122001/finance-tracker-be
cd finance-tracker-be

# Tạo database
psql -U postgres -c "CREATE DATABASE finance_tracker;"
psql -U postgres -c "CREATE USER ft_user WITH PASSWORD 'ft_password';"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE finance_tracker TO ft_user;"
psql -U postgres -c "GRANT ALL ON SCHEMA public TO ft_user;"

# Config
cp src/main/resources/application-local.yml.example \
   src/main/resources/application-local.yml

# Chạy (profile local)
./mvnw spring-boot:run -Dspring-boot.run.profiles=local
# → http://localhost:8080/swagger-ui.html
```

### Frontend

```bash
git clone https://github.com/diepAu13122001/finance-tracker-fe
cd finance-tracker-fe
npm install

cp .env.example .env
# VITE_API_URL=http://localhost:8080

npm run dev
# → http://localhost:5173
```

---

## 🧪 Tests

```bash
# Backend
./mvnw test

# Frontend
npm run test:run

# Coverage
npm run coverage
```

---

## 📡 API Endpoints

```
Auth:         POST /api/auth/register · /api/auth/login
Transactions: GET/POST /api/transactions
              PUT/DELETE /api/transactions/:id
              GET /api/transactions/summary
              GET /api/transactions/chart/daily
              GET /api/transactions/chart/monthly
Users:        GET/PUT /api/users/me
              PUT /api/users/me/password
Health:       GET /actuator/health
```

---

## 🔐 Bảo Mật

- JWT RS256, access token 15 phút
- BCrypt password hashing (cost 12)
- Ownership check: user chỉ access data của mình
- Rate limiting qua plan system
- CORS configured cho production domains

---

## 📁 Cấu Trúc Project

```
Backend (Spring Boot):
├── controller/     REST API endpoints
├── service/        Business logic
├── repository/     Database queries (Spring Data JPA)
├── entity/         JPA entities
├── dto/            Request/Response DTOs
├── security/       JWT filter, Security config
├── aspect/         AOP: @RequiresPlan gating
├── exception/      Global exception handler
└── config/         CORS, Swagger, Cache

Frontend (React):
├── components/
│   ├── shared/     Button, Input, Card, PlanGate...
│   ├── layout/     AppLayout, Sidebar, TopBar...
│   ├── transactions/ TransactionList, Modal, Filters...
│   ├── dashboard/  SummaryCards
│   └── charts/     DailyBarChart, MonthlyTrendChart
├── pages/          Dashboard, Expenses, Analytics...
├── hooks/          usePlan, useTransactions, useCharts
├── stores/         authStore (Zustand)
├── services/       API calls (Axios)
└── utils/          formatVND, parseVNDInput...
```

---

## 🗺 Roadmap

- **V1** ✅ Core app + Auth + Transactions + Charts
- **V2** 🚧 AI Features + Categories + Goals + PayOS
- **V3** 📋 Household Tracker + Premium Features

---

## 👨‍💻 Tác Giả

**Diệp Âu**
[GitHub](https://github.com/diepau13122001) ·
[Email](mailto:diepau1312@gmail.com)
