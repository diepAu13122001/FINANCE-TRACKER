# 🗓️ FINANCE TRACKER — 6-MONTH ROADMAP v2
## 3-Tier SaaS · Vietnam Market · 1h/Day · 6 Days/Week

**Schedule:** 1h/day · Mon–Sat · Review week every 4 weeks  
**Stack:** React + TypeScript + Spring Boot 3.3 + Java 21 + Claude AI  
**Goal:** Shipped SaaS product + Dev job in Vietnam 🇻🇳

---

## 📅 SCHEDULE STRUCTURE

```
[Work Week 1] [Work Week 2] [Work Week 3] [Work Week 4] → 🔵 REVIEW WEEK
[Work Week 5] [Work Week 6] [Work Week 7] [Work Week 8] → 🔵 REVIEW WEEK
... repeat for 6 months
```

| Metric | Value |
|--------|-------|
| Work days per cycle | 4 weeks × 6 days = **24 days** |
| Review week | **6 days** — no new features, only reflect + fix + plan |
| Total cycles | **5 cycles** over ~25 weeks |
| Total work sessions | ~**120 sessions** + 5 review weeks |
| Hours invested | ~**150 hours** |

### 🔵 What to do in Review Weeks
- Re-read all the code you wrote
- Fix small bugs and TODOs
- Refactor 1 messy file that bothers you
- Update README
- Write 1 commit message summary of what you built
- Plan next cycle's goals (write them down)
- Take a break — you earned it

---

## 🏗️ MEMBERSHIP ARCHITECTURE — READ THIS FIRST

This is the most important section. Everything in the plan connects back to this.

### The 3 Tiers

| | 🆓 Free | ⭐ Plus | 💎 Premium |
|--|--------|---------|-----------|
| **Price** | Free forever | Free (beta) | **499.000₫ / năm** |
| **Corresponds to** | Version 1 | Version 2 | Version 3 |
| **Auth** | ✅ | ✅ | ✅ |
| **Daily tracking** | ✅ Max 50 tx/month | ✅ Unlimited | ✅ Unlimited |
| **Basic charts** | ✅ | ✅ | ✅ |
| **Categories** | ❌ | ✅ | ✅ |
| **Financial Goals** | ❌ | ✅ | ✅ |
| **AI Voice Input** | ❌ | ✅ | ✅ |
| **AI Assistant** | ❌ | ✅ 20 msgs/month | ✅ Unlimited |
| **Themes** | Light only | ✅ All themes | ✅ All themes |
| **Household Tracker** | ❌ | ❌ | ✅ |
| **AI Classification** | ❌ | ❌ | ✅ |
| **Expiry Notifications** | ❌ | ❌ | ✅ |
| **Product Reviews** | ❌ | ❌ | ✅ |
| **Data Export CSV** | ❌ | ✅ | ✅ |

> **Strategy:** Plus tier is free during launch to grow users. Monetize only Premium (499k/year). Easy to add Plus pricing later if needed. 499k VND/year = ~$20 = very affordable for Vietnamese young professionals — this is intentional.

---

### Database: Subscription Tables

Add these to your **Week 1, Day 5** migration:

```sql
-- Subscription plans (seed data, not user-created)
CREATE TABLE subscription_plans (
  id VARCHAR(20) PRIMARY KEY,   -- 'FREE', 'PLUS', 'PREMIUM'
  name VARCHAR(100) NOT NULL,
  price_vnd BIGINT NOT NULL,    -- 0 for free, 499000 for premium
  billing_cycle VARCHAR(20),    -- 'YEARLY', NULL for free
  features JSONB                -- store feature flags as JSON
);

-- User subscriptions
CREATE TABLE user_subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID UNIQUE REFERENCES users(id) ON DELETE CASCADE,
  plan_id VARCHAR(20) REFERENCES subscription_plans(id),
  status VARCHAR(20) DEFAULT 'ACTIVE',  -- ACTIVE, EXPIRED, CANCELLED
  started_at TIMESTAMP DEFAULT NOW(),
  expires_at TIMESTAMP,                  -- NULL = never (free plan)
  payment_ref VARCHAR(255),              -- PayOS payment reference
  created_at TIMESTAMP DEFAULT NOW()
);

-- Payment history (audit trail)
CREATE TABLE payment_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  plan_id VARCHAR(20) REFERENCES subscription_plans(id),
  amount_vnd BIGINT NOT NULL,
  status VARCHAR(20),           -- PENDING, SUCCESS, FAILED
  payos_order_id VARCHAR(255),
  payos_payment_link_id VARCHAR(255),
  created_at TIMESTAMP DEFAULT NOW(),
  paid_at TIMESTAMP
);

-- Seed the plans
INSERT INTO subscription_plans VALUES
  ('FREE',    'Miễn phí',  0,      NULL,     '{"maxTransactions": 50}'),
  ('PLUS',    'Plus',      0,      'YEARLY', '{"maxTransactions": -1, "aiMessages": 20}'),
  ('PREMIUM', 'Premium',   499000, 'YEARLY', '{"maxTransactions": -1, "aiMessages": -1, "household": true}');
```

---

### Backend: Feature Gating

Create a custom annotation + Spring AOP aspect:

```java
// 1. Custom annotation
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface RequiresPlan {
    String value(); // "PLUS" or "PREMIUM"
}

// 2. Aspect that checks user's plan
@Aspect
@Component
public class PlanGateAspect {
    @Around("@annotation(requiresPlan)")
    public Object checkPlan(ProceedingJoinPoint pjp, RequiresPlan requiresPlan) throws Throwable {
        UUID userId = SecurityUtil.getCurrentUserId();
        String userPlan = subscriptionService.getUserPlan(userId);
        int userLevel = planLevel(userPlan);
        int requiredLevel = planLevel(requiresPlan.value());
        if (userLevel < requiredLevel) {
            throw new PlanUpgradeRequiredException(requiresPlan.value());
        }
        return pjp.proceed();
    }
    private int planLevel(String plan) {
        return switch (plan) { case "PREMIUM" -> 3; case "PLUS" -> 2; default -> 1; };
    }
}

// 3. Usage on any controller method
@PostMapping("/categories")
@RequiresPlan("PLUS")
public ResponseEntity<?> createCategory(...) { ... }

@GetMapping("/household")
@RequiresPlan("PREMIUM")
public ResponseEntity<?> getHouseholdItems(...) { ... }
```

Error response when plan too low:
```json
{
  "error": "PLAN_UPGRADE_REQUIRED",
  "requiredPlan": "PREMIUM",
  "upgradeUrl": "/pricing"
}
```

---

### Frontend: Feature Gating

```typescript
// src/hooks/usePlan.ts
export const usePlan = () => {
  const { user } = useAuthStore()
  const plan = user?.subscription?.planId ?? 'FREE'
  return {
    plan,
    isFree: plan === 'FREE',
    isPlus: plan === 'PLUS' || plan === 'PREMIUM',
    isPremium: plan === 'PREMIUM',
    canUse: (feature: Feature) => PLAN_FEATURES[plan].includes(feature)
  }
}

// src/components/shared/PlanGate.tsx
interface PlanGateProps {
  requires: 'PLUS' | 'PREMIUM'
  children: React.ReactNode
  fallback?: React.ReactNode   // what to show instead (upgrade prompt)
}

export const PlanGate = ({ requires, children, fallback }: PlanGateProps) => {
  const { plan } = usePlan()
  const hasAccess = planLevel(plan) >= planLevel(requires)
  if (hasAccess) return <>{children}</>
  return fallback ? <>{fallback}</> : <UpgradePrompt requiredPlan={requires} />
}

// Usage in any page
<PlanGate requires="PREMIUM">
  <HouseholdPage />
</PlanGate>

// Or on a button
<PlanGate requires="PLUS" fallback={<LockedButton label="AI Voice" />}>
  <VoiceInputButton />
</PlanGate>
```

---

### Upgrade Prompt Component (show when feature is locked)

```
┌─────────────────────────────────────────┐
│  🔒  Tính năng này cần gói Premium      │
│                                         │
│  Mở khóa Household Tracker và nhiều    │
│  tính năng AI nâng cao.                │
│                                         │
│  💎 Premium — 499.000₫ / năm           │
│     (~41.000₫/tháng)                   │
│                                         │
│  [ Nâng cấp ngay ]  [ Xem thêm ]      │
└─────────────────────────────────────────┘
```

---

### Payment: PayOS Integration

**Why PayOS?** Vietnamese payment gateway by VPBank. Supports: MoMo, ZaloPay, VNPay QR, banking apps. Easy API. Free to register. Takes ~1 week to get approved for individual developer accounts.

**Register early:** Go to [payos.vn](https://payos.vn) and register during **Week 1** even though you won't integrate until **Week 16**. Approval can take a few days.

**Payment Flow:**
```
User clicks "Nâng cấp Premium"
        ↓
Frontend → POST /api/subscriptions/create-payment
        ↓
Backend creates PayOS payment link (499.000₫, orderCode = UUID)
        ↓
Frontend redirects user to PayOS hosted payment page
        ↓
User pays via MoMo / ZaloPay / bank transfer
        ↓
PayOS calls your webhook: POST /api/webhooks/payos
        ↓
Backend verifies signature, activates subscription
        ↓
User redirected back to app → sees Premium badge 🎉
```

**Key PayOS API calls (Spring Boot):**
```java
// pom.xml
<dependency>
    <groupId>vn.payos</groupId>
    <artifactId>payos-java</artifactId>
    <version>1.0.1</version>
</dependency>

// PaymentService.java
PayOS payOS = new PayOS(clientId, apiKey, checksumKey);

ItemData item = ItemData.builder()
    .name("Finance Tracker Premium - 1 năm")
    .quantity(1)
    .price(499000)
    .build();

PaymentData paymentData = PaymentData.builder()
    .orderCode(System.currentTimeMillis())
    .amount(499000)
    .description("Premium 1 nam")
    .returnUrl("https://yourapp.com/payment/success")
    .cancelUrl("https://yourapp.com/payment/cancel")
    .items(List.of(item))
    .build();

CheckoutResponseData response = payOS.createPaymentLink(paymentData);
// → response.getCheckoutUrl() = redirect user here
```

---

### Pricing Page (add to frontend)

Simple, clean `/pricing` page with 3 columns:

```
🆓 Miễn phí          ⭐ Plus (Beta)         💎 Premium
─────────────         ──────────────         ──────────────
0₫ / tháng           Miễn phí               499.000₫ / năm
                                             (~41.000₫/tháng)

✅ Đăng nhập          ✅ Tất cả Free         ✅ Tất cả Plus
✅ Thu chi cơ bản     ✅ Phân loại           ✅ Theo dõi đồ dùng
✅ Biểu đồ            ✅ Mục tiêu tiết kiệm  ✅ AI phân loại
⛔ Tối đa 50 giao     ✅ AI nhập giọng nói   ✅ Nhắc nhở hết hạn
   dịch/tháng         ✅ Không giới hạn      ✅ AI không giới hạn
                      ✅ Xuất CSV            ✅ Tổng kết sản phẩm

[Dùng miễn phí]      [Dùng miễn phí]       [Nâng cấp ngay →]
```

---

---

# 📦 VERSION 1 — WEEKS 1–8
## Core App + Membership Foundation

---

## 🗓️ CYCLE 1 — WEEKS 1–4 (24 work days)
### V1: Core Features

---

### WEEK 1 — Setup + Design System

**Day 1 — Frontend Project Init**
- [ ] `npm create vite@latest finance-tracker -- --template react-ts`
- [ ] Install: tailwindcss, shadcn/ui, react-router-dom, lucide-react
- [ ] Folder structure: `pages/`, `components/shared/`, `components/ui/`, `hooks/`, `lib/`, `types/`, `stores/`
- [ ] Push to GitHub (public) → commit: `feat: init project`
- [ ] ⚡ Register on [payos.vn](https://payos.vn) — start approval process now (takes days)

**Day 2 — Design Tokens**
- [ ] `tailwind.config.ts` — custom colors: primary, success, danger, surface, text
- [ ] `src/lib/design-system.ts` — export DS object: `DS.card`, `DS.btnPrimary`, `DS.inputBase`, `DS.heading1`, `DS.label`, `DS.badge`
- [ ] Create `src/types/plans.ts`: `type PlanId = 'FREE' | 'PLUS' | 'PREMIUM'` + feature flag map
- [ ] Commit: `feat: design tokens and plan types`

**Day 3 — Shared Components: Button + Input + Card**
- [ ] `Button.tsx` — variants: primary / ghost / danger / premium (gold gradient for upgrade CTAs)
- [ ] `Input.tsx` — with label, error, helper text
- [ ] `Card.tsx` — variants: default / elevated / locked (shows lock overlay for gated features)
- [ ] Commit: `feat: core shared components`

**Day 4 — Shared Components: PlanGate + UpgradePrompt**
- [ ] `PlanGate.tsx` — wraps children, shows fallback if plan insufficient
- [ ] `UpgradePrompt.tsx` — locked feature prompt with plan name + upgrade button
- [ ] `LockedBadge.tsx` — small `🔒 Plus` or `🔒 Premium` badge shown on locked nav items
- [ ] `usePlan.ts` hook — reads plan from auth store, exposes `isFree`, `isPlus`, `isPremium`, `canUse(feature)`
- [ ] Commit: `feat: plan gating components and hook`

**Day 5 — Backend Init + DB Schema V1 (includes subscriptions)**
- [ ] Create Spring Boot project at [start.spring.io](https://start.spring.io): Web, JPA, Security, PostgreSQL, Validation, Lombok
- [ ] Add Flyway dependency
- [ ] Create `V1__init_schema.sql`:
  - `users` table
  - `transactions` table
  - `subscription_plans` table
  - `user_subscriptions` table
  - `payment_history` table
  - Seed subscription_plans with FREE, PLUS, PREMIUM data
- [ ] Create JPA entities: `User`, `Transaction`, `SubscriptionPlan`, `UserSubscription`
- [ ] Commit: `feat: init backend + full DB schema including subscriptions`

**Day 6 — Week 1 Buffer + DevKit Page**
- [ ] Create `src/pages/DevKit.tsx` — renders all shared components for visual testing
- [ ] Add `/dev` route (only visible in development)
- [ ] Fix any issues from Week 1
- [ ] Commit: `chore: DevKit preview page`

---

### WEEK 2 — Auth (Backend + Frontend)

**Day 7 — JWT + Security Config**
- [ ] `JwtUtil.java`: `generateToken(email, planId)` — embed plan in JWT claims
- [ ] `SecurityConfig.java` — permit `/api/auth/**` and `/api/webhooks/**`, require auth elsewhere
- [ ] `PlanGateAspect.java` — AOP aspect for `@RequiresPlan` annotation
- [ ] `RequiresPlan.java` — custom annotation
- [ ] Commit: `feat: JWT with plan claims + @RequiresPlan AOP`

**Day 8 — Register + Login Endpoints**
- [ ] `AuthService.java`: register → save user → create FREE subscription → return JWT
- [ ] `AuthController.java`: `POST /api/auth/register`, `POST /api/auth/login`
- [ ] On login: include `subscription.planId` in JWT and response
- [ ] `GlobalExceptionHandler.java`: handle `PlanUpgradeRequiredException` → 403 with `PLAN_UPGRADE_REQUIRED`
- [ ] Commit: `feat: auth endpoints + plan in JWT`

**Day 9 — Auth Frontend: Login Page**
- [ ] `LoginPage.tsx` — react-hook-form + zod validation
- [ ] `src/lib/api.ts` — Axios instance with base URL
- [ ] Axios response interceptor: if `error.code === 'PLAN_UPGRADE_REQUIRED'` → redirect to `/pricing`
- [ ] Commit: `feat: login page + axios interceptors`

**Day 10 — Auth Frontend: Register + Auth Store**
- [ ] `RegisterPage.tsx` — reuse Input/Button/Card design system
- [ ] `authStore.ts` (Zustand): `{ user, token, subscription, setAuth(), logout() }`
- [ ] Store `planId` from JWT decode in Zustand + localStorage (token only)
- [ ] `PrivateRoute.tsx` — redirect to `/login` if not auth'd
- [ ] Commit: `feat: register + auth store with plan info`

**Day 11 — Pricing Page**
- [ ] Create `src/pages/PricingPage.tsx` — 3-column layout (Free / Plus / Premium)
- [ ] Mark current plan with "Gói hiện tại ✓" badge
- [ ] Premium card: "Nâng cấp ngay" button → for now just shows "Coming Soon" toast
- [ ] Add link to pricing from navbar
- [ ] Commit: `feat: pricing page with 3 tiers`

**Day 12 — Week 2 Buffer**
- [ ] Review auth flow end-to-end: register → login → JWT includes plan → PlanGate works
- [ ] Write 3 unit tests for `AuthService`
- [ ] Fix any bugs found
- [ ] Commit: `test: AuthService unit tests`

---

### WEEK 3 — Transaction CRUD

**Day 13 — Transaction Backend**
- [ ] `TransactionRepository` — custom queries with date range + user filter
- [ ] `TransactionService` — CRUD with ownership check (user can only touch their own data)
- [ ] `TransactionController` — all endpoints behind JWT auth
- [ ] Add transaction limit check in `TransactionService.create()`:
  ```java
  if (userPlan.equals("FREE") && monthlyCount >= 50) {
      throw new PlanUpgradeRequiredException("PLUS");
  }
  ```
- [ ] Commit: `feat: transaction CRUD + FREE tier 50tx limit`

**Day 14 — Add Transaction Modal**
- [ ] `AddTransactionModal.tsx` — INCOME / EXPENSE toggle, amount in VND, note, date
- [ ] `formatVND` util: `45000 → "45.000 ₫"` using `Intl.NumberFormat('vi-VN')`
- [ ] Show transaction limit warning for Free users: `"47 / 50 giao dịch tháng này"`
- [ ] Commit: `feat: add transaction modal with VND formatting`

**Day 15 — Transaction List**
- [ ] `useTransactions.ts` — TanStack Query hook
- [ ] `TransactionList.tsx` — grouped by date, income green / expense red
- [ ] Delete with confirmation dialog
- [ ] Commit: `feat: transaction list with delete`

**Day 16 — Dashboard Layout (Responsive)**
- [ ] `DashboardPage.tsx` — sidebar layout on desktop, bottom nav on mobile
- [ ] `Sidebar.tsx` — nav items with `LockedBadge` on Plus/Premium features
- [ ] `TopBar.tsx` — shows plan badge (Free / Plus / 💎 Premium)
- [ ] Responsive: single column mobile, 2-col desktop
- [ ] Commit: `feat: responsive dashboard + plan badge in nav`

**Day 17 — Summary Cards + Transaction History**
- [ ] `SummaryCard.tsx` — income / expense / balance this month
- [ ] `TransactionsPage.tsx` — full history with date range filter
- [ ] Edit transaction (reuse Add modal with pre-filled data)
- [ ] Commit: `feat: summary cards + transaction history page`

**Day 18 — Week 3 Buffer**
- [ ] Test the 50 transaction limit in the UI
- [ ] Verify UpgradePrompt shows correctly when limit hit
- [ ] Fix mobile layout issues found in testing
- [ ] Commit: `fix: transaction limit UX improvements`

---

### WEEK 4 — Charts + Settings

**Day 19 — Daily Bar Chart**
- [ ] `DailyBarChart.tsx` — recharts BarChart, last 7/30 days, income vs expense
- [ ] Short VND format on Y-axis: `45k`, `1.2M`
- [ ] Custom tooltip with full VND amount
- [ ] Commit: `feat: daily income vs expense bar chart`

**Day 20 — Monthly Trend Line Chart**
- [ ] `MonthlyTrendChart.tsx` — recharts LineChart, Jan–Dec
- [ ] Period selector: `Tuần này / Tháng này / Năm nay`
- [ ] Commit: `feat: monthly trend chart with period selector`

**Day 21 — Settings Page (Basic)**
- [ ] `SettingsPage.tsx` — tabs: Profile / Subscription
- [ ] Profile tab: edit name, change password
- [ ] Subscription tab: shows current plan + expiry (if premium) + upgrade CTA
- [ ] "Xem gói" → links to `/pricing`
- [ ] Commit: `feat: settings page with subscription info`

**Day 22 — Error Handling + Toast Notifications**
- [ ] `react-hot-toast` setup with global `<Toaster />`
- [ ] Success/error toasts for all actions
- [ ] When API returns `PLAN_UPGRADE_REQUIRED` → show upgrade toast with link to pricing
- [ ] 401 → auto logout + toast "Phiên đăng nhập đã hết hạn"
- [ ] Commit: `feat: toast notifications + plan upgrade error handling`

**Day 23 — Vietnamese UX Polish**
- [ ] All labels, placeholders, error messages in Vietnamese
- [ ] `formatVND` applied everywhere consistently
- [ ] Date format: `dd/MM/yyyy` (Vietnamese standard)
- [ ] Number input: allow typing `45000` or `45.000` (strip dots on parse)
- [ ] Commit: `feat: full Vietnamese localization`

**Day 24 — Week 4 Buffer + Commit Cleanup**
- [ ] Run through complete user journey: register → add transactions → see charts → hit 50 limit → see upgrade prompt
- [ ] Fix any bugs
- [ ] Ensure all files have consistent naming
- [ ] Commit: `fix: V1 flow bug fixes`

---

## 🔵 REVIEW WEEK 1 (Week 5)

No new features. 1 hour per day:
- **Day 25**: Re-read all backend code. Note 3 things to improve.
- **Day 26**: Re-read all frontend code. Note 3 things to improve.
- **Day 27**: Fix the 3 backend improvements.
- **Day 28**: Fix the 3 frontend improvements.
- **Day 29**: Update README — add schema diagram, tech stack, local setup guide.
- **Day 30**: Write down your V2 goals. Look at job postings — does anything change your priorities?

---

## 🗓️ CYCLE 2 — WEEKS 6–9 (24 work days)
### V1: Polish + Docker + Deploy

---

### WEEK 6 — Docker + Deploy V1

**Day 31 — Dockerfile + docker-compose**
- [ ] `Dockerfile` for Spring Boot (multi-stage build with Java 21)
- [ ] `docker-compose.yml` — backend + PostgreSQL for local dev
- [ ] `.env.example` with all required env vars including `PAYOS_CLIENT_ID`, `PAYOS_API_KEY`, `PAYOS_CHECKSUM_KEY` (placeholders for now)
- [ ] Commit: `feat: Docker + docker-compose`

**Day 32 — Environment Config**
- [ ] `application-local.yml` (gitignored), `application-prod.yml`
- [ ] Frontend `.env` with `VITE_API_URL`, `.env.example` committed
- [ ] CORS config to allow Vercel frontend URL
- [ ] Commit: `feat: environment config separation`

**Day 33 — Deploy Frontend (Vercel)**
- [ ] Push to GitHub → connect to Vercel
- [ ] Set `VITE_API_URL` env var
- [ ] Deploy → verify live URL works
- [ ] Commit: `chore: vercel config`

**Day 34 — Deploy Backend (Railway)**
- [ ] New Railway project → add PostgreSQL service
- [ ] Connect GitHub repo → set env vars
- [ ] Run Flyway migrations (auto on startup)
- [ ] Update Vercel `VITE_API_URL` to Railway URL
- [ ] Test end-to-end on live URL
- [ ] Commit: `chore: Railway deployment config`

**Day 35 — GitHub Actions CI**
- [ ] `.github/workflows/ci.yml` — run backend tests + frontend build on every push
- [ ] Verify green checkmarks on GitHub
- [ ] Commit: `ci: GitHub Actions CI pipeline`

**Day 36 — Week 6 Buffer**
- [ ] Test complete flow on live deployment
- [ ] Fix any production-specific bugs
- [ ] Share live URL with 1 friend to test
- [ ] Commit: `fix: production bugs from live testing`

---

### WEEK 7 — UI Polish + Swagger + Tests

**Day 37 — Empty States + Skeleton Loaders**
- [ ] `Skeleton.tsx` for transaction list and charts
- [ ] `EmptyState.tsx` for no transactions: "Chưa có giao dịch nào. Thêm ngay! 👆"
- [ ] Commit: `feat: skeleton loaders and empty states`

**Day 38 — Mobile Responsiveness Audit**
- [ ] DevTools: simulate iPhone SE (375px), iPad (768px)
- [ ] Fix overflow, font sizes, tap targets (min 44px)
- [ ] Test Add Transaction modal on mobile
- [ ] Commit: `fix: mobile responsiveness`

**Day 39 — Swagger API Docs**
- [ ] Add `springdoc-openapi-starter-webmvc-ui` to pom.xml
- [ ] `@Operation` annotations on all controllers
- [ ] Verify Swagger UI at `/swagger-ui.html`
- [ ] Commit: `docs: OpenAPI/Swagger`

**Day 40 — Unit Tests: AuthService + SubscriptionService**
- [ ] `AuthServiceTest.java` — 5 tests (register success, email taken, login success, wrong password, new user gets FREE plan)
- [ ] `SubscriptionServiceTest.java` — 3 tests (getUserPlan, checkTransactionLimit_free, checkTransactionLimit_plus)
- [ ] Commit: `test: AuthService + SubscriptionService tests`

**Day 41 — Frontend Tests (Vitest)**
- [ ] `format.test.ts` — formatVND, formatShortVND
- [ ] `usePlan.test.ts` — canUse feature returns correct result per plan
- [ ] `PlanGate.test.tsx` — renders children or fallback correctly
- [ ] Commit: `test: format utils + plan gating tests`

**Day 42 — Week 7 Buffer**
- [ ] Fix any test failures
- [ ] Review test coverage
- [ ] Commit: `fix: test improvements`

---

### WEEK 8 — V1 Demo + LinkedIn + Job Research

**Day 43 — Performance: DB Indexes + Pagination**
- [ ] Add index: `idx_transactions_user_date ON transactions(user_id, transaction_date)`
- [ ] Add index: `idx_user_subscriptions_user ON user_subscriptions(user_id)`
- [ ] Add `Pageable` to transaction list endpoint (20 per page)
- [ ] Commit: `perf: DB indexes + pagination`

**Day 44 — Animations + Micro-interactions**
- [ ] Add `tailwindcss-animate`
- [ ] Fade-in on dashboard cards
- [ ] Smooth modal transitions
- [ ] Commit: `ui: animations`

**Day 45 — V1 Demo Video**
- [ ] Record 3-min Loom/OBS:
  - 0:00 Register new account
  - 0:30 Add income + expenses
  - 1:00 See charts update
  - 1:30 Hit 50 transaction limit → see upgrade prompt → pricing page
  - 2:00 Show responsive mobile view
  - 2:30 Code highlights: JWT, plan gating, design system
- [ ] Upload YouTube (unlisted) → add to README
- [ ] Commit: `docs: demo video link in README`

**Day 46 — LinkedIn Post + Job Research**
- [ ] LinkedIn: "Tôi vừa ship Version 1 của Finance Tracker SaaS..." + screenshot + live link
- [ ] Research 10 companies in HCM/Hanoi hiring React or Spring Boot
- [ ] Note down which companies want: TypeScript? Docker? AWS? Testing?
- [ ] Adjust V2/V3 priorities based on job market research

**Day 47 — README V1 Final**
- [ ] Full README: overview, features, architecture diagram (use Excalidraw), tech stack, local setup, live demo link
- [ ] Commit: `docs: complete README v1`

**Day 48 — Week 8 Buffer**
- [ ] Final V1 bug fixes
- [ ] Verify live deployment is stable
- [ ] Commit: `fix: V1 final polish`

---

## 🔵 REVIEW WEEK 2 (Week 9)

- **Day 49**: Re-read the membership/plan gating code. Is it clean? Refactor if not.
- **Day 50**: Look at your Pricing page. Show it to 2–3 friends. Get feedback.
- **Day 51**: Check Railway logs for any errors in production.
- **Day 52**: Update README with any missing info.
- **Day 53**: List all V2 features — estimate which ones are most important for job interviews.
- **Day 54**: Rest.

---

---

# 🚀 VERSION 2 — WEEKS 10–17
## Smart Features: Categories + Goals + AI + Themes

---

## 🗓️ CYCLE 3 — WEEKS 10–13 (24 work days)

---

### WEEK 10 — Categories System (Plus Feature)

**Day 55 — Categories: Backend**
- [ ] `V2__categories.sql` Flyway migration: `categories` table with `user_id`, `name`, `icon`, `color`, `type`
- [ ] Seed default VN categories: `🍜 Ăn uống`, `🚗 Di chuyển`, `🏠 Nhà ở`, `💊 Sức khỏe`, `🎮 Giải trí`, `💰 Lương`, `📦 Mua sắm`
- [ ] `CategoryService` + `CategoryController` with `@RequiresPlan("PLUS")`
- [ ] Add `category_id` FK to `transactions` table (nullable)
- [ ] Commit: `feat: categories backend [Plus]`

**Day 56 — Categories: Frontend**
- [ ] `CategoriesPage.tsx` — list, add, edit, delete custom categories
- [ ] Wrap entire page: `<PlanGate requires="PLUS"><CategoriesPage /></PlanGate>`
- [ ] Add category color picker (6 preset colors)
- [ ] Add category icon selector (12 emojis to pick)
- [ ] Commit: `feat: categories management page [Plus]`

**Day 57 — Category Selector in Transaction Modal**
- [ ] Update `AddTransactionModal` — category dropdown (only if Plus/Premium)
- [ ] For Free users: show category field with lock overlay + "Upgrade to Plus" tooltip
- [ ] Show category icon + colored badge in transaction list
- [ ] Commit: `feat: category in transactions + Free tier gating`

**Day 58 — Category Pie Chart**
- [ ] `CategoryPieChart.tsx` — recharts PieChart, expense by category this month
- [ ] Add to Dashboard as new card
- [ ] Wrap with `<PlanGate requires="PLUS">` — show blurred placeholder for Free users
- [ ] Commit: `feat: category pie chart [Plus]`

**Day 59 — Financial Goals: Backend**
- [ ] `V3__goals.sql`: `savings_goals` table (title, target, current, deadline)
- [ ] Goals CRUD API with `@RequiresPlan("PLUS")`
- [ ] `POST /api/goals/:id/deposit` endpoint
- [ ] Calculate: months to goal at current savings rate
- [ ] Commit: `feat: savings goals API [Plus]`

**Day 60 — Week 10 Buffer**
- [ ] Test the full Plus feature flow
- [ ] Verify PlanGate fallback shows correctly for Free users
- [ ] Commit: `fix: Plus feature gating review`

---

### WEEK 11 — Goals + Budgets + Account Page

**Day 61 — Financial Goals: Frontend**
- [ ] `GoalsPage.tsx` — progress bars, add goal modal, deposit action
- [ ] "Freedom Number" section: months to financial independence at current rate
- [ ] Wrap with `<PlanGate requires="PLUS">`
- [ ] Commit: `feat: goals page with freedom planner [Plus]`

**Day 62 — Budget System**
- [ ] `V4__budgets.sql`: `budgets` table (user_id, category_id, amount, month)
- [ ] Budget CRUD API `@RequiresPlan("PLUS")`
- [ ] Dashboard: budget progress bars `🍜 Ăn uống: 850k / 1.500k (57%)`
- [ ] Red highlight when > 90% used
- [ ] Commit: `feat: monthly budget tracking [Plus]`

**Day 63 — Theme System: Dark Mode**
- [ ] `darkMode: 'class'` in Tailwind config
- [ ] `dark:` variants on all components
- [ ] Theme toggle in TopBar
- [ ] Store preference in `user_preferences` table (new Flyway migration)
- [ ] Dark mode: Plus feature only (wrap toggle with PlanGate)
- [ ] Commit: `feat: dark mode [Plus]`

**Day 64 — Custom Accent Colors**
- [ ] 6 accent color options via CSS variables
- [ ] Accent color stored in `user_preferences`
- [ ] Settings → Appearance tab: theme + accent picker
- [ ] Wrap accent colors with `<PlanGate requires="PLUS">`
- [ ] Commit: `feat: custom accent colors [Plus]`

**Day 65 — Enhanced Settings + Data Export**
- [ ] `SettingsPage.tsx` rebuilt with tabs: Profile / Appearance / Subscription / Danger Zone
- [ ] Subscription tab: plan details, next renewal date, cancel link (placeholder)
- [ ] `GET /api/users/me/export-csv` → returns all transactions as CSV `@RequiresPlan("PLUS")`
- [ ] Commit: `feat: enhanced settings + CSV export [Plus]`

**Day 66 — Week 11 Buffer**
- [ ] Review all Plus features end-to-end
- [ ] Verify Free users see correct upgrade prompts (not errors)
- [ ] Commit: `fix: Plus tier UX review`

---

### WEEK 12 — Analytics + AI Setup

**Day 67 — Analytics Page**
- [ ] `AnalyticsPage.tsx` — period selector, trend chart, top categories bar chart, savings rate
- [ ] Month-over-month comparison: "Chi tiêu tháng này cao hơn 12% so với tháng trước"
- [ ] `@RequiresPlan("PLUS")` on the analytics endpoint
- [ ] Commit: `feat: analytics page [Plus]`

**Day 68 — Claude API Setup (Backend)**
- [ ] Add `anthropic-sdk-java` to pom.xml
- [ ] `AiService.java` with `parseExpenseFromText(String text)`:
  ```java
  // Returns: { amount: 45000, category: "Ăn uống", note: "Phở" }
  ```
- [ ] `@RequiresPlan("PLUS")` on all AI endpoints
- [ ] Commit: `feat: Claude API integration`

**Day 69 — AI: Parse Expense from Text**
- [ ] `POST /api/ai/parse-expense` — takes Vietnamese text, returns structured data
- [ ] Test: `"Tôi vừa ăn phở 45 nghìn ở quán gần nhà"` → `{amount: 45000, category: "Ăn uống", note: "Phở"}`
- [ ] Add rate limiting for Plus users (20 AI calls/month), unlimited for Premium
- [ ] Commit: `feat: AI expense parsing endpoint [Plus]`

**Day 70 — AI Voice Input (Frontend)**
- [ ] `useVoiceInput.ts` hook — browser Web Speech API, `lang: 'vi-VN'`
- [ ] Mic button in `AddTransactionModal`
- [ ] Voice transcript → sent to `/api/ai/parse-expense` → auto-fill form fields
- [ ] Wrap mic button with `<PlanGate requires="PLUS">`
- [ ] Commit: `feat: AI voice input [Plus]`

**Day 71 — AI Usage Counter**
- [ ] `ai_usage` table tracking calls per user per month
- [ ] Backend returns `{ remaining: 15, limit: 20 }` in AI endpoint response
- [ ] Frontend: show "15 / 20 AI calls remaining this month" in Settings
- [ ] Plus users: counter shown, Premium users: "Không giới hạn"
- [ ] Commit: `feat: AI usage tracking and limits`

**Day 72 — Week 12 Buffer**
- [ ] Test AI voice flow end to end
- [ ] Verify usage counter increments correctly
- [ ] Commit: `fix: AI feature review`

---

### WEEK 13 — AI Assistant + Smart Categorization

**Day 73 — AI Financial Assistant: Backend**
- [ ] `POST /api/ai/chat` — builds context from last 30 days of user transactions, calls Claude
- [ ] System prompt includes user's transaction summary in Vietnamese
- [ ] Saves chat history to `ai_chat_history` table
- [ ] Commit: `feat: AI assistant backend [Plus/Premium]`

**Day 74 — AI Assistant: Chat UI**
- [ ] `AiAssistantPage.tsx` — chat bubbles, input bar, typing indicator
- [ ] Sample questions shown as chips:
  - "Tháng này tôi tiêu nhiều nhất cho gì?"
  - "Tôi có thể tiết kiệm thêm bao nhiêu?"
  - "Phân tích chi tiêu của tôi"
- [ ] Show usage counter for Plus users
- [ ] Wrap with `<PlanGate requires="PLUS">`
- [ ] Commit: `feat: AI assistant chat UI [Plus]`

**Day 75 — AI Smart Category Suggestion**
- [ ] `POST /api/ai/suggest-category` — input note → output suggested category
- [ ] In `AddTransactionModal`: show suggestion chip "AI gợi ý: 🍜 Ăn uống" after user types note
- [ ] Accept/dismiss interaction
- [ ] Commit: `feat: AI auto-categorization suggestion`

**Day 76 — AI Weekly Summary Card**
- [ ] `GET /api/ai/weekly-summary` — generates Vietnamese weekly insight using Claude
- [ ] Cache result (don't regenerate on every load — use DB with TTL check)
- [ ] Dashboard card: "AI Insights" with weekly summary text
- [ ] Wrap with `<PlanGate requires="PLUS">`
- [ ] Commit: `feat: AI weekly summary card [Plus]`

**Day 77 — V2 Mobile Responsiveness Audit**
- [ ] Test all new V2 pages on 375px
- [ ] Fix any overflow or layout issues
- [ ] Ensure chat UI is usable on mobile
- [ ] Commit: `fix: V2 mobile responsiveness`

**Day 78 — Week 13 Buffer**
- [ ] Full V2 feature walkthrough
- [ ] Verify all PlanGate boundaries are correct
- [ ] Commit: `fix: V2 plan gating review`

---

## 🔵 REVIEW WEEK 3 (Week 14)

- **Day 79**: List every AI call your app makes. Check Claude API pricing — estimate your monthly cost at 100 users.
- **Day 80**: Re-read PlanGate logic in both backend and frontend. Is it consistent?
- **Day 81**: Review AI prompt quality — test 10 different Vietnamese expense phrases.
- **Day 82**: Look at your Subscription tab in Settings — is it clear to a user what their plan includes?
- **Day 83**: Update README with V2 features + new screenshots.
- **Day 84**: Post LinkedIn update: "Added AI features to my Finance Tracker..."

---

## 🗓️ CYCLE 4 — WEEKS 15–18 (24 work days)
### V2: Payment Integration + AWS Deploy

---

### WEEK 15 — PayOS Payment Integration

**Day 85 — PayOS: Backend Setup**
- [ ] Add `payos-java` dependency to pom.xml
- [ ] `PaymentService.java`:
  - `createPaymentLink(UUID userId)` → returns PayOS checkout URL
  - Stores `PENDING` record in `payment_history`
- [ ] `POST /api/subscriptions/create-payment` endpoint
- [ ] Commit: `feat: PayOS payment service + create payment endpoint`

**Day 86 — PayOS: Webhook Handler**
- [ ] `POST /api/webhooks/payos` — receives PayOS confirmation
- [ ] Verify PayOS signature (checksumKey)
- [ ] On SUCCESS: activate PREMIUM subscription for 1 year, update `payment_history`
- [ ] Return `{ "code": "00", "desc": "success" }` to PayOS
- [ ] Commit: `feat: PayOS webhook handler + subscription activation`

**Day 87 — PayOS: Frontend Flow**
- [ ] `UpgradeButton.tsx` — calls `POST /api/subscriptions/create-payment` → redirects to PayOS URL
- [ ] Payment success page: `src/pages/PaymentSuccessPage.tsx` — "Nâng cấp thành công! 🎉"
- [ ] Payment cancel page: `src/pages/PaymentCancelPage.tsx` — "Thanh toán bị hủy"
- [ ] After success: refresh auth token (now includes PREMIUM plan)
- [ ] Commit: `feat: payment flow frontend`

**Day 88 — Payment Testing (Sandbox)**
- [ ] PayOS has a sandbox mode — test full payment flow
- [ ] Test: create payment → pay in sandbox → webhook fires → subscription activated → app shows Premium
- [ ] Test: cancel flow → subscription stays as is
- [ ] Commit: `test: payment flow integration test`

**Day 89 — Subscription Management**
- [ ] Subscription tab in Settings: shows plan, renewal date, payment history list
- [ ] `GET /api/subscriptions/me` — returns current plan details + payment history
- [ ] Show "Hết hạn: 15/03/2027" for Premium users
- [ ] Add "Renew" button (shown 30 days before expiry)
- [ ] Commit: `feat: subscription management UI`

**Day 90 — Expiry Check + Auto-downgrade**
- [ ] Spring `@Scheduled` job (runs daily at midnight):
  - Find subscriptions where `expires_at < NOW()`
  - Set status = `EXPIRED`, downgrade user to FREE
- [ ] When downgraded: user's data stays, but Plus/Premium features are locked again
- [ ] Send in-app notification: "Gói Premium của bạn đã hết hạn"
- [ ] Commit: `feat: subscription expiry check + auto-downgrade`

---

### WEEK 16 — AWS Deploy + CI/CD

**Day 91 — AWS EC2 Setup**
- [ ] Launch EC2 t3.micro (or t4g.micro — cheaper ARM instance)
- [ ] Security groups: 22 (SSH from your IP only), 80, 443 (public)
- [ ] Install Docker + Docker Compose on EC2
- [ ] Commit: `chore: AWS EC2 initial config notes in README`

**Day 92 — Nginx + SSL (Cloudflare)**
- [ ] `nginx.conf` reverse proxy: port 80 → Spring Boot :8080
- [ ] Point domain (or subdomain) to EC2 IP in Cloudflare DNS
- [ ] Enable Cloudflare SSL (Full mode)
- [ ] Test HTTPS works
- [ ] Commit: `chore: Nginx + Cloudflare SSL config`

**Day 93 — GitHub Actions: CD to EC2**
- [ ] `.github/workflows/deploy.yml`:
  - On push to `main`: SSH to EC2 → `docker-compose pull && docker-compose up -d`
  - Use GitHub Secrets for EC2 SSH key, host, env vars
- [ ] Test auto-deploy
- [ ] Commit: `ci: CD pipeline to AWS EC2`

**Day 94 — Update Vercel → AWS Backend**
- [ ] Update `VITE_API_URL` in Vercel to AWS backend URL
- [ ] Update PayOS webhook URL in PayOS dashboard to AWS URL
- [ ] Test full flow on production
- [ ] Commit: `chore: production URL updates`

**Day 95 — CloudWatch Monitoring**
- [ ] Enable CloudWatch basic metrics: CPU, RAM, disk
- [ ] Add Spring Boot Actuator (`/actuator/health`) for health checks
- [ ] Set up alert: email if CPU > 80% for 5 minutes
- [ ] Commit: `chore: monitoring setup`

**Day 96 — Week 16 Buffer**
- [ ] Full production test: register → pay → get Premium → use Premium features
- [ ] Fix any production issues
- [ ] Commit: `fix: production integration review`

---

### WEEK 17 — V2 Tests + Documentation

**Day 97 — Integration Tests: Payment Flow**
- [ ] Mock PayOS SDK in tests
- [ ] `PaymentServiceTest.java`: create payment link, handle webhook success, handle webhook failure
- [ ] `SubscriptionServiceTest.java`: activate, expire, downgrade
- [ ] Commit: `test: payment + subscription integration tests`

**Day 98 — Integration Tests: AI Features**
- [ ] Mock Claude API responses in tests
- [ ] Test expense parsing with Vietnamese phrases
- [ ] Test usage limit enforcement
- [ ] Commit: `test: AI feature tests with mocked Claude API`

**Day 99 — V2 Demo Video**
- [ ] Record 4-min video:
  - 0:00 Show V1 (Free tier, transaction limit hit)
  - 0:45 Upgrade to Premium — PayOS payment flow
  - 1:30 Unlock categories, goals, themes
  - 2:15 AI voice input demo (speak in Vietnamese)
  - 3:00 AI assistant chat
  - 3:30 AWS deployment highlight
- [ ] Upload YouTube → update README
- [ ] Commit: `docs: V2 demo video`

**Day 100 — Viblo.asia Blog Post Draft**
- [ ] Start writing: "Xây dựng Finance Tracker SaaS với React + Spring Boot + AI"
  - Why you built it
  - Architecture decisions
  - Payment integration in Vietnam (PayOS)
  - AI integration challenges
- [ ] Save draft (don't publish yet — publish with V3 complete)
- [ ] Commit: `docs: blog post draft`

**Day 101 — LinkedIn Post V2 + Job Applications**
- [ ] LinkedIn: "V2 is live! Added AI voice input + premium subscription..."
- [ ] Apply to 5 companies from your Week 8 research list
- [ ] Customize each application to highlight relevant features

**Day 102 — Week 17 Buffer**
- [ ] Bug fixes from any user feedback (if any friends tested it)
- [ ] Commit: `fix: V2 post-launch fixes`

---

### WEEK 18 — V2 Final Polish

**Day 103–108** (6 days)

- **Day 103**: UX audit — can a new Vietnamese user understand all 3 tiers without explanation?
- **Day 104**: Improve Pricing page copy — A/B test: "499k/năm" vs "chỉ 41k/tháng"
- **Day 105**: Add "Renew" email reminder logic (or in-app only is fine for now)
- **Day 106**: Refactor: extract all plan-related business logic into `PlanService.java`
- **Day 107**: Code review day — read ALL backend code, leave TODO comments for refactors
- **Day 108**: Code review day — read ALL frontend code, same exercise

---

## 🔵 REVIEW WEEK 4 (Week 19)

- **Day 109**: Check AWS cost dashboard. Is it under $25? Optimize if not.
- **Day 110**: Look at PayOS sandbox transactions. Any issues?
- **Day 111**: Ask 3 friends to test the full payment flow. Note their confusion points.
- **Day 112**: Revise the 3 UX pain points from friend testing.
- **Day 113**: Update README with final V2 state.
- **Day 114**: Rest and plan V3.

---

---

# 🏠 VERSION 3 — WEEKS 20–23
## Full App: Household Tracker + AI Classification (Premium Only)

---

## 🗓️ CYCLE 5 — WEEKS 20–23 (24 work days)

---

### WEEK 20 — Household Tracker Foundation

**Day 115 — Household: DB Schema**
- [ ] `V5__household.sql`:
  ```sql
  CREATE TABLE household_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    brand VARCHAR(100),
    category VARCHAR(50) NOT NULL,  -- SKINCARE/HOUSECARE/FOOD/CLOTHES/OTHER
    ai_category VARCHAR(50),        -- AI-suggested category
    price BIGINT,
    purchase_date DATE,
    expiry_date DATE,
    quantity DECIMAL(10,2),
    unit VARCHAR(20),               -- 'ml', 'g', 'gói', 'cái', etc.
    status VARCHAR(20) DEFAULT 'IN_USE',   -- IN_USE/FINISHED/NEED_RESTOCK
    notify_before_days INT DEFAULT 7,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
  );

  CREATE TABLE item_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    item_id UUID REFERENCES household_items(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id),
    rating SMALLINT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    would_buy_again BOOLEAN,
    reviewed_at TIMESTAMP DEFAULT NOW()
  );

  CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL,  -- ITEM_EXPIRING, ITEM_RESTOCK, SUBSCRIPTION_EXPIRING
    title VARCHAR(200),
    message TEXT,
    related_id UUID,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
  );
  ```
- [ ] Commit: `feat: household items + reviews + notifications schema`

**Day 116 — Household CRUD API**
- [ ] `HouseholdItemRepository`, `HouseholdItemService`, `HouseholdItemController`
- [ ] All endpoints: `@RequiresPlan("PREMIUM")`
- [ ] CRUD: add, edit, delete, list (filterable by category, status)
- [ ] Commit: `feat: household CRUD API [Premium]`

**Day 117 — Household List Page**
- [ ] `HouseholdPage.tsx` — items grouped by category (Skincare / Nhà cửa / Thực phẩm / Quần áo)
- [ ] Wrap with `<PlanGate requires="PREMIUM">`
- [ ] Status badges: IN_USE 🟢 / NEED_RESTOCK 🟡 / FINISHED ⚫
- [ ] Filter tabs: All / In Use / Need Restock
- [ ] Commit: `feat: household items list page [Premium]`

**Day 118 — Add Item Form**
- [ ] `AddItemModal.tsx` — name, brand, category, price, purchase date, expiry date, quantity, unit
- [ ] Expiry date: highlight in red if within 7 days
- [ ] Commit: `feat: add household item modal`

**Day 119 — Item Detail Page**
- [ ] `ItemDetailPage.tsx` — full item info, status timeline, notes editor
- [ ] Mark as Finished button → status = FINISHED → prompt for review
- [ ] Mark as Need Restock button
- [ ] Edit / Delete actions
- [ ] Commit: `feat: item detail page`

**Day 120 — Week 20 Buffer**
- [ ] Test household flow end to end (add item, view, update status)
- [ ] Verify Premium gating works
- [ ] Commit: `fix: household V3 review`

---

### WEEK 21 — AI Classification + Reviews

**Day 121 — AI Auto-Classify Category**
- [ ] `POST /api/ai/classify-item` — input: item name + brand → output: category + subcategory
- [ ] Examples:
  - `"Sữa rửa mặt La Roche-Posay Effaclar"` → `{ category: "SKINCARE", subcategory: "Skincare - Làm sạch" }`
  - `"Nước tẩy rửa Vim chanh"` → `{ category: "HOUSECARE", subcategory: "Vệ sinh nhà" }`
  - `"Gạo ST25 5kg"` → `{ category: "FOOD" }`
- [ ] In Add Item modal: AI suggests category as user types name
- [ ] Commit: `feat: AI item classification [Premium]`

**Day 122 — Notification System**
- [ ] `NotificationService.java` — `createNotification(userId, type, title, message, relatedId)`
- [ ] `NotificationController` — `GET /api/notifications` (paginated), `PUT /api/notifications/:id/read`
- [ ] Notification bell in TopBar — shows unread count badge
- [ ] `NotificationsPage.tsx` — notification list, click to navigate to item
- [ ] Commit: `feat: in-app notification system`

**Day 123 — Expiry Scheduler**
- [ ] Spring `@Scheduled(cron = "0 0 8 * * *")` — runs daily at 8am
- [ ] Find items where `expiry_date BETWEEN NOW() AND NOW() + notify_before_days`
- [ ] Create `ITEM_EXPIRING` notification for each
- [ ] Also create `SUBSCRIPTION_EXPIRING` for Premium users within 30 days of expiry
- [ ] Commit: `feat: scheduled expiry notifications`

**Day 124 — Post-use Review Prompt**
- [ ] When user marks item as FINISHED: show `ReviewModal.tsx`
  - Star rating (1–5)
  - Short review text
  - "Sẽ mua lại không?" Yes / No
- [ ] `POST /api/items/:id/review` — save review
- [ ] Commit: `feat: post-use product review`

**Day 125 — Top Products Page**
- [ ] `TopProductsPage.tsx` — best rated items per category
- [ ] Filter: This Quarter / This Year
- [ ] Show: item name, brand, avg rating, times purchased, total spent
- [ ] "Would buy again" percentage
- [ ] Commit: `feat: top products summary page [Premium]`

**Day 126 — Week 21 Buffer**
- [ ] Test AI classification with 10 real product names
- [ ] Test notification system (manually trigger scheduler for testing)
- [ ] Commit: `fix: AI classification + notifications review`

---

### WEEK 22 — Household Analytics + V3 Integration

**Day 127 — Household Spending Analytics**
- [ ] `GET /api/household/analytics` — spending by category per month
- [ ] `HouseholdAnalyticsSection.tsx` — bar chart: monthly household spending
- [ ] "Tháng này bạn đã mua đồ dùng 1.2M₫ (+15% so với tháng trước)"
- [ ] Add to Analytics page under new "Đồ dùng gia đình" tab
- [ ] Commit: `feat: household spending analytics [Premium]`

**Day 128 — V3 Finance Integration**
- [ ] When adding household item with price: option to "Ghi vào chi tiêu" (add to transactions)
- [ ] Automatically creates an expense transaction with category "Mua sắm"
- [ ] Commit: `feat: household purchases linked to transactions`

**Day 129 — AI Restock Prediction**
- [ ] `GET /api/ai/restock-prediction` — uses item history to predict when items will run out
- [ ] "Dựa vào lịch sử, bạn sẽ dùng hết kem chống nắng trong ~3 tuần"
- [ ] Show on Item Detail page and as a dashboard widget
- [ ] Commit: `feat: AI restock prediction [Premium]`

**Day 130 — Mobile Responsiveness V3 Audit**
- [ ] Test all V3 pages on 375px
- [ ] Household item grid: responsive columns
- [ ] Fix notification bell on mobile
- [ ] Commit: `fix: V3 mobile responsiveness`

**Day 131 — V3 Tests**
- [ ] `HouseholdServiceTest.java` — 5 unit tests
- [ ] `NotificationSchedulerTest.java` — test that notifications are created correctly
- [ ] `AiClassificationTest.java` — with mocked Claude API
- [ ] Commit: `test: V3 service tests`

**Day 132 — Week 22 Buffer**
- [ ] Full V3 flow test: add item → AI classifies → track usage → get expiry notification → review
- [ ] Fix any Premium gating issues
- [ ] Commit: `fix: V3 flow review`

---

### WEEK 23 — V3 Polish + Launch

**Day 133 — V3 UI Final Polish**
- [ ] Ensure consistent use of design system across all V3 pages
- [ ] Audit: does every locked feature show a clear, helpful upgrade prompt?
- [ ] Add Premium badge to nav items that are Premium-only
- [ ] Commit: `ui: V3 design system consistency`

**Day 134 — Pricing Page Update**
- [ ] Update pricing page to show all V3 features in Premium column
- [ ] Add social proof section: "X người đã nâng cấp lên Premium" (you can fake this initially)
- [ ] Add FAQ section: "Tôi có thể hủy không?", "Thanh toán an toàn không?", "Dữ liệu có bị mất khi hủy không?"
- [ ] Commit: `feat: pricing page V3 update + FAQ`

**Day 135 — V3 Demo Video**
- [ ] Record 4-min video highlighting V3:
  - Household item tracking
  - AI auto-classify (speak or type product name)
  - Expiry notifications
  - Top products year summary
  - Full payment flow: Free → Premium
- [ ] Upload YouTube → update README
- [ ] Commit: `docs: V3 demo video`

**Day 136 — All 3 Demo Videos Edit**
- [ ] Create a 2-min "master trailer" showing all 3 versions evolving
- [ ] Good for LinkedIn and portfolio

**Day 137 — V3 Announcement: LinkedIn + Viblo**
- [ ] Publish Viblo.asia blog post (finish the draft from Day 100)
- [ ] LinkedIn post: "V3 complete — Finance Tracker is now a full SaaS"
- [ ] Share in Vietnamese dev groups: DevChat, Facebook groups

**Day 138 — Week 23 Buffer**
- [ ] Fix post-launch bugs
- [ ] Check PayOS dashboard — any real payments? (Share with friends!)
- [ ] Commit: `fix: V3 launch fixes`

---

## 🔵 REVIEW WEEK 5 (Week 24)

- **Day 139**: Full app walkthrough as a new user (incognito). What's confusing?
- **Day 140**: Fix top 3 UX issues from Day 139.
- **Day 141**: AWS cost check — optimize anything over budget.
- **Day 142**: Update README with complete feature list + screenshots for all 3 versions.
- **Day 143**: Write reflection: what you learned, what was hard, what you're proud of.
- **Day 144**: Rest. You built a full SaaS product. 🎉

---

---

# 💼 PORTFOLIO & JOB HUNT — WEEKS 25–26
## Polish + Blog + Apply

---

### WEEK 25 — Portfolio + Resume

**Day 145 — Architecture Diagram**
- [ ] Use Excalidraw or draw.io:
  - System: Frontend (Vercel) → Backend (AWS EC2) → PostgreSQL → PayOS webhook → Claude API
  - DB ER Diagram (key tables)
  - User flow: Free → upgrade → Premium
- [ ] Add to README and portfolio

**Day 146 — README Final Version**
- [ ] Sections: Overview, Live Demo, 3-tier Features, Tech Stack, Architecture, Local Setup, CI/CD, Payment, API Docs
- [ ] Add: "Why Monolith instead of Microservices" section (shows architectural thinking)

**Day 147 — Resume Update**
```
Finance Tracker — React + Spring Boot + Claude AI + PayOS
• Built a 3-tier SaaS with Free/Plus/Premium plans (499k VND/year)
• Integrated Claude AI for Vietnamese expense parsing + household classification
• Implemented PayOS payment gateway — full webhook-based subscription flow
• Deployed on AWS EC2 with Docker + GitHub Actions CI/CD
• Built AOP-based feature gating (Spring @RequiresPlan annotation)
• 3-version product roadmap shipped in 6 months with 1h/day
```

**Day 148 — Interview Preparation**
- [ ] Practice explaining the app in 5 minutes (Vietnamese + English)
- [ ] Prepare answers:
  - "Tại sao dùng Monolith không phải Microservices?"
  - "PayOS webhook hoạt động như thế nào?"
  - "PlanGate implement như thế nào ở cả FE và BE?"
  - "Bạn xử lý 50 transaction limit cho Free users như thế nào?"

**Day 149 — Apply to 10 Companies**
- [ ] TopDev.vn, ITViec.com, LinkedIn Vietnam
- [ ] Include live demo link + Viblo blog post in every application
- [ ] Personalize each cover letter: mention their tech stack, how your project relates

**Day 150 — Final Buffer**
- [ ] Follow up on applications
- [ ] Fix any last-minute bugs in the live app
- [ ] **YOU DID IT. 🎉**

---

---

# 📋 QUICK REFERENCE

## Daily 1-Hour Template
```
⏱ 0:00–0:05  Open the app → check yesterday's TODO → write today's ONE goal
⏱ 0:05–0:50  Code. One task only. No YouTube.
⏱ 0:50–0:55  git add . && git commit -m "feat/fix/docs: ..."
⏱ 0:55–1:00  Write tomorrow's task on a sticky note or Notion
```

## Anti-Procrastination Rules
1. Open VS Code/IntelliJ **before** opening anything else
2. Stuck > 15 min → Google or Stack Overflow, NOT a tutorial
3. Commit even if it's broken — `feat: WIP category modal`
4. If you miss a day, don't guilt-spiral. Just do today's task tomorrow.
5. Your review week is not a failure — it's part of the plan

## Membership Sanity Checks
Run these checks at the end of each cycle:
- [ ] Does a new Free user see upgrade prompts (not errors) when touching Plus features?
- [ ] Does a new Free user see upgrade prompts when touching Premium features?
- [ ] Does a Plus user see upgrade prompts when touching Premium features?
- [ ] Does a Premium user see **no** upgrade prompts anywhere?
- [ ] Does a EXPIRED Premium user get downgraded to Free automatically?
- [ ] Is the 50 tx/month limit enforced on backend (not just frontend)?

## Vietnam Job Market Checklist
By Month 6, tick all of these:

**Technical (what they test in interviews)**
- [ ] Can explain JWT auth flow step by step
- [ ] Can explain how your payment webhook works
- [ ] Can explain your feature gating architecture (AOP + PlanGate)
- [ ] Can write a React component from scratch with hooks + API call
- [ ] Can design a normalized SQL schema for a given problem
- [ ] Can explain Docker and why you used it

**Portfolio (what recruiters see first)**
- [ ] Live demo at a public HTTPS URL
- [ ] GitHub with 100+ commits over 6 months
- [ ] Architecture diagram in README
- [ ] Viblo.asia blog post in Vietnamese
- [ ] LinkedIn project showcase + 3 posts

**Differentiators (what makes you memorable)**
- [ ] Real SaaS with actual payment integration (almost no one has this in portfolio)
- [ ] AI integration (Claude API) — most juniors don't have this
- [ ] 3 shipped versions (shows product discipline + follow-through)
- [ ] Feature gating system (shows senior-level architectural thinking)

---

## Budget Summary

| Phase | Service | Cost |
|-------|---------|------|
| V1 | Railway + Vercel | $0/month |
| V2+ | AWS EC2 t3.micro | ~$8–12/month |
| V2+ | Claude API (moderate use) | ~$5–10/month |
| V2+ | Cloudflare | $0/month |
| V2+ | PayOS | 0 (takes % per transaction) |
| **Total V2+** | | **~$15–22/month** |

PayOS fee: ~1.5% per transaction. On a 499k payment: ~7.500₫ fee. You keep ~491.500₫.

---

*Version 2.0 · Updated March 2026 · Built for Vietnam Dev Market*  
*1h/day · 6 days/week · Review every 4 weeks · Ship every 2 months 💪*
