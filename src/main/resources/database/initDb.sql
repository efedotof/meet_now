CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    firstname VARCHAR(50),
    subname VARCHAR(50),
    description TEXT,
    avatar TEXT,
    friends UUID[], -- список id друзей
    city VARCHAR(100),
    age INT,
    purposes TEXT[], -- цели: ["дружба", "общение", "отношения"]
    interests TEXT[], -- интересы: ["спорт", "путешествия"]
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified BOOLEAN DEFAULT FALSE,
    is_searchable BOOLEAN DEFAULT TRUE -- для "Скрыть себя от поиска"
);

CREATE TABLE chats (
    chat_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id1 UUID REFERENCES users(id) ON DELETE CASCADE,
    user_id2 UUID REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_opened BOOLEAN DEFAULT FALSE -- раскрыты ли анкеты
);

CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chat_id UUID REFERENCES chats(chat_id) ON DELETE CASCADE,
    sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
    recipient_id UUID REFERENCES users(id) ON DELETE CASCADE,
    text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE temporary_chats (
    temp_chat_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
    recipient_id UUID REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    duration_minutes INT DEFAULT 5,
    is_finished BOOLEAN DEFAULT FALSE,
    both_agreed BOOLEAN DEFAULT FALSE -- если оба раскрыли анкету
);

CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_id UUID REFERENCES users(id),
    reported_id UUID REFERENCES users(id),
    reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE icebreakers (
    id SERIAL PRIMARY KEY,
    text TEXT NOT NULL
);

CREATE TABLE question_of_day (
    id SERIAL PRIMARY KEY,
    question TEXT NOT NULL,
    date DATE UNIQUE NOT NULL
);

CREATE TABLE chat_constraints (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    temp_chat_id UUID REFERENCES temporary_chats(temp_chat_id) ON DELETE CASCADE,
    wait_seconds INT DEFAULT 30,
    can_start BOOLEAN DEFAULT FALSE
);

CREATE TABLE chat_games (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chat_id UUID REFERENCES chats(chat_id) ON DELETE CASCADE,
    game_type VARCHAR(100), -- угадай слово, правда или действие и т.д.
    state JSONB DEFAULT '{}' -- состояние игры
);

CREATE TABLE second_chance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    temp_chat_id UUID REFERENCES temporary_chats(temp_chat_id),
    sender_decision BOOLEAN,
    recipient_decision BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed BOOLEAN DEFAULT FALSE
);
