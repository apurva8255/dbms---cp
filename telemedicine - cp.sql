-- ===================================
-- TELEMEDICINE DBMS PROJECT
-- Matching ER Diagram (User, Specialist, Pharmacy, Medicine, Disease, etc.)
-- ===================================

-- Drop & recreate database
DROP DATABASE IF EXISTS TelemedicineDB;
CREATE DATABASE TelemedicineDB;
USE TelemedicineDB;

-- =============================
-- 1. Core Entities
-- =============================

-- User table
CREATE TABLE User (
  UserID INT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  Email VARCHAR(100) UNIQUE NOT NULL,
  Password VARCHAR(100) NOT NULL,
  Phone VARCHAR(20),
  Address VARCHAR(150),
  Latitude FLOAT,
  Longitude FLOAT
);

-- Specialist (Doctors)
CREATE TABLE Specialist (
  SpecialistID INT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  Phone VARCHAR(20),
  Address VARCHAR(150),
  Specialization VARCHAR(100),
  AvailabilityStatus VARCHAR(50)
);

-- Pharmacy
CREATE TABLE Pharmacy (
  PharmacyID INT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  Address VARCHAR(150) NOT NULL,
  Phone VARCHAR(20),
  Latitude FLOAT,
  Longitude FLOAT
);

-- Disease
CREATE TABLE Disease (
  DiseaseID INT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  Description VARCHAR(255),
  Symptoms VARCHAR(255),
  AffectedOrgans VARCHAR(255)
);

-- Medicine
CREATE TABLE Medicine (
  MedicineID INT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  Description VARCHAR(255),
  ForDisease INT,
  FOREIGN KEY (ForDisease) REFERENCES Disease(DiseaseID)
);

-- Pharmacy Stock (Inventory)
CREATE TABLE PharmacyStock (
  PharmacyStockID INT PRIMARY KEY,
  PharmacyID INT,
  MedicineID INT,
  QuantityAvailable INT,
  Price DECIMAL(10,2),
  FOREIGN KEY (PharmacyID) REFERENCES Pharmacy(PharmacyID),
  FOREIGN KEY (MedicineID) REFERENCES Medicine(MedicineID)
);

-- =============================
-- 2. Appointments
-- =============================
CREATE TABLE Appointment (
  AppointmentID INT PRIMARY KEY,
  UserID INT,
  SpecialistID INT,
  Date DATE,
  Time TIME,
  Status VARCHAR(50),
  FOREIGN KEY (UserID) REFERENCES User(UserID),
  FOREIGN KEY (SpecialistID) REFERENCES Specialist(SpecialistID)
);

-- =============================
-- 3. Reviews & Search History
-- =============================
CREATE TABLE Review (
  ReviewID INT PRIMARY KEY,
  UserID INT,
  ReviewType VARCHAR(50), -- Specialist or Pharmacy
  EntityID INT, -- SpecialistID or PharmacyID
  Rating INT CHECK (Rating BETWEEN 1 AND 5),
  ReviewText VARCHAR(255),
  Timestamp DATETIME,
  FOREIGN KEY (UserID) REFERENCES User(UserID)
);

CREATE TABLE SearchHistory (
  SearchID INT PRIMARY KEY,
  UserID INT,
  SearchType VARCHAR(50), -- Specialist, Pharmacy, Medicine
  Keyword VARCHAR(100),
  Timestamp DATETIME,
  FOREIGN KEY (UserID) REFERENCES User(UserID)
);

-- =============================
-- 4. GeoService (tracking)
-- =============================
CREATE TABLE GeoService (
  GeoServiceID INT PRIMARY KEY,
  EntityType VARCHAR(50), -- Specialist / Pharmacy
  EntityID INT,
  Latitude FLOAT,
  Longitude FLOAT,
  LastUpdated DATETIME
);

-- =============================
-- 5. Sample Data
-- =============================

-- Users
INSERT INTO User VALUES (1, 'Sankalp Singh', 'sankalp@mail.com', 'pass123', '9998887777', 'Clarendon Street', 40.7128, -74.0060);
INSERT INTO User VALUES (2, 'Stanley Cooper', 'stanley@mail.com', 'pass123', '9998881111', 'Westcott Street', 42.1234, -76.5432);

-- Specialists
INSERT INTO Specialist VALUES (101, 'Dr. Jason Shapiro', '2113114111', 'Clarendon Street', 'General Physician', 'Available');
INSERT INTO Specialist VALUES (102, 'Dr. Matt LeBlanc', '2113114222', 'Ackerman Street', 'Cardiologist', 'Available');

-- Pharmacy
INSERT INTO Pharmacy VALUES (201, 'CVS Pharmacy', 'Marshall Street', '2113114114', 40.5000, -73.9000);

-- Diseases
INSERT INTO Disease VALUES (301, 'Flu', 'Viral infection', 'Fever, Cough, Cold', 'Respiratory System');
INSERT INTO Disease VALUES (302, 'Diabetes', 'High blood sugar levels', 'Fatigue, Thirst', 'Endocrine System');

-- Medicines
INSERT INTO Medicine VALUES (401, 'Paracetamol', 'Fever reducer', 301);
INSERT INTO Medicine VALUES (402, 'Insulin', 'Blood sugar control', 302);

-- Pharmacy Stock
INSERT INTO PharmacyStock VALUES (501, 201, 401, 50, 5.00);
INSERT INTO PharmacyStock VALUES (502, 201, 402, 30, 15.00);

-- Appointments
INSERT INTO Appointment VALUES (601, 1, 101, '2025-09-10', '10:00:00', 'Confirmed');
INSERT INTO Appointment VALUES (602, 2, 102, '2025-09-11', '14:00:00', 'Pending');

-- Reviews
INSERT INTO Review VALUES (701, 1, 'Specialist', 101, 5, 'Very helpful doctor.', NOW());
INSERT INTO Review VALUES (702, 2, 'Pharmacy', 201, 4, 'Good stock availability.', NOW());

-- Search History
INSERT INTO SearchHistory VALUES (801, 1, 'Specialist', 'Cardiologist', NOW());
INSERT INTO SearchHistory VALUES (802, 2, 'Medicine', 'Paracetamol', NOW());

-- GeoService
INSERT INTO GeoService VALUES (901, 'Specialist', 101, 40.7130, -74.0055, NOW());
INSERT INTO GeoService VALUES (902, 'Pharmacy', 201, 40.5002, -73.8999, NOW());

-- =============================
-- 6. Example Reports (Queries)
-- =============================

-- A) List all appointments with user and doctor
SELECT a.AppointmentID, u.Name AS Patient, s.Name AS Doctor, a.Date, a.Time, a.Status
FROM Appointment a
JOIN User u ON a.UserID = u.UserID
JOIN Specialist s ON a.SpecialistID = s.SpecialistID;

-- B) Medicines stocked by each pharmacy
SELECT p.Name AS Pharmacy, m.Name AS Medicine, ps.QuantityAvailable, ps.Price
FROM PharmacyStock ps
JOIN Pharmacy p ON ps.PharmacyID = p.PharmacyID
JOIN Medicine m ON ps.MedicineID = m.MedicineID;

-- C) Average rating of each specialist
SELECT s.Name, AVG(r.Rating) AS AvgRating
FROM Specialist s
JOIN Review r ON s.SpecialistID = r.EntityID
WHERE r.ReviewType = 'Specialist'
GROUP BY s.Name;

-- D) Most recent search by each user
SELECT u.Name, sh.SearchType, sh.Keyword, sh.Timestamp
FROM SearchHistory sh
JOIN User u ON sh.UserID = u.UserID
ORDER BY sh.Timestamp DESC;

