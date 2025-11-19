<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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

        .navbar .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .navbar .username {
            color: #333;
            font-weight: 600;
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
            font-size: 32px;
            margin-bottom: 10px;
        }
        
        .welcome-header p {
            color: #666;
            font-size: 16px;
        }
        
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-top: 30px;
        }
        
        .dashboard-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 30px;
            border-radius: 15px;
            color: white;
            text-decoration: none;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: block;
        }
        
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
        }
        
        .dashboard-card h3 {
            font-size: 24px;
            margin-bottom: 10px;
        }
        
        .dashboard-card p {
            font-size: 14px;
            opacity: 0.9;
        }
        
        .card-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>📚 Library Management System</h1>
        <div class="user-info">
            <span class="username">Welcome, <sec:authentication property="principal.username"/>!</span>
            <form action="/logout" method="post" style="display: inline;">
                <button type="submit" style="color: white; background: #667eea; padding: 8px 20px; border-radius: 5px; border: none; cursor: pointer; font-family: inherit; font-size: 14px;">Logout</button>
            </form>
        </div>
    </div>

    <div class="welcome-container">
        <div class="welcome-header">
            <h2>Welcome to Dashboard</h2>
            <p>Select an option below to manage library operations</p>
        </div>

        <div class="dashboard-grid">
            <a href="/books/add" class="dashboard-card">
                <div class="card-icon">📖</div>
                <h3>Add Book</h3>
                <p>Add new books to the library collection</p>
            </a>

            <a href="/students/add" class="dashboard-card">
                <div class="card-icon">👨‍🎓</div>
                <h3>Add Student</h3>
                <p>Register new students in the system</p>
            </a>

            <a href="/issues/issue" class="dashboard-card">
                <div class="card-icon">📋</div>
                <h3>Issue Book</h3>
                <p>Issue books to students</p>
            </a>

            <a href="/issues/return" class="dashboard-card">
                <div class="card-icon">↩️</div>
                <h3>Return Book</h3>
                <p>Process book returns and calculate fines</p>
            </a>

            <a href="/books/search" class="dashboard-card">
                <div class="card-icon">🔍</div>
                <h3>Search Books</h3>
                <p>Search and view book details</p>
            </a>

            <a href="/students/view" class="dashboard-card">
                <div class="card-icon">👤</div>
                <h3>View Student Info</h3>
                <p>View student details and history</p>
            </a>

            <a href="/books/all" class="dashboard-card">
                <div class="card-icon">📚</div>
                <h3>All Books</h3>
                <p>View all books in the library</p>
            </a>

            <a href="/issues/all" class="dashboard-card">
                <div class="card-icon">📊</div>
                <h3>All Issues</h3>
                <p>View all book issue records</p>
            </a>
        </div>
    </div>
</body>
</html>
