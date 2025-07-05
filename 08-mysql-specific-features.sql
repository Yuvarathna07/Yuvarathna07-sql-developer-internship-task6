-- Task 7: MySQL-Specific View Features

-- 15. View with MySQL-specific functions
CREATE VIEW employee_analytics AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    d.department_name,
    e.salary,
    e.hire_date,
    -- MySQL date functions
    TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) AS years_employed,
    TIMESTAMPDIFF(MONTH, e.hire_date, CURDATE()) AS months_employed,
    DAYOFWEEK(e.hire_date) AS hire_day_of_week,
    DAYNAME(e.hire_date) AS hire_day_name,
    QUARTER(e.hire_date) AS hire_quarter,
    
    -- MySQL string functions
    UPPER(CONCAT(LEFT(e.first_name, 1), LEFT(e.last_name, 1))) AS initials,
    CHAR_LENGTH(CONCAT(e.first_name, ' ', e.last_name)) AS name_length,
    
    -- MySQL mathematical functions
    ROUND(e.salary / 12, 2) AS monthly_salary,
    ROUND(e.salary / 52, 2) AS weekly_salary,
    ROUND(e.salary / 2080, 2) AS hourly_rate,
    
    -- MySQL conditional functions
    IF(e.salary > 75000, 'High', 'Standard') AS salary_category,
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) >= 5 THEN 'Veteran'
        WHEN TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) >= 2 THEN 'Experienced'
        ELSE 'New Hire'
    END AS experience_level
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE e.is_active = TRUE;

-- 16. View with window functions (MySQL 8.0+)
CREATE VIEW employee_salary_rankings AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.department_name,
    e.salary,
    -- Window functions for ranking
    RANK() OVER (ORDER BY e.salary DESC) AS overall_salary_rank,
    DENSE_RANK() OVER (PARTITION BY d.department_id ORDER BY e.salary DESC) AS dept_salary_rank,
    ROW_NUMBER() OVER (PARTITION BY d.department_id ORDER BY e.hire_date) AS dept_hire_order,
    
    -- Window functions for aggregation
    AVG(e.salary) OVER (PARTITION BY d.department_id) AS dept_avg_salary,
    MAX(e.salary) OVER (PARTITION BY d.department_id) AS dept_max_salary,
    MIN(e.salary) OVER (PARTITION BY d.department_id) AS dept_min_salary,
    COUNT(*) OVER (PARTITION BY d.department_id) AS dept_employee_count,
    
    -- Percentage calculations
    ROUND((e.salary / AVG(e.salary) OVER (PARTITION BY d.department_id)) * 100, 2) AS salary_vs_dept_avg_pct,
    ROUND((e.salary / AVG(e.salary) OVER ()) * 100, 2) AS salary_vs_company_avg_pct
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE e.is_active = TRUE;

-- 17. JSON-based view (MySQL 5.7+)
CREATE VIEW employee_json_summary AS
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    JSON_OBJECT(
        'department', d.department_name,
        'location', d.location,
        'budget', d.budget,
        'employee_count', COUNT(e.employee_id),
        'avg_salary', ROUND(AVG(e.salary), 2),
        'total_payroll', SUM(e.salary),
        'employees', JSON_ARRAYAGG(
            JSON_OBJECT(
                'id', e.employee_id,
                'name', CONCAT(e.first_name, ' ', e.last_name),
                'email', e.email,
                'salary', e.salary,
                'hire_date', e.hire_date
            )
        )
    ) AS department_data
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id AND e.is_active = TRUE
GROUP BY d.department_id, d.department_name, d.location, d.budget;
