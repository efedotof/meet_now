-- Migration: V28__update_sticker_images_fixed.sql
-- Обновление ссылок на изображения стикеров с безопасным подходом

-- Удаляем старые стикеры (если они существуют) для чистого обновления
DELETE FROM sticker 
WHERE pack_id = 'aa10c840-e29b-41d4-a716-446655440000';

-- Удаляем старый стикерпак (если существует)
DELETE FROM sticker_pack 
WHERE id = 'aa10c840-e29b-41d4-a716-446655440000';

-- Создаем стикерпак с котиками
INSERT INTO sticker_pack (id, title) 
VALUES ('aa10c840-e29b-41d4-a716-446655440000', 'Cats');

-- Добавляем стикеры в пак с обновленными ссылками PNG
INSERT INTO sticker (id, pack_id, emoji, image_url) VALUES
('bb20c840-e29b-41d4-a716-446655440000', 'aa10c840-e29b-41d4-a716-446655440000', '🔪', 'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/stickers/cat/cats1.png'),
('bb20c840-e29b-41d4-a716-446655440001', 'aa10c840-e29b-41d4-a716-446655440000', '🫥', 'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/stickers/cat/cats2.png'),
('bb20c840-e29b-41d4-a716-446655440002', 'aa10c840-e29b-41d4-a716-446655440000', '😠', 'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/stickers/cat/cats3.png');

-- Комментарий к миграции
COMMENT ON TABLE sticker IS 'Стикеры с обновленными ссылками на изображения в формате PNG';