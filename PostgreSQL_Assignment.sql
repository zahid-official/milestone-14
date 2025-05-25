-- Active: 1747811270922@@127.0.0.1@5432@conservation_db
CREATE DATABASE conservation_db;




CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    region VARCHAR(50)
);
