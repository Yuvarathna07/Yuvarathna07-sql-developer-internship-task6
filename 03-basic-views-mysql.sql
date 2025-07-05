-- Task 7: Creating Views - Basic MySQL View Examples

-- 1. Simple View - Employee Directory (Data Abstraction)
CREATE VIEW employee_directory AS
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    e.email,
    e.phone,
    d.department_name,
    e.hire_date,
    DATEDIFF(CURDATE(), e.hire_date) AS days_employed
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE e.is_active = TRUE
ORDER BY e.last_name, e.first_name;

-- Query the view
SELECT * FROM employee_directory;

-- 2. Department Summary View (Complex SELECT with aggregation)
CREATE VIEW department_summary AS
SELECT 
    d.department_name,
    d.location,
    d.budget,
    COUNT(e.employee_id) AS total_employees,
    ROUND(AVG(e.salary), 2) AS average_salary,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary,
    SUM(e.salary) AS total_salary_cost,
    ROUND((SUM(e.salary) / d.budget) * 100, 2) AS salary_budget_percentage
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id AND e.is_active = TRUE
GROUP BY d.department_id, d.department_name, d.location, d.budget
ORDER BY total_employees DESC;

-- Query the department summary
SELECT * FROM department_summary;

-- 3. Employee Hierarchy View
CREATE VIEW employee_hierarchy AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.email,
    d.department_name,
    CASE 
        WHEN e.manager_id IS NULL THEN 'Department Head'
        ELSE CONCAT(m.first_name, ' ', m.last_name)
    END AS manager_name,
    e.salary,
    CASE 
        WHEN e.salary >= 80000 THEN 'Senior Level'
        WHEN e.salary >= 65000 THEN 'Mid Level'
        ELSE 'Junior Level'
    END AS salary_grade
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
LEFT JOIN employees m ON e.manager_id = m.employee_id
WHERE e.is_active = TRUE;
