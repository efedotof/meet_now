ALTER TABLE chats ADD COLUMN IF NOT EXISTS encrypted_aes_key_user1 TEXT;
ALTER TABLE chats ADD COLUMN IF NOT EXISTS encrypted_aes_key_user2 TEXT;

ALTER TABLE temporary_chats ADD COLUMN IF NOT EXISTS encrypted_aes_key_sender TEXT;
ALTER TABLE temporary_chats ADD COLUMN IF NOT EXISTS encrypted_aes_key_recipient TEXT;