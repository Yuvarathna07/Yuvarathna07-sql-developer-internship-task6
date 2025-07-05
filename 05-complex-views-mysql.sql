-- Task 7: Complex MySQL Views with Multiple Joins and Advanced Features

-- 8. Project Assignment Details View (Complex JOIN with calculations)
CREATE VIEW project_assignments_detailed AS
SELECT 
    p.project_name,
    p.status AS project_status,
    p.budget AS project_budget,
    DATE_FORMAT(p.start_date, '%Y-%m-%d') AS start_date,
    DATE_FORMAT(p.end_date, '%Y-%m-%d') AS end_date,
    DATEDIFF(p.end_date, p.start_date) AS project_duration_days,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.email,
    ep.role,
    ep.hours_allocated,
    d.department_name,
    CASE 
        WHEN p.end_date < CURDATE() AND p.status != 'Completed' THEN 'Overdue'
        WHEN DATEDIFF(p.end_date, CURDATE()) <= 30 AND p.status = 'Active' THEN 'Due Soon'
        WHEN p.status = 'Active' THEN 'On Track'
        ELSE p.status
    END AS timeline_status,
    ROUND((ep.hours_allocated / 40.0) * 100, 1) AS workload_percentage
FROM projects p
INNER JOIN employee_projects ep ON p.project_id = ep.project_id
INNER JOIN employees e ON ep.employee_id = e.employee_id
INNER JOIN departments d ON e.department_id = d.department_id
WHERE e.is_active = TRUE
ORDER BY p.project_name, e.last_name;

-- 9. Employee Workload Analysis View
CREATE VIEW employee_workload_analysis AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.email,
    d.department_name,
    COUNT(DISTINCT ep.project_id) AS active_projects,
    SUM(ep.hours_allocated) AS total_allocated_hours,
    ROUND(AVG(ep.hours_allocated), 1) AS avg_hours_per_project,
    GROUP_CONCAT(DISTINCT p.project_name ORDER BY p.project_name SEPARATOR ', ') AS project_list,
    CASE 
        WHEN SUM(ep.hours_allocated) > 40 THEN 'Overloaded'
        WHEN SUM(ep.hours_allocated) >= 35 THEN 'Full Load'
        WHEN SUM(ep.hours_allocated) >= 20 THEN 'Moderate Load'
        WHEN SUM(ep.hours_allocated) > 0 THEN 'Light Load'
        ELSE 'Available'
    END AS workload_status,
    CASE 
        WHEN SUM(ep.hours_allocated) > 40 THEN 'High Priority for Rebalancing'
        WHEN SUM(ep.hours_allocated) < 20 THEN 'Available for New Projects'
        ELSE 'Optimal Load'
    END AS recommendation
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
LEFT JOIN employee_projects ep ON e.employee_id = ep.employee_id
LEFT JOIN projects p ON ep.project_id = p.project_id AND p.status = 'Active'
WHERE e.is_active = TRUE
GROUP BY e.employee_id, e.first_name, e.last_name, e.email, d.department_name
ORDER BY total_allocated_hours DESC;

-- 10. Project Budget Analysis View
CREATE VIEW project_budget_analysis AS
SELECT 
    p.project_name,
    p.status,
    p.budget,
    COUNT(DISTINCT ep.employee_id) AS team_size,
    SUM(ep.hours_allocated) AS total_allocated_hours,
    ROUND(AVG(e.salary / 2080), 2) AS avg_hourly_rate, -- Assuming 2080 work hours per year
    ROUND(SUM((e.salary / 2080) * ep.hours_allocated), 2) AS estimated_labor_cost,
    ROUND((SUM((e.salary / 2080) * ep.hours_allocated) / p.budget) * 100, 2) AS labor_cost_percentage,
    CASE 
        WHEN (SUM((e.salary / 2080) * ep.hours_allocated) / p.budget) * 100 > 80 THEN 'High Labor Cost'
        WHEN (SUM((e.salary / 2080) * ep.hours_allocated) / p.budget) * 100 > 60 THEN 'Moderate Labor Cost'
        ELSE 'Low Labor Cost'
    END AS cost_category,
    DATEDIFF(COALESCE(p.end_date, CURDATE()), p.start_date) AS project_duration,
    ROUND(p.budget / NULLIF(DATEDIFF(COALESCE(p.end_date, CURDATE()), p.start_date), 0), 2) AS daily_budget_burn
FROM projects p
LEFT JOIN employee_projects ep ON p.project_id = ep.project_id
LEFT JOIN employees e ON ep.employee_id = e.employee_id AND e.is_active = TRUE
GROUP BY p.project_id, p.project_name, p.status, p.budget, p.start_date, p.end_date
HAVING team_size > 0
ORDER BY labor_cost_percentage DESC;
