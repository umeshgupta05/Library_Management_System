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
    <title>Add New Book - Library Management</title>
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
            max-width: 800px;
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
            max-width: 800px;
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
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            color: #555;
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .btn-submit {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            margin-top: 10px;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-submit:active {
            transform: translateY(0);
        }
        
        .message {
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
            text-align: center;
            font-weight: 500;
        }
        
        .success {
            background-color: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
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
    </style>
</head>
<body>
    <div class="navbar">
        <h1>📖 Add New Book</h1>
        <a href="welcome.jsp">← Back to Dashboard</a>
    </div>
    
    <div class="container">
        <h2>Register a New Book</h2>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    String message = "";
    String messageType = "";
    
    String bookName = request.getParameter("bookName");
    String author = request.getParameter("author");
    String isbn = request.getParameter("isbn");

    if (bookName != null && author != null && isbn != null) {
        if (bookName.trim().isEmpty() || author.trim().isEmpty() || isbn.trim().isEmpty()) {
            message = "Please fill in all fields.";
            messageType = "info";
        } else {
            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                String url = "jdbc:oracle:thin:@localhost:1521:XE";
                String username = "system"; 
                String password = "767089"; 

                conn = DriverManager.getConnection(url, username, password);

                String sql = "INSERT INTO Books (book_id, book_name, author, isbn, added_date) VALUES (Books_seq.NEXTVAL, ?, ?, ?, SYSDATE)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, bookName.trim());
                pstmt.setString(2, author.trim());
                pstmt.setString(3, isbn.trim());
                
                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    message = "✓ Book added successfully! Book: '" + bookName + "' by " + author;
                    messageType = "success";
                } else {
                    message = "Failed to add the book. Please try again.";
                    messageType = "error";
                }
            } catch (ClassNotFoundException e) {
                message = "Database driver not found. Please check Oracle JDBC configuration.";
                messageType = "error";
            } catch (SQLException e) {
                message = "Database error: " + e.getMessage();
                messageType = "error";
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
                messageType = "error";
            } finally {
                try {
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException se) {
                    message = "Error closing resources: " + se.getMessage();
                    messageType = "error";
                }
            }
        }
    }
%>

        <form method="post" action="addBook.jsp">
            <div class="form-group">
                <label for="bookName">📚 Book Name</label>
                <input type="text" id="bookName" name="bookName" placeholder="Enter book title" required>
            </div>

            <div class="form-group">
                <label for="author">✍️ Author Name</label>
                <input type="text" id="author" name="author" placeholder="Enter author name" required>
            </div>

            <div class="form-group">
                <label for="isbn">🔢 ISBN Number</label>
                <input type="text" id="isbn" name="isbn" placeholder="Enter ISBN number" required>
            </div>

            <button type="submit" class="btn-submit">Add Book to Library</button>
        </form>

<% if (!message.isEmpty()) { %>
        <div class="message <%= messageType %>">
            <%= message %>
        </div>
<% } %>
    </div>
</body>
</html>

</body>
</html>
