<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | Expense Tracker</title>
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

        .register-container {
            background: #fff;
            width: 400px;
            padding: 40px 35px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            text-align: center;
        }

        .register-container h2 {
            margin-bottom: 10px;
            color: #333;
        }

        .register-container p {
            color: #777;
            margin-bottom: 25px;
            font-size: 14px;
        }

        input {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }

        button {
            width: 100%;
            background-color: #3498db;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            cursor: pointer;
            transition: 0.3s;
        }

        button:hover {
            background-color: #2980b9;
        }

        .login-link {
            margin-top: 15px;
            font-size: 13px;
        }

        .login-link a {
            color: #3498db;
            text-decoration: none;
        }

        .success {
            color: green;
            font-size: 13px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<div class="register-container">
    <h2>Create Your Account ✨</h2>
    <p>Join Expense Tracker to manage your spending smartly!</p>

    <form action="register" method="post">
        <input type="text" name="name" placeholder="Full Name" required>
        <input type="email" name="email" placeholder="Email" required>
        <input type="password" name="password" placeholder="Password" required>

        <% if (request.getParameter("success") != null) { %>
            <p class="success">Registration successful! You can now login.</p>
        <% } %>

        <button type="submit">Register</button>
    </form>

    <div class="login-link">
        Already have an account? <a href="login.jsp">Login</a>
    </div>
</div>
</body>
</html>
