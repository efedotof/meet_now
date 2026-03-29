ALTER TABLE users ADD COLUMN IF NOT EXISTS public_key TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS encrypted_private_key TEXT;

CREATE INDEX IF NOT EXISTS idx_users_public_key ON users(public_key) WHERE public_key IS NOT NULL;

ALTER TABLE users ADD COLUMN IF NOT EXISTS salt TEXT;

CREATE INDEX IF NOT EXISTS idx_users_salt ON users(salt) WHERE salt IS NOT NULL;