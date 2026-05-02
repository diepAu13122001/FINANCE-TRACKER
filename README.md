# React + TypeScript + Vite

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

🌐 **Demo:** [finance-tracker.vercel.app](https://finance-tracker-gxdy99t2b-diepau13122001s-projects.vercel.app)  
📹 **Video demo:** [YouTube](https://youtube.com/...)

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react) uses [Babel](https://babeljs.io/) (or [oxc](https://oxc.rs) when used in [rolldown-vite](https://vite.dev/guide/rolldown)) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh

## React Compiler

The React Compiler is not enabled on this template because of its impact on dev & build performances. To add it, see [this documentation](https://react.dev/learn/react-compiler/installation).

## Expanding the ESLint configuration

If you are developing a production application, we recommend updating the configuration to enable type-aware lint rules:

```js
export default defineConfig([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      // Other configs...

      // Remove tseslint.configs.recommended and replace with this
      tseslint.configs.recommendedTypeChecked,
      // Alternatively, use this for stricter rules
      tseslint.configs.strictTypeChecked,
      // Optionally, add this for stylistic rules
      tseslint.configs.stylisticTypeChecked,

      // Other configs...
    ],
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.node.json', './tsconfig.app.json'],
        tsconfigRootDir: import.meta.dirname,
      },
      // other options...
    },
  },
])
```

You can also install [eslint-plugin-react-x](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-x) and [eslint-plugin-react-dom](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-dom) for React-specific lint rules:

```js
// eslint.config.js
import reactX from 'eslint-plugin-react-x'
import reactDom from 'eslint-plugin-react-dom'

export default defineConfig([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      // Other configs...
      // Enable lint rules for React
      reactX.configs['recommended-typescript'],
      // Enable lint rules for React DOM
      reactDom.configs.recommended,
    ],
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.node.json', './tsconfig.app.json'],
        tsconfigRootDir: import.meta.dirname,
      },
      // other options...
    },
  },
])
```
```markdown
users ──────────── user_subscriptions ──── subscription_plans
  │                                               (FREE/PLUS/PREMIUM)
  └──── transactions
  └──── payment_history
```

---

## 🚀 Chạy Local

### Yêu Cầu
- Java 21+
- Node.js 18+
- PostgreSQL 15+

### Backend

```bash
# 1. Clone repo
git clone https://github.com/yourusername/finance-tracker-be

# 2. Tạo database
psql -U postgres -c "CREATE DATABASE finance_tracker;"
psql -U postgres -c "CREATE USER ft_user WITH PASSWORD 'ft_password';"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE finance_tracker TO ft_user;"

# 3. Cấu hình application.yml
cp src/main/resources/application.yml.example src/main/resources/application.yml
# Điền thông tin database và JWT secret

# 4. Chạy — Flyway tự migrate schema
./mvnw spring-boot:run
# API chạy tại http://localhost:8080
```

### Frontend

```bash
# 1. Clone repo
git clone https://github.com/yourusername/finance-tracker-fe

# 2. Cài dependencies
npm install

# 3. Cấu hình env
cp .env.example .env
# VITE_API_URL=http://localhost:8080

# 4. Chạy dev server
npm run dev
# App chạy tại http://localhost:5173
```

---

## 📡 API Endpoints

### Auth
```
POST /api/auth/register   Đăng ký
POST /api/auth/login      Đăng nhập
```

### Transactions
```
GET    /api/transactions              Danh sách (phân trang, filter)
POST   /api/transactions              Tạo mới
PUT    /api/transactions/:id          Cập nhật
DELETE /api/transactions/:id          Xóa
GET    /api/transactions/summary      Tổng hợp theo kỳ
GET    /api/transactions/chart/daily  Biểu đồ ngày
GET    /api/transactions/chart/monthly Biểu đồ tháng
```

### Users
```
GET /api/users/me          Thông tin cá nhân
PUT /api/users/me          Cập nhật hồ sơ
PUT /api/users/me/password Đổi mật khẩu
```

---

## 🔒 Hệ Thống Phân Quyền

```
FREE    → 50 giao dịch/tháng, biểu đồ cơ bản
PLUS    → Không giới hạn, danh mục, AI 20 tin/tháng
PREMIUM → Tất cả Plus + AI không giới hạn + đồ dùng gia đình
```

Backend: `@RequiresPlan("PLUS")` annotation + AOP aspect  
Frontend: `<PlanGate requires="PLUS">` component + `usePlan()` hook

---

## 👨‍💻 Tác Giả

**Diệp Âu** — [GitHub](https://github.com/diepau13122001)
