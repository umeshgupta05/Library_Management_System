<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Return Book - Library Management</title>
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
            max-width: 1000px;
            margin: 0 auto 30px;
        }
        
        .navbar h1 {
            color: #667eea;
            font-size: 24px;
        }
        
        .navbar a {
            color: #667eea;
            text-decoration: none;
            padding: 8px 20px;
            border: 2px solid #667eea;
            border-radius: 5px;
            transition: all 0.3s ease;
        }
        
        .navbar a:hover {
            background: #667eea;
            color: white;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
        }
        
        h2 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
            font-size: 28px;
        }
        
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
        }
        
        .success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .issue-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .issue-table th,
        .issue-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .issue-table th {
            background: #667eea;
            color: white;
            font-weight: 600;
        }
        
        .issue-table tr:hover {
            background: #f8f9fa;
        }
        
        .btn-return {
            padding: 8px 20px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.3s ease;
        }
        
        .btn-return:hover {
            background: #218838;
        }
        
        .no-issues {
            text-align: center;
            padding: 40px;
            color: #666;
            font-size: 16px;
        }
        
        .info-box {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 25px;
            font-size: 14px;
            color: #856404;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>↩️ Return Book</h1>
        <a href="/welcome">← Back to Dashboard</a>
    </div>

    <div class="container">
        <h2>Return Book</h2>

        <c:if test="${not empty successMessage}">
            <div class="message success">${successMessage}</div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="message error">${errorMessage}</div>
        </c:if>

        <div class="info-box">
            <strong>Note:</strong> Overdue books will incur a fine of ₹5 per day after the due date.
        </div>

        <c:choose>
            <c:when test="${not empty activeIssues}">
                <table class="issue-table">
                    <thead>
                        <tr>
                            <th>Student Name</th>
                            <th>Roll Number</th>
                            <th>Book Title</th>
                            <th>Issue Date</th>
                            <th>Due Date</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="issue" items="${activeIssues}">
                            <tr>
                                <td>${issue.student.name}</td>
                                <td>${issue.student.rollNumber}</td>
                                <td>${issue.book.title}</td>
                                <td>${issue.issueDate}</td>
                                <td>${issue.dueDate}</td>
                                <td>
                                    <form action="/issues/return" method="post" style="display: inline;">
                                        <input type="hidden" name="issueId" value="${issue.id}">
                                        <button type="submit" class="btn-return">Return</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="no-issues">
                    <p>📚 No active book issues found.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
