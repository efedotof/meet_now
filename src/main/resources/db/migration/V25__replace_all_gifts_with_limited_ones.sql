-- Migration: V25__replace_all_gifts_with_limited_ones.sql
-- Замена всех существующих подарков на три лимитированных подарка

-- Очищаем историю покупок, так как старые подарки будут удалены
DELETE FROM gift_purchase_history;

-- Очищаем таблицу подарков
DELETE FROM gifts;

-- Вставляем три новых лимитированных подарка

-- Подарок 1: Кольцо (Легендарный)
INSERT INTO gifts (name, description, image_url, gift_type_id, cost_points, is_active, rarity_id, animation_url, is_limited, available_quantity, initial_quantity, sold_count, is_sold_out) 
SELECT 
    'Кольцо' as name,
    'Легендарное кольцо' as description,
    'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/gifts/legendary/ring.png' as image_url,
    gt.id as gift_type_id,
    350 as cost_points,
    true as is_active,
    gr.id as rarity_id,
    null as animation_url,
    true as is_limited,
    35 as available_quantity,
    35 as initial_quantity,
    0 as sold_count,
    false as is_sold_out
FROM gift_types gt
CROSS JOIN gift_rarities gr
WHERE gt.type_name = 'Артефакт' AND gr.name = 'LEGENDARY';

-- Подарок 2: Мой цветочек (Обычный)
INSERT INTO gifts (name, description, image_url, gift_type_id, cost_points, is_active, rarity_id, animation_url, is_limited, available_quantity, initial_quantity, sold_count, is_sold_out) 
SELECT 
    'Мой цветочек' as name,
    'Милое изображение цветочка' as description,
    'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/gifts/common/my_little_flower.png' as image_url,
    gt.id as gift_type_id,
    10 as cost_points,
    true as is_active,
    gr.id as rarity_id,
    null as animation_url,
    true as is_limited,
    35 as available_quantity,
    35 as initial_quantity,
    0 as sold_count,
    false as is_sold_out
FROM gift_types gt
CROSS JOIN gift_rarities gr
WHERE gt.type_name = 'Изображение' AND gr.name = 'COMMON';

-- Подарок 3: Мороженка (Эпическое)
INSERT INTO gifts (name, description, image_url, gift_type_id, cost_points, is_active, rarity_id, animation_url, is_limited, available_quantity, initial_quantity, sold_count, is_sold_out) 
SELECT 
    'Мороженка' as name,
    'Вкусное эпическое мороженое' as description,
    'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/gifts/epic/ice_cream.png' as image_url,
    gt.id as gift_type_id,
    150 as cost_points,
    true as is_active,
    gr.id as rarity_id,
    null as animation_url,
    true as is_limited,
    35 as available_quantity,
    35 as initial_quantity,
    0 as sold_count,
    false as is_sold_out
FROM gift_types gt
CROSS JOIN gift_rarities gr
WHERE gt.type_name = 'Изображение' AND gr.name = 'EPIC';

-- Комментарий к миграции
COMMENT ON TABLE gifts IS 'Таблица содержит три лимитированных подарка по 35 штук каждый';
COMMENT ON COLUMN gifts.is_limited IS 'Все подарки лимитированные (ограниченное количество)';
COMMENT ON COLUMN gifts.available_quantity IS 'Доступное количество для покупки (у всех по 35 штук)';
COMMENT ON COLUMN gifts.initial_quantity IS 'Начальное количество (35 штук для каждого подарка)';