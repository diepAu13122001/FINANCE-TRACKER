-- ============================================================
-- DB SETUP — chạy MỘT LẦN với superuser (postgres)
-- KHÔNG đặt vào folder Flyway migration
-- ============================================================
--
-- Cách chạy:
--   psql -U postgres -d finance_tracker -f db_setup.sql
--
-- Hoặc copy paste vào pgAdmin Query Tool sau khi connect bằng postgres user
-- ============================================================
-- 1. Cấp quyền cho ft_user trên schema public
GRANT ALL ON SCHEMA public TO ft_user;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ft_user;

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ft_user;

GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO ft_user;

-- 2. Đổi owner các bảng đã tồn tại sang ft_user
ALTER TABLE IF EXISTS users OWNER TO ft_user;

ALTER TABLE IF EXISTS subscription_plans OWNER TO ft_user;

ALTER TABLE IF EXISTS user_subscriptions OWNER TO ft_user;

ALTER TABLE IF EXISTS payment_history OWNER TO ft_user;

ALTER TABLE IF EXISTS transactions OWNER TO ft_user;

ALTER TABLE IF EXISTS flyway_schema_history OWNER TO ft_user;

-- 3. Default privileges — mọi object tạo sau này tự động grant cho ft_user
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO ft_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO ft_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO ft_user;

-- 4. Đảm bảo ft_user là owner của database (optional nhưng tốt)
ALTER DATABASE finance_tracker OWNER TO ft_user;