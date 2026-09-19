-- ============================================================
-- SQL Views Practice — Answers
-- By Eng| Mohamed Mahmoud Salama
-- Database: COMPANY
-- ============================================================


-- ============================================================
-- Part 1 — Simple Views
-- ============================================================

-- Q1)
CREATE VIEW employee_basic_view
AS
SELECT fname, lname, salary
FROM employee;

SELECT * FROM employee_basic_view;

-------------------------------------------------

-- Q2)
CREATE VIEW research_employees
AS
SELECT *
FROM employee
WHERE dno = 5;

SELECT * FROM research_employees;

-------------------------------------------------

-- Q3)
CREATE VIEW high_salary_employees
AS
SELECT fname, lname, salary
FROM employee
WHERE salary > 30000;

SELECT * FROM high_salary_employees;

-------------------------------------------------

-- Q4)
CREATE VIEW female_employees
AS
SELECT fname, lname, sex, salary
FROM employee
WHERE sex = 'F';

SELECT * FROM female_employees;

-------------------------------------------------

-- Q5)
CREATE VIEW employee_names
AS
SELECT
    CONCAT(fname, ' ', minit, ' ', lname) AS Full_Name,
    ssn,
    salary
FROM employee;

SELECT * FROM employee_names;

-------------------------------------------------

-- Q6)
CREATE VIEW department5_employees
AS
SELECT ssn, fname, lname, salary, dno
FROM employee
WHERE dno = 5;

SELECT * FROM department5_employees;

-------------------------------------------------

-- Q7)
CREATE VIEW employee_addresses
AS
SELECT fname, lname, address
FROM employee;

SELECT * FROM employee_addresses;

-------------------------------------------------

-- Q8)
CREATE VIEW low_salary_employees
AS
SELECT *
FROM employee
WHERE NOT salary > 25000;

SELECT * FROM low_salary_employees;


-- ============================================================
-- Part 2 — DML Through Simple Views
-- ============================================================

-- Q9)
CREATE VIEW the_employees
AS
SELECT fname, lname, salary
FROM employee;

UPDATE the_employees
SET salary = 35000
WHERE fname = 'John' AND lname = 'Smith';

-------------------------------------------------

-- Q10)
CREATE VIEW employees_dept4
AS
SELECT *
FROM employee
WHERE dno = 4
WITH CHECK OPTION;

UPDATE employees_dept4
SET salary = 28000
WHERE ssn = '999887777';

-------------------------------------------------

-- Q11)
CREATE VIEW employees_delete
AS
SELECT fname, lname, salary
FROM employee;

-- step 1: remove related works_on rows first (foreign key dependency)
DELETE FROM works_on
WHERE essn = (SELECT ssn FROM employee WHERE fname = 'Ahmad' AND lname = 'Jabbar');

-- step 2: delete through the view
DELETE FROM employees_delete
WHERE fname = 'Ahmad' AND lname = 'Jabbar';


-- ============================================================
-- Part 3 — Complex Views: JOIN
-- ============================================================

-- Q12)
CREATE VIEW employee_department_view
AS
SELECT CONCAT(e.fname, ' ', e.lname) AS Full_Name, d.dname
FROM employee AS e
INNER JOIN department AS d
ON e.dno = d.dnumber;

SELECT * FROM employee_department_view;

-------------------------------------------------

-- Q13)
CREATE VIEW employee_projects
AS
SELECT CONCAT(e.fname, ' ', e.lname) AS Full_Name, p.pname
FROM employee AS e
INNER JOIN works_on AS w
ON e.ssn = w.essn
INNER JOIN project AS p
ON p.pnumber = w.pno;

SELECT * FROM employee_projects;

-------------------------------------------------

-- Q14)
CREATE VIEW project_department_view
AS
SELECT pname, plocation, dname
FROM project AS p
INNER JOIN department AS d
ON p.dnum = d.dnumber;

SELECT * FROM project_department_view;

-------------------------------------------------

-- Q15)
CREATE VIEW employee_project_hours
AS
SELECT CONCAT(e.fname, ' ', e.lname) AS employee_name, p.pname, w.hours
FROM employee AS e
INNER JOIN works_on AS w
ON e.ssn = w.essn
INNER JOIN project AS p
ON w.pno = p.pnumber;

SELECT * FROM employee_project_hours;


-- ============================================================
-- Part 4 — Complex Views: Aggregate Functions
-- ============================================================

-- Q16)
CREATE VIEW department_avg_salary
AS
SELECT dno, ROUND(AVG(salary), 2) AS average_salary
FROM employee
GROUP BY dno;

SELECT * FROM department_avg_salary;

-------------------------------------------------

-- Q17)
CREATE VIEW department_employee_count
AS
SELECT dno, COUNT(ssn) AS employee_count
FROM employee
GROUP BY dno;

SELECT * FROM department_employee_count;

-------------------------------------------------

-- Q18)
CREATE VIEW department_total_salary
AS
SELECT dno, SUM(salary) AS total_salary
FROM employee
GROUP BY dno;

SELECT * FROM department_total_salary;

-------------------------------------------------

-- Q19)
CREATE VIEW department_max_salary
AS
SELECT dno, MAX(salary) AS max_salary
FROM employee
GROUP BY dno;

SELECT * FROM department_max_salary;


-- ============================================================
-- Part 5 — Complex Views: JOIN + GROUP BY
-- ============================================================

-- Q20)
CREATE VIEW department_info
AS
SELECT
    d.dname,
    COUNT(e.ssn) AS employee_count,
    ROUND(AVG(e.salary)) AS average_salary
FROM department AS d
JOIN employee AS e
ON e.dno = d.dnumber
GROUP BY d.dname;

SELECT * FROM department_info;

-------------------------------------------------

-- Q21)
CREATE VIEW project_hours_summary
AS
SELECT p.pname, SUM(w.hours) AS total_hours
FROM works_on AS w
JOIN project AS p
ON p.pnumber = w.pno
GROUP BY p.pname;

SELECT * FROM project_hours_summary;

-------------------------------------------------

-- Q22)
CREATE VIEW employee_total_hours
AS
SELECT e.fname, e.lname, SUM(w.hours) AS total_hours
FROM employee AS e
JOIN works_on AS w
ON w.essn = e.ssn
GROUP BY e.fname, e.lname, e.ssn;

SELECT * FROM employee_total_hours;

-------------------------------------------------

-- Q23)
CREATE VIEW department_project_count
AS
SELECT d.dname, COUNT(p.pnumber) AS project_count
FROM department AS d
JOIN project AS p
ON d.dnumber = p.dnum
GROUP BY d.dname;

SELECT * FROM department_project_count;


-- ============================================================
-- Part 6 — More Complex Views
-- ============================================================

-- Q24)
CREATE VIEW emp_dept_proj_hours
AS
SELECT
    CONCAT(e.fname, ' ', e.lname) AS employee_name,
    d.dname,
    p.pname,
    w.hours
FROM employee AS e
JOIN department AS d ON e.dno = d.dnumber
JOIN works_on AS w ON w.essn = e.ssn
JOIN project AS p ON p.pnumber = w.pno;

SELECT * FROM emp_dept_proj_hours;
-- DROP VIEW emp_dept_proj_hours;

-------------------------------------------------

-- Q25)
CREATE VIEW research_project_hours
AS
SELECT p.pname AS project_name, SUM(w.hours) AS total_hours
FROM works_on AS w
JOIN project AS p ON p.pnumber = w.pno
WHERE p.dnum = 5
GROUP BY p.pname;

SELECT * FROM research_project_hours;

-------------------------------------------------

-- Q26)
CREATE VIEW dept_high_avg_salary
AS
SELECT
    d.dname,
    d.dnumber,
    d.mgrssn,
    d.mgrstartdate,
    ROUND(AVG(e.salary), 2) AS highest_average
FROM department AS d
JOIN employee AS e
ON d.dnumber = e.dno
GROUP BY d.dnumber
ORDER BY highest_average DESC
LIMIT 1;

SELECT * FROM dept_high_avg_salary;

-------------------------------------------------

-- Q27)
CREATE VIEW employees_more_than_one_project
AS
SELECT e.fname, e.lname, e.ssn, COUNT(w.essn) AS count_project
FROM employee AS e
JOIN works_on AS w
ON w.essn = e.ssn
GROUP BY e.fname, e.lname, e.ssn
HAVING COUNT(w.essn) > 1;

SELECT * FROM employees_more_than_one_project;

-------------------------------------------------

-- Q28)
CREATE VIEW employees_more_than_30_hours
AS
SELECT
    CONCAT(e.fname, ' ', e.lname) AS employee_name,
    e.ssn,
    SUM(w.hours) AS total_hours
FROM employee AS e
JOIN works_on AS w
ON w.essn = e.ssn
GROUP BY e.fname, e.lname, e.ssn
HAVING SUM(w.hours) > 30;

SELECT * FROM employees_more_than_30_hours;


-- ============================================================
-- Part 7 — Simple or Complex?
-- ============================================================

-- Q29)
-- View: SIMPLE
-- Reason: one table, no JOIN, no GROUP BY, no aggregate function.
-- DML is generally possible.

-- Q30)
-- View: COMPLEX
-- Reason: uses JOIN between two tables.

-- Q31)
-- View: COMPLEX
-- Reason: uses AVG() and GROUP BY.

-- Q32)
-- View: SIMPLE
-- Reason: one table, WHERE clause only.
-- Yes, UPDATE is generally allowed.

-- Q33)
-- View: COMPLEX
-- Reason: uses JOIN between two tables, COUNT(), and GROUP BY.
-- DML is generally not possible.
