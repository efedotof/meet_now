-- Migration: V27__update_sticker_images.sql
-- Обновление ссылок на изображения стикеров

-- Обновляем URL изображений для существующих стикеров
UPDATE sticker 
SET image_url = 'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/stickers/cat/cats1.png'
WHERE id = 'bb20c840-e29b-41d4-a716-446655440000';

UPDATE sticker 
SET image_url = 'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/stickers/cat/cats2.png'
WHERE id = 'bb20c840-e29b-41d4-a716-446655440001';

UPDATE sticker 
SET image_url = 'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/stickers/cat/cats4.png'
WHERE id = 'bb20c840-e29b-41d4-a716-446655440002';

-- Проверяем, существует ли стикерпак, и создаем его, если нет
INSERT INTO sticker_pack (id, title) 
SELECT 'aa10c840-e29b-41d4-a716-446655440000', 'Cats'
WHERE NOT EXISTS (SELECT 1 FROM sticker_pack WHERE id = 'aa10c840-e29b-41d4-a716-446655440000');

-- Если стикеры были удалены, вставляем их заново
INSERT INTO sticker (id, pack_id, emoji, image_url)
SELECT 'bb20c840-e29b-41d4-a716-446655440000', 'aa10c840-e29b-41d4-a716-446655440000', '🔪', 'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/stickers/cat/cats1.png'
WHERE NOT EXISTS (SELECT 1 FROM sticker WHERE id = 'bb20c840-e29b-41d4-a716-446655440000');

INSERT INTO sticker (id, pack_id, emoji, image_url)
SELECT 'bb20c840-e29b-41d4-a716-446655440001', 'aa10c840-e29b-41d4-a716-446655440000', '🫥', 'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/stickers/cat/cats2.png'
WHERE NOT EXISTS (SELECT 1 FROM sticker WHERE id = 'bb20c840-e29b-41d4-a716-446655440001');

INSERT INTO sticker (id, pack_id, emoji, image_url)
SELECT 'bb20c840-e29b-41d4-a716-446655440002', 'aa10c840-e29b-41d4-a716-446655440000', '😠', 'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/stickers/cat/cats4.png'
WHERE NOT EXISTS (SELECT 1 FROM sticker WHERE id = 'bb20c840-e29b-41d4-a716-446655440002');

-- Комментарий к миграции
COMMENT ON TABLE sticker IS 'Стикеры с обновленными ссылками на изображения в формате PNG';