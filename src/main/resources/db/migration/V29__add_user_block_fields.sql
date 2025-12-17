-- Migration V29: Add user block fields
-- Add is_blocked and block_reason columns to users table

ALTER TABLE users 
ADD COLUMN IF NOT EXISTS is_blocked BOOLEAN DEFAULT FALSE;

ALTER TABLE users 
ADD COLUMN IF NOT EXISTS block_reason TEXT;

COMMENT ON COLUMN users.is_blocked IS 'Flag indicating if user is blocked';
COMMENT ON COLUMN users.block_reason IS 'Reason for blocking the user';

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_is_blocked ON users(is_blocked);
CREATE INDEX IF NOT EXISTS idx_users_is_online ON users(is_online);
CREATE INDEX IF NOT EXISTS idx_users_is_searching ON users(is_searching);