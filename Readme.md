# 📚 Library Management System

A modern, secure, and production-ready Library Management System built using **Spring Boot**, **JSP**, **Spring Data JPA**, and **Oracle Database XE**.

**Version:** 2.0  
**Last Updated:** November 4, 2025  

---

## 🛠️ Technology Stack

| Technology       | Version | Purpose                 |
|------------------|---------|-------------------------|
| Java             | 17      | Programming Language    |
| Spring Boot      | 3.2.0   | Framework               |
| Spring Security  | 6.x     | Authentication          |
| Spring Data JPA  | 3.x     | Data Access Layer       |
| Hibernate        | 6.x     | ORM Layer               |
| JSP + JSTL       | 2.3     | View Layer              |
| Oracle XE        | 11g+    | Production Database     |
| H2 Database      | Latest  | Development Database    |
| Apache Tomcat    | 9.0.96  | Application Server      |
| Maven            | 3.6+    | Build Tool              |

---

## 🌟 Features

### Core Features
- 🔐 Session-based secure login (Spring Security)
- 📚 Complete Book Management (Add/Update/Delete/Search)
- 👨‍🎓 Student Registration & Management
- 📖 Issue Books (Limit: 4 per student)
- 📤 Book Returns with timestamps
- 💰 Automatic Fine Calculation (₹5/day overdue)
- 🔍 Advanced Search (title, author, ISBN, category)
- 📊 Admin Dashboard with analytics
- 📝 Audit Trail for all transactions

### Technical Highlights
- BCrypt password hashing  
- PreparedStatements for SQL Injection protection  
- Centralized DB configuration  
- Exception handling & input validation  
- H2 database for development  
- Oracle XE for production  
- Responsive modern JSP UI  

---

## 📁 Project Structure

Library_Management_System/
├── src/main/java/com/library/
│ ├── controller/
│ ├── service/
│ ├── repository/
│ ├── model/
│ └── config/
├── src/main/resources/
│ ├── application.properties
│ └── static/
├── src/main/webapp/WEB-INF/views/
│ ├── Login.jsp
│ ├── welcome.jsp
│ ├── addBook.jsp
│ ├── searchBook.jsp
│ ├── addStudent.jsp
│ ├── viewStudentInfo.jsp
│ ├── issueBook.jsp
│ └── returnBook.jsp
├── pom.xml
└── README.md

yaml
Copy code

---

## 🚀 Quick Start

### Prerequisites
- Java 17+
- Maven 3.6+
- Oracle XE (optional for production)

### Installation

```bash
git clone https://github.com/umeshgupta05/Library_Management_System.git
cd Library_Management_System
mvn clean install
mvn spring-boot:run
Access Application
arduino
Copy code
http://localhost:8080
Default Credentials
makefile
Copy code
Username: admin
Password: password123
🗄️ Database Configuration
H2 Database (Default)
H2 Console:

bash
Copy code
http://localhost:8080/h2-console
Default credentials:

yaml
Copy code
JDBC URL: jdbc:h2:mem:librarydb
Username: sa
Password:
Oracle XE (Production)
Edit application.properties:

properties
Copy code
spring.datasource.url=jdbc:oracle:thin:@localhost:1521:XE
spring.datasource.username=system
spring.datasource.password=your_password
spring.datasource.driver-class-name=oracle.jdbc.OracleDriver
spring.jpa.database-platform=org.hibernate.dialect.OracleDialect
🗄️ Database Schema
1. Books Table
sql
Copy code
CREATE TABLE Books (
  book_id NUMBER PRIMARY KEY,
  book_name VARCHAR2(200) NOT NULL,
  author VARCHAR2(100) NOT NULL,
  isbn VARCHAR2(20) UNIQUE NOT NULL,
  added_date DATE DEFAULT SYSDATE
);
2. Students Table
sql
Copy code
CREATE TABLE Students (
  student_id NUMBER PRIMARY KEY,
  name VARCHAR2(100) NOT NULL,
  email VARCHAR2(100) UNIQUE NOT NULL,
  contact VARCHAR2(20) NOT NULL,
  registered_date DATE DEFAULT SYSDATE
);
3. BorrowedBooks Table
sql
Copy code
CREATE TABLE BorrowedBooks (
  borrow_id NUMBER PRIMARY KEY,
  student_id NUMBER NOT NULL,
  book_id NUMBER NOT NULL,
  borrow_date TIMESTAMP DEFAULT SYSTIMESTAMP,
  return_date TIMESTAMP,
  CONSTRAINT fk_borrowed_student FOREIGN KEY (student_id) REFERENCES Students(student_id),
  CONSTRAINT fk_borrowed_book FOREIGN KEY (book_id) REFERENCES Books(book_id)
);
Sequences
sql
Copy code
CREATE SEQUENCE Books_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE BorrowedBooks_seq START WITH 1 INCREMENT BY 1;
🧭 API Endpoints
Public
Method	Endpoint	Description
GET	/login	Login page
POST	/login	Authenticate

Protected (Requires Login)
Method	Endpoint	Description
GET	/welcome	Dashboard
GET	/books/add	Add Book
GET	/books/search	Search Books
GET	/students/add	Add Student
GET	/students/view	View Student Info
GET	/issues/issue	Issue Book
GET	/issues/return	Return Book
GET	/issues/all	List all issues

⚙️ Configuration
application.properties
properties
Copy code
server.port=8080
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp
spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=update
server.servlet.session.timeout=30m
