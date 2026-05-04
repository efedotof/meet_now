CREATE TABLE news (
    id BIGSERIAL PRIMARY KEY,
    image_url VARCHAR(512) NOT NULL,
    action_url VARCHAR(512),
    title VARCHAR(255),
    description TEXT,
    sort_order INT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

COMMENT ON TABLE news IS 'Баннеры / новости для отображения';
COMMENT ON COLUMN news.image_url IS 'Ссылка на изображение';
COMMENT ON COLUMN news.action_url IS 'Ссылка для перехода при клике';
COMMENT ON COLUMN news.sort_order IS 'Порядок сортировки';
COMMENT ON COLUMN news.is_active IS 'Активен ли баннер для отображения';