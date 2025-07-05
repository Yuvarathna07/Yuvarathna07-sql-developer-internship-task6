-- Create role-based security view
CREATE VIEW my_team_view AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS team_member,
    e.email,
    e.hire_date,
    d.department_name,
    COUNT(DISTINCT ep.project_id) AS active_projects
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
LEFT JOIN employee_projects ep ON e.employee_id = ep.employee_id
LEFT JOIN projects p ON ep.project_id = p.project_id AND p.status = 'Active'
WHERE e.manager_id = @current_user_id  -- This would be set based on logged-in user
AND e.is_active = TRUE
GROUP BY e.employee_id, e.first_name, e.last_name, e.email, e.hire_date, d.department_name;

-- Create audit trail view for security monitoring
CREATE VIEW view_usage_audit AS
SELECT 
    TABLE_NAME as view_name,
    'VIEW' as object_type,
    DEFINER as created_by,
    SECURITY_TYPE as security_model,
    IS_UPDATABLE as can_update,
    CHECK_OPTION as has_check_option
FROM INFORMATION_SCHEMA.VIEWS 
WHERE TABLE_SCHEMA = DATABASE()
ORDER BY TABLE_NAME;

-- Show current view permissions
SELECT 
    GRANTEE,
    TABLE_SCHEMA,
    TABLE_NAME,
    PRIVILEGE_TYPE,
    IS_GRANTABLE
FROM INFORMATION_SCHEMA.TABLE_PRIVILEGES 
WHERE TABLE_SCHEMA = DATABASE() 
AND TABLE_NAME IN (
    SELECT TABLE_NAME 
    FROM INFORMATION_SCHEMA.VIEWS 
    WHERE TABLE_SCHEMA = DATABASE()
)
ORDER BY TABLE_NAME, GRANTEE;
