CREATE TABLE operator (
    operator_id SERIAL,
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    patronymic VARCHAR(50),
    military_rank VARCHAR(50),
    phone_number VARCHAR(20),
    email VARCHAR(100),
    CONSTRAINT pk_operator PRIMARY KEY (operator_id)
);

CREATE TABLE drone (
    drone_id SERIAL,
    serial_number VARCHAR(100) UNIQUE NOT NULL,
    model VARCHAR(100),
    status VARCHAR(50),
    operator_id INTEGER,
    CONSTRAINT pk_drone PRIMARY KEY (drone_id),
    CONSTRAINT fk_drone_operator FOREIGN KEY (operator_id)
        REFERENCES operator(operator_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE operation_zone (
    zone_id SERIAL,
    zone_name VARCHAR(100),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    radius_meters INTEGER,
    CONSTRAINT pk_zone PRIMARY KEY (zone_id)
);

CREATE TABLE mission (
    mission_id SERIAL,
    drone_id INTEGER,
    zone_id INTEGER,
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    status VARCHAR(50),
    CONSTRAINT pk_mission PRIMARY KEY (mission_id),
    CONSTRAINT fk_mission_drone FOREIGN KEY (drone_id)
        REFERENCES drone(drone_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_mission_zone FOREIGN KEY (zone_id)
        REFERENCES operation_zone(zone_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE telemetry (
    telemetry_id SERIAL,
    mission_id INTEGER,
    timestamp TIMESTAMP,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    altitude_meters INTEGER,
    battery_level_percent INTEGER,
    signal_strength_percent INTEGER,
    CONSTRAINT pk_telemetry PRIMARY KEY (telemetry_id),
    CONSTRAINT fk_telemetry_mission FOREIGN KEY (mission_id)
        REFERENCES mission(mission_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- 1. Видалення зв'язку між таблицями 
ALTER TABLE drone
DROP CONSTRAINT fk_drone_operator;

-- 2., 3. Внесення змін до таблиці mission

-- Видалення поля
ALTER TABLE mission
DROP COLUMN status;
-- Зміна типу поля
ALTER TABLE mission
ALTER COLUMN start_date TYPE DATE;
-- Зміна назви поля
ALTER TABLE mission
RENAME COLUMN end_date TO completed_at;

-- 4. Додавання поля та обмеження його унікальності в таблиці operator

-- Додавання поля
ALTER TABLE operator
ADD COLUMN personal_code VARCHAR(20);
-- Обмеження унікальності
ALTER TABLE operator
ADD CONSTRAINT unique_personal_code UNIQUE (personal_code);

-- 5. Зміна типу обмеження цілісності зв’язку в таблиці mission із operation_zone 
ALTER TABLE mission DROP CONSTRAINT fk_mission_zone;

ALTER TABLE mission ADD CONSTRAINT fk_mission_zone
FOREIGN KEY (zone_id)
REFERENCES operation_zone(zone_id)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Лабораторна робота №4 --

--Одиночне додавання: 
INSERT INTO operator (last_name, first_name, patronymic, military_rank, phone_number, email, personal_code)
VALUES ('Шевченко', 'Андрій', 'Іванович', 'Майор', '+380501234567', 'andriy.shevchenko@army.ua', 'OP12345');

-- Групове додавання:
INSERT INTO operator (last_name, first_name, patronymic, military_rank, phone_number, email, personal_code)
VALUES
('Ковальчук', 'Олег', 'Сергійович', 'Старший лейтенант', '+380673456789', 'oleg.k@army.ua', 'OP12346'),
('Мельник', 'Ірина', 'Василівна', 'Капітан', '+380931112233', 'iryna.m@army.ua', 'OP12347');

INSERT INTO drone (serial_number, model, status, operator_id)
VALUES
('DR-0001', 'Mavic Air 2', 'Активний', 1),
('DR-0002', 'DJI Phantom 4', 'В ремонті', 2);

INSERT INTO operation_zone (zone_name, latitude, longitude, radius_meters)
VALUES
('Зона Альфа', 48.450001, 34.983333, 1000),
('Зона Браво', 49.233334, 28.466667, 800);

INSERT INTO mission (drone_id, zone_id, start_date, completed_at)
VALUES
(1, 1, '2025-04-07', '2025-04-07'),
(2, 2, '2025-04-06', '2025-04-06');

INSERT INTO telemetry (mission_id, timestamp, latitude, longitude, altitude_meters, battery_level_percent, signal_strength_percent)
VALUES
(1, '2025-04-07 10:00:00', 48.450002, 34.983334, 100, 95, 90),
(1, '2025-04-07 10:05:00', 48.450003, 34.983335, 110, 93, 89),
(2, '2025-04-06 12:00:00', 49.233335, 28.466668, 120, 88, 85);

-- Оновлення одного поля за умовою
UPDATE drone
SET status = 'Активний'
WHERE status = 'В ремонті';
-- Оновлення кількох полів за умовою
UPDATE operator
SET military_rank = 'Капітан',
    email = 'new_email@army.ua'
WHERE operator_id = 2;
-- Змінення значення полів для всіх операторів з певним званням
UPDATE operator
SET military_rank = 'Старший сержант'
WHERE military_rank = 'Сержант';
-- Оновлення battery_level і signal_strength якщо дрон летів високо
UPDATE telemetry
SET battery_level_percent = battery_level_percent - 10,
    signal_strength_percent = signal_strength_percent - 15
WHERE altitude_meters > 1000;

-- Видалення одного з полів таблиці operator
DELETE FROM operator
WHERE operator_id = 5;
-- Видалення всіх даних з таблиці
DELETE FROM drone;






