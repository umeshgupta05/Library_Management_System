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
    <title>Search Books - Library Management</title>
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
        }
        
        .search-box input {
            flex: 1;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
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
        
        .results-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        
        .results-table th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }
        
        .results-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #e0e0e0;
            color: #333;
        }
        
        .results-table tr:hover {
            background-color: #f8f9fa;
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
            background-color: #d1ecf1;
            color: #0c5460;
            border-left: 4px solid #17a2b8;
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
    </style>
</head>
<body>
    <div class="navbar">
        <h1>🔍 Search Books</h1>
        <a href="welcome.jsp">← Back to Dashboard</a>
    </div>
    
    <div class="container">
        <h2>Find Books in Library</h2>

        <form method="get" action="searchBook.jsp" class="search-box">
            <input type="text" id="searchQuery" name="searchQuery" 
                   placeholder="Enter book name or author..." 
                   value="<%= request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "" %>" 
                   required>
            <button type="submit" class="btn-search">🔍 Search</button>
        </form>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String message = "";
    String messageType = "";
    boolean hasResults = false;
    
    String searchQuery = request.getParameter("searchQuery");
    
    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        try {
            Class.forName(DatabaseConfig.getDriver());
            conn = DriverManager.getConnection(
                DatabaseConfig.getUrl(), 
                DatabaseConfig.getUsername(), 
                DatabaseConfig.getPassword()
            );
            
            String sql = "SELECT * FROM Books WHERE UPPER(book_name) LIKE ? OR UPPER(author) LIKE ? ORDER BY book_name";
            pstmt = conn.prepareStatement(sql);
            String searchPattern = "%" + searchQuery.trim().toUpperCase() + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            rs = pstmt.executeQuery();
            
            if (rs.isBeforeFirst()) {
                hasResults = true;
%>
        <table class="results-table">
            <thead>
                <tr>
                    <th>Book ID</th>
                    <th>Book Name</th>
                    <th>Author</th>
                    <th>ISBN</th>
                    <th>Added Date</th>
                </tr>
            </thead>
            <tbody>
<%
                while (rs.next()) {
%>
                <tr>
                    <td><%= rs.getInt("book_id") %></td>
                    <td><%= rs.getString("book_name") %></td>
                    <td><%= rs.getString("author") %></td>
                    <td><%= rs.getString("isbn") %></td>
                    <td><%= rs.getDate("added_date") %></td>
                </tr>
<%
                }
%>
            </tbody>
        </table>
<%
            } else {
%>
        <div class="no-results">
            <div class="no-results-icon">📚</div>
            <h3>No Books Found</h3>
            <p>No books match your search query: "<%= searchQuery %>"</p>
            <p>Try searching with different keywords.</p>
        </div>
<%
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
                if (rs != null) rs.close();
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
