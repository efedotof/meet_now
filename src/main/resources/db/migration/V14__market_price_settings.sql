CREATE TABLE IF NOT EXISTS market_settings (
    id BIGINT PRIMARY KEY DEFAULT 1,
    base_constant INTEGER NOT NULL DEFAULT 1000,
    max_multiplier DOUBLE PRECISION NOT NULL DEFAULT 3.0,
    update_cron VARCHAR(50) NOT NULL DEFAULT '0 0 3 * * *',
    use_median BOOLEAN NOT NULL DEFAULT false,
    last_updated TIMESTAMP
);

ALTER TABLE gifts ADD COLUMN IF NOT EXISTS current_price INTEGER;

INSERT INTO market_settings (id, base_constant, max_multiplier, update_cron, use_median, last_updated)
SELECT 1, 1000, 3.0, '0 0 3 * * *', false, NULL
WHERE NOT EXISTS (SELECT 1 FROM market_settings);