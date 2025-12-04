-- Migration: V22__populate_gifts_data.sql
-- Добавление тестовых данных для подарков

-- Вставляем типы подарков, если они еще не существуют
INSERT INTO gift_types (type_name, description) VALUES
    ('Открытка', 'Поздравительные открытки и карточки'),
    ('Книга', 'Электронные книги и литература'),
    ('Изображение', 'Картинки и фотографии'),
    ('Артефакт', 'Редкие и уникальные предметы'),
    ('Стикеры', 'Наборы стикеров для чата')
ON CONFLICT (type_name) DO NOTHING;

-- Вставляем подарки с соответствующими редкостями
INSERT INTO gifts (name, description, image_url, gift_type_id, cost_points, is_active, rarity_id, animation_url) 
SELECT 
    gift_data.name,
    gift_data.description,
    gift_data.image_url,
    gt.id as gift_type_id,
    gift_data.cost_points,
    gift_data.is_active,
    gr.id as rarity_id,
    gift_data.animation_url
FROM (
    -- Обычные подарки
    SELECT 'Поздравительная открытка' as name, 
           'Традиционная поздравительная открытка' as description,
           'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/gifts/common/postcard.png' as image_url,
           'Открытка' as type_name, 
           10 as cost_points, 
           true as is_active,
           'COMMON' as rarity_name,
           null as animation_url
    
    UNION ALL
    
    -- Редкие подарки
    SELECT 'Редкая книга' as name,
           'Электронная книга редкого издания' as description,
           'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/gifts/rare/rare_book.png' as image_url,
           'Книга' as type_name,
           50 as cost_points,
           true as is_active,
           'RARE' as rarity_name,
           null as animation_url
    
    UNION ALL
    
    -- Эпические подарки
    SELECT 'Эпическая книга' as name,
           'Книга с эпическим содержанием' as description,
           'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/gifts/epic/epic_book.png' as image_url,
           'Книга' as type_name,
           150 as cost_points,
           true as is_active,
           'EPIC' as rarity_name,
           null as animation_url
    
    UNION ALL
    
    -- Легендарные подарки
    SELECT 'Легендарное изображение' as name,
           'Уникальное легендарное изображение' as description,
           'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/gifts/legendary/images.jpeg' as image_url,
           'Изображение' as type_name,
           350 as cost_points,
           true as is_active,
           'LEGENDARY' as rarity_name,
           null as animation_url
    
    UNION ALL
    
    -- Мифические подарки
    SELECT 'Мифический артефакт' as name,
           'Древний мифический артефакт' as description,
           'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/gifts/mythic/5fddd802e215a96-upscaled.jpeg' as image_url,
           'Артефакт' as type_name,
           750 as cost_points,
           true as is_active,
           'MYTHIC' as rarity_name,
           null as animation_url
) as gift_data
LEFT JOIN gift_types gt ON gt.type_name = gift_data.type_name
LEFT JOIN gift_rarities gr ON gr.name = gift_data.rarity_name
WHERE gt.id IS NOT NULL AND gr.id IS NOT NULL
ON CONFLICT DO NOTHING;

-- Создаем индекс для оптимизации запросов по активности и редкости
CREATE INDEX IF NOT EXISTS idx_gifts_active_rarity ON gifts(is_active, rarity_id);

-- Комментарий к миграции
COMMENT ON TABLE gifts IS 'Таблица содержит данные о подарках с различными редкостями';
COMMENT ON COLUMN gifts.cost_points IS 'Стоимость подарка в баллах';
COMMENT ON COLUMN gifts.is_active IS 'Флаг активности подарка (можно ли его дарить)';