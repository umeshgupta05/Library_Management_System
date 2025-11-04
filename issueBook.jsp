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
    <title>Issue Book - Library Management</title>
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
        
        .warning {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
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
        <h1>📚 Issue Book</h1>
        <a href="welcome.jsp">← Back to Dashboard</a>
    </div>

    <div class="container">
        <h2>Issue Book to Student</h2>
        
<%
    String message = "";
    String messageType = "";
    
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String studentIdStr = request.getParameter("studentId");
        String bookIdStr = request.getParameter("bookId");
        
        if (studentIdStr != null && !studentIdStr.trim().isEmpty() && 
            bookIdStr != null && !bookIdStr.trim().isEmpty()) {
            
            Connection conn = null;
            PreparedStatement checkStudent = null;
            PreparedStatement checkBook = null;
            PreparedStatement countBooks = null;
            PreparedStatement checkDuplicate = null;
            PreparedStatement insertBorrow = null;
            ResultSet rsStudent = null;
            ResultSet rsBook = null;
            ResultSet rsCount = null;
            ResultSet rsDuplicate = null;
            
            try {
                int studentId = Integer.parseInt(studentIdStr.trim());
                int bookId = Integer.parseInt(bookIdStr.trim());
                
                Class.forName(DatabaseConfig.getDriver());
                conn = DriverManager.getConnection(
                    DatabaseConfig.getUrl(), 
                    DatabaseConfig.getUsername(), 
                    DatabaseConfig.getPassword()
                );
                
                // Check if student exists
                checkStudent = conn.prepareStatement("SELECT name FROM Students WHERE student_id = ?");
                checkStudent.setInt(1, studentId);
                rsStudent = checkStudent.executeQuery();
                
                if (!rsStudent.next()) {
                    message = "Student ID " + studentId + " does not exist!";
                    messageType = "error";
                } else {
                    String studentName = rsStudent.getString("name");
                    
                    // Check if book exists
                    checkBook = conn.prepareStatement("SELECT book_name FROM Books WHERE book_id = ?");
                    checkBook.setInt(1, bookId);
                    rsBook = checkBook.executeQuery();
                    
                    if (!rsBook.next()) {
                        message = "Book ID " + bookId + " does not exist!";
                        messageType = "error";
                    } else {
                        String bookName = rsBook.getString("book_name");
                        
                        // Check if student already has this book
                        checkDuplicate = conn.prepareStatement(
                            "SELECT book_id FROM BorrowedBooks WHERE student_id = ? AND book_id = ? AND return_date IS NULL");
                        checkDuplicate.setInt(1, studentId);
                        checkDuplicate.setInt(2, bookId);
                        rsDuplicate = checkDuplicate.executeQuery();
                        
                        if (rsDuplicate.next()) {
                            message = "Student already has this book borrowed!";
                            messageType = "warning";
                        } else {
                            // Count current borrowed books (not returned)
                            countBooks = conn.prepareStatement(
                                "SELECT COUNT(*) as book_count FROM BorrowedBooks WHERE student_id = ? AND return_date IS NULL");
                            countBooks.setInt(1, studentId);
                            rsCount = countBooks.executeQuery();
                            
                            if (rsCount.next()) {
                                int currentBooks = rsCount.getInt("book_count");
                                
                                if (currentBooks >= 4) {
                                    message = "Cannot issue book! Student " + studentName + " has already borrowed " + 
                                             currentBooks + " books. Maximum limit is 4 books.";
                                    messageType = "error";
                                } else {
                                    // Issue the book
                                    insertBorrow = conn.prepareStatement(
                                        "INSERT INTO BorrowedBooks (borrow_id, student_id, book_id, borrow_date) " +
                                        "VALUES (BorrowedBooks_seq.NEXTVAL, ?, ?, SYSDATE)");
                                    insertBorrow.setInt(1, studentId);
                                    insertBorrow.setInt(2, bookId);
                                    
                                    int rowsInserted = insertBorrow.executeUpdate();
                                    
                                    if (rowsInserted > 0) {
                                        message = "✅ Book '" + bookName + "' successfully issued to " + studentName + 
                                                 "! (Total books: " + (currentBooks + 1) + "/4)";
                                        messageType = "success";
                                    } else {
                                        message = "Failed to issue book. Please try again.";
                                        messageType = "error";
                                    }
                                }
                            }
                        }
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
                    if (rsStudent != null) rsStudent.close();
                    if (rsBook != null) rsBook.close();
                    if (rsCount != null) rsCount.close();
                    if (rsDuplicate != null) rsDuplicate.close();
                    if (checkStudent != null) checkStudent.close();
                    if (checkBook != null) checkBook.close();
                    if (countBooks != null) countBooks.close();
                    if (checkDuplicate != null) checkDuplicate.close();
                    if (insertBorrow != null) insertBorrow.close();
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
            <p><strong>📌 Important Rules:</strong></p>
            <p>• Each student can borrow a maximum of 4 books</p>
            <p>• Student must return books before borrowing more if limit is reached</p>
            <p>• One student cannot borrow the same book twice simultaneously</p>
        </div>

        <form method="POST" action="issueBook.jsp">
            <div class="form-group">
                <label for="studentId">Student ID *</label>
                <input type="number" id="studentId" name="studentId" required 
                       placeholder="Enter Student ID (e.g., 1001)">
            </div>
            
            <div class="form-group">
                <label for="bookId">Book ID *</label>
                <input type="number" id="bookId" name="bookId" required 
                       placeholder="Enter Book ID (search books first)">
            </div>
            
            <button type="submit" class="btn-submit">📖 Issue Book</button>
        </form>
        
        <div class="info-box" style="margin-top: 20px;">
            <p><strong>💡 Tip:</strong> Use "Search Books" to find Book IDs and "View Students" to find Student IDs</p>
        </div>
    </div>
</body>
</html>
