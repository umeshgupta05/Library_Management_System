<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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
        }
        
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: border-color 0.3s ease;
        }
        
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
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
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
        }

        .error-field {
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>📖 Add New Book</h1>
        <a href="/welcome">← Back to Dashboard</a>
    </div>

    <div class="container">
        <h2>Add New Book</h2>

        <c:if test="${not empty successMessage}">
            <div class="message success">${successMessage}</div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="message error">${errorMessage}</div>
        </c:if>

        <form:form action="/books/add" method="post" modelAttribute="book">
            <div class="form-group">
                <label for="title">Book Title *</label>
                <form:input path="title" id="title" required="required" placeholder="Enter book title"/>
                <form:errors path="title" cssClass="error-field"/>
            </div>

            <div class="form-group">
                <label for="author">Author Name *</label>
                <form:input path="author" id="author" required="required" placeholder="Enter author name"/>
                <form:errors path="author" cssClass="error-field"/>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="isbn">ISBN *</label>
                    <form:input path="isbn" id="isbn" required="required" placeholder="Enter ISBN"/>
                    <form:errors path="isbn" cssClass="error-field"/>
                </div>

                <div class="form-group">
                    <label for="category">Category *</label>
                    <form:select path="category" id="category" required="required">
                        <option value="">Select Category</option>
                        <option value="Fiction">Fiction</option>
                        <option value="Non-Fiction">Non-Fiction</option>
                        <option value="Science">Science</option>
                        <option value="Technology">Technology</option>
                        <option value="History">History</option>
                        <option value="Biography">Biography</option>
                        <option value="Education">Education</option>
                        <option value="Reference">Reference</option>
                    </form:select>
                    <form:errors path="category" cssClass="error-field"/>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="publisher">Publisher *</label>
                    <form:input path="publisher" id="publisher" required="required" placeholder="Enter publisher name"/>
                    <form:errors path="publisher" cssClass="error-field"/>
                </div>

                <div class="form-group">
                    <label for="publicationYear">Publication Year *</label>
                    <form:input path="publicationYear" type="number" id="publicationYear" required="required" min="1900" max="2025" placeholder="Enter year"/>
                    <form:errors path="publicationYear" cssClass="error-field"/>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="quantity">Total Quantity *</label>
                    <form:input path="quantity" type="number" id="quantity" required="required" min="1" placeholder="Enter quantity"/>
                    <form:errors path="quantity" cssClass="error-field"/>
                </div>

                <div class="form-group">
                    <label for="availableQuantity">Available Quantity *</label>
                    <form:input path="availableQuantity" type="number" id="availableQuantity" required="required" min="0" placeholder="Enter available quantity"/>
                    <form:errors path="availableQuantity" cssClass="error-field"/>
                </div>
            </div>

            <div class="form-group">
                <label for="description">Description</label>
                <form:textarea path="description" id="description" placeholder="Enter book description (optional)"/>
            </div>

            <button type="submit" class="btn-submit">Add Book</button>
        </form:form>
    </div>
</body>
</html>
