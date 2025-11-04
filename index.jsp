<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Library Management System - Home</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 20px;
      }

      .container {
        background: white;
        max-width: 900px;
        width: 100%;
        padding: 50px;
        border-radius: 20px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        animation: slideIn 0.6s ease-out;
      }

      @keyframes slideIn {
        from {
          opacity: 0;
          transform: translateY(30px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }

      .header {
        text-align: center;
        margin-bottom: 40px;
      }

      .header h1 {
        color: #333;
        font-size: 42px;
        margin-bottom: 10px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
      }

      .header .subtitle {
        color: #666;
        font-size: 18px;
        margin-bottom: 30px;
      }

      .features-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 20px;
        margin-bottom: 40px;
      }

      .feature-btn {
        display: block;
        padding: 25px 20px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        text-decoration: none;
        border-radius: 12px;
        font-size: 18px;
        font-weight: 600;
        text-align: center;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
      }

      .feature-btn:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(102, 126, 234, 0.6);
      }

      .feature-btn:active {
        transform: translateY(-2px);
      }

      .feature-icon {
        font-size: 32px;
        display: block;
        margin-bottom: 10px;
      }

      .login-section {
        text-align: center;
        padding-top: 30px;
        border-top: 2px solid #f0f0f0;
      }

      .login-btn {
        display: inline-block;
        padding: 15px 40px;
        background: #fff;
        color: #667eea;
        text-decoration: none;
        border-radius: 25px;
        font-size: 18px;
        font-weight: 600;
        border: 2px solid #667eea;
        transition: all 0.3s ease;
      }

      .login-btn:hover {
        background: #667eea;
        color: white;
        transform: scale(1.05);
      }

      .description {
        text-align: center;
        color: #666;
        line-height: 1.6;
        margin-bottom: 30px;
      }

      .info-cards {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-top: 30px;
      }

      .info-card {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 10px;
        border-left: 4px solid #667eea;
      }

      .info-card h3 {
        color: #333;
        font-size: 18px;
        margin-bottom: 10px;
      }

      .info-card p {
        color: #666;
        font-size: 14px;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="header">
        <h1>Library Management System</h1>
        <p class="subtitle">Your Complete Library Solution</p>
      </div>

      <div class="description">
        <p>
          Welcome to our comprehensive Library Management System. Manage books,
          students, and library operations efficiently with our modern and
          user-friendly interface.
        </p>
      </div>

      <div class="info-cards">
        <div class="info-card">
          <h3>Book Management</h3>
          <p>
            Add, search, and manage your library's book collection with ease.
          </p>
        </div>
        <div class="info-card">
          <h3>Student Management</h3>
          <p>Register students and maintain their information in the system.</p>
        </div>
        <div class="info-card">
          <h3>Secure Access</h3>
          <p>Secure login system to protect your library data.</p>
        </div>
      </div>

      <div class="login-section">
        <p style="color: #666; margin-bottom: 15px">Already have an account?</p>
        <a href="Login.jsp" class="login-btn">Login to Dashboard</a>
      </div>
    </div>
  </body>
</html>
