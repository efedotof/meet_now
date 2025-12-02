-- Удаляем старые данные для избежания конфликта с новым типом
DELETE FROM answers WHERE question_id IN (
    '11111111-1111-1111-1111-111111111111',
    '22222222-2222-2222-2222-222222222222', 
    '33333333-3333-3333-3333-333333333333'
);

DELETE FROM questions WHERE id IN (
    '11111111-1111-1111-1111-111111111111',
    '22222222-2222-2222-2222-222222222222',
    '33333333-3333-3333-3333-333333333333'
);

-- Удаляем индекс перед изменением типа столбца (опционально, но помогает избежать проблем)
DROP INDEX IF EXISTS idx_questions_status;

-- Удаляем старые значения по умолчанию и изменяем тип столбца status
ALTER TABLE questions 
ALTER COLUMN status DROP DEFAULT;

-- Изменяем тип столбца с ENUM на VARCHAR(50)
ALTER TABLE questions 
ALTER COLUMN status TYPE VARCHAR(50) 
USING status::VARCHAR(50);

-- Устанавливаем новое значение по умолчанию
ALTER TABLE questions 
ALTER COLUMN status SET DEFAULT 'PENDING';

-- Добавляем CHECK constraint для валидации значений
ALTER TABLE questions 
ADD CONSTRAINT status_check 
CHECK (status IN ('PENDING', 'RECEIVED', 'RESOLVED'));

-- Воссоздаем индекс
CREATE INDEX idx_questions_status ON questions(status);

-- Удаляем старый ENUM тип, если он больше не используется
DROP TYPE IF EXISTS question_status;

-- Вставляем тестовые данные с новым типом данных
INSERT INTO questions (id, title, description, status, user_id, created_at, updated_at) VALUES
('11111111-1111-1111-1111-111111111111', 'Проблема с входом в систему', 'Не могу войти в аккаунт, выдает ошибку аутентификации', 'PENDING', (SELECT id FROM users LIMIT 1), NOW(), NOW()),
('22222222-2222-2222-2222-222222222222', 'Не приходят уведомления', 'Перестали приходить push-уведомления о новых сообщениях', 'RECEIVED', (SELECT id FROM users LIMIT 1), NOW(), NOW()),
('33333333-3333-3333-3333-333333333333', 'Вопрос о функциях приложения', 'Как использовать временные чаты?', 'RESOLVED', (SELECT id FROM users LIMIT 1), NOW(), NOW());

INSERT INTO answers (id, question_id, content, created_by, created_at) VALUES
('44444444-4444-4444-4444-444444444444', '33333333-3333-3333-3333-333333333333', 'Временные чаты доступны в разделе "Быстрые встречи". Вы можете начать чат на 5 минут с другим пользователем.', (SELECT id FROM users LIMIT 1), NOW());