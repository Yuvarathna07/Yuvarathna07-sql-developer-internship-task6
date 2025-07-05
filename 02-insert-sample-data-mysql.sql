-- Insert sample data for MySQL demonstration

-- Insert departments
INSERT INTO departments (department_name, location, budget) VALUES
('Engineering', 'New York', 500000.00),
('Marketing', 'Los Angeles', 200000.00),
('Sales', 'Chicago', 300000.00),
('Human Resources', 'New York', 150000.00),
('Finance', 'New York', 250000.00),
('IT Support', 'Remote', 180000.00);

-- Insert employees (managers first, then their reports)
INSERT INTO employees (first_name, last_name, email, phone, hire_date, salary, department_id, manager_id, is_active) VALUES
-- Department heads (no manager)
('John', 'Doe', 'john.doe@company.com', '555-0101', '2020-01-15', 95000.00, 1, NULL, TRUE),
('Mike', 'Johnson', 'mike.johnson@company.com', '555-0103', '2021-06-10', 85000.00, 2, NULL, TRUE),
('David', 'Brown', 'david.brown@company.com', '555-0105', '2019-11-12', 90000.00, 3, NULL, TRUE),
('Lisa', 'Davis', 'lisa.davis@company.com', '555-0106', '2022-02-28', 75000.00, 4, NULL, TRUE),
('Robert', 'Miller', 'robert.miller@company.com', '555-0107', '2020-09-15', 85000.00, 5, NULL, TRUE),

-- Team members
('Jane', 'Smith', 'jane.smith@company.com', '555-0102', '2020-03-20', 80000.00, 1, 1, TRUE),
('Sarah', 'Williams', 'sarah.williams@company.com', '555-0104', '2021-08-05', 70000.00, 2, 2, TRUE),
('Emily', 'Wilson', 'emily.wilson@company.com', '555-0108', '2023-01-10', 65000.00, 1, 1, TRUE),
('Tom', 'Anderson', 'tom.anderson@company.com', '555-0109', '2022-05-20', 72000.00, 3, 3, TRUE),
('Anna', 'Taylor', 'anna.taylor@company.com', '555-0110', '2023-03-15', 58000.00, 4, 4, TRUE),
('Chris', 'Moore', 'chris.moore@company.com', '555-0111', '2021-12-01', 78000.00, 5, 5, TRUE),
('Jessica', 'White', 'jessica.white@company.com', '555-0112', '2022-09-10', 62000.00, 6, NULL, TRUE),

-- Inactive employee
('Mark', 'Thompson', 'mark.thompson@company.com', '555-0113', '2020-07-01', 68000.00, 1, 1, FALSE);

-- Insert projects
INSERT INTO projects (project_name, start_date, end_date, budget, status) VALUES
('Website Redesign', '2023-01-01', '2023-06-30', 100000.00, 'Completed'),
('Mobile App Development', '2023-03-15', '2024-03-31', 200000.00, 'Active'),
('Marketing Campaign Q4', '2023-10-01', '2023-12-31', 75000.00, 'Completed'),
('Database Migration', '2023-02-01', '2023-08-31', 150000.00, 'Completed'),
('Customer Portal', '2023-07-01', '2024-06-30', 180000.00, 'Active'),
('ERP Implementation', '2024-01-01', '2024-12-31', 300000.00, 'Active'),
('Security Audit', '2023-11-01', '2024-02-28', 50000.00, 'On Hold');

-- Insert employee-project assignments
INSERT INTO employee_projects (employee_id, project_id, role, hours_allocated, assigned_date) VALUES
(1, 1, 'Project Manager', 40, '2023-01-01'),
(2, 1, 'Lead Developer', 35, '2023-01-01'),
(8, 1, 'Junior Developer', 30, '2023-01-15'),

(1, 2, 'Technical Lead', 30, '2023-03-15'),
(2, 2, 'Senior Developer', 40, '2023-03-15'),
(8, 2, 'Developer', 35, '2023-03-15'),

(3, 3, 'Marketing Manager', 40, '2023-10-01'),
(7, 3, 'Marketing Specialist', 35, '2023-10-01'),

(1, 4, 'Technical Consultant', 20, '2023-02-01'),
(12, 4, 'System Administrator', 40, '2023-02-01'),

(2, 5, 'Lead Developer', 35, '2023-07-01'),
(8, 5, 'Frontend Developer', 40, '2023-07-01'),

(5, 6, 'Financial Analyst', 25, '2024-01-01'),
(11, 6, 'Project Coordinator', 30, '2024-01-01'),

(12, 7, 'Security Specialist', 40, '2023-11-01');
