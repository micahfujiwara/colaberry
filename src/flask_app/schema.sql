-- Dimension Tables
CREATE TABLE IF NOT EXISTS Weather_Station (
    weather_station_id TEXT PRIMARY KEY,
    region TEXT
);

CREATE TABLE IF NOT EXISTS Date_Dim (
    date_id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE UNIQUE,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
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
);

CREATE TABLE IF NOT EXISTS Yield_Data (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date_id INTEGER,
    yield_amount INTEGER,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (date_id) REFERENCES Date_Dim(date_id)
);
