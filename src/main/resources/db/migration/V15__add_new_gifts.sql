INSERT INTO gifts (name, description, image_url, gift_type_id, cost_points, is_active, rarity_id, is_limited, available_quantity, initial_quantity) 
SELECT 
    'Премиум доступ' as name,
    'Получите премиум статус на месяц! Все возможности платформы без ограничений.' as description,
    'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/gifts/premium/premium1.png' as image_url,
    gt.id as gift_type_id,
    20000 as cost_points,
    true as is_active,
    gr.id as rarity_id,
    true as is_limited,
    100 as available_quantity,
    100 as initial_quantity
FROM gift_types gt
CROSS JOIN gift_rarities gr
WHERE gt.type_name = 'PREMIUM' AND gr.name = 'LEGENDARY';

INSERT INTO gifts (name, description, image_url, gift_type_id, cost_points, is_active, rarity_id, is_limited, available_quantity, initial_quantity) 
SELECT 
    'Подарочная коробка' as name,
    'Обычная коробка с бантиком' as description,
    'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/gifts/common/common4.png' as image_url,
    gt.id as gift_type_id,
    10 as cost_points,
    true as is_active,
    gr.id as rarity_id,
    false as is_limited,
    NULL as available_quantity,
    NULL as initial_quantity
FROM gift_types gt
CROSS JOIN gift_rarities gr
WHERE gt.type_name = 'Изображение' AND gr.name = 'COMMON';