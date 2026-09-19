-- ============================================================
-- SQL PRACTICE — 20 QUESTIONS — FINAL ANSWERS
-- PostgreSQL — Company Database
-- ============================================================


-- ============================================================
-- 1) Employees Born Before 1965
-- ============================================================
SELECT fname, lname, bdate
FROM employee
WHERE bdate < '1965-01-01'
ORDER BY bdate ASC;


-- ============================================================
-- 2) Employees With Salary Between 25000 and 40000
-- ============================================================
SELECT fname, lname, salary
FROM employee
WHERE salary BETWEEN 25000 AND 40000;


-- ============================================================
-- 3) Employees From Specific Departments (4, 5)
-- ============================================================
SELECT fname, lname, dno
FROM employee
WHERE dno IN (4, 5);


-- ============================================================
-- 4) Employees Whose Last Name Starts With S
-- ============================================================
SELECT fname, lname, salary
FROM employee
WHERE lname LIKE 'S%';


-- ============================================================
-- 5) Employees With Salary Above 30000 and Born Before 1970
-- ============================================================
SELECT fname, lname, bdate, salary
FROM employee
WHERE salary > 30000
  AND bdate < '1970-01-01';


-- ============================================================
-- 6) Department Managers
-- ============================================================
SELECT d.dname, e.fname, e.lname, d.mgrstartdate
FROM department AS d
JOIN employee AS e
  ON d.mgrssn = e.ssn;


-- ============================================================
-- 7) Employees and Their Department Locations
-- ============================================================
SELECT e.fname, e.lname, d.dname, dl.dlocation
FROM employee AS e
JOIN department AS d
  ON d.dnumber = e.dno
JOIN dept_locations AS dl
  ON dl.dnumber = d.dnumber;


-- ============================================================
-- 8) Employees Working on ProductX
-- ============================================================
SELECT e.fname, e.lname, p.pname, w.hours
FROM employee AS e
JOIN works_on AS w
  ON w.essn = e.ssn
JOIN project AS p
  ON w.pno = p.pnumber
WHERE p.pname = 'ProductX';


-- ============================================================
-- 9) Employees Working More Than 20 Hours on a Project
-- ============================================================
SELECT e.fname, e.lname, p.pname, w.hours
FROM employee AS e
JOIN works_on AS w
  ON w.essn = e.ssn
JOIN project AS p
  ON w.pno = p.pnumber
WHERE w.hours > 20
ORDER BY w.hours DESC;


-- ============================================================
-- 10) Total Hours for Each Employee
-- ============================================================
SELECT e.fname, e.lname, SUM(w.hours) AS total_hours
FROM employee AS e
JOIN works_on AS w
  ON w.essn = e.ssn
GROUP BY e.ssn, e.fname, e.lname;


-- ============================================================
-- 11) Number of Projects for Each Employee
-- ============================================================
SELECT e.fname, e.lname, COUNT(w.pno) AS number_project
FROM employee AS e
JOIN works_on AS w
  ON w.essn = e.ssn
GROUP BY e.ssn, e.fname, e.lname;


-- ============================================================
-- 12) Employees Working on Exactly Two Projects
-- ============================================================
SELECT e.fname, e.lname, COUNT(w.pno) AS project_count
FROM employee AS e
JOIN works_on AS w
  ON w.essn = e.ssn
GROUP BY e.ssn, e.fname, e.lname
HAVING COUNT(w.pno) = 2;


-- ============================================================
-- 13) Projects With Total Hours Greater Than 30
-- ============================================================
SELECT p.pname, SUM(w.hours) AS total_hours
FROM project AS p
JOIN works_on AS w
  ON p.pnumber = w.pno
GROUP BY p.pname
HAVING SUM(w.hours) > 30;


-- ============================================================
-- 14) Departments With Average Salary Between 25000 and 40000
-- ============================================================
SELECT dno, ROUND(AVG(salary), 2) AS average_salary
FROM employee
GROUP BY dno
HAVING AVG(salary) BETWEEN 25000 AND 40000;


-- ============================================================
-- 15) Department With the Highest Average Salary
-- ============================================================
SELECT d.dname, ROUND(AVG(e.salary), 2) AS average_salary
FROM employee AS e
JOIN department AS d
  ON d.dnumber = e.dno
GROUP BY d.dname
ORDER BY average_salary DESC
LIMIT 1;


-- ============================================================
-- 16) Employees Who Work on Projects Controlled by Another Department
-- ============================================================
SELECT
    e.fname,
    e.lname,
    e.dno  AS employee_department,
    p.pname,
    p.dnum AS project_department
FROM employee AS e
JOIN works_on AS w
  ON w.essn = e.ssn
JOIN project AS p
  ON w.pno = p.pnumber
WHERE e.dno <> p.dnum;


-- ============================================================
-- 17) Employees Who Work More Than 10 Hours on Projects in Stafford
-- ============================================================
SELECT e.fname, e.lname, p.pname, w.hours
FROM employee AS e
JOIN works_on AS w
  ON w.essn = e.ssn
JOIN project AS p
  ON w.pno = p.pnumber
WHERE w.hours > 10
  AND p.plocation = 'Stafford';


-- ============================================================
-- 18) Employees Who Have Dependents
-- ============================================================
SELECT DISTINCT e.fname, e.lname
FROM employee AS e
JOIN dependent AS de
  ON de.essn = e.ssn;


-- ============================================================
-- 19) Employees Who Have the Same Salary as Another Employee
-- ============================================================
SELECT DISTINCT
    CONCAT(e1.fname, ' ', e1.lname) AS full_name,
    e1.salary
FROM employee AS e1
JOIN employee AS e2
  ON e1.salary = e2.salary
WHERE e1.ssn <> e2.ssn;


-- ============================================================
-- 20) FINAL CHALLENGE — Department Project Report
-- ============================================================
SELECT
    d.dname AS department_name,

    (SELECT COUNT(*)
       FROM employee AS e
      WHERE e.dno = d.dnumber)                       AS number_of_employees,

    (SELECT SUM(e.salary)
       FROM employee AS e
      WHERE e.dno = d.dnumber)                       AS total_salary,

    (SELECT ROUND(AVG(e.salary), 2)
       FROM employee AS e
      WHERE e.dno = d.dnumber)                       AS average_salary,

    (SELECT COUNT(p.pnumber)
       FROM project AS p
      WHERE p.dnum = d.dnumber)                      AS number_of_projects,

    (SELECT SUM(w.hours)
       FROM works_on AS w
       JOIN project AS p ON w.pno = p.pnumber
      WHERE d.dnumber = p.dnum)                      AS total_project_hours

FROM department AS d
ORDER BY total_salary DESC;