CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    firstname VARCHAR(50),
    subname VARCHAR(50),
    description TEXT,
    avatar TEXT,
    city VARCHAR(100),
    age INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified BOOLEAN DEFAULT FALSE,
    is_searchable BOOLEAN DEFAULT TRUE,
    is_online BOOLEAN DEFAULT FALSE,
    floor TEXT,
    is_searching BOOLEAN DEFAULT FALSE,
    game_points INT DEFAULT 0 
);


CREATE TABLE IF NOT EXISTS user_purposes (
    user_id UUID NOT NULL,
    purpose VARCHAR(255) NOT NULL,
    PRIMARY KEY (user_id, purpose),
    CONSTRAINT fk_user_purposes_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS user_interests (
    user_id UUID NOT NULL,
    interest VARCHAR(255) NOT NULL,
    PRIMARY KEY (user_id, interest),
    CONSTRAINT fk_user_interests_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS chats (
    chat_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id1 UUID REFERENCES users(id) ON DELETE CASCADE,
    user_id2 UUID REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_opened BOOLEAN DEFAULT FALSE,
    last_message TEXT
);


CREATE TABLE IF NOT EXISTS temporary_chats (
    temp_chat_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
    recipient_id UUID REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    duration_minutes INT DEFAULT 5,
    is_finished BOOLEAN DEFAULT FALSE,
    both_agreed BOOLEAN DEFAULT FALSE 
);

CREATE TABLE IF NOT EXISTS messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chat_id UUID REFERENCES chats(chat_id) ON DELETE CASCADE,
    sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
    recipient_id UUID REFERENCES users(id) ON DELETE CASCADE,
    temp_chat_id UUID REFERENCES temporary_chats(temp_chat_id) ON DELETE CASCADE,
    text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN NOT NULL DEFAULT false
);



CREATE TABLE IF NOT EXISTS reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reporter_id UUID REFERENCES users(id),
    reported_id UUID REFERENCES users(id),
    reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS icebreakers (
    id BIGSERIAL PRIMARY KEY,
    text TEXT NOT NULL
);


CREATE TABLE IF NOT EXISTS question_of_day (
    id BIGSERIAL PRIMARY KEY,
    question TEXT NOT NULL,
    date DATE UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS chat_constraints (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    temp_chat_id UUID REFERENCES temporary_chats(temp_chat_id) ON DELETE CASCADE,
    wait_seconds INT DEFAULT 30,
    can_start BOOLEAN DEFAULT FALSE
);


CREATE TABLE IF NOT EXISTS chat_games (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chat_id UUID REFERENCES chats(chat_id) ON DELETE CASCADE,
    game_type VARCHAR(100), 
    state TEXT 
);



CREATE TABLE IF NOT EXISTS second_chance (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    temp_chat_id UUID REFERENCES temporary_chats(temp_chat_id),
    sender_decision BOOLEAN,
    recipient_decision BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed BOOLEAN DEFAULT FALSE
);


CREATE TABLE IF NOT EXISTS user_friends (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    friend_id UUID REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, friend_id)
);


CREATE TABLE IF NOT EXISTS global_interests(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS global_purposes(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS user_sessions (
    token VARCHAR(255) PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL
);


CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS user_roles (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id INT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);


CREATE TABLE IF NOT EXISTS sticker_pack (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS sticker (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pack_id UUID NOT NULL REFERENCES sticker_pack(id) ON DELETE CASCADE,
    emoji VARCHAR(100) NOT NULL,
    image_url TEXT NOT NULL,
    UNIQUE (pack_id, emoji) 
);

INSERT INTO roles (role_name) VALUES
('MODERATION'),
('ADMIN'),
('USER')
ON CONFLICT (role_name) DO NOTHING; 


INSERT INTO global_interests (title) VALUES
('Музыка'),
('Спорт'),
('Путешествия'),
('Кино'),
('Книги'),
('Программирование'),
('Фотография'),
('Искусство'),
('Кулинария'),
('Игры'),
('Наука'),
('Технологии'),
('Мода'),
('Автомобили'),
('Природа'),
('Йога'),
('Танцы'),
('История'),
('Психология'),
('Инвестиции'),
('Творчество'),
('Театр'),
('Рыбалка'),
('Садоводство'),
('Астрология'),
('Блоггинг'),
('Горные лыжи'),
('Сноуборд'),
('Серфинг'),
('Дайвинг'),
('Велоспорт'),
('Бег'),
('Футбол'),
('Баскетбол'),
('Теннис'),
('Шахматы'),
('Коллекционирование'),
('Рисование'),
('Поэзия'),
('Пение'),
('Барбекю'),
('Дегустация вин'),
('Кофе'),
('Чай'),
('Флористика'),
('Дизайн интерьера'),
('Архитектура'),
('Авиация'),
('Астрономия'),
('Космос'),
('Робототехника'),
('Дроны'),
('Гейминг'),
('VR'),
('Киберспорт'),
('Криптовалюты'),
('Трейдинг'),
('Недвижимость'),
('Маркетинг'),
('Стартапы'),
('Медитация'),
('ЗОЖ'),
('Фитнес'),
('Бокс'),
('Единоборства'),
('Скалолазание'),
('Походы'),
('Кемпинг'),
('Яхтинг'),
('Татуировки'),
('Мотоциклы'),
('Подкасты'),
('Юмор'),
('Паркур'),
('Фехтование'),
('Стрельба'),
('Бильярд'),
('Пазлы'),
('Каллиграфия'),
('Оригами'),
('Моделизм'),
('Вышивание'),
('Вязание'),
('Гончарство'),
('Деревообработка'),
('Электроника'),
('Философия'),
('Эзотерика'),
('Нумерология'),
('Реставрация'),
('Парфюмерия'),
('Визаж'),
('Стрит-арт'),
('Граффити'),
('Фуд-фотография'),
('Веганство'),
('Сыроварение'),
('Пивоварение'),
('Консервация'),
('Социальные сети'),
('Стриминг'),
('Мемы'),
('Комиксы'),
('Манга'),
('Аниме'),
('К-поп'),
('Караоке'),
('Альпинизм'),
('Рафтинг'),
('Каякинг'),
('Фридайвинг'),
('Скейтбординг'),
('Ролики'),
('Гольф'),
('Пейнтбол'),
('Лазертаг'),
('Настольные игры'),
('Ролевые игры'),
('Аюрведа'),
('Биохакинг'),
('Фриланс'),
('Волонтерство'),
('Благотворительность'),
('Экотуризм'),
('Саморазвитие'),
('Изучение языков'),
('Фокусы'),
('Жонглирование'),
('Поиск кладов'),
('Археология'),
('Фантастика'),
('Фэнтези'),
('Ужасы'),
('Детективы'),
('Биографии'),
('Животные'),
('Аквариумистика'),
('Фермерство'),
('Пчеловодство'),
('Винтаж'),
('Антиквариат'),
('Нумизматика'),
('Скрапбукинг'),
('Мыловарение'),
('Свечеварение'),
('Пилатес'),
('Стретчинг'),
('Айкидо'),
('Карате'),
('Тхэквондо'),
('Брейкданс'),
('Танго'),
('Фламенко'),
('Боди-арт'),
('Веб-дизайн'),
('Геймдизайн'),
('Анимация'),
('Ди-джеинг'),
('Битбокс'),
('Электронная музыка'),
('Рок'),
('Метал'),
('Джаз'),
('Хип-хоп'),
('Регги'),
('Классическая музыка'),
('Мишлен'),
('Молекулярная гастрономия'),
('Средиземноморская кухня'),
('Японская кухня'),
('Китайская кухня'),
('Мексиканская кухня'),
('Веганская кухня'),
('Кондитерское дело'),
('Шоколатье'),
('Крафтовое пиво'),
('Коктейли'),
('Виски'),
('Сомелье'),
('Баня'),
('Сауна'),
('Ароматерапия'),
('Косметика'),
('Прически'),
('Татуировки'),
('Часы'),
('Украшения'),
('Живопись'),
('Скульптура'),
('Комиксы'),
('Иллюстрация'),
('Каллиграфия'),
('Поэзия')
ON CONFLICT (title) DO NOTHING;


INSERT INTO global_purposes (title) VALUES
('Дружба'),
('Отношения'),
('Общение'),
('Спорт'),
('Путешествия'),
('Обучение'),
('Наставничество'),
('Проекты'),
('Команда'),
('Поддержка'),
('Хобби'),
('Свидания'),
('Игры'),
('Творчество'),
('Флирт'),
('Бизнес'),
('Коворкинг'),
('Волонтерство'),
('Прогулки'),
('Мероприятия'),
('Йога'),
('Танцы'),
('Музыка'),
('Кулинария'),
('Языки'),
('Отдых'),
('Единомышленники'),
('Автопутешествия'),
('Выставки'),
('Философия'),
('Чтение'),
('Кино'),
('Садоводство'),
('Развитие'),
('Медитация'),
('Рыбалка'),
('Походы'),
('Велоспорт'),
('Фотография'),
('Шопинг'),
('Семья'),
('Животные'),
('Коллекционирование'),
('Книги'),
('Подкасты'),
('Блог'),
('Квесты'),
('Спа'),
('Катание'),
('Плавание'),
('Шахматы'),
('Головоломки'),
('Марафоны'),
('Донорство'),
('Астрономия'),
('Экология'),
('Флешмобы'),
('Программирование'),
('Дизайн'),
('Маркетинг'),
('Инвестиции'),
('Благотворительность'),
('Коучинг'),
('Вебинары'),
('Курсы'),
('Исследования'),
('Конференции'),
('Фестивали'),
('Концерты'),
('Театр'),
('Караоке'),
('Рисование'),
('Ремесла'),
('Виноделие'),
('Пивоварение'),
('Барбекю'),
('Этикет'),
('Ораторское'),
('Актерское'),
('Боевые искусства'),
('Самооборона'),
('Выживание'),
('Психология'),
('История'),
('Литература'),
('Поэзия'),
('Математика'),
('Физика'),
('Биология'),
('Робототехника'),
('ИИ'),
('VR'),
('Блокчейн'),
('Криптовалюты'),
('Архитектура'),
('Нумерология'),
('Астрология'),
('Реинкарнация'),
('Ментальное здоровье'),
('Лидерство'),
('Тайм-менеджмент'),
('Стартапы'),
('Гостеприимство'),
('Мода'),
('Медиа'),
('Event-менеджмент'),
('Кризис-менеджмент')
ON CONFLICT (title) DO NOTHING;
