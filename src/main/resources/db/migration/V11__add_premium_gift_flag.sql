INSERT INTO gift_types (type_name, description)
VALUES ('PREMIUM', 'Подарок, дающий премиум-статус получателю')
ON CONFLICT (type_name) DO NOTHING;
