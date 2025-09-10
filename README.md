**# 🏥 TelemedicineDB – DBMS Project

This project is a **Telemedicine Database Management System** built in **MySQL Workbench**.  
It models a small telemedicine platform where users (patients) can book appointments with doctors, order medicines from pharmacies, and leave reviews.  

---

## 📌 What the Program Does

### ✅ 1. Creates a new database
```sql**
**CREATE DATABASE TelemedicineDB;
Drops any old version of the database

Builds a fresh database called TelemedicineDB

✅ 2. Creates all tables (like Excel sheets)
The program creates 10 main tables based on the ER diagram:

User → Patients/users with login info

Specialist → Doctors (name, specialization, availability)

Pharmacy → Pharmacies (location, contact info)

Disease → Diseases (symptoms, affected organs)

Medicine → Medicines linked to diseases

PharmacyStock → Which pharmacy has which medicine, how much, and at what price

Appointment → Patients booking with doctors

Review → Patients giving ratings/comments to doctors or pharmacies

SearchHistory → Records of what users searched (doctor, medicine, etc.)

GeoService → Stores the live location of specialists/pharmacies

✅ 3. Inserts sample data
The script automatically fills the database with example records:

Users (patients)

Specialists (doctors)

Pharmacies

Diseases and medicines

Pharmacy stock details

Appointments (confirmed & pending)

Reviews (ratings and comments)

Search history logs

GeoService entries

✅ 4. Provides useful queries (Reports)
At the end of the script, there are report queries to extract information:

All appointments → who booked which doctor and when

Medicines stocked by pharmacies with prices

Average rating of each specialist

Recent searches by users

👉 These are the business reports you can show in demo/viva.

🎯 In Simple Words
The program builds a mini telemedicine system database inside MySQL:

Stores doctors, patients, pharmacies, medicines, diseases

Allows patients to book appointments

Tracks pharmacy stock of medicines

Lets patients rate/review doctors & pharmacies

Logs search history and locations (GeoService)

Can be queried for reports and analytics

🚀 How to Run
Open MySQL Workbench

Create a new SQL tab

Paste the contents of telemedicine_cp.sql

Run the script (⚡ Execute button)

Switch to the database:

sql
Copy code
USE TelemedicineDB;
SHOW TABLES;
Run the queries at the end of the file to see reports

📂 Project Structure
pgsql
Copy code
dbms---cp/
  ├── telemedicine_cp.sql   # Full SQL script (schema + inserts + reports)
  └── README.md             # Project documentation


---

**
