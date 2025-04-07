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
