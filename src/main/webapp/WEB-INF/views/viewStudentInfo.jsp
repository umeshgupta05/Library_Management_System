<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Student Info - Library Management</title>
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
        
        .search-form {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .search-form input {
            flex: 1;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
        }
        
        .search-form button {
            padding: 12px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
        }
        
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
        }
        
        .error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .student-info {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-top: 15px;
        }
        
        .info-item {
            padding: 10px;
        }
        
        .info-item label {
            display: block;
            color: #666;
            font-size: 12px;
            margin-bottom: 5px;
            font-weight: 600;
        }
        
        .info-item span {
            display: block;
            color: #333;
            font-size: 16px;
            font-weight: 500;
        }
        
        .book-history {
            margin-top: 30px;
        }
        
        .book-history h3 {
            color: #333;
            margin-bottom: 15px;
        }
        
        .issue-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
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
    </style>
</head>
<body>
    <div class="navbar">
        <h1>👤 View Student Info</h1>
        <a href="/welcome">← Back to Dashboard</a>
    </div>

    <div class="container">
        <h2>Student Information</h2>

        <form action="/students/view" method="post" class="search-form">
            <input type="text" name="rollNumber" placeholder="Enter Roll Number" required>
            <button type="submit">Search</button>
        </form>

        <c:if test="${not empty errorMessage}">
            <div class="message error">${errorMessage}</div>
        </c:if>

        <c:if test="${studentFound}">
            <div class="student-info">
                <h3>Student Details</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <label>Name</label>
                        <span>${student.name}</span>
                    </div>
                    <div class="info-item">
                        <label>Roll Number</label>
                        <span>${student.rollNumber}</span>
                    </div>
                    <div class="info-item">
                        <label>Email</label>
                        <span>${student.email}</span>
                    </div>
                    <div class="info-item">
                        <label>Phone</label>
                        <span>${student.phone}</span>
                    </div>
                    <div class="info-item">
                        <label>Department</label>
                        <span>${student.department}</span>
                    </div>
                    <div class="info-item">
                        <label>Course</label>
                        <span>${student.course}</span>
                    </div>
                    <div class="info-item">
                        <label>Year</label>
                        <span>${student.year}</span>
                    </div>
                    <div class="info-item">
                        <label>Registration Date</label>
                        <span>${student.registrationDate}</span>
                    </div>
                </div>
            </div>

            <div class="book-history">
                <h3>Book Issue History</h3>
                <c:choose>
                    <c:when test="${not empty bookIssues}">
                        <table class="issue-table">
                            <thead>
                                <tr>
                                    <th>Book Title</th>
                                    <th>Issue Date</th>
                                    <th>Due Date</th>
                                    <th>Return Date</th>
                                    <th>Fine</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="issue" items="${bookIssues}">
                                    <tr>
                                        <td>${issue.book.title}</td>
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
                                                    ₹${issue.fine}
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
                        <p style="text-align: center; color: #666; padding: 20px;">No book issue history found.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </div>
</body>
</html>
