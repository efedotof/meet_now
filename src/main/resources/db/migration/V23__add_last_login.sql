ALTER TABLE users ADD COLUMN IF NOT EXISTS last_login TIMESTAMP;

UPDATE users SET last_login = created_at WHERE last_login IS NULL;