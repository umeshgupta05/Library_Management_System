<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if user is logged in
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Student Information - Library Management</title>
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
        
        h2 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
            font-size: 28px;
        }
        
        .search-box {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            justify-content: center;
        }
        
        .search-box input {
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            width: 300px;
            transition: all 0.3s ease;
        }
        
        .search-box input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .btn-search {
            padding: 12px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .btn-search:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .student-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 30px;
            margin-top: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        
        .student-card h3 {
            color: #667eea;
            margin-bottom: 20px;
            font-size: 24px;
        }
        
        .info-row {
            display: flex;
            padding: 15px;
            border-bottom: 1px solid #e0e0e0;
            align-items: center;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #555;
            width: 180px;
            font-size: 15px;
        }
        
        .info-value {
            color: #333;
            font-size: 15px;
            flex: 1;
        }
        
        .message {
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
            text-align: center;
            font-weight: 500;
        }
        
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        .info {
            background-color: #fff3cd;
            color: #856404;
            border-left: 4px solid #ffc107;
        }
        
        .no-results {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        
        .no-results-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        
        .borrowed-books-section {
            margin-top: 30px;
        }
        
        .borrowed-books-section h3 {
            color: #667eea;
            margin-bottom: 15px;
            font-size: 22px;
        }
        
        .books-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }
        
        .books-table th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: 600;
        }
        
        .books-table td {
            padding: 12px;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .books-table tr:last-child td {
            border-bottom: none;
        }
        
        .books-table tr:hover {
            background: #f8f9fa;
        }
        
        .no-books {
            text-align: center;
            padding: 20px;
            color: #666;
            background: #f8f9fa;
            border-radius: 8px;
            margin-top: 15px;
        }
        
        .book-count {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            margin-left: 10px;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>📋 View Student Information</h1>
        <a href="welcome.jsp">← Back to Dashboard</a>
    </div>
    
    <div class="container">
        <h2>Search Student by ID</h2>

        <form method="post" action="viewStudentInfo.jsp" class="search-box">
            <input type="number" id="studentId" name="studentId" 
                   placeholder="Enter Student ID" 
                   value="<%= request.getParameter("studentId") != null ? request.getParameter("studentId") : "" %>" 
                   required>
            <button type="submit" class="btn-search">🔍 Search</button>
        </form>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    PreparedStatement pstmtBooks = null;
    ResultSet rs = null;
    ResultSet rsBooks = null;
    String message = "";
    String messageType = "";
    String studentId = request.getParameter("studentId");

    if (studentId != null && !studentId.trim().isEmpty()) {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            String url = "jdbc:oracle:thin:@localhost:1521:XE";
            String username = "system";
            String password = "767089amma";

            conn = DriverManager.getConnection(url, username, password);

            String sql = "SELECT * FROM Students WHERE student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(studentId.trim()));
            rs = pstmt.executeQuery();

            if (rs.next()) {
                int studId = rs.getInt("student_id");
%>
        <div class="student-card">
            <h3>👨‍🎓 Student Details</h3>
            <div class="info-row">
                <span class="info-label">🆔 Student ID:</span>
                <span class="info-value"><%= studId %></span>
            </div>
            <div class="info-row">
                <span class="info-label">👤 Full Name:</span>
                <span class="info-value"><%= rs.getString("name") %></span>
            </div>
            <div class="info-row">
                <span class="info-label">📧 Email Address:</span>
                <span class="info-value"><%= rs.getString("email") %></span>
            </div>
            <div class="info-row">
                <span class="info-label">📱 Contact Number:</span>
                <span class="info-value"><%= rs.getString("contact") %></span>
            </div>
            <div class="info-row">
                <span class="info-label">📅 Registration Date:</span>
                <span class="info-value"><%= rs.getDate("registered_date") %></span>
            </div>
        </div>
        
        <div class="borrowed-books-section">
<%
                // Get borrowed books for this student
                String sqlBooks = "SELECT bb.borrow_id, bb.book_id, b.book_name, b.author, bb.borrow_date, bb.return_date " +
                                 "FROM BorrowedBooks bb " +
                                 "JOIN Books b ON bb.book_id = b.book_id " +
                                 "WHERE bb.student_id = ? AND bb.return_date IS NULL " +
                                 "ORDER BY bb.borrow_date DESC";
                pstmtBooks = conn.prepareStatement(sqlBooks);
                pstmtBooks.setInt(1, studId);
                rsBooks = pstmtBooks.executeQuery();
                
                // Count books
                int bookCount = 0;
                java.util.ArrayList<java.util.HashMap<String, Object>> booksList = new java.util.ArrayList<>();
                while (rsBooks.next()) {
                    bookCount++;
                    java.util.HashMap<String, Object> bookData = new java.util.HashMap<>();
                    bookData.put("borrowId", rsBooks.getInt("borrow_id"));
                    bookData.put("bookId", rsBooks.getInt("book_id"));
                    bookData.put("bookName", rsBooks.getString("book_name"));
                    bookData.put("author", rsBooks.getString("author"));
                    bookData.put("borrowDate", rsBooks.getTimestamp("borrow_date"));
                    booksList.add(bookData);
                }
%>
            <h3>📚 Currently Borrowed Books <span class="book-count"><%= bookCount %>/4</span></h3>
<%
                if (bookCount > 0) {
%>
            <table class="books-table">
                <thead>
                    <tr>
                        <th>Book ID</th>
                        <th>Book Name</th>
                        <th>Author</th>
                        <th>Borrow Date</th>
                    </tr>
                </thead>
                <tbody>
<%
                    for (java.util.HashMap<String, Object> book : booksList) {
%>
                    <tr>
                        <td><%= book.get("bookId") %></td>
                        <td><%= book.get("bookName") %></td>
                        <td><%= book.get("author") %></td>
                        <td><%= book.get("borrowDate") %></td>
                    </tr>
<%
                    }
%>
                </tbody>
            </table>
<%
                } else {
%>
            <div class="no-books">
                📖 No books currently borrowed by this student
            </div>
<%
                }
%>
        </div>
<%
            } else {
%>
        <div class="no-results">
            <div class="no-results-icon">👥</div>
            <h3>Student Not Found</h3>
            <p>No student found with ID: <%= studentId %></p>
            <p>Please check the ID and try again.</p>
        </div>
<%
            }
        } catch (NumberFormatException e) {
            message = "Please enter a valid numeric Student ID.";
            messageType = "error";
        } catch (ClassNotFoundException e) {
            message = "Database driver not found. Please check Oracle JDBC configuration.";
            messageType = "error";
        } catch (SQLException e) {
            message = "Database error: " + e.getMessage();
            messageType = "error";
        } catch (Exception e) {
            message = "Error retrieving student information: " + e.getMessage();
            messageType = "error";
        } finally {
            try {
                if (rsBooks != null) rsBooks.close();
                if (rs != null) rs.close();
                if (pstmtBooks != null) pstmtBooks.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException se) {
                message = "Error closing resources: " + se.getMessage();
                messageType = "error";
            }
        }
    }
%>

<% if (!message.isEmpty()) { %>
        <div class="message <%= messageType %>">
            <%= message %>
        </div>
<% } %>
    </div>
</body>
</html>
