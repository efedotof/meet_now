-- Изменение типа колонок на DOUBLE PRECISION для совместимости с Java Double
ALTER TABLE gift_rarities 
ALTER COLUMN multiplier TYPE DOUBLE PRECISION,
ALTER COLUMN probability TYPE DOUBLE PRECISION;

-- Обновление существующих данных
UPDATE gift_rarities SET 
    multiplier = multiplier::double precision,
    probability = probability::double precision;