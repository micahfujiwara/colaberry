-- Dimension Tables
CREATE TABLE IF NOT EXISTS Weather_Station (
    weather_station_id TEXT PRIMARY KEY,
    region TEXT,
    unique(weather_station_id, region)
);

CREATE TABLE IF NOT EXISTS Date_Dim (
    date_id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE UNIQUE,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    unique (date_id, date, year, month, day)
);

-- Fact Tables
CREATE TABLE IF NOT EXISTS Weather (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date_id INTEGER,
    max_temp INTEGER,
    min_temp INTEGER,
    precipitation INTEGER,
    weather_station_id TEXT,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (date_id) REFERENCES Date_Dim(date_id),
    FOREIGN KEY (weather_station_id) REFERENCES Weather_Station(weather_station_id)
    unique (date_id, max_temp, min_temp, precipitation, weather_station_id, Date_Dim, Weather_Station)
);

CREATE TABLE IF NOT EXISTS Yield_Data (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date_id INTEGER,
    yield_amount INTEGER,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (date_id) REFERENCES Date_Dim(date_id),
    unique (date_id, yield_amount, Date_Dim)
);








####################################

-- Dimension Tables

CREATE TABLE IF NOT EXISTS Date_Dim (
    date_id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE UNIQUE,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(date)
);

-- Fact Tables
CREATE TABLE IF NOT EXISTS Weather (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date_id INTEGER,
    max_temp INTEGER,
    min_temp INTEGER,
    precipitation INTEGER,
    weather_station_id TEXT,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (date_id) REFERENCES Date_Dim(date_id),
    UNIQUE (date_id, weather_station_id)
);

CREATE TABLE IF NOT EXISTS Yield_Data (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date_id INTEGER,
    yield_amount INTEGER,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (date_id) REFERENCES Date_Dim(date_id),
    UNIQUE (date_id, yield_amount)
);
