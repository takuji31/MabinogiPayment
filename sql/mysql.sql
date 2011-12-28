CREATE TABLE IF NOT EXISTS sessions (
    id           CHAR(72) PRIMARY KEY,
    session_data TEXT
);

CREATE TABLE IF NOT EXISTS payment (
    id          INTEGER UNSIGNED    NOT NULL    PRIMARY KEY,
    `type`      VARCHAR(255)        NOT NULL,
    point       INTEGER UNSIGNED    NOT NULL,
    memo        VARCHAR(255)        NOT NULL,
    created_on  DATE                NOT NULL,
    INDEX (`type`),
    INDEX (point),
    INDEX (memo),
    INDEX (created_on)
);
