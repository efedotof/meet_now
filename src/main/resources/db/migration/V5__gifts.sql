
INSERT INTO gift_types (type_name, description) VALUES
('Открытка', 'Поздравительные открытки и карточки'),
('Книга', 'Электронные книги и литература'),
('Изображение', 'Картинки и фотографии'),
('Артефакт', 'Редкие и уникальные предметы'),
('Стикеры', 'Наборы стикеров для чата')
ON CONFLICT (type_name) DO NOTHING;

INSERT INTO gift_rarities (name, display_name, color, multiplier, probability, min_points, max_points) VALUES
('COMMON', 'Обычный', '#808080', 1.00, 0.50, 0, 50),
('RARE', 'Редкий', '#0070DD', 1.50, 0.25, 51, 100),
('EPIC', 'Эпический', '#A335EE', 2.00, 0.15, 101, 200),
('LEGENDARY', 'Легендарный', '#FF8000', 3.00, 0.08, 201, 500),
('MYTHIC', 'Мифический', '#E5CC80', 5.00, 0.02, 501, 1000)
ON CONFLICT (name) DO NOTHING;

INSERT INTO gifts (name, description, image_url, gift_type_id, cost_points, is_active, rarity_id, is_limited, available_quantity, initial_quantity) 
SELECT 
    'Кольцо' as name,
    'Легендарное кольцо' as description,
    'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/gifts/legendary/ring.png' as image_url,
    gt.id as gift_type_id,
    350 as cost_points,
    true as is_active,
    gr.id as rarity_id,
    true as is_limited,
    35 as available_quantity,
    35 as initial_quantity
FROM gift_types gt
CROSS JOIN gift_rarities gr
WHERE gt.type_name = 'Артефакт' AND gr.name = 'LEGENDARY';

INSERT INTO gifts (name, description, image_url, gift_type_id, cost_points, is_active, rarity_id, is_limited, available_quantity, initial_quantity) 
SELECT 
    'Мой цветочек' as name,
    'Милое изображение цветочка' as description,
    'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/gifts/common/my_little_flower.png' as image_url,
    gt.id as gift_type_id,
    10 as cost_points,
    true as is_active,
    gr.id as rarity_id,
    true as is_limited,
    35 as available_quantity,
    35 as initial_quantity
FROM gift_types gt
CROSS JOIN gift_rarities gr
WHERE gt.type_name = 'Изображение' AND gr.name = 'COMMON';

INSERT INTO gifts (name, description, image_url, gift_type_id, cost_points, is_active, rarity_id, is_limited, available_quantity, initial_quantity) 
SELECT 
    'Мороженка' as name,
    'Вкусное эпическое мороженое' as description,
    'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/gifts/epic/ice_cream.png' as image_url,
    gt.id as gift_type_id,
    150 as cost_points,
    true as is_active,
    gr.id as rarity_id,
    true as is_limited,
    35 as available_quantity,
    35 as initial_quantity
FROM gift_types gt
CROSS JOIN gift_rarities gr
WHERE gt.type_name = 'Изображение' AND gr.name = 'EPIC';