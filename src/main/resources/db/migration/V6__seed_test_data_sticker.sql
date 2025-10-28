-- Создаем стикерпак с котиками
INSERT INTO sticker_pack (id, title) VALUES
('aa10c840-e29b-41d4-a716-446655440000', 'Cats')
ON CONFLICT (title) DO NOTHING;

-- Добавляем стикеры в пак
INSERT INTO sticker (id, pack_id, emoji, image_url) VALUES
('bb20c840-e29b-41d4-a716-446655440000', 'aa10c840-e29b-41d4-a716-446655440000', '🔪', 'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/stickers/cat/cats1.jpg'),
('bb20c840-e29b-41d4-a716-446655440001', 'aa10c840-e29b-41d4-a716-446655440000', '🫥', 'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/stickers/cat/cats2.jpg'),
('bb20c840-e29b-41d4-a716-446655440002', 'aa10c840-e29b-41d4-a716-446655440000', '😠', 'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/stickers/cat/cats4.jpg')
ON CONFLICT (pack_id, emoji) DO NOTHING;