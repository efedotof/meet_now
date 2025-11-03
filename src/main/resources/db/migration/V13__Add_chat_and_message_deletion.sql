
ALTER TABLE chats ADD COLUMN deleted_by_user1 BOOLEAN DEFAULT FALSE;
ALTER TABLE chats ADD COLUMN deleted_by_user2 BOOLEAN DEFAULT FALSE;
ALTER TABLE chats ADD COLUMN deleted_at TIMESTAMP;

ALTER TABLE temporary_chats ADD COLUMN deleted_by_sender BOOLEAN DEFAULT FALSE;
ALTER TABLE temporary_chats ADD COLUMN deleted_by_recipient BOOLEAN DEFAULT FALSE;
ALTER TABLE temporary_chats ADD COLUMN deleted_at TIMESTAMP;

ALTER TABLE messages ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE;
ALTER TABLE messages ADD COLUMN deleted_at TIMESTAMP;
ALTER TABLE messages ADD COLUMN deleted_by UUID REFERENCES users(id);

CREATE INDEX IF NOT EXISTS idx_chats_deleted ON chats(deleted_by_user1, deleted_by_user2);
CREATE INDEX IF NOT EXISTS idx_temporary_chats_deleted ON temporary_chats(deleted_by_sender, deleted_by_recipient);
CREATE INDEX IF NOT EXISTS idx_messages_deleted ON messages(is_deleted);