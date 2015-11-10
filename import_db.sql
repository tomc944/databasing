DROP TABLE IF EXISTS users;

CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  reply_id INTEGER,
  user_id INTEGER NOT NULL,
  body VARCHAR(255) NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id), -- come back to 'NOT NULL'
  FOREIGN KEY (reply_id) REFERENCES replies(id), -- Can be null, come back to 'IF EXISTS'
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Waldo', 'Claiborne'),
  ('Ryan', 'Samp');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Who?', 'Who did it?', 2),
  ('Why not?', 'Why didnt I do it', 1);

INSERT INTO
  question_follows (question_id, user_id)
VALUES
  (1, 1),
  (1, 2),
  (2, 1);

INSERT INTO
  replies (question_id, reply_id, user_id, body)
VALUES
  (1, NULL, 1, 'I dont know man'),
  (1, 1, 2, 'It was Waldo!'),
  (2, NULL, 2, 'Wheres WALDO?!'),
  (2, 3, 1, 'Im right here, duh');

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (1, 1),
  (2, 2);
