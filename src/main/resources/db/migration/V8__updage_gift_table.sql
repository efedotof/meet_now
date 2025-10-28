-- Создание таблицы редкостей подарков
CREATE TABLE IF NOT EXISTS gift_rarities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) UNIQUE NOT NULL,
    display_name VARCHAR(100) NOT NULL,
    color VARCHAR(7) NOT NULL,
    multiplier DECIMAL(3,2) DEFAULT 1.00,
    probability DECIMAL(3,2) DEFAULT 1.00,
    min_points INTEGER DEFAULT 0,
    max_points INTEGER DEFAULT 100,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Обновление таблицы gifts для связи с gift_rarities
ALTER TABLE gifts 
DROP COLUMN IF EXISTS rarity,
ADD COLUMN rarity_id UUID REFERENCES gift_rarities(id) ON DELETE SET NULL;

-- Вставка начальных данных для редкостей
INSERT INTO gift_rarities (name, display_name, color, multiplier, probability, min_points, max_points) VALUES
('COMMON', 'Обычный', '#808080', 1.00, 0.50, 0, 50),
('RARE', 'Редкий', '#0070DD', 1.50, 0.25, 51, 100),
('EPIC', 'Эпический', '#A335EE', 2.00, 0.15, 101, 200),
('LEGENDARY', 'Легендарный', '#FF8000', 3.00, 0.08, 201, 500),
('MYTHIC', 'Мифический', '#E5CC80', 5.00, 0.02, 501, 1000)
ON CONFLICT (name) DO NOTHING;

-- Обновление существующих подарков для связи с редкостями
UPDATE gifts SET rarity_id = (SELECT id FROM gift_rarities WHERE name = 'COMMON') 
WHERE rarity_id IS NULL;

-- Создание индексов
CREATE INDEX IF NOT EXISTS idx_gift_rarities_name ON gift_rarities(name);
CREATE INDEX IF NOT EXISTS idx_gift_rarities_active ON gift_rarities(is_active);
CREATE INDEX IF NOT EXISTS idx_gifts_rarity_id ON gifts(rarity_id);

-- Обновление существующих индексов
CREATE INDEX IF NOT EXISTS idx_gifts_rarity_active ON gifts(rarity_id, is_active);