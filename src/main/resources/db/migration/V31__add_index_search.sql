CREATE INDEX idx_users_search_fast
ON users (is_online, is_searchable, is_searching);

CREATE INDEX idx_users_age ON users (age);
CREATE INDEX idx_users_city ON users (city);
CREATE INDEX idx_users_floor ON users (floor);


CREATE INDEX idx_user_interests_user ON user_interests(user_id, interest);
CREATE INDEX idx_user_purposes_user ON user_purposes(user_id, purpose);
