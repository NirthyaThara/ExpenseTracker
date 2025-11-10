<%@ page import="java.util.*, com.expensetracker.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Users - Expense Tracker</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #2d3e50;
            color: white;
            padding: 15px 30px;
            text-align: center;
        }
        .navbar {
                    background-color: #343a40;
                    color: white;
                    padding: 15px 30px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                }

                .navbar h1 {
                    font-size: 22px;
                }

                .navbar ul {
                    list-style: none;
                    display: flex;
                    gap: 20px;
                }

                .navbar a {
                    color: white;
                    text-decoration: none;
                    font-weight: 500;
                }

                .navbar a:hover {
                    text-decoration: underline;
                }

        .container {
            width: 90%;
            margin: 40px auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 30px;
        }
        h2 {
            color: #2d3e50;
            margin-bottom: 20px;
            text-align: center;
        }
        .btn {
            display: inline-block;
            padding: 10px 16px;
            color: white;
            background: #007bff;
            text-decoration: none;
            border-radius: 5px;
            margin-bottom: 15px;
        }
        .btn:hover {
            background: #0056b3;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 10px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: center;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        tr:nth-child(even) { background-color: #f2f2f2; }
        tr:hover { background-color: #eaf0f7; }
        .action-link {
            color: #007bff;
            text-decoration: none;
        }
        .action-link:hover {
            text-decoration: underline;
        }
        .no-data {
            text-align: center;
            color: #888;
            padding: 20px;
        }
    </style>
</head>
<body>
<div class="navbar">
    <h1>Expense Tracker</h1>
    <ul>
        <li><a href="admin_home.jsp">Home</a></li>
        <li><a href="view_expenses_admin.jsp">View Expenses</a></li>
        <li><a href="monthlyExpenditure">Show history</a></li>
        <li><a href="logout" class="logout-btn">Logout</a></li>

    </ul>
</div>
<div class="container">
    <h2>Manage Users</h2>
    <a href="add_user.jsp" class="btn">+ Add New User</a>
    <%
    List<User> listCheck = (List<User>) request.getAttribute("userList");
    if (listCheck == null) {
        out.print("<p style='color:red;'>userList attribute is NULL!</p>");
    } else {
        out.print("<p style='color:green;'>userList size = " + listCheck.size() + "</p>");
    }
    %>

    <table>
        <tr>
            <th>ID</th><th>Name</th><th>Email</th><th>Role</th><th>Action</th>
        </tr>

        <%
        List<User> users = (List<User>) request.getAttribute("userList");
        if (users != null && !users.isEmpty()) {
            for (User u : users) {
        %>
        <tr>
            <td><%=u.getId()%></td>
            <td><%=u.getName()%></td>
            <td><%=u.getEmail()%></td>
            <td><%=u.getRole()%></td>
            <td>
                <a href="edit_user?id=<%=u.getId()%>" class="action-link">Edit</a> |
                <a href="delete_user?id=<%=u.getId()%>"
                   class="action-link"
                   onclick="return confirm('Are you sure you want to delete this user?');">
                   Delete
                </a>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr><td colspan="5" class="no-data">No users found in the system.</td></tr>
        <%
        }
        %>
    </table>
</div>
</body>
</html>
