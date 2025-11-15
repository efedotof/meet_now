
ALTER TABLE chat_games 
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

UPDATE chat_games SET created_at = CURRENT_TIMESTAMP WHERE created_at IS NULL;

ALTER TABLE chat_games 
ALTER COLUMN created_at SET NOT NULL;

CREATE INDEX IF NOT EXISTS idx_chat_games_created_at ON chat_games(created_at);