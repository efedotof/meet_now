ALTER TABLE free_search_usage ADD COLUMN IF NOT EXISTS used_date DATE;
UPDATE free_search_usage SET used_date = CAST(used_at AS DATE) WHERE used_date IS NULL;
ALTER TABLE free_search_usage ALTER COLUMN used_date SET NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS unique_free_search_per_day ON free_search_usage(user_id, used_date);