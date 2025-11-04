<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="config.DatabaseConfig" %>
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
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 600;
            font-size: 14px;
        }
        
        input, select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        
        input:focus, select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .btn-submit {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .message {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: 500;
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
        
        .info-box {
            background: #e7f3ff;
            border: 1px solid #b3d9ff;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .info-box p {
            margin: 5px 0;
            color: #004085;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>📤 Return Book</h1>
        <a href="welcome.jsp">← Back to Dashboard</a>
    </div>

    <div class="container">
        <h2>Return Book from Student</h2>
        
<%
    String message = "";
    String messageType = "";
    
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String studentIdStr = request.getParameter("studentId");
        String bookIdStr = request.getParameter("bookId");
        
        if (studentIdStr != null && !studentIdStr.trim().isEmpty() && 
            bookIdStr != null && !bookIdStr.trim().isEmpty()) {
            
            Connection conn = null;
            PreparedStatement checkBorrow = null;
            PreparedStatement updateReturn = null;
            PreparedStatement getInfo = null;
            ResultSet rsBorrow = null;
            ResultSet rsInfo = null;
            
            try {
                int studentId = Integer.parseInt(studentIdStr.trim());
                int bookId = Integer.parseInt(bookIdStr.trim());
                
                Class.forName(DatabaseConfig.getDriver());
                conn = DriverManager.getConnection(
                    DatabaseConfig.getUrl(), 
                    DatabaseConfig.getUsername(), 
                    DatabaseConfig.getPassword()
                );
                
                // Check if this book is currently borrowed by this student
                checkBorrow = conn.prepareStatement(
                    "SELECT bb.borrow_id, s.name as student_name, b.book_name " +
                    "FROM BorrowedBooks bb " +
                    "JOIN Students s ON bb.student_id = s.student_id " +
                    "JOIN Books b ON bb.book_id = b.book_id " +
                    "WHERE bb.student_id = ? AND bb.book_id = ? AND bb.return_date IS NULL");
                checkBorrow.setInt(1, studentId);
                checkBorrow.setInt(2, bookId);
                rsBorrow = checkBorrow.executeQuery();
                
                if (!rsBorrow.next()) {
                    message = "No active borrow record found! Either the book was not borrowed by this student or already returned.";
                    messageType = "error";
                } else {
                    int borrowId = rsBorrow.getInt("borrow_id");
                    String studentName = rsBorrow.getString("student_name");
                    String bookName = rsBorrow.getString("book_name");
                    
                    // Update the return date to current timestamp
                    updateReturn = conn.prepareStatement(
                        "UPDATE BorrowedBooks SET return_date = SYSTIMESTAMP WHERE borrow_id = ?");
                    updateReturn.setInt(1, borrowId);
                    
                    int rowsUpdated = updateReturn.executeUpdate();
                    
                    if (rowsUpdated > 0) {
                        message = "✅ Book '" + bookName + "' successfully returned by " + studentName + "!";
                        messageType = "success";
                    } else {
                        message = "Failed to update return record. Please try again.";
                        messageType = "error";
                    }
                }
                
            } catch (NumberFormatException e) {
                message = "Invalid Student ID or Book ID format!";
                messageType = "error";
            } catch (ClassNotFoundException e) {
                message = "Database driver not found!";
                messageType = "error";
            } catch (SQLException e) {
                message = "Database error: " + e.getMessage();
                messageType = "error";
            } finally {
                try {
                    if (rsBorrow != null) rsBorrow.close();
                    if (rsInfo != null) rsInfo.close();
                    if (checkBorrow != null) checkBorrow.close();
                    if (updateReturn != null) updateReturn.close();
                    if (getInfo != null) getInfo.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            message = "Please fill in all fields!";
            messageType = "error";
        }
    }
    
    if (!message.isEmpty()) {
%>
        <div class="message <%= messageType %>"><%= message %></div>
<%
    }
%>

        <div class="info-box">
            <p><strong>📌 How to Return Books:</strong></p>
            <p>• Enter the Student ID who is returning the book</p>
            <p>• Enter the Book ID that is being returned</p>
            <p>• Book must be currently borrowed (not already returned)</p>
            <p>• Return timestamp will be recorded automatically</p>
        </div>

        <form method="POST" action="returnBook.jsp">
            <div class="form-group">
                <label for="studentId">Student ID *</label>
                <input type="number" id="studentId" name="studentId" required 
                       placeholder="Enter Student ID (e.g., 1001)">
            </div>
            
            <div class="form-group">
                <label for="bookId">Book ID *</label>
                <input type="number" id="bookId" name="bookId" required 
                       placeholder="Enter Book ID being returned">
            </div>
            
            <button type="submit" class="btn-submit">📤 Return Book</button>
        </form>
        
        <div class="info-box" style="margin-top: 20px;">
            <p><strong>💡 Tip:</strong> Use "View Student Info" to see which books a student has borrowed</p>
        </div>
    </div>
</body>
</html>
