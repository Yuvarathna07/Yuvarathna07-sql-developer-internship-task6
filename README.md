# SQL Views Tutorial - Task 7: Creating Views

## 📋 Project Overview

This project demonstrates the creation and usage of SQL views in MySQL as part of a SQL Developer Internship task. The project covers basic to advanced view concepts, security implementations, and practical examples that address common interview questions about SQL views.

## 🎯 Learning Objectives

- Understand what SQL views are and their purpose
- Learn to create simple and complex views
- Implement security measures using views
- Practice data abstraction techniques
- Master view management operations
- Prepare for SQL developer interviews

## 🛠️ Tools Used

- **Database**: MySQL 8.0+ (compatible with MySQL 5.7+)
- **IDE Options**: 
  - MySQL Workbench
  - phpMyAdmin
  - Command Line MySQL Client
  - Any MySQL-compatible database client

## 📁 Project Structure

\`\`\`
sql-views-tutorial/
├── scripts/
│   ├── 01-create-tables-mysql.sql      # Database schema creation
│   ├── 02-insert-sample-data-mysql.sql # Sample data insertion
│   ├── 03-basic-views-mysql.sql        # Basic view examples
│   ├── 04-security-views-mysql.sql     # Security-focused views
│   ├── 05-complex-views-mysql.sql      # Advanced view examples
│   ├── 06-updatable-views-mysql.sql    # Updatable view examples
│   ├── 07-view-management-mysql.sql    # View management operations
│   ├── 08-mysql-specific-features.sql  # MySQL-specific features
│   ├── 09-view-examples-queries-mysql.sql # Example queries
│   └── 10-view-security-examples-mysql.sql # Security examples
└── README.md                           # This file
\`\`\`

## 🚀 Getting Started

### Prerequisites

1. MySQL Server 5.7+ installed
2. MySQL client or GUI tool (MySQL Workbench recommended)
3. Basic knowledge of SQL SELECT statements

### Installation Steps

1. **Clone or Download** this repository
2. **Connect** to your MySQL server
3. **Create a database** (optional):
   \`\`\`sql
   CREATE DATABASE company_db;
   USE company_db;
   \`\`\`
4. **Execute scripts in order**:
   - Run each script file in numerical order (01 through 10)
   - Each script builds upon the previous ones

### Quick Setup

\`\`\`bash
# Connect to MySQL
mysql -u your_username -p

# Create database
CREATE DATABASE company_db;
USE company_db;

# Run scripts in order
source scripts/01-create-tables-mysql.sql;
source scripts/02-insert-sample-data-mysql.sql;
source scripts/03-basic-views-mysql.sql;
# ... continue with remaining scripts
\`\`\`

## 📊 Database Schema

The project uses a company database with the following tables:

### Core Tables
- **employees**: Employee information (ID, name, email, salary, department, manager)
- **departments**: Department details (ID, name, location, budget)
- **projects**: Project information (ID, name, dates, budget, status)
- **employee_projects**: Many-to-many relationship between employees and projects

### Sample Data
- 6 departments (Engineering, Marketing, Sales, HR, Finance, IT Support)
- 13 employees with realistic hierarchical relationships
- 7 projects with different statuses
- Multiple project assignments per employee

## 🔍 View Categories

### 1. Basic Views
- **employee_directory**: Simple employee contact information
- **department_summary**: Aggregated department statistics
- **employee_hierarchy**: Employee-manager relationships

### 2. Security Views
- **public_employee_info**: Public-safe employee data (no sensitive info)
- **manager_dashboard**: Manager-specific team information
- **hr_salary_analysis**: HR-restricted salary analytics
- **payroll_summary**: Finance department payroll data

### 3. Complex Views
- **project_assignments_detailed**: Multi-table joins with calculations
- **employee_workload_analysis**: Workload distribution analysis
- **project_budget_analysis**: Budget vs. actual cost analysis

### 4. Updatable Views
- **active_employees_updatable**: Direct employee updates
- **department_management**: Department information updates
- **project_status_management**: Project status updates

### 5. MySQL-Specific Features
- **employee_analytics**: MySQL date/string functions
- **employee_salary_rankings**: Window functions (MySQL 8.0+)
- **employee_json_summary**: JSON aggregation functions

## 🔐 Security Features

### Data Protection
- Sensitive data (salaries, personal info) hidden from public views
- Role-based access through different view permissions
- CHECK OPTION implementation for data integrity

### Access Control Examples
\`\`\`sql
-- HR user access
GRANT SELECT ON hr_salary_analysis TO 'hr_user'@'localhost';

-- Manager access
GRANT SELECT ON manager_dashboard TO 'manager_user'@'localhost';

-- Employee access
GRANT SELECT ON public_employee_info TO 'employee_user'@'localhost';
\`\`\`

## 📝 Key Concepts Demonstrated

### 1. View Creation
\`\`\`sql
CREATE VIEW employee_directory AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    e.email,
    d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.is_active = TRUE;
\`\`\`

### 2. Complex Aggregations
\`\`\`sql
CREATE VIEW department_summary AS
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS total_employees,
    AVG(e.salary) AS average_salary,
    SUM(e.salary) AS total_salary_cost
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;
\`\`\`

### 3. Security Implementation
\`\`\`sql
CREATE VIEW public_employee_info AS
SELECT 
    employee_id,
    first_name,
    last_name,
    department_name,
    hire_date
    -- Note: salary, email, phone excluded for security
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.is_active = TRUE;
\`\`\`

### 4. Updatable Views with CHECK OPTION
\`\`\`sql
CREATE VIEW high_salary_employees AS
SELECT 
    employee_id,
    first_name,
    last_name,
    salary
FROM employees
WHERE salary > 70000
WITH CHECK OPTION;
\`\`\`

## 🎤 Interview Questions Covered

### 1. What is a view?
A view is a virtual table based on a SQL query that provides a way to present data from one or more tables without storing the data physically.

### 2. Can we update data through a view?
Yes, if the view meets certain criteria: single table source, no aggregation functions, no DISTINCT, no GROUP BY, and includes key columns.

### 3. What is a materialized view?
MySQL doesn't support materialized views natively, but they can be simulated using regular tables with scheduled refresh procedures.

### 4. Difference between view and table?
- **Views**: Virtual, execute queries dynamically, provide abstraction
- **Tables**: Physical storage, persistent data, direct data access

### 5. How to drop a view?
\`\`\`sql
DROP VIEW IF EXISTS view_name;
\`\`\`

### 6. Why use views?
- **Simplicity**: Hide complex queries
- **Security**: Restrict data access
- **Consistency**: Standardize data presentation
- **Abstraction**: Logical data organization

### 7. Can we create indexed views?
MySQL doesn't support indexed views directly, but indexes on underlying tables improve view performance.

### 8. How to secure data using views?
- Exclude sensitive columns
- Use WHERE clauses to filter data
- Implement role-based permissions
- Use WITH CHECK OPTION for data integrity

### 9. What are limitations of views?
- Performance overhead for complex views
- Limited update capabilities
- Dependency on underlying tables
- Restrictions on certain operations

### 10. How does WITH CHECK OPTION work?
Ensures that INSERT/UPDATE operations through the view satisfy the view's WHERE clause, maintaining data integrity.

## 🔧 Usage Examples

### Basic Queries
\`\`\`sql
-- View all employees
SELECT * FROM employee_directory;

-- Department statistics
SELECT * FROM department_summary ORDER BY average_salary DESC;

-- Project assignments
SELECT * FROM project_assignments_detailed WHERE timeline_status = 'Due Soon';
\`\`\`

### Advanced Queries
\`\`\`sql
-- Find available employees for new projects
SELECT employee_name, workload_status, total_allocated_hours
FROM employee_workload_analysis 
WHERE workload_status IN ('Available', 'Light Load')
ORDER BY total_allocated_hours;

-- Department salary comparison
SELECT 
    department_name,
    average_salary,
    CASE 
        WHEN average_salary > (SELECT AVG(average_salary) FROM department_summary) 
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS comparison
FROM department_summary;
\`\`\`

### View Management
\`\`\`sql
-- Show all views
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- View definition
SHOW CREATE VIEW employee_directory;

-- Update view
CREATE OR REPLACE VIEW employee_directory AS
SELECT 
    employee_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    email,
    department_name,
    hire_date
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.is_active = TRUE;
\`\`\`

## 🚀 Advanced Features

### Window Functions (MySQL 8.0+)
\`\`\`sql
-- Salary rankings
SELECT 
    employee_name,
    salary,
    RANK() OVER (ORDER BY salary DESC) as salary_rank,
    DENSE_RANK() OVER (PARTITION BY department_name ORDER BY salary DESC) as dept_rank
FROM employee_salary_rankings;
\`\`\`

### JSON Functions (MySQL 5.7+)
\`\`\`sql
-- Department data as JSON
SELECT department_data 
FROM employee_json_summary 
WHERE department_name = 'Engineering';
\`\`\`

## 📈 Performance Considerations

### Best Practices
1. **Index underlying tables** properly
2. **Avoid complex views** in frequently executed queries
3. **Use EXPLAIN** to analyze view performance
4. **Consider materialized view alternatives** for heavy aggregations

### Performance Testing
\`\`\`sql
-- Compare direct query vs view performance
EXPLAIN SELECT * FROM employees e 
JOIN departments d ON e.department_id = d.department_id;

EXPLAIN SELECT * FROM employee_directory;
\`\`\`

## 🔒 Security Best Practices

### Access Control
1. **Grant minimal permissions** required
2. **Use views instead of direct table access**
3. **Implement role-based security**
4. **Regular security audits**

### Data Protection
1. **Hide sensitive columns** in public views
2. **Use WHERE clauses** for row-level security
3. **Implement WITH CHECK OPTION** for data integrity
4. **Log view access** for auditing

## 🐛 Troubleshooting

### Common Issues

**View not updatable**
- Check if view is based on single table
- Ensure no aggregation functions are used
- Verify all key columns are included

**Permission denied**
- Check user privileges on underlying tables
- Verify view permissions are granted
- Ensure proper database connection

**Performance issues**
- Add indexes to underlying tables
- Simplify complex view logic
- Consider breaking complex views into simpler ones

