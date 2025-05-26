-- Active: 1747811270922@@127.0.0.1@5432@conservation_db

--------------------------------------
-- 🛢️ DATABASE CREATION
--------------------------------------
CREATE DATABASE conservation_db;






--------------------------------------
-- 🧱 TABLE CREATION
--------------------------------------

-- Table: rangers
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
);


-- Table: species
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL UNIQUE,
    scientific_name VARCHAR(100) NOT NULL UNIQUE,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) NOT NULL
);


-- Table: sightings
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER NOT NULL REFERENCES rangers(ranger_id),
    species_id INTEGER NOT NULL REFERENCES species(species_id),
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(100) NOT NULL,
    notes TEXT
);






--------------------------------------
-- 📥 INSERT SAMPLE DATA
--------------------------------------

-- Insert rangers
INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');


-- Insert species
INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');


-- Insert sightings
INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);






--------------------------------------
-- 🔍 PROBLEM SOLUTIONS
--------------------------------------

-- problem: 01
INSERT INTO rangers (name, region) VALUES
('Derek Fox', 'Coastal Plains');





-- problem: 02
SELECT count(DISTINCT species_id) AS unique_species_count FROM sightings;





-- problem: 03
SELECT * FROM sightings
    WHERE location ILIKE '%Pass%';





-- problem: 04
SELECT name, count(sighting_id) AS total_sightings FROM sightings
    JOIN rangers USING(ranger_id)
    GROUP BY NAME;





-- problem: 05
SELECT common_name FROM species
    LEFT JOIN sightings USING(species_id)
    WHERE sightings.species_id IS NULL;





-- problem: 06
SELECT common_name, sighting_time, name FROM sightings
    JOIN rangers USING (ranger_id)
    JOIN species USING (species_id)
    ORDER BY sighting_time DESC
    LIMIT 2;





-- problem: 07
UPDATE species
    SET conservation_status = 'Historic'
    WHERE EXTRACT (YEAR FROM discovery_date) < 1800;


    


-- problem: 08
CREATE FUNCTION time_of_day(p_sightings_sighting_time TIMESTAMP)
RETURNS VARCHAR(30)
LANGUAGE plpgsql
AS
$$
    BEGIN
        IF EXTRACT(HOUR FROM p_sightings_sighting_time) < 12 THEN
            RETURN 'Morning';

        ELSIF EXTRACT(HOUR FROM p_sightings_sighting_time) < 17 THEN
            RETURN 'Afternoon';

        ELSE 
            RETURN 'Evening';

        END IF;
    END
$$;

SELECT sighting_id, time_of_day(sighting_time) FROM sightings;





-- problem: 09
DELETE FROM rangers
    WHERE ranger_id IN (
        SELECT ranger_id FROM rangers
        LEFT JOIN sightings USING(ranger_id)
        WHERE sightings.sighting_id IS NULL
    );