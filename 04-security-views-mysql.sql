-- Task 7: Security and Data Protection Views in MySQL

-- 4. Public Employee Info (Security - Hide sensitive data)
CREATE VIEW public_employee_info AS
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    e.hire_date,
    YEAR(CURDATE()) - YEAR(e.hire_date) AS years_of_service,
    CASE 
        WHEN YEAR(CURDATE()) - YEAR(e.hire_date) >= 5 THEN 'Veteran'
        WHEN YEAR(CURDATE()) - YEAR(e.hire_date) >= 2 THEN 'Experienced'
        ELSE 'New'
    END AS experience_level
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE e.is_active = TRUE;
-- Note: Salary, email, phone are hidden for security

-- 5. Manager Dashboard View (Role-based access)
CREATE VIEW manager_dashboard AS
SELECT 
    d.department_name,
    CONCAT(mgr.first_name, ' ', mgr.last_name) AS manager_name,
    COUNT(e.employee_id) AS team_size,
    ROUND(AVG(e.salary), 2) AS avg_team_salary,
    SUM(e.salary) AS total_team_cost,
    MIN(e.hire_date) AS earliest_hire_date,
    MAX(e.hire_date) AS latest_hire_date
FROM employees mgr
INNER JOIN departments d ON mgr.department_id = d.department_id
INNER JOIN employees e ON mgr.employee_id = e.manager_id
WHERE mgr.is_active = TRUE AND e.is_active = TRUE
GROUP BY d.department_name, mgr.employee_id, mgr.first_name, mgr.last_name;

-- 6. HR Salary Analysis (Restricted access)
CREATE VIEW hr_salary_analysis AS
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    ROUND(STDDEV(e.salary), 2) AS salary_std_dev,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary,
    CASE 
        WHEN AVG(e.salary) > 80000 THEN 'High Pay'
        WHEN AVG(e.salary) > 65000 THEN 'Medium Pay'
        ELSE 'Entry Level Pay'
    END AS pay_category,
    ROUND((MAX(e.salary) - MIN(e.salary)) / MIN(e.salary) * 100, 2) AS pay_range_percentage
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE e.is_active = TRUE
GROUP BY d.department_id, d.department_name
HAVING COUNT(e.employee_id) > 0;

-- 7. Payroll Summary View (Finance department access)
CREATE VIEW payroll_summary AS
SELECT 
    YEAR(CURDATE()) AS payroll_year,
    MONTH(CURDATE()) AS payroll_month,
    MONTHNAME(CURDATE()) AS month_name,
    COUNT(e.employee_id) AS active_employees,
    SUM(e.salary) AS monthly_gross_payroll,
    ROUND(SUM(e.salary) * 0.15, 2) AS estimated_benefits_cost,
    ROUND(SUM(e.salary) * 1.15, 2) AS total_monthly_cost,
    ROUND(SUM(e.salary) * 12, 2) AS annual_payroll_projection
FROM employees e
WHERE e.is_active = TRUE;
