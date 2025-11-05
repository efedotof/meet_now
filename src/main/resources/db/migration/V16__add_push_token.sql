ALTER TABLE users ADD COLUMN encrypted_push_token TEXT;
ALTER TABLE users ADD COLUMN push_token_salt TEXT;
CREATE INDEX IF NOT EXISTS idx_users_encrypted_push_token ON users(encrypted_push_token);