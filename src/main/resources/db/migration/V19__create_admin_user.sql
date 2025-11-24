-- Создание администратора
INSERT INTO users (id, username, password, email, firstname, subname, description, avatar, city, age, verified, is_searchable, is_online, floor, is_searching, game_points) VALUES
(
    '550e8400-e29b-41d4-a716-446655440002',
    'admin',
    '7a23aeb3b4db90f7c4669df7827713b94f560489446b9619f3dd96d3e778112f', 
    'admin@example.com',
    'Администратор',
    'Системы',
    'Системный администратор платформы',
    'https://example.com/avatars/admin.jpg',
    'Москва',
    30,
    true,
    false,
    true,
    'male',
    false,
    1000
);

-- Назначение роли ADMIN
INSERT INTO user_roles (user_id, role_id) VALUES
(
    '550e8400-e29b-41d4-a716-446655440002', 
    (SELECT id FROM roles WHERE role_name = 'ADMIN')
);

-- Добавление изображения администратора (опционально)
INSERT INTO user_images (user_id, image_url) VALUES
('550e8400-e29b-41d4-a716-446655440002', 'https://example.com/images/admin1.jpg');

-- Добавление целей администратора
INSERT INTO user_purposes (user_id, purpose) VALUES
('550e8400-e29b-41d4-a716-446655440002', 'Модерация'),
('550e8400-e29b-41d4-a716-446655440002', 'Поддержка пользователей');

-- Добавление интересов администратора
INSERT INTO user_interests (user_id, interest) VALUES
('550e8400-e29b-41d4-a716-446655440002', 'Технологии'),
('550e8400-e29b-41d4-a716-446655440002', 'Безопасность'),
('550e8400-e29b-41d4-a716-446655440002', 'Сообщества');

-- Создание сессии администратора
INSERT INTO user_sessions (token, user_id, created_at, expires_at) VALUES
(
    'admin_token_12345',
    '550e8400-e29b-41d4-a716-446655440002',
    NOW(),
    NOW() + INTERVAL '7 days'
);