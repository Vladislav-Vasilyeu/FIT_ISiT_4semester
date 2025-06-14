--1--
CREATE TABLE T_RANGE (
    id      NUMBER PRIMARY KEY,
    name    VARCHAR2(50),
    score   NUMBER
)
PARTITION BY RANGE (score) (
    PARTITION p_low VALUES LESS THAN (50),
    PARTITION p_medium VALUES LESS THAN (80),
    PARTITION p_high VALUES LESS THAN (MAXVALUE)
);

--2--
CREATE TABLE T_INTERVAL (
    id        NUMBER PRIMARY KEY,
    name      VARCHAR2(50),
    reg_date  DATE
)
PARTITION BY RANGE (reg_date)
INTERVAL (NUMTOYMINTERVAL(1, 'MONTH')) -- интервал в 1 месяц
(
    PARTITION p_start VALUES LESS THAN (DATE '2024-01-01')
);




--3--
CREATE TABLE T_HASH (
    id         NUMBER PRIMARY KEY,
    category   VARCHAR2(30),
    value      NUMBER
)
PARTITION BY HASH (category)
PARTITIONS 4;

--4--
CREATE TABLE T_LIST (
    id        NUMBER PRIMARY KEY,
    region    CHAR(2),
    data_val  VARCHAR2(100)
)
PARTITION BY LIST (region) (
    PARTITION p_north VALUES ('N'),
    PARTITION p_south VALUES ('S'),
    PARTITION p_east  VALUES ('E'),
    PARTITION p_other VALUES (DEFAULT)
);



INSERT INTO T_RANGE VALUES (1, 'LowScore', 40);    -- p_low
INSERT INTO T_RANGE VALUES (2, 'MedScore', 70);    -- p_medium
INSERT INTO T_RANGE VALUES (3, 'HighScore', 90);   -- p_high

INSERT INTO T_INTERVAL VALUES (1, 'OldUser', DATE '2023-12-01'); -- p_start
INSERT INTO T_INTERVAL VALUES (2, 'MidUser', DATE '2024-01-15'); -- секция 2024-01-01 → 2024-02-01
INSERT INTO T_INTERVAL VALUES (3, 'NewUser', DATE '2024-03-10'); -- секция 2024-03-01 → 2024-04-01

INSERT INTO T_HASH VALUES (1, 'A', 100);
INSERT INTO T_HASH VALUES (2, 'B', 200);
INSERT INTO T_HASH VALUES (3, 'C', 300);
-- попадут в разные секции (p1..p4)

INSERT INTO T_LIST VALUES (1, 'N', 'Data North');  -- p_north
INSERT INTO T_LIST VALUES (2, 'S', 'Data South');  -- p_south
INSERT INTO T_LIST VALUES (3, 'Z', 'Data Other');  -- p_other (DEFAULT)

-- Посмотреть все строки
SELECT * FROM T_RANGE;
SELECT * FROM T_INTERVAL;
SELECT * FROM T_HASH;
SELECT * FROM T_LIST;

-- Посмотреть сами секции
SELECT table_name, partition_name, high_value
FROM user_tab_partitions
WHERE table_name IN ('T_RANGE', 'T_INTERVAL', 'T_HASH', 'T_LIST');


--6
ALTER TABLE T_RANGE ENABLE ROW MOVEMENT;
ALTER TABLE T_INTERVAL ENABLE ROW MOVEMENT;
ALTER TABLE T_HASH ENABLE ROW MOVEMENT;
ALTER TABLE T_LIST ENABLE ROW MOVEMENT;

SELECT id, name, score FROM T_RANGE ORDER BY id;
UPDATE T_RANGE SET score = 60 WHERE id = 1;
SELECT * FROM T_RANGE PARTITION (p_low);
SELECT * FROM T_RANGE PARTITION (p_medium);

SELECT id, name, reg_date FROM T_INTERVAL ORDER BY id;
UPDATE T_INTERVAL SET reg_date = DATE '2024-02-01' WHERE id = 1;
SELECT * FROM T_INTERVAL PARTITION FOR (DATE '2023-12-01');
SELECT * FROM T_INTERVAL PARTITION FOR (DATE '2024-02-01');

SELECT id, category, value FROM T_HASH ORDER BY id;
UPDATE T_HASH SET category = 'D' WHERE id = 1;
SELECT * FROM T_HASH WHERE category = 'A';
SELECT * FROM T_HASH WHERE category = 'D';

SELECT id, region, data_val FROM T_LIST ORDER BY id;
UPDATE T_LIST SET region = 'S' WHERE id = 1;
SELECT * FROM T_LIST PARTITION (p_north);
SELECT * FROM T_LIST PARTITION (p_south);

ALTER TABLE T_RANGE
MERGE PARTITIONS p_medium, p_high INTO PARTITION p_medium_high;

SELECT partition_name, high_value
FROM user_tab_partitions
WHERE table_name = 'T_RANGE';

ALTER TABLE T_RANGE
SPLIT PARTITION p_medium_high AT (80)
INTO (
    PARTITION p_medium,
    PARTITION p_high
);

SELECT partition_name, high_value
FROM user_tab_partitions
WHERE table_name = 'T_RANGE';


CREATE TABLE T_TEMP_EAST (
    id        NUMBER PRIMARY KEY,
    region    CHAR(2),
    data_val  VARCHAR2(100)
);

INSERT INTO T_TEMP_EAST VALUES (1001, 'E', 'EXCHANGE DATA 1');
INSERT INTO T_TEMP_EAST VALUES (1002, 'E', 'EXCHANGE DATA 2');
COMMIT;


ALTER TABLE T_LIST
EXCHANGE PARTITION p_east
WITH TABLE T_TEMP_EAST
WITHOUT VALIDATION;

SELECT * FROM T_LIST PARTITION (p_east);
SELECT * FROM T_TEMP_EAST;

SELECT table_name
FROM user_part_tables;

SELECT table_name, partition_name, high_value
FROM user_tab_partitions
WHERE table_name = 'T_RANGE';

SELECT *
FROM T_RANGE PARTITION (P_LOW);

SELECT *
FROM T_LIST PARTITION (P_NORTH);


