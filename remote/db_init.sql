-- Create Tables
CREATE TABLE IF NOT EXISTS regions (
    region_oid INT PRIMARY KEY,
    region_name VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS cities (
    city_oid INT PRIMARY KEY,
    region_oid INT NOT NULL,
    city_name VARCHAR(255) NOT NULL,
    geojson JSON,
    FOREIGN KEY (region_oid) REFERENCES regions(region_oid)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS city_sections (
    section_id INT PRIMARY KEY,
    region_oid INT NOT NULL,
    city_oid INT NOT NULL,
    section_name VARCHAR(255) NOT NULL,
    area_km2 FLOAT NOT NULL,
    FOREIGN KEY (region_oid) REFERENCES regions(region_oid),
    FOREIGN KEY (city_oid) REFERENCES cities(city_oid)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS satellites (
    satellite_oid INT PRIMARY KEY,
    satellite_name VARCHAR(255) NOT NULL,
    signal_strength INT NOT NULL,
    coverage_radius INT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS satellite_frequencies (
    freq_id INT PRIMARY KEY,
    satellite_oid INT NOT NULL,
    frequency INT NOT NULL,
    FOREIGN KEY (satellite_oid) REFERENCES satellites(satellite_oid)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS satellite_antennas (
    antenna_id INT PRIMARY KEY,
    satellite_oid INT NOT NULL,
    antenna_type VARCHAR(255) NOT NULL,
    power_output INT NOT NULL,
    FOREIGN KEY (satellite_oid) REFERENCES satellites(satellite_oid)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS antenna_configurations (
    config_id INT PRIMARY KEY,
    satellite_oid INT NOT NULL,
    antenna_id INT NOT NULL,
    polarization VARCHAR(255) NOT NULL,
    beam_width INT NOT NULL,
    FOREIGN KEY (satellite_oid) REFERENCES satellites(satellite_oid),
    FOREIGN KEY (antenna_id) REFERENCES satellite_antennas(antenna_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS region_satellites (
    region_oid INT NOT NULL,
    satellite_oid INT NOT NULL,
    PRIMARY KEY (region_oid, satellite_oid),
    FOREIGN KEY (region_oid) REFERENCES regions(region_oid),
    FOREIGN KEY (satellite_oid) REFERENCES satellites(satellite_oid)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS city_satellites (
    region_oid INT NOT NULL,
    city_oid INT NOT NULL,
    satellite_oid INT NOT NULL,
    PRIMARY KEY (region_oid, city_oid, satellite_oid),
    FOREIGN KEY (region_oid) REFERENCES regions(region_oid),
    FOREIGN KEY (city_oid) REFERENCES cities(city_oid),
    FOREIGN KEY (satellite_oid) REFERENCES satellites(satellite_oid)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS section_satellites (
    region_oid INT NOT NULL,
    section_id INT NOT NULL,
    satellite_oid INT NOT NULL,
    config_id INT NOT NULL,
    PRIMARY KEY (region_oid, section_id, satellite_oid),
    FOREIGN KEY (region_oid) REFERENCES regions(region_oid),
    FOREIGN KEY (section_id) REFERENCES city_sections(section_id),
    FOREIGN KEY (satellite_oid) REFERENCES satellites(satellite_oid),
    FOREIGN KEY (config_id) REFERENCES antenna_configurations(config_id)
) ENGINE=InnoDB;


-- Insert Data
INSERT INTO regions (region_oid, region_name) VALUES
(1, 'North America'),
(2, 'Europe');

INSERT INTO cities (city_oid, region_oid, city_name, geojson) VALUES
(101, 1, 'Dallas', '{}'),
(102, 1, 'New York', '{}'),
(201, 2, 'London', '{}'),
(202, 2, 'Paris', '{}');

INSERT INTO city_sections (section_id, region_oid, city_oid, section_name, area_km2) VALUES
(1001, 1, 101, 'Downtown', 5),
(1002, 1, 101, 'Uptown', 8),
(1003, 1, 102, 'Brooklyn', 12),
(2001, 2, 201, 'Westminster', 6),
(2002, 2, 202, 'Montmartre', 9);

INSERT INTO satellites (satellite_oid, satellite_name, signal_strength, coverage_radius) VALUES
(5001, 'SatCom-Alpha', 50, 1000),
(5002, 'SatCom-Beta', 45, 800);

INSERT INTO satellite_frequencies (freq_id, satellite_oid, frequency) VALUES
(2001, 5001, 2400),
(2002, 5001, 1800),
(2003, 5002, 2500),
(2004, 5002, 2100);

INSERT INTO satellite_antennas (antenna_id, satellite_oid, antenna_type, power_output) VALUES
(3001, 5001, 'High-Gain', 500),
(3002, 5001, 'Medium-Gain', 300),
(3003, 5002, 'Low-Gain', 250),
(3004, 5002, 'Phased Array', 600);

INSERT INTO antenna_configurations (config_id, satellite_oid, antenna_id, polarization, beam_width) VALUES
(4001, 5001, 3001, 'Vertical', 30),
(4002, 5001, 3002, 'Horizontal', 45),
(4003, 5002, 3003, 'Circular', 60),
(4004, 5002, 3004, 'Dual', 70);

INSERT INTO region_satellites (region_oid, satellite_oid) VALUES
(1, 5001),
(1, 5002),
(2, 5001),
(2, 5002);

INSERT INTO city_satellites (region_oid, city_oid, satellite_oid) VALUES
(1, 101, 5001),
(1, 102, 5001),
(2, 201, 5002),
(2, 202, 5002);

INSERT INTO section_satellites (region_oid, section_id, satellite_oid, config_id) VALUES
(1, 1001, 5001, 4001),
(1, 1002, 5001, 4002),
(2, 2001, 5002, 4003),
(2, 2002, 5002, 4004);
