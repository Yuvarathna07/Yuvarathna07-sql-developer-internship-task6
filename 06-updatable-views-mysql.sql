-- Task 7: Updatable Views Examples in MySQL

-- 11. Simple Updatable View (Single table, no aggregation)
CREATE VIEW active_employees_updatable AS
SELECT 
    employee_id,
    first_name,
    last_name,
    email,
    phone,
    salary,
    department_id,
    hire_date
FROM employees
WHERE is_active = TRUE;

-- This view can be updated because:
-- 1. It's based on a single table
-- 2. No aggregation functions (COUNT, SUM, AVG, etc.)
-- 3. No DISTINCT clause
-- 4. No GROUP BY clause
-- 5. All key columns are included

-- Example of updating through view
-- UPDATE active_employees_updatable SET salary = 82000 WHERE employee_id = 2;
-- INSERT INTO active_employees_updatable (first_name, last_name, email, salary, department_id, hire_date) 
-- VALUES ('New', 'Employee', 'new.employee@company.com', 60000, 1, CURDATE());

-- 12. Department Management View (Updatable)
CREATE VIEW department_management AS
SELECT 
    department_id,
    department_name,
    location,
    budget
FROM departments;

-- This is updatable because it directly maps to the departments table
-- UPDATE department_management SET budget = 520000 WHERE department_id = 1;

-- 13. Project Status View (Updatable)
CREATE VIEW project_status_management AS
SELECT 
    project_id,
    project_name,
    status,
    start_date,
    end_date,
    budget
FROM projects;

-- Examples of updates through this view:
-- UPDATE project_status_management SET status = 'Completed' WHERE project_id = 2;
-- UPDATE project_status_management SET end_date = '2024-06-30' WHERE project_id = 5;

-- 14. Employee Contact Info View (Updatable with WHERE clause)
CREATE VIEW employee_contact_updatable AS
SELECT 
    employee_id,
    first_name,
    last_name,
    email,
    phone
FROM employees
WHERE is_active = TRUE;

-- This view is updatable for contact information only
-- UPDATE employee_contact_updatable SET phone = '555-9999' WHERE employee_id = 1;
