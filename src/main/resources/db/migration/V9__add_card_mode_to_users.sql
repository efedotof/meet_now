ALTER TABLE users ADD COLUMN is_card_mode BOOLEAN DEFAULT FALSE;


INSERT INTO roles (role_name) VALUES ('PREMIUM') ON CONFLICT (role_name) DO NOTHING;

CREATE TABLE matches (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user1_id    UUID NOT NULL,
    user2_id    UUID NOT NULL,
    matched_at  TIMESTAMP NOT NULL DEFAULT now(),
    CONSTRAINT matches_user1_user2_unique UNIQUE (user1_id, user2_id)
);

CREATE TABLE swipes (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    swiper_id   UUID NOT NULL,
    target_id   UUID NOT NULL,
    action      VARCHAR(10) NOT NULL CHECK (action IN ('LIKE', 'DISLIKE')),
    created_at  TIMESTAMP NOT NULL DEFAULT now(),
    CONSTRAINT swipes_swiper_target_unique UNIQUE (swiper_id, target_id)
);

ALTER TABLE matches
    ADD CONSTRAINT fk_matches_user1 FOREIGN KEY (user1_id) REFERENCES users (id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_matches_user2 FOREIGN KEY (user2_id) REFERENCES users (id) ON DELETE CASCADE;

ALTER TABLE swipes
    ADD CONSTRAINT fk_swipes_swiper FOREIGN KEY (swiper_id) REFERENCES users (id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_swipes_target FOREIGN KEY (target_id) REFERENCES users (id) ON DELETE CASCADE;

CREATE INDEX idx_matches_user1 ON matches (user1_id);
CREATE INDEX idx_matches_user2 ON matches (user2_id);
CREATE INDEX idx_swipes_swiper ON swipes (swiper_id);
CREATE INDEX idx_swipes_target ON swipes (target_id);