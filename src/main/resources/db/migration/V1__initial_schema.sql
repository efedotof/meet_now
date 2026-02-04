CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Основные таблицы
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS message_content_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS citys(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name_city VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS global_interests(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS global_purposes(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    firstname VARCHAR(50),
    subname VARCHAR(50),
    description TEXT,
    avatar TEXT,
    city VARCHAR(100),
    age INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified BOOLEAN DEFAULT FALSE,
    is_searchable BOOLEAN DEFAULT TRUE,
    is_online BOOLEAN DEFAULT FALSE,
    floor TEXT,
    is_searching BOOLEAN DEFAULT FALSE,
    game_points INT DEFAULT 0,
    encrypted_push_token TEXT,
    push_token_salt TEXT,
    is_blocked BOOLEAN DEFAULT FALSE,
    block_reason TEXT
);

CREATE TABLE IF NOT EXISTS user_sessions (
    token VARCHAR(255) PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS user_roles (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id INT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

-- Друзья и заявки
CREATE TABLE IF NOT EXISTS friend_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    from_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    to_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_friend_request_status CHECK (status IN ('PENDING', 'ACCEPTED', 'REJECTED', 'CANCELLED')),
    CONSTRAINT check_friend_request_not_self CHECK (from_user_id != to_user_id),
    CONSTRAINT unique_pending_request UNIQUE (from_user_id, to_user_id, status)
);

CREATE TABLE IF NOT EXISTS friendships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    friend_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    friends_since TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_friendship_not_self CHECK (user_id != friend_id),
    CONSTRAINT unique_friendship UNIQUE (user_id, friend_id)
);

-- Чаты и сообщения
CREATE TABLE IF NOT EXISTS chats (
    chat_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id1 UUID REFERENCES users(id) ON DELETE CASCADE,
    user_id2 UUID REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_opened BOOLEAN DEFAULT FALSE,
    last_message TEXT,
    last_message_at TIMESTAMP,
    deleted_by_user1 BOOLEAN DEFAULT FALSE,
    deleted_by_user2 BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS temporary_chats (
    temp_chat_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
    recipient_id UUID REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    duration_minutes INT DEFAULT 5,
    is_finished BOOLEAN DEFAULT FALSE,
    both_agreed BOOLEAN DEFAULT FALSE,
    deleted_by_sender BOOLEAN DEFAULT FALSE,
    deleted_by_recipient BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP
);



CREATE TABLE IF NOT EXISTS gift_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS gift_rarities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) UNIQUE NOT NULL,
    display_name VARCHAR(100) NOT NULL,
    color VARCHAR(7) NOT NULL,
    multiplier DOUBLE PRECISION DEFAULT 1.00,
    probability DOUBLE PRECISION DEFAULT 1.00,
    min_points INTEGER DEFAULT 0,
    max_points INTEGER DEFAULT 100,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS gifts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image_url TEXT NOT NULL,
    gift_type_id UUID NOT NULL REFERENCES gift_types(id) ON DELETE CASCADE,
    cost_points INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    rarity_id UUID REFERENCES gift_rarities(id) ON DELETE SET NULL,
    animation_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    available_quantity INTEGER,
    is_limited BOOLEAN DEFAULT FALSE,
    is_sold_out BOOLEAN DEFAULT FALSE,
    initial_quantity INTEGER,
    sold_count INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS daily_gifts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    gift_id UUID NOT NULL REFERENCES gifts(id) ON DELETE CASCADE,
    received_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    streak_count INTEGER DEFAULT 1 
);


CREATE TABLE IF NOT EXISTS sticker_pack (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS sticker (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pack_id UUID NOT NULL REFERENCES sticker_pack(id) ON DELETE CASCADE,
    emoji VARCHAR(100) NOT NULL,
    image_url TEXT NOT NULL,
    UNIQUE (pack_id, emoji)
);


CREATE TABLE IF NOT EXISTS messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chat_id UUID REFERENCES chats(chat_id) ON DELETE CASCADE,
    sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
    recipient_id UUID REFERENCES users(id) ON DELETE CASCADE,
    temp_chat_id UUID REFERENCES temporary_chats(temp_chat_id) ON DELETE CASCADE,
    text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN NOT NULL DEFAULT false,
    content_type UUID NOT NULL REFERENCES message_content_types(id),
    gift_id UUID REFERENCES gifts(id) ON DELETE SET NULL,
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP,
    deleted_by UUID REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS message_media (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    message_id UUID NOT NULL REFERENCES messages(id) ON DELETE CASCADE,
    media_url TEXT NOT NULL,
    file_size BIGINT,
    mime_type VARCHAR(100),
    thumbnail_url TEXT,
    sticker_id UUID REFERENCES sticker(id),
    content_type UUID NOT NULL REFERENCES message_content_types(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sort_order INT DEFAULT 0
);

-- Профиль пользователя
CREATE TABLE IF NOT EXISTS user_images (
    user_id UUID REFERENCES users(id),
    image_url TEXT
);

CREATE TABLE IF NOT EXISTS user_purposes (
    user_id UUID NOT NULL,
    purpose VARCHAR(255) NOT NULL,
    PRIMARY KEY (user_id, purpose),
    CONSTRAINT fk_user_purposes_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS user_interests (
    user_id UUID NOT NULL,
    interest VARCHAR(255) NOT NULL,
    PRIMARY KEY (user_id, interest),
    CONSTRAINT fk_user_interests_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Игры
CREATE TABLE IF NOT EXISTS chat_games (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chat_id UUID REFERENCES chats(chat_id) ON DELETE CASCADE,
    game_type VARCHAR(100),
    state TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS game_configs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_type VARCHAR(255) UNIQUE NOT NULL,
    game_url TEXT NOT NULL,
    score_multiplier NUMERIC(5,2) DEFAULT 0.05,
    game_name VARCHAR(255) NOT NULL,
    game_description TEXT,
    thumbnail_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);






CREATE TABLE IF NOT EXISTS sent_gifts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    recipient_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    gift_id UUID NOT NULL REFERENCES gifts(id) ON DELETE CASCADE,
    chat_id UUID REFERENCES chats(chat_id) ON DELETE SET NULL,
    temp_chat_id UUID REFERENCES temporary_chats(temp_chat_id) ON DELETE SET NULL,
    message TEXT,
    is_anonymous BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_gift_chat_type CHECK (
        (chat_id IS NOT NULL AND temp_chat_id IS NULL) OR 
        (chat_id IS NULL AND temp_chat_id IS NOT NULL)
    )
);

CREATE TABLE IF NOT EXISTS user_inventory (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    gift_id UUID NOT NULL REFERENCES gifts(id) ON DELETE CASCADE,
    quantity INTEGER DEFAULT 1,
    received_from UUID REFERENCES users(id) ON DELETE SET NULL,
    received_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_visible BOOLEAN DEFAULT TRUE,
    UNIQUE(user_id, gift_id, received_from)
);

CREATE TABLE IF NOT EXISTS gift_purchase_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    gift_id UUID NOT NULL REFERENCES gifts(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 1,
    spent_points INTEGER NOT NULL,
    purchase_type VARCHAR(20) NOT NULL CHECK (purchase_type IN ('BUY_FOR_SELF', 'SEND_TO_FRIEND')),
    purchased_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_successful BOOLEAN DEFAULT TRUE
);

-- Поддержка
CREATE TABLE IF NOT EXISTS questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'PENDING',
    user_id UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT status_check CHECK (status IN ('PENDING', 'RECEIVED', 'RESOLVED'))
);

CREATE TABLE IF NOT EXISTS answers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Уведомления
CREATE TABLE IF NOT EXISTS notification_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    title VARCHAR(255),
    message TEXT,
    notification_type VARCHAR(50) NOT NULL,
    sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    success BOOLEAN NOT NULL DEFAULT false,
    error_message TEXT,
    CONSTRAINT fk_notification_history_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Вспомогательные таблицы
CREATE TABLE IF NOT EXISTS reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reporter_id UUID REFERENCES users(id),
    reported_id UUID REFERENCES users(id),
    reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'SENT'
);

CREATE TABLE IF NOT EXISTS icebreakers (
    id BIGSERIAL PRIMARY KEY,
    text TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS question_of_day (
    id BIGSERIAL PRIMARY KEY,
    question TEXT NOT NULL,
    date DATE UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS chat_constraints (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    temp_chat_id UUID REFERENCES temporary_chats(temp_chat_id) ON DELETE CASCADE,
    wait_seconds INT DEFAULT 30,
    can_start BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS second_chance (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    temp_chat_id UUID REFERENCES temporary_chats(temp_chat_id),
    sender_decision BOOLEAN,
    recipient_decision BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS match_delivery_state (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chat_id UUID NOT NULL,
    user1_id UUID NOT NULL,
    user2_id UUID NOT NULL,
    user1_received BOOLEAN NOT NULL DEFAULT FALSE,
    user2_received BOOLEAN NOT NULL DEFAULT FALSE,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    user1_acknowledged_at TIMESTAMP,
    user2_acknowledged_at TIMESTAMP,
    completed_at TIMESTAMP,
    CONSTRAINT unique_chat_id UNIQUE (chat_id)
);

-- Индексы
CREATE INDEX IF NOT EXISTS idx_user_online_searchable_searching ON users(is_online, is_searchable, is_searching);
CREATE INDEX IF NOT EXISTS idx_user_city_online_searchable ON users(city, is_online, is_searchable);
CREATE INDEX IF NOT EXISTS idx_user_age_online_searchable ON users(age, is_online, is_searchable);
CREATE INDEX IF NOT EXISTS idx_user_floor_online_searchable ON users(floor, is_online, is_searchable);
CREATE INDEX IF NOT EXISTS idx_user_verified_online_searchable ON users(verified, is_online, is_searchable);
CREATE INDEX IF NOT EXISTS idx_user_search_status ON users(is_online, is_searchable, is_searching, city, age, verified);
CREATE INDEX IF NOT EXISTS idx_users_encrypted_push_token ON users(encrypted_push_token);
CREATE INDEX IF NOT EXISTS idx_users_is_blocked ON users(is_blocked);
CREATE INDEX IF NOT EXISTS idx_users_search_fast ON users (is_online, is_searchable, is_searching);
CREATE INDEX IF NOT EXISTS idx_users_age ON users (age);
CREATE INDEX IF NOT EXISTS idx_users_city ON users (city);
CREATE INDEX IF NOT EXISTS idx_users_floor ON users (floor);

CREATE INDEX IF NOT EXISTS idx_user_interests_user_id ON user_interests(user_id);
CREATE INDEX IF NOT EXISTS idx_user_interests_interest ON user_interests(interest);
CREATE INDEX IF NOT EXISTS idx_user_interests_user ON user_interests(user_id, interest);
CREATE INDEX IF NOT EXISTS idx_user_purposes_user_id ON user_purposes(user_id);
CREATE INDEX IF NOT EXISTS idx_user_purposes_purpose ON user_purposes(purpose);
CREATE INDEX IF NOT EXISTS idx_user_purposes_user ON user_purposes(user_id, purpose);

CREATE INDEX IF NOT EXISTS idx_message_media_message_id ON message_media(message_id);
CREATE INDEX IF NOT EXISTS idx_message_media_content_type ON message_media(content_type);
CREATE INDEX IF NOT EXISTS idx_messages_content_type ON messages(content_type);
CREATE INDEX IF NOT EXISTS idx_messages_gift_id ON messages(gift_id);
CREATE INDEX IF NOT EXISTS idx_messages_deleted ON messages(is_deleted);

CREATE INDEX IF NOT EXISTS idx_chats_deleted ON chats(deleted_by_user1, deleted_by_user2);
CREATE INDEX IF NOT EXISTS idx_temporary_chats_deleted ON temporary_chats(deleted_by_sender, deleted_by_recipient);

CREATE INDEX IF NOT EXISTS idx_chat_games_created_at ON chat_games(created_at);

CREATE INDEX IF NOT EXISTS idx_sent_gifts_sender_id ON sent_gifts(sender_id);
CREATE INDEX IF NOT EXISTS idx_sent_gifts_recipient_id ON sent_gifts(recipient_id);
CREATE INDEX IF NOT EXISTS idx_sent_gifts_chat_id ON sent_gifts(chat_id);
CREATE INDEX IF NOT EXISTS idx_sent_gifts_temp_chat_id ON sent_gifts(temp_chat_id);
CREATE INDEX IF NOT EXISTS idx_sent_gifts_sent_at ON sent_gifts(sent_at);

CREATE INDEX IF NOT EXISTS idx_user_inventory_user_id ON user_inventory(user_id);
CREATE INDEX IF NOT EXISTS idx_user_inventory_gift_id ON user_inventory(gift_id);

CREATE INDEX IF NOT EXISTS idx_gift_rarities_name ON gift_rarities(name);
CREATE INDEX IF NOT EXISTS idx_gift_rarities_active ON gift_rarities(is_active);
CREATE INDEX IF NOT EXISTS idx_gifts_rarity_id ON gifts(rarity_id);
CREATE INDEX IF NOT EXISTS idx_gifts_rarity_active ON gifts(rarity_id, is_active);
CREATE INDEX IF NOT EXISTS idx_gifts_active_rarity ON gifts(is_active, rarity_id);
CREATE INDEX IF NOT EXISTS idx_gifts_limited ON gifts(is_limited, is_sold_out, available_quantity);
CREATE INDEX IF NOT EXISTS idx_gifts_sold_count ON gifts(sold_count);

CREATE INDEX IF NOT EXISTS idx_gift_purchase_user ON gift_purchase_history(user_id);
CREATE INDEX IF NOT EXISTS idx_gift_purchase_gift ON gift_purchase_history(gift_id);
CREATE INDEX IF NOT EXISTS idx_gift_purchase_date ON gift_purchase_history(purchased_at);
CREATE INDEX IF NOT EXISTS idx_gift_purchase_type ON gift_purchase_history(purchase_type);

CREATE INDEX IF NOT EXISTS idx_questions_status ON questions(status);
CREATE INDEX IF NOT EXISTS idx_questions_user_id ON questions(user_id);
CREATE INDEX IF NOT EXISTS idx_answers_question_id ON answers(question_id);
CREATE INDEX IF NOT EXISTS idx_answers_created_by ON answers(created_by);

CREATE INDEX IF NOT EXISTS idx_notification_history_user_id ON notification_history(user_id);
CREATE INDEX IF NOT EXISTS idx_notification_history_sent_at ON notification_history(sent_at);
CREATE INDEX IF NOT EXISTS idx_notification_history_type ON notification_history(notification_type);
CREATE INDEX IF NOT EXISTS idx_notification_history_success ON notification_history(success);
CREATE INDEX IF NOT EXISTS idx_notification_history_user_sent ON notification_history(user_id, sent_at DESC);
CREATE INDEX IF NOT EXISTS idx_notification_history_type_sent ON notification_history(notification_type, sent_at DESC);

CREATE INDEX IF NOT EXISTS idx_friend_requests_from_user ON friend_requests(from_user_id);
CREATE INDEX IF NOT EXISTS idx_friend_requests_to_user ON friend_requests(to_user_id);
CREATE INDEX IF NOT EXISTS idx_friend_requests_status ON friend_requests(status);
CREATE INDEX IF NOT EXISTS idx_friend_requests_from_to_status ON friend_requests(from_user_id, to_user_id, status);

CREATE INDEX IF NOT EXISTS idx_friendships_user ON friendships(user_id);
CREATE INDEX IF NOT EXISTS idx_friendships_friend ON friendships(friend_id);
CREATE INDEX IF NOT EXISTS idx_friendships_user_friend ON friendships(user_id, friend_id);

CREATE INDEX IF NOT EXISTS idx_match_delivery_state_chat_id ON match_delivery_state(chat_id);
CREATE INDEX IF NOT EXISTS idx_match_delivery_state_user1_id ON match_delivery_state(user1_id);
CREATE INDEX IF NOT EXISTS idx_match_delivery_state_user2_id ON match_delivery_state(user2_id);
CREATE INDEX IF NOT EXISTS idx_match_delivery_state_status ON match_delivery_state(status);
CREATE INDEX IF NOT EXISTS idx_match_delivery_state_created_at ON match_delivery_state(created_at);
CREATE INDEX IF NOT EXISTS idx_match_delivery_state_user_pair ON match_delivery_state(user1_id, user2_id);

-- Функции и триггеры
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_friend_requests_updated_at 
    BEFORE UPDATE ON friend_requests 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

CREATE OR REPLACE FUNCTION update_gift_sold_out_status()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.is_limited = TRUE AND (NEW.available_quantity IS NULL OR NEW.available_quantity <= 0) THEN
        NEW.is_sold_out := TRUE;
    ELSE
        NEW.is_sold_out := FALSE;
    END IF;
    
    IF TG_OP = 'INSERT' AND NEW.is_limited = TRUE AND NEW.initial_quantity IS NULL THEN
        NEW.initial_quantity := NEW.available_quantity;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_gift_sold_out
    BEFORE INSERT OR UPDATE ON gifts
    FOR EACH ROW
    EXECUTE FUNCTION update_gift_sold_out_status();

CREATE OR REPLACE FUNCTION cleanup_old_notifications(days_to_keep INTEGER DEFAULT 90)
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM notification_history 
    WHERE sent_at < (CURRENT_TIMESTAMP - (days_to_keep || ' days')::INTERVAL)
    RETURNING COUNT(*) INTO deleted_count;
    
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION notify_cleanup_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM notification_history WHERE sent_at < CURRENT_TIMESTAMP - INTERVAL '180 days') > 10000 THEN
        PERFORM cleanup_old_notifications(180);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER cleanup_notifications_trigger
AFTER INSERT ON notification_history
EXECUTE FUNCTION notify_cleanup_trigger();