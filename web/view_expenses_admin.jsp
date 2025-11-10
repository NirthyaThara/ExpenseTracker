<%@ page import="java.sql.*, com.expensetracker.util.DBConnection, com.expensetracker.model.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Expense Summary</title>
    <style>
        :root {
            --primary: #28a745;
            --secondary: #007bff;
            --danger: #dc3545;
            --dark: #343a40;
            --light: #f8f9fa;
        }

        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: var(--light);
            margin: 0;
            padding: 0;
        }

        /* Navbar */
        .navbar {
            background-color: var(--dark);
            padding: 12px 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .navbar ul {
            list-style: none;
            display: flex;
            gap: 25px;
            margin: 0;
            padding: 0;
        }

        .navbar a, .navbar button {
            color: white;
            text-decoration: none;
            font-weight: 600;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 15px;
            transition: color 0.3s ease;
        }

        .navbar a:hover, .navbar button:hover {
            color: var(--primary);
        }

        .btn-email {
            background-color: var(--primary);
            color: #fff;
            padding: 8px 15px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-weight: 600;
        }

        .btn-email:hover {
            background-color: #218838;
        }

        .container {
            width: 90%;
            max-width: 1100px;
            margin: 40px auto;
            background-color: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #222;
            margin-bottom: 25px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }

        th {
            background-color: var(--primary);
            color: #fff;
        }

        tr:hover {
            background-color: #f8f9fa;
        }

        .btn {
            padding: 6px 12px;
            border-radius: 5px;
            font-size: 14px;
            text-decoration: none;
            color: #fff;
            font-weight: 500;
            border: none;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-edit {
            background-color: var(--secondary);
        }

        .btn-edit:hover {
            background-color: #0056b3;
        }

        .btn-delete {
            background-color: var(--danger);
        }

        .btn-delete:hover {
            background-color: #a71d2a;
        }

        .summary {
            display: flex;
            justify-content: center;
            gap: 25px;
            flex-wrap: wrap;
            margin-top: 35px;
        }

        .card {
            background-color: #fff;
            border-radius: 10px;
            padding: 20px 25px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.08);
            width: 250px;
            text-align: center;
        }

        .card h4 {
            margin: 0;
            color: #333;
            font-size: 16px;
            font-weight: 600;
        }

        .card p {
            margin-top: 8px;
            font-size: 18px;
            font-weight: bold;
        }

        .income { color: green; }
        .expense { color: #dc3545; }
        .balance { color: #000; }

        .success-msg {
            text-align: center;
            color: green;
            font-weight: 600;
            margin-bottom: 10px;
        }

        @media (max-width: 768px) {
            .summary { flex-direction: column; align-items: center; }
            table { font-size: 13px; }
            .navbar ul { flex-direction: column; gap: 10px; }
        }
    </style>
</head>
<body>

<div class="navbar">
    <ul>
        <li><a href="admin_home.jsp">Home</a></li>

        <li><a href="monthlyExpenditure">History</a></li>

        <li><a href="logout">Logout</a></li>
        <li>
                            <form action="sendExpenseSummary" method="post" style="margin:0;">
                                <button type="submit" class="btn-email">Send Expense Summary</button>
                            </form>
        </li>
    </ul>
</div>

<div class="container">
    <h2>Expense Summary</h2>

    <% if (request.getParameter("email") != null) { %>
        <div class="success-msg">Expense summary sent successfully to your email!</div>
    <% } %>

    <table>
        <tr>
            <th>ID</th>
            <th>Description</th>
            <th>Category</th>
            <th>Amount</th>
            <th>Date</th>
            <%
                User user = (User) session.getAttribute("user");
                if (user == null) {
                    response.sendRedirect("login.jsp?error=Please+login+first");
                    return;
                }

                String role = user.getRole();
                if ("ADMIN".equalsIgnoreCase(role)) {
            %>
            <th>Username</th>
            <% } %>

        </tr>

        <%
            double totalIncome = 0, totalExpense = 0;
            try (Connection conn = DBConnection.getConnection()) {
                PreparedStatement ps;
                if ("ADMIN".equalsIgnoreCase(role)) {
                    ps = conn.prepareStatement("SELECT * FROM expenses ORDER BY date DESC");
                } else {
                    ps = conn.prepareStatement("SELECT * FROM expenses WHERE user_id = ? ORDER BY date DESC");
                    ps.setInt(1, user.getId());
                }

                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    double amt = rs.getDouble("amount");
                    String cat = rs.getString("category");
                    if ("Income".equalsIgnoreCase(cat)) totalIncome += amt;
                    else totalExpense += Math.abs(amt);
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("description") %></td>
            <td><%= cat %></td>
            <td>Rs. <%= String.format("%.2f", amt) %></td>
            <td><%= rs.getDate("date") %></td>
            <% if ("ADMIN".equalsIgnoreCase(role)) { %>
                <td><%= rs.getString("username") %></td>
            <% } %>

        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='7' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
            }
            double netBalance = totalIncome - totalExpense;
        %>
    </table>

    <div class="summary">
        <div class="card">
            <h4>Total Income</h4>
            <p class="income">Rs. <%= String.format("%.2f", totalIncome) %></p>
        </div>
        <div class="card">
            <h4>Total Expense</h4>
            <p class="expense">Rs. <%= String.format("%.2f", totalExpense) %></p>
        </div>
        <div class="card">
            <h4>Net Balance</h4>
            <p class="balance">Rs. <%= String.format("%.2f", netBalance) %></p>
        </div>
    </div>
</div>

</body>
</html>
