-- Создание таблицы для истории уведомлений
CREATE TABLE IF NOT EXISTS notification_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    title VARCHAR(255),
    message TEXT,
    notification_type VARCHAR(50) NOT NULL,
    sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    success BOOLEAN NOT NULL DEFAULT false,
    error_message TEXT,
    
    -- Индексы для быстрого поиска
    CONSTRAINT fk_notification_history_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Создание индексов для оптимизации запросов
CREATE INDEX IF NOT EXISTS idx_notification_history_user_id ON notification_history(user_id);
CREATE INDEX IF NOT EXISTS idx_notification_history_sent_at ON notification_history(sent_at);
CREATE INDEX IF NOT EXISTS idx_notification_history_type ON notification_history(notification_type);
CREATE INDEX IF NOT EXISTS idx_notification_history_success ON notification_history(success);
CREATE INDEX IF NOT EXISTS idx_notification_history_user_sent ON notification_history(user_id, sent_at DESC);
CREATE INDEX IF NOT EXISTS idx_notification_history_type_sent ON notification_history(notification_type, sent_at DESC);

-- Комментарии к таблице и колонкам
COMMENT ON TABLE notification_history IS 'История отправки push-уведомлений';
COMMENT ON COLUMN notification_history.id IS 'Уникальный идентификатор записи';
COMMENT ON COLUMN notification_history.user_id IS 'Идентификатор пользователя, которому отправлено уведомление';
COMMENT ON COLUMN notification_history.title IS 'Заголовок уведомления';
COMMENT ON COLUMN notification_history.message IS 'Текст уведомления';
COMMENT ON COLUMN notification_history.notification_type IS 'Тип уведомления (token, user, multicast, data, system)';
COMMENT ON COLUMN notification_history.sent_at IS 'Дата и время отправки уведомления';
COMMENT ON COLUMN notification_history.success IS 'Статус успешности отправки';
COMMENT ON COLUMN notification_history.error_message IS 'Сообщение об ошибке (если отправка не удалась)';

-- Создание функции для очистки старых записей
CREATE OR REPLACE FUNCTION cleanup_old_notifications(days_to_keep INTEGER DEFAULT 90)
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM notification_history 
    WHERE sent_at < (CURRENT_TIMESTAMP - (days_to_keep || ' days')::INTERVAL)
    RETURNING COUNT(*) INTO deleted_count;
    
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Создание представления для статистики уведомлений
CREATE OR REPLACE VIEW notification_statistics_view AS
SELECT 
    DATE(sent_at) as day,
    notification_type,
    success,
    COUNT(*) as count,
    COUNT(DISTINCT user_id) as unique_users
FROM notification_history
GROUP BY DATE(sent_at), notification_type, success
ORDER BY day DESC, notification_type;

-- Создание представления для мониторинга успешности уведомлений
CREATE OR REPLACE VIEW notification_success_rate_view AS
SELECT 
    notification_type,
    COUNT(*) as total_sent,
    SUM(CASE WHEN success THEN 1 ELSE 0 END) as successful,
    SUM(CASE WHEN NOT success THEN 1 ELSE 0 END) as failed,
    ROUND(SUM(CASE WHEN success THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 2) as success_rate_percent
FROM notification_history
GROUP BY notification_type
ORDER BY total_sent DESC;

-- Создание триггера для автоматической очистки старых записей (опционально)
CREATE OR REPLACE FUNCTION notify_cleanup_trigger()
RETURNS TRIGGER AS $$
BEGIN
    -- Автоматически удаляем записи старше 180 дней
    IF (SELECT COUNT(*) FROM notification_history WHERE sent_at < CURRENT_TIMESTAMP - INTERVAL '180 days') > 10000 THEN
        PERFORM cleanup_old_notifications(180);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера, который будет срабатывать при вставке новой записи
CREATE OR REPLACE TRIGGER cleanup_notifications_trigger
AFTER INSERT ON notification_history
EXECUTE FUNCTION notify_cleanup_trigger();