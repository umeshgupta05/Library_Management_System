<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is logged in
    String username = null;
    HttpSession userSession = request.getSession(false);
    
    if (userSession != null) {
        username = (String) userSession.getAttribute("username");
    }
    
    // If no session, check cookie
    if (username == null) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName())) {
                    username = cookie.getValue();
                    break;
                }
            }
        }
    }
    
    // If still no username, redirect to login
    if (username == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome - Library Management System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .navbar {
            background: white;
            padding: 15px 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .navbar h1 {
            color: #667eea;
            font-size: 24px;
        }
        
        .navbar a {
            color: white;
            background: #667eea;
            padding: 8px 20px;
            border-radius: 5px;
            text-decoration: none;
            transition: background 0.3s ease;
        }
        
        .navbar a:hover {
            background: #764ba2;
        }
        
        .welcome-container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            animation: fadeIn 0.5s ease-in;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .welcome-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .welcome-header h2 {
            color: #333;
            font-size: 36px;
            margin-bottom: 10px;
        }
        
        .welcome-header p {
            color: #666;
            font-size: 16px;
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-top: 30px;
        }
        
        .feature-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 30px;
            border-radius: 12px;
            text-align: center;
            color: white;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            display: block;
        }
        
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        }
        
        .feature-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        
        .feature-card h3 {
            font-size: 20px;
            margin-bottom: 10px;
        }
        
        .feature-card p {
            font-size: 14px;
            opacity: 0.9;
        }
        
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 30px;
            text-align: center;
            border-left: 4px solid #28a745;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>Library Management System</h1>
        <a href="LogoutServlet">Logout</a>
    </div>
    
    <div class="welcome-container">
        <div class="success-message">
            Welcome <%= username %>! You have successfully logged in.
        </div>
        
        <div class="welcome-header">
            <h2>Welcome to Library Management System</h2>
            <p>Select an option below to get started</p>
        </div>
        
        <div class="features-grid">
            <a href="addBook.jsp" class="feature-card">
                <div class="feature-icon">📖</div>
                <h3>Add New Book</h3>
                <p>Register a new book in the library system</p>
            </a>
            
            <a href="searchBook.jsp" class="feature-card">
                <div class="feature-icon">🔍</div>
                <h3>Search Books</h3>
                <p>Find books by name or author</p>
            </a>
            
            <a href="issueBook.jsp" class="feature-card">
                <div class="feature-icon">📚</div>
                <h3>Issue Book</h3>
                <p>Issue books to students (max 4 per student)</p>
            </a>
            
            <a href="returnBook.jsp" class="feature-card">
                <div class="feature-icon">📤</div>
                <h3>Return Book</h3>
                <p>Process book returns from students</p>
            </a>
            
            <a href="addStudent.jsp" class="feature-card">
                <div class="feature-icon">👨‍🎓</div>
                <h3>Add Student</h3>
                <p>Register a new student in the system</p>
            </a>
            
            <a href="viewStudentInfo.jsp" class="feature-card">
                <div class="feature-icon">📋</div>
                <h3>View Student Info</h3>
                <p>View student details and borrowed books</p>
            </a>
        </div>
    </div>
</body>
</html>