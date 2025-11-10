<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.expensetracker.model.User" %>
<%
    // ✅ Use the implicit JSP session object directly — do not redeclare
    User user = (User) (session != null ? session.getAttribute("user") : null);

    if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Expense Tracker</title>
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #2ecc71;
            color: white;
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        header h1 {
            margin: 0;
            font-size: 24px;
        }
        .logout-btn {
            background: #e74c3c;
            border: none;
            color: white;
            padding: 8px 16px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
        }
        .logout-btn:hover {
            background: #c0392b;
        }
        .container {
            max-width: 900px;
            margin: 50px auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            padding: 30px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        .links {
            display: flex;
            justify-content: center;
            margin-top: 30px;
            gap: 20px;
        }
        .links a {
            text-decoration: none;
            background-color: #2ecc71;
            color: white;
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: 500;
            transition: 0.3s;
        }
        .links a:hover {
            background-color: #27ae60;
        }
    </style>
</head>
<body>
    <header>
        <h1>Welcome, Admin <%= user.getName() %> 👑</h1>
        <form action="logout" method="get" style="margin: 0;">
            <button class="logout-btn" type="submit">Logout</button>
        </form>
    </header>

    <div class="container">
        <h2>Admin Dashboard</h2>
        <p style="text-align:center;color:#555;">
            Here you can manage users and view all expenses across the platform.
        </p>

        <div class="links">
            <a href="view_expenses_admin.jsp">View All Expenses</a>
            <a href="manageUsers">Manage Users</a>
            <!-- ✅ Send Expense Summary via Email -->

                        <form action="sendExpenseSummary" method="post">
                            <button type="submit"
                                    style="background-color:#00BFFF;
                                           color:white;
                                           padding:10px 20px;
                                           border:none;
                                           border-radius:8px;
                                           cursor:pointer;
                                           font-size:16px;">
                                📧 Send Expense Summary to Email
                            </button>
                        </form>

                        <% if (request.getParameter("email") != null) { %>
                            <p style="color:green; margin-top:10px;">
                                ✅ Expense summary sent successfully to your email!
                            </p>
                        <% } %>

        </div>




    </div>
</body>
</html>
