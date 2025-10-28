-- Вставка пользователей
INSERT INTO users (id, username, password, email, firstname, subname, description, avatar, city, age, verified, is_searchable, is_online, floor, is_searching, game_points) VALUES
(
    '550e8400-e29b-41d4-a716-446655440000',
    'ivan_ivanov',
    'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', -- password: password123
    'ivan@mail.ru',
    'Иван',
    'Иванов',
    'Привет! Я люблю путешествия, спорт и программирование. Ищу интересных собеседников и новых друзей.',
    'https://example.com/avatars/ivan.jpg',
    'Москва',
    25,
    true,
    true,
    true,
    'male',
    true,
    150
),
(
    '550e8400-e29b-41d4-a716-446655440001', 
    'anna_smirnova',
    'faeab9a5b6827805681a5b5e036b9f554244375e93c5fadbb0389ea9de1aaeef', -- password: anna2024
    'anna@yandex.ru',
    'Анна',
    'Смирнова',
    'Увлекаюсь искусством, фотографией и кулинарией. Люблю активный отдых и познавательные беседы.',
    'https://example.com/avatars/anna.jpg',
    'Санкт-Петербург',
    23,
    true,
    true,
    false,
    'female',
    true,
    200
);

-- Добавление изображений пользователей
INSERT INTO user_images (user_id, image_url) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'https://example.com/images/ivan1.jpg'),
('550e8400-e29b-41d4-a716-446655440000', 'https://example.com/images/ivan2.jpg'),
('550e8400-e29b-41d4-a716-446655440001', 'https://example.com/images/anna1.jpg'),
('550e8400-e29b-41d4-a716-446655440001', 'https://example.com/images/anna2.jpg');

-- Добавление целей пользователей
INSERT INTO user_purposes (user_id, purpose) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Дружба'),
('550e8400-e29b-41d4-a716-446655440000', 'Общение'),
('550e8400-e29b-41d4-a716-446655440000', 'Путешествия'),
('550e8400-e29b-41d4-a716-446655440001', 'Дружба'),
('550e8400-e29b-41d4-a716-446655440001', 'Обучение'),
('550e8400-e29b-41d4-a716-446655440001', 'Свидания');

-- Добавление интересов пользователей
INSERT INTO user_interests (user_id, interest) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Программирование'),
('550e8400-e29b-41d4-a716-446655440000', 'Спорт'),
('550e8400-e29b-41d4-a716-446655440000', 'Путешествия'),
('550e8400-e29b-41d4-a716-446655440000', 'Музыка'),
('550e8400-e29b-41d4-a716-446655440001', 'Искусство'),
('550e8400-e29b-41d4-a716-446655440001', 'Фотография'),
('550e8400-e29b-41d4-a716-446655440001', 'Кулинария'),
('550e8400-e29b-41d4-a716-446655440001', 'Кино');

-- Создание чата между пользователями
INSERT INTO chats (chat_id, user_id1, user_id2, is_opened, last_message) VALUES
(
    '660e8400-e29b-41d4-a716-446655440000',
    '550e8400-e29b-41d4-a716-446655440000',
    '550e8400-e29b-41d4-a716-446655440001',
    true,
    'Привет! Как твои дела?'
);

-- Создание временного чата
INSERT INTO temporary_chats (temp_chat_id, sender_id, recipient_id, is_finished, both_agreed) VALUES
(
    '770e8400-e29b-41d4-a716-446655440000',
    '550e8400-e29b-41d4-a716-446655440000',
    '550e8400-e29b-41d4-a716-446655440001',
    false,
    true
);

-- Добавление сообщений с указанием типа контента
INSERT INTO messages (id, chat_id, sender_id, recipient_id, text, is_read, content_type) VALUES
(
    '880e8400-e29b-41d4-a716-446655440000',
    '660e8400-e29b-41d4-a716-446655440000',
    '550e8400-e29b-41d4-a716-446655440000',
    '550e8400-e29b-41d4-a716-446655440001',
    'Привет! Очень понравился твой профиль!',
    true,
    (SELECT id FROM message_content_types WHERE type_name = 'text')
),
(
    '880e8400-e29b-41d4-a716-446655440001',
    '660e8400-e29b-41d4-a716-446655440000',
    '550e8400-e29b-41d4-a716-446655440001',
    '550e8400-e29b-41d4-a716-446655440000',
    'Спасибо! Твой тоже очень интересный!',
    true,
    (SELECT id FROM message_content_types WHERE type_name = 'text')
);

-- Добавление ролей пользователям
INSERT INTO user_roles (user_id, role_id) VALUES
('550e8400-e29b-41d4-a716-446655440000', (SELECT id FROM roles WHERE role_name = 'USER')),
('550e8400-e29b-41d4-a716-446655440001', (SELECT id FROM roles WHERE role_name = 'USER'));

-- Добавление сессий пользователей
INSERT INTO user_sessions (token, user_id, created_at, expires_at) VALUES
(
    'ivan_token_12345',
    '550e8400-e29b-41d4-a716-446655440000',
    NOW(),
    NOW() + INTERVAL '7 days'
),
(
    'anna_token_67890',
    '550e8400-e29b-41d4-a716-446655440001',
    NOW(),
    NOW() + INTERVAL '7 days'
);

-- Добавление друзей
INSERT INTO user_friends (user_id, friend_id) VALUES
('550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440001'),
('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000');

-- Добавление icebreakers
INSERT INTO icebreakers (text) VALUES
('Какое твое любимое место для путешествий?'),
('Какой жанр фильмов тебе нравится?'),
('Есть ли у тебя хобби, которому ты уделяешь много времени?');

-- Добавление вопроса дня
INSERT INTO question_of_day (question, date) VALUES
('Какую книгу вы сейчас читаете?', CURRENT_DATE);

-- Добавление ограничения для чата
INSERT INTO chat_constraints (temp_chat_id, wait_seconds, can_start) VALUES
('770e8400-e29b-41d4-a716-446655440000', 30, true);

-- Добавление второго шанса
INSERT INTO second_chance (temp_chat_id, sender_decision, recipient_decision) VALUES
('770e8400-e29b-41d4-a716-446655440000', true, true);


