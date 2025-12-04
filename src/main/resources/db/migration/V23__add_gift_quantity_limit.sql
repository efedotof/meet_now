-- Migration: V23__add_gift_quantity_limit.sql
-- Добавление ограниченных подарков с количеством

-- Добавляем новые поля в таблицу gifts
ALTER TABLE gifts 
ADD COLUMN IF NOT EXISTS available_quantity INTEGER,
ADD COLUMN IF NOT EXISTS is_limited BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS is_sold_out BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS initial_quantity INTEGER,
ADD COLUMN IF NOT EXISTS sold_count INTEGER DEFAULT 0;


CREATE INDEX IF NOT EXISTS idx_gifts_limited ON gifts(is_limited, is_sold_out, available_quantity);


CREATE INDEX IF NOT EXISTS idx_gifts_sold_count ON gifts(sold_count);

UPDATE gifts SET 
    is_limited = FALSE,
    is_sold_out = FALSE,
    available_quantity = NULL,
    initial_quantity = NULL,
    sold_count = 0
WHERE is_limited IS NULL;


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


DROP TRIGGER IF EXISTS trg_update_gift_sold_out ON gifts;
CREATE TRIGGER trg_update_gift_sold_out
    BEFORE INSERT OR UPDATE ON gifts
    FOR EACH ROW
    EXECUTE FUNCTION update_gift_sold_out_status();


CREATE OR REPLACE FUNCTION decrease_gift_quantity(gift_id_param UUID, quantity_param INTEGER)
RETURNS INTEGER AS $$
DECLARE
    current_quantity INTEGER;
    updated_quantity INTEGER;
BEGIN

    SELECT available_quantity INTO current_quantity 
    FROM gifts 
    WHERE id = gift_id_param FOR UPDATE;
    

    IF NOT FOUND THEN
        RETURN 0;
    END IF;
    

    IF (SELECT is_limited FROM gifts WHERE id = gift_id_param) = FALSE THEN
        RETURN 1;
    END IF;
    

    IF current_quantity IS NULL THEN
        RETURN 1;
    END IF;
    

    IF current_quantity < quantity_param THEN
        RETURN 0;
    END IF;
    

    updated_quantity := current_quantity - quantity_param;
    
    UPDATE gifts 
    SET available_quantity = updated_quantity,
        sold_count = sold_count + quantity_param
    WHERE id = gift_id_param;
    
    RETURN 1;
END;
$$ LANGUAGE plpgsql;


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

-- Индексы для таблицы истории покупок
CREATE INDEX IF NOT EXISTS idx_gift_purchase_user ON gift_purchase_history(user_id);
CREATE INDEX IF NOT EXISTS idx_gift_purchase_gift ON gift_purchase_history(gift_id);
CREATE INDEX IF NOT EXISTS idx_gift_purchase_date ON gift_purchase_history(purchased_at);
CREATE INDEX IF NOT EXISTS idx_gift_purchase_type ON gift_purchase_history(purchase_type);

-- Добавляем комментарии к новым полям
COMMENT ON COLUMN gifts.available_quantity IS 'Доступное количество для покупки (NULL = неограниченно)';
COMMENT ON COLUMN gifts.is_limited IS 'Флаг лимитированного подарка';
COMMENT ON COLUMN gifts.is_sold_out IS 'Флаг, что подарок распродан';
COMMENT ON COLUMN gifts.initial_quantity IS 'Начальное количество для лимитированных подарков';
COMMENT ON COLUMN gifts.sold_count IS 'Количество проданных экземпляров';

-- Вставляем примеры лимитированных подарков (опционально)
INSERT INTO gifts (name, description, image_url, gift_type_id, cost_points, is_active, rarity_id, is_limited, available_quantity, initial_quantity) 
SELECT 
    'Лимитированная коллекционная открытка',
    'Эксклюзивная коллекционная открытка, только 100 экземпляров',
    'https://s3.ru1.storage.beget.cloud/e65bd570b6c1-meetnow/gifts/limited/limited_postcard.png',
    gt.id,
    100,
    TRUE,
    gr.id,
    TRUE,
    100,
    100
FROM gift_types gt
CROSS JOIN gift_rarities gr
WHERE gt.type_name = 'Открытка' AND gr.name = 'RARE'
ON CONFLICT DO NOTHING;