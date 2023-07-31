-- 
CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT NOT NULL);
-- 
SELECT *
FROM users;
-- 
SELECT *
FROM users
WHERE users.id >= :minId;
-- 
INSERT INTO users(id, name)
VALUES (1, 'name1'),
    (2, :c);
-- {"name":"updateUserName"}
UPDATE users
SET name = :name
WHERE :id = id
RETURNING *;
-- {"name":"deleteUsersById"}
DELETE FROM users
WHERE id IN (:ids);
-- 
CREATE TABLE posts (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    title TEXT NOT NULL,
    subtitle TEXT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
-- 
CREATE TABLE topics (
    code VARCHAR(512) PRIMARY KEY,
    priority INT default 0,
    description TEXT
);
-- 
CREATE TABLE posts_topics (
    topic_code VARCHAR(512) REFERENCES topics(code),
    post_id INTEGER REFERENCES posts(id),
    PRIMARY KEY(topic_code, post_id)
);
-- 
SELECT users.id,
    users.name user_name,
    pt.topic_code,
    posts.*
FROM users
    INNER JOIN posts ON posts.user_id = users.id
    LEFT JOIN posts_topics pt ON pt.post_id = posts.id
WHERE users.id = 1
    and posts.subtitle is not null;
-- {"name":"usersWithPosts"}
SELECT users.id,
    users.name user_name,
    json_group_array(
        json_object(
            'id',
            posts.id,
            'user_id',
            posts.user_id,
            'title',
            posts.title,
            'subtitle',
            posts.subtitle,
            'body',
            posts.body,
            'created_at',
            posts.created_at,
            'topics',
            json_array(pt.topic_code)
        )
    ) posts
FROM users
    INNER JOIN posts ON posts.user_id = users.id
    LEFT JOIN posts_topics pt ON pt.post_id = posts.id
WHERE posts.subtitle is not null
GROUP BY users.id;
-- {"name":"usersWithPostsJSON"}
SELECT users.id,
    users.name user_name,
    json_group_array(p.json_value) posts
FROM users
    INNER JOIN posts_with_topics_json p ON p.user_id = users.id
GROUP BY users.id;
-- 
CREATE VIEW posts_with_topics_json AS
SELECT posts.id,
    posts.user_id,
    json_object(
        'id',
        posts.id,
        'user_id',
        posts.user_id,
        'title',
        posts.title,
        'subtitle',
        posts.subtitle,
        'body',
        posts.body,
        'created_at',
        posts.created_at,
        'topics',
        json_group_array(pt.topic_code)
    ) json_value
FROM posts
    LEFT JOIN posts_topics pt ON pt.post_id = posts.id
GROUP BY posts.id;
--
DELETE FROM users WHERE (id = ?) RETURNING id,name;