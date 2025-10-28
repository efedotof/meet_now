
CREATE TABLE IF NOT EXISTS gift_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS gifts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image_url TEXT NOT NULL,
    gift_type_id UUID NOT NULL REFERENCES gift_types(id) ON DELETE CASCADE,
    cost_points INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    rarity VARCHAR(20) DEFAULT 'COMMON',
    animation_url TEXT, 
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

CREATE TABLE IF NOT EXISTS daily_gifts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    gift_id UUID NOT NULL REFERENCES gifts(id) ON DELETE CASCADE,
    received_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    streak_count INTEGER DEFAULT 1 
);

CREATE INDEX IF NOT EXISTS idx_sent_gifts_sender_id ON sent_gifts(sender_id);
CREATE INDEX IF NOT EXISTS idx_sent_gifts_recipient_id ON sent_gifts(recipient_id);
CREATE INDEX IF NOT EXISTS idx_sent_gifts_chat_id ON sent_gifts(chat_id);
CREATE INDEX IF NOT EXISTS idx_sent_gifts_temp_chat_id ON sent_gifts(temp_chat_id);
CREATE INDEX IF NOT EXISTS idx_sent_gifts_sent_at ON sent_gifts(sent_at);

CREATE INDEX IF NOT EXISTS idx_user_inventory_user_id ON user_inventory(user_id);
CREATE INDEX IF NOT EXISTS idx_user_inventory_gift_id ON user_inventory(gift_id);

CREATE INDEX IF NOT EXISTS idx_daily_gifts_user_id ON daily_gifts(user_id);
CREATE INDEX IF NOT EXISTS idx_daily_gifts_received_at ON daily_gifts(received_at);

