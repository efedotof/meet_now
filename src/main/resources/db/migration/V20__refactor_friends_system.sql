-- Удаляем старую таблицу друзей
DROP TABLE IF EXISTS user_friends;

-- Создаем таблицу для заявок в друзья
CREATE TABLE IF NOT EXISTS friend_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    from_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    to_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Ограничения
    CONSTRAINT fk_friend_requests_from_user FOREIGN KEY (from_user_id) REFERENCES users(id),
    CONSTRAINT fk_friend_requests_to_user FOREIGN KEY (to_user_id) REFERENCES users(id),
    CONSTRAINT check_friend_request_status CHECK (status IN ('PENDING', 'ACCEPTED', 'REJECTED', 'CANCELLED')),
    CONSTRAINT check_friend_request_not_self CHECK (from_user_id != to_user_id),
    
    -- Уникальность: один пользователь может отправить только один активный запрос другому
    CONSTRAINT unique_pending_request UNIQUE (from_user_id, to_user_id, status)
);

-- Создаем таблицу для подтвержденной дружбы
CREATE TABLE IF NOT EXISTS friendships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    friend_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    friends_since TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Ограничения
    CONSTRAINT fk_friendships_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_friendships_friend FOREIGN KEY (friend_id) REFERENCES users(id),
    CONSTRAINT check_friendship_not_self CHECK (user_id != friend_id),
    
    -- Уникальность: каждая дружба хранится только один раз
    CONSTRAINT unique_friendship UNIQUE (user_id, friend_id)
);

-- Создаем индексы для оптимизации запросов
CREATE INDEX IF NOT EXISTS idx_friend_requests_from_user ON friend_requests(from_user_id);
CREATE INDEX IF NOT EXISTS idx_friend_requests_to_user ON friend_requests(to_user_id);
CREATE INDEX IF NOT EXISTS idx_friend_requests_status ON friend_requests(status);
CREATE INDEX IF NOT EXISTS idx_friend_requests_from_to_status ON friend_requests(from_user_id, to_user_id, status);

CREATE INDEX IF NOT EXISTS idx_friendships_user ON friendships(user_id);
CREATE INDEX IF NOT EXISTS idx_friendships_friend ON friendships(friend_id);
CREATE INDEX IF NOT EXISTS idx_friendships_user_friend ON friendships(user_id, friend_id);

-- Функция для обновления updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Триггер для автоматического обновления updated_at
CREATE TRIGGER update_friend_requests_updated_at 
    BEFORE UPDATE ON friend_requests 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Вставляем начальные данные для типов контента сообщений, если их нет
INSERT INTO message_content_types (type_name) 
VALUES 
    ('TEXT'),
    ('IMAGE'),
    ('VIDEO'),
    ('AUDIO'),
    ('STICKER'),
    ('FILE')
ON CONFLICT (type_name) DO NOTHING;

-- Создаем представление для удобного просмотра друзей пользователя
CREATE OR REPLACE VIEW user_friends_view AS
SELECT 
    u.id as user_id,
    u.username as user_username,
    f.friend_id,
    u2.username as friend_username,
    f.friends_since
FROM users u
JOIN friendships f ON u.id = f.user_id
JOIN users u2 ON f.friend_id = u2.id;

-- Создаем представление для просмотра активных заявок в друзья
CREATE OR REPLACE VIEW pending_friend_requests_view AS
SELECT 
    fr.id as request_id,
    fr.from_user_id,
    u1.username as from_username,
    fr.to_user_id,
    u2.username as to_username,
    fr.created_at,
    fr.status
FROM friend_requests fr
JOIN users u1 ON fr.from_user_id = u1.id
JOIN users u2 ON fr.to_user_id = u2.id
WHERE fr.status = 'PENDING';

-- Комментарии к таблицам
COMMENT ON TABLE friend_requests IS 'Таблица для хранения заявок в друзья между пользователями';
COMMENT ON TABLE friendships IS 'Таблица для хранения подтвержденных дружеских связей';
COMMENT ON COLUMN friend_requests.status IS 'Статус заявки: PENDING, ACCEPTED, REJECTED, CANCELLED';
COMMENT ON COLUMN friendships.friends_since IS 'Дата и время установления дружбы';