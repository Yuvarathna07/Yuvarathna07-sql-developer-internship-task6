-- Task 7: Example Queries Using MySQL Views

-- Using the employee_directory view
SELECT * FROM employee_directory 
WHERE department_name = 'Engineering'
ORDER BY years_of_service DESC;

-- Using department_summary view with MySQL-specific formatting
SELECT 
    department_name,
    total_employees,
    FORMAT(average_salary, 2) AS formatted_avg_salary,
    FORMAT(total_salary_cost, 0) AS formatted_total_cost,
    CONCAT(salary_budget_percentage, '%') AS budget_utilization
FROM department_summary 
WHERE total_employees > 0
ORDER BY average_salary DESC;

-- Using project_assignments_detailed view
SELECT 
    project_name,
    COUNT(*) AS team_size,
    SUM(hours_allocated) AS total_hours,
    GROUP_CONCAT(DISTINCT department_name) AS departments_involved,
    timeline_status
FROM project_assignments_detailed 
GROUP BY project_name, project_status, timeline_status
HAVING team_size > 1
ORDER BY total_hours DESC;

-- Using employee_workload_analysis view
SELECT 
    employee_name,
    department_name,
    active_projects,
    total_allocated_hours,
    workload_status,
    recommendation
FROM employee_workload_analysis 
WHERE workload_status IN ('Available', 'Light Load')
ORDER BY total_allocated_hours ASC;

-- Complex query joining multiple views
SELECT 
    ed.full_name,
    ed.department_name,
    ed.years_of_service,
    ewa.active_projects,
    ewa.workload_status,
    esr.overall_salary_rank,
    esr.dept_salary_rank
FROM employee_directory ed
LEFT JOIN employee_workload_analysis ewa ON ed.employee_id = ewa.employee_id
LEFT JOIN employee_salary_rankings esr ON ed.employee_id = esr.employee_id
WHERE ed.years_of_service >= 2
ORDER BY esr.overall_salary_rank;

-- Using views in subqueries with MySQL functions
SELECT 
    department_name,
    average_salary,
    total_employees,
    CASE 
        WHEN average_salary > (SELECT AVG(average_salary) FROM department_summary) THEN 'Above Average'
        ELSE 'Below Average'
    END AS salary_comparison
FROM department_summary
WHERE total_employees > 0
ORDER BY average_salary DESC;

-- Performance comparison query
SELECT 
    'Direct Query' AS query_type,
    COUNT(*) AS record_count,
    BENCHMARK(1000, (
        SELECT COUNT(*) 
        FROM employees e 
        JOIN departments d ON e.department_id = d.department_id 
        WHERE e.is_active = TRUE
    )) AS performance_test
UNION ALL
SELECT 
    'View Query' AS query_type,
    COUNT(*) AS record_count,
    BENCHMARK(1000, (SELECT COUNT(*) FROM employee_directory)) AS performance_test
FROM employee_directory;

-- Using MySQL-specific view features
SELECT 
    employee_name,
    department_name,
    FORMAT(salary, 0) AS formatted_salary,
    hire_day_name,
    experience_level,
    CONCAT('$', FORMAT(monthly_salary, 2)) AS monthly_pay
FROM employee_analytics
WHERE experience_level = 'Veteran'
ORDER BY salary DESC;
