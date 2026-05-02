# AI-POWERED PERSONAL FINANCE TRACKER
## Full-Stack Requirements Document (Web + Mobile)

**Version:** 3.0 - Full-Stack Edition  
**Date:** January 2026  
**Timeline:** 12 weeks (60 days, 5 hours/day, 5 days/week)  
**Budget:** $15-25/month (~375k-625k VND)  
**Tech Stack:** Spring Boot 4 + ReactJS + React Native + AWS

---

## TABLE OF CONTENTS

1. [Executive Summary](#1-executive-summary)
2. [Project Goals](#2-project-goals)
3. [Technology Stack](#3-technology-stack)
4. [System Architecture](#4-system-architecture)
5. [Core Features](#5-core-features)
6. [Database Design](#6-database-design)
7. [API Design](#7-api-design)
8. [Frontend Features](#8-frontend-features)
9. [Mobile App Features](#9-mobile-app-features)
10. [AWS Infrastructure](#10-aws-infrastructure)
11. [Testing Strategy](#11-testing-strategy)
12. [Security Requirements](#12-security-requirements)
13. [Success Metrics](#13-success-metrics)

---

## 1. EXECUTIVE SUMMARY

### 1.1 Project Overview
A comprehensive personal finance management platform designed specifically for Vietnamese users. The system uses AI to automate expense tracking through voice input, receipt scanning (OCR), and natural language processing. Available as both web application and mobile app.

### 1.2 Key Features
- **Voice Expense Entry**: Record expenses in Vietnamese using speech-to-text
- **AI Expense Parsing**: Claude API automatically extracts amount, category, merchant
- **Receipt Scanning**: OCR-based receipt processing with Tesseract
- **Multi-Currency Support**: VND, USD with real-time conversion
- **AI Insights**: Personalized spending analysis and recommendations
- **Budget Management**: Smart budget tracking with alerts
- **Cross-Platform**: Web (React) + Mobile (React Native)

### 1.3 Target Users
- Young professionals (22-35 years old)
- Vietnamese speakers
- Tech-savvy individuals seeking automated expense tracking
- Users who want insights without manual data entry

---

## 2. PROJECT GOALS

### 2.1 Technical Goals
- Build production-ready microservices architecture
- Implement comprehensive testing (Unit, Integration, E2E)
- Deploy on AWS with minimal cost (<$25/month)
- Achieve 85%+ code coverage
- Support 100+ concurrent users
- API response time <200ms (95th percentile)

### 2.2 Learning Goals
- Master Spring Boot 4 + Java 21 features
- Learn React 18+ with TypeScript
- Build React Native mobile app
- Implement comprehensive testing strategies (JUnit 5, Jest, Detox)
- Master AWS deployment and cost optimization
- Work with AI APIs (Anthropic Claude, Google Speech-to-Text)

### 2.3 Career Goals
- Create standout portfolio for Backend/Frontend/Full-Stack positions
- Demonstrate microservices architecture expertise
- Show AI integration capabilities
- Prove deployment and DevOps skills
- Showcase testing best practices

---

## 3. TECHNOLOGY STACK

### 3.1 Backend (Microservices)

#### Framework
- **Spring Boot**: 4.0.x (latest stable)
- **Java**: 21 (LTS)
- **Spring Cloud**: 2024.0.x
- **Spring Security**: 7.x

#### Core Dependencies
```xml
<dependencies>
    <!-- Spring Boot Starters -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
        <version>4.0.0</version>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-security</artifactId>
    </dependency>
    
    <!-- Spring Cloud -->
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-gateway</artifactId>
    </dependency>
    
    <!-- Database -->
    <dependency>
        <groupId>org.postgresql</groupId>
        <artifactId>postgresql</artifactId>
        <version>42.7.1</version>
    </dependency>
    
    <!-- Redis -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-redis</artifactId>
    </dependency>
    
    <!-- AI & OCR -->
    <dependency>
        <groupId>com.anthropic</groupId>
        <artifactId>anthropic-sdk-java</artifactId>
        <version>0.1.0</version>
    </dependency>
    <dependency>
        <groupId>net.sourceforge.tess4j</groupId>
        <artifactId>tess4j</artifactId>
        <version>5.10.0</version>
    </dependency>
    
    <!-- Utilities -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
    </dependency>
    <dependency>
        <groupId>org.mapstruct</groupId>
        <artifactId>mapstruct</artifactId>
        <version>1.6.0</version>
    </dependency>
    
    <!-- Testing -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.testcontainers</groupId>
        <artifactId>testcontainers</artifactId>
        <version>1.19.3</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

### 3.2 Frontend (Web)

#### Framework
- **React**: 18.3.x
- **TypeScript**: 5.x
- **Build Tool**: Vite 5.x

#### Core Libraries
```json
{
  "dependencies": {
    "react": "^18.3.0",
    "react-dom": "^18.3.0",
    "react-router-dom": "^6.22.0",
    "typescript": "^5.3.3",
    
    "@tanstack/react-query": "^5.20.0",
    "axios": "^1.6.5",
    "zustand": "^4.5.0",
    
    "tailwindcss": "^3.4.1",
    "shadcn/ui": "latest",
    "lucide-react": "^0.316.0",
    
    "react-hook-form": "^7.50.0",
    "zod": "^3.22.4",
    
    "recharts": "^2.12.0",
    "date-fns": "^3.3.1",
    
    "react-hot-toast": "^2.4.1"
  },
  "devDependencies": {
    "@testing-library/react": "^14.1.2",
    "@testing-library/jest-dom": "^6.2.0",
    "vitest": "^1.2.0",
    "cypress": "^13.6.3"
  }
}
```

### 3.3 Mobile (React Native)

#### Framework
- **React Native**: 0.73.x
- **TypeScript**: 5.x
- **Navigation**: React Navigation 6.x

#### Core Libraries
```json
{
  "dependencies": {
    "react-native": "0.73.2",
    "@react-navigation/native": "^6.1.9",
    "@react-navigation/stack": "^6.3.20",
    
    "react-native-voice": "^3.2.4",
    "react-native-camera": "^4.2.1",
    "react-native-image-picker": "^7.1.0",
    
    "@tanstack/react-query": "^5.20.0",
    "axios": "^1.6.5",
    "zustand": "^4.5.0",
    
    "react-native-paper": "^5.12.3",
    "react-native-vector-icons": "^10.0.3",
    "react-native-chart-kit": "^6.12.0",
    
    "@react-native-async-storage/async-storage": "^1.21.0"
  },
  "devDependencies": {
    "detox": "^20.16.1",
    "jest": "^29.7.0"
  }
}
```

### 3.4 Database
- **PostgreSQL**: 18.x
- **Redis**: 7.x
- **Migration Tool**: Flyway

### 3.5 Infrastructure & DevOps

#### AWS Services
- EC2 t3.micro (Spot/Reserved Instance)
- EBS gp3 (30GB)
- CloudWatch (Logs & Monitoring)
- IAM (Security)
- VPC (Default)

#### External Services
- **Cloudflare**: DNS, SSL, CDN (FREE)
- **Cloudinary**: Image Storage (FREE - 10GB)
- **GitHub Actions**: CI/CD (FREE)

#### Containerization
- Docker 24.x
- Docker Compose 2.x
- NGINX (Reverse Proxy)

---

## 4. SYSTEM ARCHITECTURE

### 4.1 Microservices Architecture

```
                    Cloudflare CDN
                    (DNS + SSL)
                           │
                    ┌──────▼──────┐
                    │   NGINX     │  Port 80/443
                    │ API Gateway │
                    └──────┬──────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
    ┌───▼────┐      ┌──────▼─────┐    ┌──────▼─────┐
    │  User  │      │  Expense   │    │ Analytics  │
    │Service │      │  Service   │    │  Service   │
    │ :8081  │      │   :8082    │    │   :8083    │
    └───┬────┘      └──────┬─────┘    └──────┬─────┘
        │                  │                  │
        └──────────────────┼──────────────────┘
                           │
                    ┌──────▼──────┐
                    │ PostgreSQL  │  Port 5432
                    │   Redis     │  Port 6379
                    └─────────────┘
```

### 4.2 Service Breakdown

#### API Gateway Service (Port 8080)
- Route requests to microservices
- Rate limiting
- Authentication validation
- Request logging

#### User Service (Port 8081)
- User registration/login
- Profile management
- JWT token generation
- Password reset

#### Expense Service (Port 8082)
- CRUD operations for expenses
- Voice expense processing
- Receipt OCR processing
- Category management
- Multi-currency handling

#### Analytics Service (Port 8083)
- Spending analysis
- AI insights generation
- Budget tracking
- Report generation

#### Receipt Processing Service (Port 8084)
- Image preprocessing
- Tesseract OCR
- Claude AI parsing
- Image storage (Cloudinary)

### 4.3 Frontend Architecture

```
React Web App
├── src/
│   ├── components/
│   │   ├── ui/           # shadcn/ui components
│   │   ├── layout/       # Layout components
│   │   ├── forms/        # Form components
│   │   └── charts/       # Chart components
│   ├── pages/
│   │   ├── Dashboard/
│   │   ├── Expenses/
│   │   ├── Analytics/
│   │   └── Settings/
│   ├── hooks/            # Custom React hooks
│   ├── services/         # API services
│   ├── stores/           # Zustand stores
│   ├── utils/            # Utilities
│   └── types/            # TypeScript types
```

### 4.4 Mobile Architecture

```
React Native App
├── src/
│   ├── components/
│   ├── screens/
│   │   ├── Dashboard/
│   │   ├── AddExpense/
│   │   ├── Analytics/
│   │   └── Settings/
│   ├── navigation/
│   ├── services/
│   ├── stores/
│   ├── utils/
│   └── types/
```

---

## 5. CORE FEATURES

### 5.1 User Management

#### Registration & Authentication
- Email/password registration
- JWT-based authentication
- Refresh token mechanism
- Password reset via email

#### Profile Management
- Update profile information
- Change password
- Set preferences (language, currency, timezone)
- Avatar upload

### 5.2 Expense Management

#### Manual Entry
- Add expense with form
- Fields: amount, category, merchant, date, notes
- Multi-currency support
- Attach receipt image

#### Voice Entry (Vietnamese)
**Example**: "Tôi vừa mua cà phê 45 nghìn ở Highlands"
- Record voice input
- Send to Google Speech-to-Text API
- Parse with Claude AI
- Extract: amount (45,000 VND), category (Food & Drink), merchant (Highlands)
- Auto-create expense

#### Receipt Scanning
- Take photo or upload receipt
- Preprocess image (grayscale, enhance contrast)
- Extract text with Tesseract OCR
- Parse with Claude AI
- Extract line items, total, merchant, date
- Review and save

#### Expense Operations
- View all expenses (list/grid view)
- Search and filter (by date, category, amount range)
- Edit expense
- Delete expense
- Attach notes
- Mark as recurring

### 5.3 Category Management

#### Default Categories (Vietnamese)
- 🍔 Ăn uống (Food & Drink)
- 🚗 Di chuyển (Transportation)
- 🏠 Nhà cửa (Housing)
- 🛒 Mua sắm (Shopping)
- ⚡ Tiện ích (Utilities)
- 💊 Sức khỏe (Healthcare)
- 🎭 Giải trí (Entertainment)
- 📚 Giáo dục (Education)
- ✈️ Du lịch (Travel)
- 💼 Khác (Others)

#### Custom Categories
- Create custom categories
- Set category icons and colors
- Set budget per category
- Archive unused categories

### 5.4 Budget Management

#### Budget Creation
- Set monthly budget per category
- Set overall monthly budget
- Set weekly/daily limits

#### Budget Tracking
- Visual progress bars
- Alerts when approaching limit (80%, 90%, 100%)
- Spending vs. budget comparison
- Rollover unused budget (optional)

### 5.5 Analytics & Insights

#### Spending Analysis
- Total spending by time period (day/week/month/year)
- Spending by category (pie chart)
- Spending trends (line chart)
- Top merchants
- Average daily spending
- Compare with previous periods

#### AI Insights (Claude)
**Generated insights:**
- Spending patterns identification
- Anomaly detection (unusual expenses)
- Budget optimization recommendations
- Saving opportunities
- Predictive spending forecast

**Example Insight:**
"Bạn đã chi tiêu 30% nhiều hơn cho Ăn uống trong tháng này so với tháng trước. Xem xét giảm các bữa ăn ngoài để tiết kiệm 500k VND/tháng."

#### Reports
- Monthly summary report
- Category breakdown report
- Merchant spending report
- Export to PDF/Excel

### 5.6 Voice Query (Natural Language)

**Examples:**
- "Tôi đã chi bao nhiêu tiền cho đồ ăn tuần này?"
- "Quán cà phê nào tôi hay đến nhất?"
- "So sánh chi tiêu tháng này với tháng trước"

**Processing:**
- Parse natural language query
- Map to database query
- Return results
- Generate voice response (optional)

---

## 6. DATABASE DESIGN

### 6.1 PostgreSQL Schema

#### Users Table
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    avatar_url TEXT,
    default_currency VARCHAR(3) DEFAULT 'VND',
    language VARCHAR(10) DEFAULT 'vi',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
```

#### Expenses Table
```sql
CREATE TABLE expenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    amount DECIMAL(15, 2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    category_id UUID NOT NULL REFERENCES categories(id),
    merchant VARCHAR(255),
    description TEXT,
    expense_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_recurring BOOLEAN DEFAULT FALSE,
    receipt_image_url TEXT,
    source VARCHAR(20) DEFAULT 'manual', -- manual, voice, receipt
    CONSTRAINT positive_amount CHECK (amount > 0)
);

CREATE INDEX idx_expenses_user_date ON expenses(user_id, expense_date DESC);
CREATE INDEX idx_expenses_category ON expenses(category_id);
CREATE INDEX idx_expenses_merchant ON expenses(merchant);
```

#### Categories Table
```sql
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    icon VARCHAR(50),
    color VARCHAR(7),
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_categories_user ON categories(user_id);
```

#### Budgets Table
```sql
CREATE TABLE budgets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category_id UUID REFERENCES categories(id) ON DELETE CASCADE,
    amount DECIMAL(15, 2) NOT NULL,
    period VARCHAR(20) NOT NULL, -- monthly, weekly, yearly
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_budgets_user_period ON budgets(user_id, start_date, end_date);
```

#### Receipts Table
```sql
CREATE TABLE receipts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expense_id UUID NOT NULL REFERENCES expenses(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    ocr_text TEXT,
    processed_at TIMESTAMP,
    confidence_score DECIMAL(3, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### AI_Insights Table
```sql
CREATE TABLE ai_insights (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    insight_type VARCHAR(50), -- pattern, anomaly, recommendation
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    severity VARCHAR(20), -- info, warning, critical
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_insights_user_date ON ai_insights(user_id, generated_at DESC);
```

### 6.2 Redis Caching Strategy

#### Cache Keys
- `user:{userId}` - User profile (TTL: 1 hour)
- `expenses:{userId}:{month}` - Monthly expenses (TTL: 5 minutes)
- `categories:{userId}` - User categories (TTL: 1 hour)
- `analytics:{userId}:{period}` - Analytics data (TTL: 15 minutes)
- `jwt:token:{token}` - JWT blacklist (TTL: token expiry)

---

## 7. API DESIGN

### 7.1 Authentication Endpoints

```
POST   /api/auth/register
POST   /api/auth/login
POST   /api/auth/refresh
POST   /api/auth/logout
POST   /api/auth/forgot-password
POST   /api/auth/reset-password
```

### 7.2 User Endpoints

```
GET    /api/users/me
PUT    /api/users/me
PUT    /api/users/me/password
POST   /api/users/me/avatar
DELETE /api/users/me
```

### 7.3 Expense Endpoints

```
GET    /api/expenses                    # List with pagination
POST   /api/expenses                    # Create expense
GET    /api/expenses/{id}               # Get expense details
PUT    /api/expenses/{id}               # Update expense
DELETE /api/expenses/{id}               # Delete expense
POST   /api/expenses/voice              # Create via voice
POST   /api/expenses/receipt            # Create via receipt
GET    /api/expenses/search             # Search expenses
```

### 7.4 Category Endpoints

```
GET    /api/categories                  # List all categories
POST   /api/categories                  # Create category
PUT    /api/categories/{id}             # Update category
DELETE /api/categories/{id}             # Delete category
```

### 7.5 Budget Endpoints

```
GET    /api/budgets                     # List budgets
POST   /api/budgets                     # Create budget
PUT    /api/budgets/{id}                # Update budget
DELETE /api/budgets/{id}                # Delete budget
GET    /api/budgets/progress            # Budget progress
```

### 7.6 Analytics Endpoints

```
GET    /api/analytics/spending          # Spending analysis
GET    /api/analytics/by-category       # Category breakdown
GET    /api/analytics/trends            # Spending trends
GET    /api/analytics/merchants         # Top merchants
GET    /api/analytics/insights          # AI insights
POST   /api/analytics/query             # Natural language query
```

### 7.7 Request/Response Examples

#### POST /api/expenses/voice
**Request:**
```json
{
  "audioFile": "base64_encoded_audio",
  "language": "vi-VN"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "amount": 45000,
    "currency": "VND",
    "category": {
      "id": "cat-123",
      "name": "Ăn uống"
    },
    "merchant": "Highlands Coffee",
    "expenseDate": "2026-01-05",
    "source": "voice",
    "transcription": "Tôi vừa mua cà phê 45 nghìn ở Highlands"
  }
}
```

---

## 8. FRONTEND FEATURES (WEB)

### 8.1 Pages

#### Dashboard
- Summary cards (total spending, budget remaining, top category)
- Recent expenses list
- Spending chart (last 30 days)
- Quick actions (add expense, scan receipt, voice input)

#### Expenses Page
- Expense list with filters (date range, category, merchant)
- Search bar
- Sort options (date, amount, category)
- Pagination
- Bulk actions (delete, export)

#### Add Expense Modal
- Form with validation
- Category selector
- Date picker
- Currency selector
- Voice input button
- Receipt upload
- Submit button

#### Analytics Page
- Time period selector (week/month/year)
- Spending by category (pie chart)
- Spending trends (line chart)
- Top merchants (bar chart)
- AI insights cards
- Export report button

#### Settings Page
- Profile settings
- Currency preferences
- Language settings
- Category management
- Budget configuration
- Logout

### 8.2 UI Components (shadcn/ui)

- Button, Input, Select, Checkbox, Radio
- Dialog, Modal, Sheet
- Card, Badge, Avatar
- Table, Pagination
- Toast notifications
- Loading skeletons
- Charts (recharts)

### 8.3 Responsive Design

- Mobile: < 640px
- Tablet: 640px - 1024px
- Desktop: > 1024px

Tailwind breakpoints:
```css
sm: 640px
md: 768px
lg: 1024px
xl: 1280px
2xl: 1536px
```

---

## 9. MOBILE APP FEATURES

### 9.1 Screens

#### Home Screen
- Summary cards
- Quick add expense button
- Recent expenses
- Voice input FAB

#### Add Expense Screen
- Form inputs
- Voice input button
- Camera button (scan receipt)
- Gallery button (upload receipt)

#### Expenses List Screen
- Scrollable expense list
- Pull-to-refresh
- Search and filter
- Swipe actions (edit, delete)

#### Analytics Screen
- Charts and visualizations
- Insights cards
- Export option

#### Settings Screen
- Profile management
- Preferences
- About

### 9.2 Native Features

- Voice recording (react-native-voice)
- Camera access (react-native-camera)
- Push notifications
- Offline support (AsyncStorage)
- Biometric authentication

### 9.3 Platform Support

- iOS 13+
- Android 8.0+ (API level 26+)

---

## 10. AWS INFRASTRUCTURE

### 10.1 EC2 Configuration

**Instance Type:** t3.micro
- vCPU: 2
- RAM: 1 GB
- Storage: 30 GB EBS gp3
- Cost: $5-8/month (Spot) or $11/month (Reserved)

**Docker Services:**
- API Gateway (Port 8080)
- User Service (Port 8081)
- Expense Service (Port 8082)
- Analytics Service (Port 8083)
- Receipt Service (Port 8084)
- PostgreSQL (Port 5432)
- Redis (Port 6379)
- NGINX (Port 80/443)

### 10.2 Security Configuration

**Security Group Rules:**
- Port 22 (SSH): Your IP only
- Port 80 (HTTP): 0.0.0.0/0
- Port 443 (HTTPS): 0.0.0.0/0
- Ports 8080-8084: Localhost only

**IAM Roles:**
- EC2 role with CloudWatch Logs permissions
- S3 read access (for deployment artifacts)

### 10.3 Monitoring

**CloudWatch Metrics:**
- CPU Utilization
- Memory Utilization
- Disk Space
- Network In/Out

**CloudWatch Logs:**
- Application logs
- NGINX access logs
- Error logs

**Alerts:**
- CPU > 80%
- Disk > 85%
- Memory > 85%
- Service down

---

## 11. TESTING STRATEGY

### 11.1 Backend Testing

#### Unit Tests (JUnit 5 + Mockito)
- Service layer tests
- Repository tests
- Utility method tests
- Target coverage: 80%+

#### Integration Tests (TestContainers)
- API endpoint tests
- Database integration tests
- Redis cache tests
- External API mocks

#### Performance Tests (JMeter)
- Load testing (100+ concurrent users)
- Stress testing
- Endurance testing

### 11.2 Frontend Testing (Web)

#### Unit Tests (Vitest)
- Component tests
- Hook tests
- Utility function tests
- Target coverage: 75%+

#### Integration Tests (Testing Library)
- Form submission tests
- API integration tests
- Navigation tests

#### E2E Tests (Cypress)
- User flows (login, add expense, view analytics)
- Critical paths
- Cross-browser testing

### 11.3 Mobile Testing

#### Unit Tests (Jest)
- Component tests
- Service tests
- Utility tests

#### E2E Tests (Detox)
- User flows
- Navigation
- Platform-specific features

---

## 12. SECURITY REQUIREMENTS

### 12.1 Authentication & Authorization
- JWT with RS256 algorithm
- Access token expiry: 15 minutes
- Refresh token expiry: 7 days
- Secure HTTP-only cookies for tokens
- CORS configuration

### 12.2 Data Protection
- Password hashing: bcrypt (cost factor 12)
- Database encryption at rest
- HTTPS only (TLS 1.3)
- Input validation and sanitization
- SQL injection prevention (JPA/PreparedStatement)
- XSS prevention

### 12.3 API Security
- Rate limiting (100 requests/minute per IP)
- Request size limits
- API versioning
- Error messages without sensitive data

---

## 13. SUCCESS METRICS

### 13.1 Technical Metrics
- [ ] API response time <200ms (95th percentile)
- [ ] Vietnamese speech recognition ≥85% accuracy
- [ ] OCR accuracy ≥80%
- [ ] Backend test coverage ≥80%
- [ ] Frontend test coverage ≥75%
- [ ] Support 100+ concurrent users
- [ ] 99% uptime

### 13.2 Cost Metrics
- [ ] Monthly AWS cost <$25 (625k VND)
- [ ] Zero surprise charges
- [ ] All resources properly tagged

### 13.3 Portfolio Metrics
- [ ] Public GitHub repository
- [ ] Complete documentation (EN + VI)
- [ ] Demo video (Web + Mobile)
- [ ] Blog post on Medium/Dev.to
- [ ] LinkedIn showcase

---

## APPENDIX A: LEARNING RESOURCES

### Spring Boot 4
- Official docs: https://spring.io/projects/spring-boot
- Baeldung tutorials: https://www.baeldung.com/spring-boot

### React + TypeScript
- React docs: https://react.dev/
- TypeScript handbook: https://www.typescriptlang.org/docs/

### React Native
- Official docs: https://reactnative.dev/
- Expo docs: https://docs.expo.dev/

### Testing
- JUnit 5: https://junit.org/junit5/docs/current/user-guide/
- Vitest: https://vitest.dev/
- Cypress: https://docs.cypress.io/
- Detox: https://wix.github.io/Detox/

### AWS
- EC2: https://docs.aws.amazon.com/ec2/
- Cost optimization: https://aws.amazon.com/pricing/cost-optimization/

---

**Document Version:** 3.0  
**Last Updated:** January 05, 2026  
**Status:** Ready for implementation ✅