CREATE DATABASE man

CREATE TABLE users (
  id SERIAL4 PRIMARY KEY,
  firstname varchar(400),
  lastname varchar(400),
  email varchar(400),
  password_digest varchar(400)
);
