-- 1) Basic SQL Queries

SELECT * FROM employees ;
SELECT emp_id , emp_name , dept_id FROM employees WHERE location = 'Cairo' ;

------------------------------------------------------------

-- 2) DISTINCT Keyword :
SELECT DISTINCT dept_id FROM employees ;

------------------------------------------------------------

-- 3) Data Definition Language [DDL] :
CREATE TABLE students (
ID INT primary key ,
First_Name TEXT NOT NULL ,
Last_Name TEXT DEFAULT  'Unknown' ,
Address VARCHAR(100) DEFAULT  'N/A' ,
City VARCHAR(50) DEFAULT  'N/A' ,
Birth_Date DATE
);

DROP TABLE students

------------------------------------------------------------

-- 4) Data Manipulation Language [DML] :
INSERT INTO students(first_name,last_name,address,city,birth_date)
VALUES ('Ahmed','Ali','Downtown','Cairo','2007-05-21');

UPDATE students 
SET address = 'Garden City' WHERE last_name = 'Ahmed' ;

------------------------------------------------------------

-- 5) TRANSACTION Control
BEGIN ;
DELETE FROM students WHERE city = 'Cairo' ;
ROLLBACK ;

------------------------------------------------------------
