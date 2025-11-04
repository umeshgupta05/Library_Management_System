# 📚 Library Management System

**Technology Stack:** Java, JSP, Servlets, Oracle Database XE, Apache Tomcat 9.0.96  
**Version:** 2.0  
**Last Updated:** November 4, 2025

---

## 📋 Table of Contents

1. [Features](#features)
2. [Project Statistics](#project-statistics)
3. [Quick Start](#quick-start)
4. [Database Configuration](#database-configuration)
5. [Database Schema](#database-schema)
6. [Project Structure](#project-structure)
7. [Security](#security)
8. [Testing](#testing)
9. [Troubleshooting](#troubleshooting)

---

## ✨ Features

- 🔐 **Session-Based Authentication** - Secure login/logout system
- 📖 **Book Management** - Add and search books
- 📚 **Book Issuing** - Issue books to students (max 4 per student)
- 📤 **Book Returns** - Process book returns with timestamp tracking
- 👨‍🎓 **Student Management** - Register and view student information
- 📋 **Borrowed Books Tracking** - View all books borrowed by students
- ⏰ **Complete Audit Trail** - Timestamp tracking for all transactions
- 🚫 **Business Rules Enforcement** - 4-book limit, duplicate prevention

---

## 📊 Project Statistics

- **JSP Pages:** 10 (Login, Index, Welcome, AddBook, SearchBook, IssueBook, ReturnBook, AddStudent, ViewStudentInfo)
- **Servlets:** 3 (CheckLoginServlet, LogoutServlet)
- **Database Tables:** 3 (Books, Students, BorrowedBooks)
- **Configuration Files:** 1 (DatabaseConfig)
- **Security Level:** ✅ Credentials separated from code

---

## 🚀 Quick Start

### Prerequisites

- Java JDK 8+
- Apache Tomcat 9.0+
- Oracle Database XE
- Oracle JDBC Driver (ojdbc.jar in Tomcat's lib folder)

### Installation Steps

**1. Setup Database**

Run the SQL script to create all tables:

```bash
sqlplus system/your_password@localhost:1521/XE @setup_borrowed_books.sql
```

**2. Configure Database Credentials**

Edit `WEB-INF/classes/config/DatabaseConfig.java`:

```java
private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:XE";
private static final String DB_USERNAME = "system";
private static final String DB_PASSWORD = "your_password";
```

Compile the configuration:

```bash
cd WEB-INF/classes
javac config/DatabaseConfig.java
```

**3. Start Application**

```bash
# Start Oracle Database
net start OracleServiceXE

# Start Tomcat
cd apache-tomcat-9.0.96\bin
startup.bat

# Access: http://localhost:8080/AdJava/
```

**4. Login**

- Username: `admin`
- Password: `password123`

---

## 🔐 Database Configuration

### Centralized Credentials

All database credentials are now managed through `DatabaseConfig.java`:

```
WEB-INF/classes/config/DatabaseConfig.java
```

**Benefits:**

- ✅ Single point of configuration
- ✅ No hardcoded credentials in JSP files
- ✅ Easy to change for different environments
- ✅ Git-ignored for security

**Usage in JSP:**

```jsp
<%@ page import="config.DatabaseConfig" %>
<%
    Class.forName(DatabaseConfig.getDriver());
    Connection conn = DriverManager.getConnection(
        DatabaseConfig.getUrl(),
        DatabaseConfig.getUsername(),
        DatabaseConfig.getPassword()
    );
%>
```

---

## 🗄️ Database Schema

---

## 🗄️ Database Schema

### Tables Overview

**1. Books Table**

```sql
CREATE TABLE Books (
    book_id NUMBER PRIMARY KEY,
    book_name VARCHAR2(200) NOT NULL,
    author VARCHAR2(100) NOT NULL,
    isbn VARCHAR2(20) UNIQUE NOT NULL,
    added_date DATE DEFAULT SYSDATE
);
```

**2. Students Table**

```sql
CREATE TABLE Students (
    student_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    contact VARCHAR2(20) NOT NULL,
    registered_date DATE DEFAULT SYSDATE
);
```

**3. BorrowedBooks Table**

```sql
CREATE TABLE BorrowedBooks (
    borrow_id NUMBER PRIMARY KEY,
    student_id NUMBER NOT NULL,
    book_id NUMBER NOT NULL,
    borrow_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    return_date TIMESTAMP,
    CONSTRAINT fk_borrowed_student FOREIGN KEY (student_id) REFERENCES Students(student_id),
    CONSTRAINT fk_borrowed_book FOREIGN KEY (book_id) REFERENCES Books(book_id)
);
```

### Sequences

- `Books_seq` - Auto-generates book IDs
- `BorrowedBooks_seq` - Auto-generates borrow transaction IDs

---

## 🗄️ Database Schema

### Connection Details

```properties
Driver: oracle.jdbc.driver.OracleDriver
URL: jdbc:oracle:thin:@localhost:1521:XE
Username: system
Password: 767089amma (update as needed)
Port: 1521
SID: XE
```

### Tables

#### Books Table

```sql
CREATE TABLE Books (
    book_id NUMBER PRIMARY KEY,          -- Auto-generated via sequence
    book_name VARCHAR2(200) NOT NULL,    -- Book title
    author VARCHAR2(100) NOT NULL,       -- Author name
    isbn VARCHAR2(20) UNIQUE NOT NULL,   -- ISBN number (unique)
    added_date DATE DEFAULT SYSDATE      -- Date added to library
>>>>>>> 9563ec3c824cbae64cee5f6732934103e642c067
);
```

### Sequences

- `Books_seq` - Auto-generates book IDs
- `BorrowedBooks_seq` - Auto-generates borrow transaction IDs

### Business Rules

- ✅ Maximum 4 books per student at a time
- ✅ Same book cannot be borrowed twice by same student simultaneously
- ✅ return_date = NULL means book is currently borrowed
- ✅ All transactions timestamped with SYSTIMESTAMP

---

## 📁 Project Structure

```
AdJava/
├── index.jsp                    # Landing page
├── Login.jsp                    # Login form
├── welcome.jsp                  # Dashboard (6 features)
├── addBook.jsp                  # Add new book
├── searchBook.jsp               # Search books
├── issueBook.jsp                # Issue book to student
├── returnBook.jsp               # Return book from student
├── addStudent.jsp               # Register student
├── viewStudentInfo.jsp          # View student & borrowed books
├── setup_borrowed_books.sql     # Database setup script
├── run_setup.bat                # Batch file to run SQL
├── .gitignore                   # Excludes DatabaseConfig from git
├── Readme.md                    # This file
└── WEB-INF/
    ├── web.xml                  # Servlet mappings
    └── classes/
        ├── CheckLoginServlet.java         # Login handler
        ├── CheckLoginServlet.class
        ├── LogoutServlet.java             # Logout handler
        ├── LogoutServlet.class
        └── config/
            ├── DatabaseConfig.java         # DB credentials (git-ignored)
            ├── DatabaseConfig.class
            └── DatabaseConfig_TEMPLATE.java # Template for setup
```

---

## 🔒 Security

### Implemented Security Features

1. **Session-Based Authentication**

   - All pages check for valid session
   - Redirect to login if unauthorized
   - Logout invalidates session completely

2. **Centralized Database Configuration**

   - Credentials in separate `DatabaseConfig.java`
   - No hardcoded passwords in JSP files
   - Git-ignored to prevent credential exposure

3. **SQL Injection Prevention**

   - All queries use `PreparedStatement`
   - Parameter binding instead of string concatenation
   - Input validation and sanitization

4. **Input Validation**
   - Trim and empty checks on all inputs
   - NumberFormatException handling
   - Duplicate entry prevention

### Files Using DatabaseConfig

- ✅ `addBook.jsp`
- ✅ `addStudent.jsp`
- ✅ `searchBook.jsp`
- ✅ `viewStudentInfo.jsp`
- ✅ `issueBook.jsp`
- ✅ `returnBook.jsp`

### .gitignore Configuration

```
WEB-INF/classes/config/DatabaseConfig.class
WEB-INF/classes/config/DatabaseConfig.java
*.class
*.log
```

---

## 🧪 Testing

### Test Scenarios

**1. Login System**

- Login with correct credentials (admin/password123)
- Login with incorrect credentials
- Access protected pages without login
- Logout and verify session cleared

**2. Book Management**

- Add new book
- Search by book name
- Search by author name
- Add duplicate ISBN (should fail)

**3. Student Management**

- Register new student
- View student information
- Register with duplicate ID (should fail)
- Register with duplicate email (should fail)

**4. Book Borrowing**

- Issue book to student
- Check book count (X/4)
- Try issuing 5th book (should fail)
- View borrowed books in student info
- Borrow same book twice (should fail)

**5. Book Returns**

- Return a borrowed book
- Verify book count decreases
- Try returning non-borrowed book (should fail)
- Verify timestamp recorded

---

## ❗ Troubleshooting

---

## ❗ Troubleshooting

### Common Issues

**1. ClassNotFoundException: config.DatabaseConfig**

```
Solution: Compile DatabaseConfig.java
cd WEB-INF/classes
javac config/DatabaseConfig.java
```

**2. ORA-01017: Invalid username/password**

```
Solution: Update credentials in DatabaseConfig.java
Check: sqlplus system/password@localhost:1521/XE
```

**3. HTTP 404 - Page Not Found**

```
Solution: Verify Tomcat is running and URL is correct
URL: http://localhost:8080/AdJava/
```

**4. Session Lost / Not Logged In**

```
Solution: Check session timeout in web.xml
Clear browser cookies and login again
```

**5. Book Not Issuing (4-Book Limit)**

```
Solution: Student has 4 books already borrowed
Return books first, then issue new ones
```

**6. Oracle Database Not Running**

```
Solution: net start OracleServiceXE
Check: lsnrctl status
```

---

## 📝 Key Interview Points

### Architecture

- **MVC Pattern**: JSP (View), Servlets (Controller), Database (Model)
- **Session Management**: HttpSession for authentication state
- **Centralized Configuration**: DatabaseConfig class for credentials

### Security

- **SQL Injection Prevention**: PreparedStatement with parameter binding
- **Session Security**: All pages check authentication before display
- **Credential Management**: Separated from code, git-ignored

### Database

- **Referential Integrity**: Foreign keys ensure data consistency
- **Sequences**: Auto-increment primary keys
- **Timestamps**: SYSTIMESTAMP for precise tracking
- **Constraints**: Check constraints for business rules

### Business Logic

- **4-Book Limit**: COUNT query with WHERE return_date IS NULL
- **Duplicate Prevention**: UNIQUE constraints and validation
- **Audit Trail**: Never delete, update return_date instead

### Technologies

- **Frontend**: JSP, HTML5, CSS3 (responsive gradient design)
- **Backend**: Java Servlets, JDBC
- **Database**: Oracle 11g XE
- **Server**: Apache Tomcat 9.0.96

---

**Project Status:** ✅ Production Ready  
**Security Level:** ✅ Credentials Secured  
**Last Updated:** November 4, 2025
├── 📄 welcome.jsp # Dashboard
├── 📄 addBook.jsp # Add book form
├── 📄 addStudent.jsp # Add student form
├── 📄 searchBook.jsp # Search books
├── 📄 viewStudentInfo.jsp # View student info
├── 📄 RandomNumberGenerator.jsp # Random number utility
│
├── 📁 WEB-INF/
│ ├── 📄 web.xml # Deployment descriptor
│ └── 📁 classes/
│ ├── 📄 CheckLoginServlet.java # Login servlet
│ └── 📄 SessionCookieServlet.java # Session demo servlet
│
├── 📘 DOCUMENTATION.md # This file
└── 📄 AdJava.iml # IntelliJ project file

````

### File Descriptions

| File                      | Purpose                     | Lines |
| ------------------------- | --------------------------- | ----- |
| index.jsp                 | Landing page with modern UI | ~120  |
| Login.jsp                 | User authentication         | ~100  |
| welcome.jsp               | Main dashboard              | ~140  |
| addBook.jsp               | Add books (INSERT)          | ~180  |
| addStudent.jsp            | Register students (INSERT)  | ~185  |
| searchBook.jsp            | Search books (SELECT)       | ~190  |
| viewStudentInfo.jsp       | View student details        | ~185  |
| RandomNumberGenerator.jsp | Random utility              | ~90   |
| CheckLoginServlet.java    | Login handler               | ~25   |
| SessionCookieServlet.java | Session demo                | ~70   |

---

## 🎯 Features & Usage

### 1. Home Page (index.jsp)

- **URL**: `http://localhost:8080/AdJava/`
- **Features**: Feature overview, navigation to all modules
- **Design**: Modern gradient design with feature cards

### 2. Login System

- **URL**: `http://localhost:8080/AdJava/Login.jsp`
- **Credentials**: admin / password123
- **Servlet**: CheckLoginServlet
- **Success**: Redirects to welcome.jsp
- **Failure**: Shows error message on Login.jsp

### 3. Dashboard (welcome.jsp)

- **Access**: After successful login
- **Features**: 6 main modules accessible via cards
- **Design**: Navbar with logout, feature grid

### 4. Add Book Module

- **URL**: Via dashboard or direct
- **Database**: INSERT into Books table
- **Auto-generated**: book_id via Books_seq
- **Required Fields**: book_name, author, isbn
- **Validation**: Empty fields, duplicate ISBN

### 5. Search Books

- **URL**: Via dashboard
- **Database**: SELECT with LIKE query
- **Search**: By book name OR author (case-insensitive)
- **Security**: Uses PreparedStatement
- **Display**: Table format with all book details

### 6. Add Student

- **URL**: Via dashboard
- **Database**: INSERT into Students table
- **Required Fields**: student_id, name, email, contact
- **Validation**: Numeric ID, email format, duplicate checks

### 7. View Student Info

- **URL**: Via dashboard
- **Database**: SELECT by student_id
- **Input**: Student ID (numeric)
- **Display**: Card-based layout with all details

### 8. Random Number Generator

- **URL**: Via dashboard
- **Function**: Generates 2 random numbers (1-100)
- **Purpose**: Utility demonstration

### 9. Session/Cookie Demo

- **URL**: `http://localhost:8080/AdJava/SessionCookieServlet`
- **Function**: Creates session cookie (10 min expiry)
- **Purpose**: Session management demonstration

---

## ⚙️ Configuration

### web.xml Configuration

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
         http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
         version="3.1">

    <welcome-file-list>
        <welcome-file>index.jsp</welcome-file>
    </welcome-file-list>

    <servlet>
        <servlet-name>CheckLoginServlet</servlet-name>
        <servlet-class>CheckLoginServlet</servlet-class>
    </servlet>

    <servlet>
        <servlet-name>SessionCookieServlet</servlet-name>
        <servlet-class>SessionCookieServlet</servlet-class>
    </servlet>

    <servlet-mapping>
        <servlet-name>CheckLoginServlet</servlet-name>
        <url-pattern>/CheckLoginServlet</url-pattern>
    </servlet-mapping>

    <servlet-mapping>
        <servlet-name>SessionCookieServlet</servlet-name>
        <url-pattern>/SessionCookieServlet</url-pattern>
    </servlet-mapping>
</web-app>
````

### JDBC Configuration (in JSP files)

```java
// Database connection settings
Class.forName("oracle.jdbc.driver.OracleDriver");
String url = "jdbc:oracle:thin:@localhost:1521:XE";
String username = "system";
String password = "767089amma";  // UPDATE THIS
Connection conn = DriverManager.getConnection(url, username, password);
```

---

## 🚀 Deployment Guide

### Pre-Deployment Checklist

#### Code Compilation

- [ ] Compile CheckLoginServlet.java
- [ ] Compile SessionCookieServlet.java
- [ ] Verify .class files in WEB-INF/classes/

```cmd
cd webapps\AdJava\WEB-INF\classes
javac -cp "..\..\..\..\lib\servlet-api.jar" *.java
```

#### Configuration

- [ ] Update database credentials in all JSP files
- [ ] Verify web.xml servlet mappings
- [ ] Check JDBC driver in Tomcat/lib/ or WEB-INF/lib/
- [ ] Verify Tomcat port (default 8080)

#### Database

- [ ] Oracle service running
- [ ] Tables created (Books, Students)
- [ ] Sequence created (Books_seq)
- [ ] Test connection: `sqlplus system/password@localhost:1521/XE`
- [ ] Sample data inserted (optional)

#### File Structure

```
AdJava/
├── *.jsp (8 files)
├── WEB-INF/
│   ├── web.xml
│   ├── classes/
│   │   ├── CheckLoginServlet.class
│   │   └── SessionCookieServlet.class
│   └── lib/
│       └── ojdbc.jar (if not in Tomcat/lib)
└── DOCUMENTATION.md
```

### Deployment Steps

1. **Stop Tomcat**

   ```cmd
   cd apache-tomcat-9.0.96\bin
   shutdown.bat
   ```

2. **Clear Cache (optional)**

   - Delete `work/` directory contents
   - Delete `temp/` directory contents

3. **Deploy Application**

   - Ensure AdJava folder is in webapps/
   - Verify all files present

4. **Compile Servlets**

   ```cmd
   cd webapps\AdJava\WEB-INF\classes
   javac -cp "..\..\..\..\lib\servlet-api.jar" *.java
   ```

5. **Start Tomcat**

   ```cmd
   cd apache-tomcat-9.0.96\bin
   startup.bat
   ```

6. **Verify Deployment**
   - Check logs: `logs/catalina.out`
   - Access: `http://localhost:8080/AdJava/`
   - Test login functionality

---

## ✅ Testing Checklist

### Functional Testing

#### Login Module

- [ ] Valid credentials (admin/password123) → Success
- [ ] Invalid credentials → Error message displayed
- [ ] Empty fields → Validation error
- [ ] Redirect to welcome.jsp on success

#### Add Book Module

- [ ] Add book with all valid fields → Success message
- [ ] Empty fields → Validation error
- [ ] Duplicate ISBN → Error handled
- [ ] Book added to database (verify with SQL)
- [ ] Auto-generated book_id works

#### Search Book Module

- [ ] Search by exact book name → Results shown
- [ ] Search by partial book name → Results shown
- [ ] Search by author → Results shown
- [ ] Case-insensitive search works
- [ ] No results → "No books found" message
- [ ] Results display in table format

#### Add Student Module

- [ ] Add student with valid data → Success
- [ ] Empty fields → Validation error
- [ ] Non-numeric student ID → Error
- [ ] Duplicate student ID → Error handled
- [ ] Duplicate email → Error handled
- [ ] Student added to database

#### View Student Info

- [ ] Search existing student ID → Details displayed
- [ ] Search non-existent ID → "Not found" message
- [ ] Non-numeric input → Error handled
- [ ] Card display format correct
- [ ] All fields visible

#### Other Modules

- [ ] Random number generator works
- [ ] Session cookie servlet displays correctly
- [ ] All navigation links work
- [ ] Back buttons functional

### UI/UX Testing

- [ ] Consistent design across all pages
- [ ] Gradient backgrounds display correctly
- [ ] Hover effects work on buttons
- [ ] Forms are properly styled
- [ ] Error messages color-coded correctly
- [ ] Success messages display properly
- [ ] Responsive on different screen sizes

### Security Testing

- [ ] SQL injection attempts blocked (PreparedStatement)
- [ ] Input validation working
- [ ] Error messages don't expose system details

---

## 🐛 Troubleshooting

### Issue 1: Can't Access Application

**Error**: 404 Not Found

**Solutions**:

1. Verify Tomcat is running:
   ```cmd
   # Check if process is running
   tasklist | findstr java
   ```
2. Check URL is correct: `http://localhost:8080/AdJava/` (case-sensitive)
3. Verify AdJava folder exists in webapps/
4. Check Tomcat logs:
   ```cmd
   type logs\catalina.out
   ```

### Issue 2: Database Connection Error

**Error**: SQLException or Connection refused

**Solutions**:

1. Verify Oracle service is running:
   ```cmd
   services.msc
   # Look for: OracleServiceXE and start it
   ```
2. Test connection:
   ```cmd
   sqlplus system/password@localhost:1521/XE
   ```
3. Verify credentials in JSP files match Oracle
4. Check if tables exist:
   ```sql
   SELECT table_name FROM user_tables;
   ```

### Issue 3: Login Not Working

**Error**: 404 or Servlet not found

**Solutions**:

1. Check web.xml has CheckLoginServlet mapping
2. Verify servlet is compiled (.class file exists)
3. Check servlet class is in WEB-INF/classes/
4. Restart Tomcat after changes

### Issue 4: Servlet Compilation Errors

**Error**: javax.servlet cannot be resolved (in IDE)

**This is NORMAL!** Servlets will work in Tomcat runtime.

**To fix IDE errors (optional)**:

1. Add servlet-api.jar to project classpath
2. Or configure Tomcat library in IDE
3. **Note**: Not required for deployment

### Issue 5: Books Not Adding

**Error**: SQL Exception

**Solutions**:

1. Check Books_seq exists:
   ```sql
   SELECT sequence_name FROM user_sequences;
   ```
2. Verify Books table structure
3. Check for duplicate ISBN
4. Review error message in browser

### Issue 6: Search Returns Nothing

**Possible Causes**:

1. No data in Books table
2. Case mismatch (should be handled by UPPER())
3. Typo in search term

**Solutions**:

1. Add sample books via addBook.jsp
2. Or insert via SQL:
   ```sql
   INSERT INTO Books VALUES (Books_seq.NEXTVAL, 'Test Book', 'Test Author', 'ISBN123', SYSDATE);
   COMMIT;
   ```

---

## 🎓 Interview Preparation

### Technical Concepts Covered

#### 1. Java Servlets

- **Lifecycle**: init() → service() → destroy()
- **Methods**: doGet(), doPost()
- **Request Forwarding**: RequestDispatcher
- **Annotations**: @WebServlet
- **Session Management**: HttpSession, Cookies

#### 2. JSP (JavaServer Pages)

- **Scriptlets**: `<% ... %>`
- **Expressions**: `<%= ... %>`
- **Directives**: `<%@ page ... %>`
- **Error Handling**: Try-catch blocks
- **Form Processing**: request.getParameter()

#### 3. JDBC

- **Driver Loading**: Class.forName()
- **Connection**: DriverManager.getConnection()
- **PreparedStatement**: SQL injection prevention
- **ResultSet**: Data retrieval
- **Transaction**: Commit/Rollback
- **Resource Management**: finally blocks

#### 4. Database Design

- **Primary Keys**: book_id, student_id
- **Unique Constraints**: isbn, email
- **Sequences**: Auto-increment for IDs
- **Normalization**: Tables are in 3NF
- **Constraints**: NOT NULL, UNIQUE, PRIMARY KEY

#### 5. Web Architecture

- **MVC Pattern**: Servlet (Controller), JSP (View), Database (Model)
- **Request-Response**: HTTP GET/POST
- **Session vs Cookie**: Difference and usage
- **Deployment Descriptor**: web.xml configuration

### Key Points to Mention

1. **UI/UX Excellence**

   - "Redesigned entire application with modern gradient design"
   - "Implemented responsive layouts with CSS3"
   - "Added smooth animations and hover effects"
   - "Consistent design language across all pages"

2. **Security Implementation**

   - "Used PreparedStatement to prevent SQL injection"
   - "Implemented server-side validation on all forms"
   - "Proper error handling without exposing system details"
   - "Resource cleanup in finally blocks"

3. **Code Quality**

   - "Followed Java EE best practices"
   - "Comprehensive error handling with try-catch"
   - "Input validation with trim() and empty checks"
   - "UTF-8 encoding for international character support"

4. **Database Design**

   - "Normalized tables with appropriate constraints"
   - "Used sequences for auto-incrementing IDs"
   - "Implemented unique constraints for data integrity"
   - "Proper indexing on primary and unique keys"

5. **Project Management**
   - "Complete documentation for maintenance"
   - "Modular code structure for scalability"
   - "Configuration separated from code"
   - "Version control ready"

### Sample Interview Questions & Answers

**Q1: Explain the architecture of your application.**

> "The application follows a Servlet-JSP architecture, which is a variation of MVC. Servlets act as controllers handling business logic, JSPs serve as views for presentation, and Oracle Database is the model layer. Users interact with JSP pages, which submit requests to servlets. Servlets process the requests, interact with the database via JDBC, and forward results back to JSPs for display."

**Q2: How did you prevent SQL injection?**

> "I used PreparedStatement instead of Statement for all database queries. PreparedStatement uses parameter binding, which treats user input as data rather than executable SQL code. For example, in searchBook.jsp, instead of concatenating strings, I use pstmt.setString() to bind parameters safely."

**Q3: What is the purpose of the Books_seq sequence?**

> "Books_seq is an Oracle sequence that auto-generates unique book IDs. When inserting a new book, we use Books_seq.NEXTVAL to get the next available ID, ensuring uniqueness without manual ID management. This prevents ID conflicts and simplifies the insertion process."

**Q4: How do you handle database connection errors?**

> "I implement comprehensive error handling using try-catch-finally blocks. Database operations are in try blocks, exceptions are caught and user-friendly error messages are displayed, and database resources (ResultSet, PreparedStatement, Connection) are closed in finally blocks to prevent resource leaks."

**Q5: Explain the difference between session and cookies.**

> "Sessions store data on the server side with a session ID sent to the client, while cookies store data on the client side. Sessions are more secure for sensitive data but consume server memory. Cookies can persist across browser sessions. In my SessionCookieServlet, I demonstrate cookie creation with a 10-minute expiration."

---

## 📊 Project Enhancements Summary

### What Was Enhanced

1. **UI/UX** - Complete redesign with modern gradient design
2. **Security** - Fixed SQL injection vulnerability
3. **Validation** - Enhanced form validation and error handling
4. **Code Quality** - UTF-8 encoding, resource cleanup, exception handling
5. **Configuration** - Fixed web.xml, added servlet mappings
6. **Documentation** - Comprehensive documentation in one file

### Bug Fixes

- ✅ Fixed SQL injection in searchBook.jsp (Statement → PreparedStatement)
- ✅ Fixed character encoding (UTF-8) in all JSP files
- ✅ Fixed missing CheckLoginServlet mapping in web.xml
- ✅ Enhanced error handling with try-catch blocks
- ✅ Fixed resource cleanup in finally blocks
- ✅ Added proper validation for all forms

### Security Improvements

- ✅ PreparedStatement for all queries
- ✅ Input validation and sanitization
- ✅ Server-side validation
- ✅ Proper error messages (no stack traces to users)

---

## 📞 Quick Reference

### Important URLs

- **Home**: `http://localhost:8080/AdJava/`
- **Login**: `http://localhost:8080/AdJava/Login.jsp`
- **Dashboard**: `http://localhost:8080/AdJava/welcome.jsp`

### Login Credentials

- **User ID**: `admin`
- **Password**: `password123`

### Database Connection

- **URL**: `jdbc:oracle:thin:@localhost:1521:XE`
- **Username**: `system`
- **Password**: `767089amma` (update in JSP files)

### Commands

```cmd
# Start Oracle
net start OracleServiceXE

# Start Tomcat
cd apache-tomcat-9.0.96\bin
startup.bat

# Stop Tomcat
shutdown.bat

# View Logs
type logs\catalina.out
```

---

## ✅ Final Checklist

### Before Interview

- [ ] Review database schema
- [ ] Understand servlet lifecycle
- [ ] Know JSP syntax
- [ ] Review JDBC concepts
- [ ] Practice explaining MVC pattern
- [ ] Test all features
- [ ] Prepare code walkthrough
- [ ] Review error handling approach
- [ ] Understand security measures

### Before Deployment

- [ ] Update database credentials in JSP files
- [ ] Compile all servlets
- [ ] Create database tables
- [ ] Test database connectivity
- [ ] Verify all files present
- [ ] Check Tomcat configuration
- [ ] Test application thoroughly
- [ ] Review logs for errors

---

## 🎉 Project Status

**Overall Status**: ✅ **PRODUCTION READY**  
**Quality**: ⭐⭐⭐⭐⭐ (5/5)  
**Documentation**: ✅ **COMPLETE**  
**Interview Ready**: ✅ **YES**

---

**Developed by**: Library Management System Team  
**Last Updated**: November 4, 2025  
**Version**: 1.0  
**Status**: Ready for Deployment ✅
