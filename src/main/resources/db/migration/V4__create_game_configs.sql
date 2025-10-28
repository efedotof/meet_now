CREATE TABLE IF NOT EXISTS game_configs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_type VARCHAR(255) UNIQUE NOT NULL,
    game_url TEXT NOT NULL,
    score_multiplier NUMERIC(5,2) DEFAULT 0.05,
    game_name VARCHAR(255) NOT NULL,
    game_description TEXT,
    thumbnail_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO game_configs (game_type, game_url, score_multiplier, game_name, game_description, thumbnail_url, is_active) VALUES
('clicker', 'https://games.mnapp.ru/clicker/', 1.00, 'Clicker Game', 'Увлекательная кликер игра', 'https://games.mnapp.ru/thumbnails/clicker.jpg', true),
('space_defender', 'https://games.mnapp.ru/space_defender/', 1.50, 'Space Defender', 'Защищайте космос от врагов', 'https://games.mnapp.ru/thumbnails/space_defender.jpg', true),
('star_catcher', 'https://games.mnapp.ru/star_catcher/', 0.80, 'Star Catcher', 'Ловите падающие звезды', 'https://games.mnapp.ru/thumbnails/star_catcher.jpg', true),
('treasure_maze', 'https://games.mnapp.ru/treasure_maze/', 2.00, 'Treasure Maze', 'Найдите сокровища в лабиринте', 'https://games.mnapp.ru/thumbnails/treasure_maze.jpg', true);