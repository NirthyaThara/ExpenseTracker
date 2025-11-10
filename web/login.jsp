<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Expense Tracker</title>
    <style>
        * {
            box-sizing: border-box;
            font-family: "Poppins", sans-serif;
        }

        body {
            background: #f4f6f8;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .login-container {
            background: #fff;
            width: 360px;
            padding: 40px 35px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            text-align: center;
        }

        .login-container h2 {
            margin-bottom: 10px;
            color: #333;
        }

        .login-container p {
            color: #777;
            margin-bottom: 25px;
            font-size: 14px;
        }

        input[type="email"], input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }

        button {
            width: 100%;
            background-color: #2ecc71;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            cursor: pointer;
            transition: 0.3s;
        }

        button:hover {
            background-color: #27ae60;
        }

        .register-link {
            margin-top: 15px;
            font-size: 13px;
        }

        .register-link a {
            color: #2ecc71;
            text-decoration: none;
        }

        .error {
            color: red;
            font-size: 13px;
            margin-bottom: 10px;
        }

        .success {
            color: green;
            font-size: 13px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<div class="login-container">
    <h2>Welcome Back 👋</h2>
    <p>Login to continue tracking your expenses</p>

    <!-- ✅ Add these messages here -->
    <% if (request.getParameter("logout") != null) { %>
        <p class="success">You have been logged out successfully.</p>
    <% } %>

    <% if (request.getParameter("error") != null) { %>
        <p class="error">Invalid email or password</p>
    <% } %>
    <!-- ✅ End messages -->

    <form action="login" method="post">
        <input type="email" name="email" placeholder="Email" required>
        <input type="password" name="password" placeholder="Password" required>

        <button type="submit">Login</button>
    </form>

    <div class="register-link">
        New user? <a href="register.jsp">Create an account</a>
    </div>
</div>
</body>
</html>
