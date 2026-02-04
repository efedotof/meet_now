ALTER TABLE temporary_chats 
ADD COLUMN IF NOT EXISTS sender_agreed BOOLEAN NOT NULL DEFAULT false;

ALTER TABLE temporary_chats 
ADD COLUMN IF NOT EXISTS recipient_agreed BOOLEAN NOT NULL DEFAULT false;

UPDATE temporary_chats 
SET sender_agreed = false, 
    recipient_agreed = false 
WHERE sender_agreed IS NULL OR recipient_agreed IS NULL;

UPDATE temporary_chats 
SET both_agreed = (sender_agreed AND recipient_agreed);

CREATE INDEX IF NOT EXISTS idx_temporary_chats_agreed 
ON temporary_chats(sender_agreed, recipient_agreed, both_agreed);

COMMENT ON COLUMN temporary_chats.sender_agreed IS 'Согласие отправителя на продолжение чата в постоянный';
COMMENT ON COLUMN temporary_chats.recipient_agreed IS 'Согласие получателя на продолжение чата в постоянный';