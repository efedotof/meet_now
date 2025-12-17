-- Добавляем новый тип контента "gift"
INSERT INTO message_content_types (type_name) VALUES 
('gift')
ON CONFLICT (type_name) DO NOTHING;

-- Добавляем поле gift_id в таблицу messages
ALTER TABLE messages 
ADD COLUMN IF NOT EXISTS gift_id UUID REFERENCES gifts(id) ON DELETE SET NULL;

-- Создаем индекс для улучшения производительности запросов с gift_id
CREATE INDEX IF NOT EXISTS idx_messages_gift_id ON messages(gift_id);