
-- Create Regions Table
CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(100) NOT NULL
);

-- Insert Regions
INSERT INTO regions VALUES (1, 'North America'), (2, 'Europe');

-- Create Cities Table
CREATE TABLE cities (
    city_id INT PRIMARY KEY,
    region_id INT NOT NULL,
    city_name VARCHAR(100) NOT NULL,
    geojson TEXT,
    FOREIGN KEY (region_id) REFERENCES regions(region_id) ON DELETE CASCADE
);

-- Insert Cities
INSERT INTO cities VALUES 
(101, 1, 'Dallas', '{geojson}'),
(102, 1, 'New York', '{geojson}'),
(201, 2, 'London', '{geojson}'),
(202, 2, 'Paris', '{geojson}');

-- Create City Sections Table
CREATE TABLE city_sections (
    section_id INT PRIMARY KEY,
    city_id INT NOT NULL,
    section_name VARCHAR(100) NOT NULL,
    area_km2 FLOAT,
    FOREIGN KEY (city_id) REFERENCES cities(city_id) ON DELETE CASCADE
);

-- Insert City Sections
INSERT INTO city_sections VALUES
(1001, 101, 'Downtown', 5),
(1002, 101, 'Uptown', 8),
(1003, 102, 'Brooklyn', 12),
(2001, 201, 'Westminster', 6),
(2002, 202, 'Montmartre', 9);

-- Create Satellites Table
CREATE TABLE satellites (
    satellite_id INT PRIMARY KEY,
    satellite_name VARCHAR(100) NOT NULL,
    signal_strength FLOAT,
    coverage_radius FLOAT
);

-- Insert Satellites
INSERT INTO satellites VALUES
(5001, 'SatCom-Alpha', 50, 1000),
(5002, 'SatCom-Beta', 45, 800);

-- Create Satellite Frequencies Table
CREATE TABLE satellite_frequencies (
    frequency_id INT PRIMARY KEY,
    satellite_id INT NOT NULL,
    frequency_mhz FLOAT NOT NULL,
    FOREIGN KEY (satellite_id) REFERENCES satellites(satellite_id) ON DELETE CASCADE
);

-- Insert Satellite Frequencies
INSERT INTO satellite_frequencies VALUES
(2001, 5001, 2400),
(2002, 5001, 1800),
(2003, 5002, 2500),
(2004, 5002, 2100);

-- Create Satellite Antennas Table
CREATE TABLE satellite_antennas (
    antenna_id INT PRIMARY KEY,
    satellite_id INT NOT NULL,
    antenna_type VARCHAR(100),
    power_output FLOAT,
    FOREIGN KEY (satellite_id) REFERENCES satellites(satellite_id) ON DELETE CASCADE
);

-- Insert Satellite Antennas
INSERT INTO satellite_antennas VALUES
(3001, 5001, 'High-Gain', 500),
(3002, 5001, 'Medium-Gain', 300),
(3003, 5002, 'Low-Gain', 250),
(3004, 5002, 'Phased Array', 600);

-- Create Antenna Configurations Table
CREATE TABLE antenna_configurations (
    config_id INT PRIMARY KEY,
    antenna_id INT NOT NULL,
    polarization VARCHAR(50),
    beam_width_deg FLOAT,
    FOREIGN KEY (antenna_id) REFERENCES satellite_antennas(antenna_id) ON DELETE CASCADE
);

-- Insert Antenna Configurations
INSERT INTO antenna_configurations VALUES
(4001, 3001, 'Vertical', 30),
(4002, 3001, 'Horizontal', 45),
(4003, 3003, 'Circular', 60),
(4004, 3004, 'Dual', 70);

-- Create Region-Satellite Link Table
CREATE TABLE region_satellites (
    region_id INT,
    satellite_id INT,
    PRIMARY KEY (region_id, satellite_id),
    FOREIGN KEY (region_id) REFERENCES regions(region_id) ON DELETE CASCADE,
    FOREIGN KEY (satellite_id) REFERENCES satellites(satellite_id) ON DELETE CASCADE
);

-- Insert Region-Satellite Links
INSERT INTO region_satellites VALUES
(1, 5001),
(1, 5002),
(2, 5001),
(2, 5002);

-- Create City-Satellite Link Table
CREATE TABLE city_satellites (
    city_id INT,
    satellite_id INT,
    PRIMARY KEY (city_id, satellite_id),
    FOREIGN KEY (city_id) REFERENCES cities(city_id) ON DELETE CASCADE,
    FOREIGN KEY (satellite_id) REFERENCES satellites(satellite_id) ON DELETE CASCADE
);

-- Insert City-Satellite Links
INSERT INTO city_satellites VALUES
(101, 5001),
(102, 5001),
(201, 5002),
(202, 5002);

-- Create Section-Satellite Link Table
CREATE TABLE section_satellites (
    section_id INT,
    config_id INT,
    satellite_id INT,
    PRIMARY KEY (section_id, config_id, satellite_id),
    FOREIGN KEY (section_id) REFERENCES city_sections(section_id) ON DELETE CASCADE,
    FOREIGN KEY (config_id) REFERENCES antenna_configurations(config_id) ON DELETE CASCADE,
    FOREIGN KEY (satellite_id) REFERENCES satellites(satellite_id) ON DELETE CASCADE
);

-- Insert Section-Satellite Links
INSERT INTO section_satellites VALUES
(1001, 4001, 5001),
(1002, 4002, 5001),
(2001, 4003, 5002),
(2002, 4004, 5002);
