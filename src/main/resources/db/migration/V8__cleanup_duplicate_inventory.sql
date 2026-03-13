BEGIN;

WITH duplicates AS (
    SELECT id,
           ROW_NUMBER() OVER (PARTITION BY user_id, gift_id, received_from ORDER BY id) AS rn,
           SUM(quantity) OVER (PARTITION BY user_id, gift_id, received_from) AS total_qty
    FROM user_inventory
)
UPDATE user_inventory ui
SET quantity = duplicates.total_qty
FROM duplicates
WHERE ui.id = duplicates.id AND duplicates.rn = 1;

WITH duplicates AS (
    SELECT id,
           ROW_NUMBER() OVER (PARTITION BY user_id, gift_id, received_from ORDER BY id) AS rn
    FROM user_inventory
)
DELETE FROM user_inventory
WHERE id IN (SELECT id FROM duplicates WHERE rn > 1);

DO $$
DECLARE
    dup_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO dup_count
    FROM (
        SELECT 1
        FROM user_inventory
        GROUP BY user_id, gift_id, received_from
        HAVING COUNT(*) > 1
    ) t;
    
    IF dup_count > 0 THEN
        RAISE EXCEPTION 'Остались дубликаты: %', dup_count;
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'unique_user_gift_from' 
          AND conrelid = 'user_inventory'::regclass
    ) THEN
        ALTER TABLE user_inventory 
        ADD CONSTRAINT unique_user_gift_from UNIQUE (user_id, gift_id, received_from);
    END IF;
END $$;

COMMIT;