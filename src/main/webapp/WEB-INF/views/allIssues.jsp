<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Issues - Library Management</title>
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
            max-width: 1400px;
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
            max-width: 1400px;
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
            position: sticky;
            top: 0;
        }
        
        .issue-table tr:hover {
            background: #f8f9fa;
        }
        
        .badge {
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .badge-warning {
            background: #fff3cd;
            color: #856404;
        }
        
        .badge-success {
            background: #d4edda;
            color: #155724;
        }
        
        .badge-danger {
            background: #f8d7da;
            color: #721c24;
        }

        .filters {
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            justify-content: center;
        }

        .filters a {
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s ease;
        }

        .filters a:hover {
            background: #764ba2;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>📊 All Book Issues</h1>
        <a href="/welcome">← Back to Dashboard</a>
    </div>

    <div class="container">
        <h2>Book Issue Records</h2>

        <div class="filters">
            <a href="/issues/all">All Issues</a>
            <a href="/issues/overdue">Overdue Issues</a>
        </div>

        <c:choose>
            <c:when test="${not empty issues}">
                <table class="issue-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Student Name</th>
                            <th>Roll Number</th>
                            <th>Book Title</th>
                            <th>Issue Date</th>
                            <th>Due Date</th>
                            <th>Return Date</th>
                            <th>Fine</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="issue" items="${issues}">
                            <tr>
                                <td>${issue.id}</td>
                                <td>${issue.student.name}</td>
                                <td>${issue.student.rollNumber}</td>
                                <td><strong>${issue.book.title}</strong></td>
                                <td>${issue.issueDate}</td>
                                <td>${issue.dueDate}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty issue.returnDate}">
                                            ${issue.returnDate}
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${issue.fine > 0}">
                                            <strong>₹${issue.fine}</strong>
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${issue.status == 'ISSUED'}">
                                            <span class="badge badge-warning">Issued</span>
                                        </c:when>
                                        <c:when test="${issue.status == 'RETURNED'}">
                                            <span class="badge badge-success">Returned</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-danger">Overdue</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p style="text-align: center; padding: 40px; color: #666;">No issue records found.</p>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
