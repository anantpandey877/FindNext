-- FindNext Database Schema
-- Application: FindNext - Job Portal with AI Resume Matching
-- Created: December 5, 2025

-- Create database
CREATE DATABASE IF NOT EXISTS findnext;
USE findnext;

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS applications;
DROP TABLE IF EXISTS resume_analysis_logs;
DROP TABLE IF EXISTS jobs;
DROP TABLE IF EXISTS users;

-- ==============================================
-- 1. USERS Table
-- Stores user data for job seekers, employers, and admins
-- ==============================================
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('user', 'employer', 'admin') NOT NULL DEFAULT 'user',
    status ENUM('active', 'blocked') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==============================================
-- 2. JOBS Table
-- Stores job listings posted by employers
-- ==============================================
CREATE TABLE jobs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    skills TEXT NOT NULL,
    company VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    experience VARCHAR(50),
    package_lpa VARCHAR(50),
    vacancies INT,
    employer_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(10) NOT NULL DEFAULT 'active',
    FOREIGN KEY (employer_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_employer (employer_id),
    INDEX idx_status (status),
    INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==============================================
-- 3. APPLICATIONS Table
-- Tracks job applications submitted by users
-- ==============================================
CREATE TABLE applications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    job_id INT NOT NULL,
    resume_path VARCHAR(255),
    score FLOAT,
    status ENUM('applied', 'shortlisted', 'rejected') DEFAULT 'applied',
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
    UNIQUE KEY unique_application (user_id, job_id),
    INDEX idx_user (user_id),
    INDEX idx_job (job_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==============================================
-- 4. RESUME_ANALYSIS_LOGS Table
-- Stores Affinda API JSON results for resumes
-- ==============================================
CREATE TABLE resume_analysis_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    result_json JSON NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==============================================
-- Sample Data Insertion
-- ==============================================

-- Insert sample admin user
INSERT INTO users (name, email, password, role, status) VALUES
('Admin User', 'admin@findnext.com', 'admin123', 'admin', 'active');

-- Insert sample employer
INSERT INTO users (name, email, password, role, status) VALUES
('HR Manager', 'hr@techcorp.com', 'employer123', 'employer', 'active');

-- Insert sample job seeker
INSERT INTO users (name, email, password, role, status) VALUES
('John Doe', 'john.doe@example.com', 'user123', 'user', 'active');

-- Insert sample job (employer_id=2 is the HR Manager)
INSERT INTO jobs (title, description, skills, company, location, experience, package_lpa, vacancies, employer_id, status) VALUES
('Full Stack Java Developer',
 'We are looking for an experienced Full Stack Java Developer to join our team. The ideal candidate should have strong knowledge of Java, Spring Boot, JSP, and modern web technologies.',
 'Java, Spring Boot, JSP, HTML, CSS, JavaScript, MySQL, Git',
 'TechCorp Solutions',
 'Bangalore, India',
 '2-4 years',
 '8-12 LPA',
 5,
 2,
 'active');

-- ==============================================
-- Verification Queries
-- ==============================================

-- Uncomment below queries to verify after setup:
-- SELECT 'Users Table' as 'Table', COUNT(*) as 'Row Count' FROM users
-- UNION ALL
-- SELECT 'Jobs Table', COUNT(*) FROM jobs
-- UNION ALL
-- SELECT 'Applications Table', COUNT(*) FROM applications
-- UNION ALL
-- SELECT 'Resume Analysis Logs Table', COUNT(*) FROM resume_analysis_logs;

-- SELECT * FROM users;
-- SELECT * FROM jobs;

COMMIT;

-- ==============================================
-- Setup Complete
-- ==============================================
-- Database: findnext
-- Tables Created: 4 (users, jobs, applications, resume_analysis_logs)
-- Sample Data: 3 users, 1 job
-- ==============================================

