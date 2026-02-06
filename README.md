# FindNext

FindNext is a Java web application built using Jakarta Servlets and JSP.  
It is designed for job posting and job applications, supporting both users and employers.

The application includes resume upload and update, resume analysis, and email-based OTP for verification and notifications.

## Highlights

- User and employer authentication  
- Job posting management for employers  
- Job applications and applicant management  
- Resume upload, update, and viewing  
- Resume parsing and analysis integration  
- Email OTP for account verification and password reset  
- Application status notifications  

## Tech Stack

- Java (Jakarta Servlet API)  
- JSP  
- Apache Tomcat 10.1.x  
- MySQL  

## Source Layout

src/main/java/  
Contains servlets, DAOs, models, and utility classes  

src/main/webapp/  
Contains JSP pages and static assets like CSS, JavaScript, and images  

src/main/resources/db/schema.sql  
Contains the database schema  

## Configuration

The application uses environment variables for configuration.

### Database

DB_URL  
DB_USER  
DB_PASSWORD  

### Resume Analysis

AFFINDA_API_KEY  

### Email Configuration

MAIL_USERNAME  
MAIL_PASSWORD  
MAIL_FROM  

## URLs and Context Path

The application runs under Tomcat’s context path, which usually matches the WAR file name.

Examples:

FindNext.war → /FindNext/  

Main entry route:

/home  

## Database Schema

The SQL schema file is located at:

src/main/resources/db/schema.sql  

## Deployment Artifact

A deployable WAR file may be provided as a GitHub Release asset.

This repository contains the source code.  
Deployment binaries are optional and may be included only in releases.

## Notes

If resume analysis fails due to network or DNS restrictions, ensure that the deployment environment allows outbound HTTPS access to the resume analysis API endpoint used by the application.

## Author

FindNext – Java Dynamic Web Application  
Developed as a full-stack Java web project using Servlets and JSP.
