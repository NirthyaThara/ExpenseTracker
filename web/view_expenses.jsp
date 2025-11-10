<%@ page import="java.sql.*, com.expensetracker.util.DBConnection, com.expensetracker.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Expenses</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f5f6fa;
            margin: 0;
            padding: 0;
            color: #333;
        }

        /* ===== Navbar ===== */
        .navbar {
            background-color: #2c3e50;
            color: white;
            padding: 12px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
        }

        .navbar h1 {
            font-size: 20px;
            font-weight: 600;
            margin: 0;
        }

        .navbar ul {
            list-style: none;
            display: flex;
            align-items: center;
            gap: 25px;
            margin: 0;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
        }

        .navbar a:hover {
            color: #1abc9c;
        }

        /* Send Email Button */
        .navbar button {
            background-color: #1abc9c;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: 0.3s;
        }

        .navbar button:hover {
            background-color: #16a085;
        }

        /* ===== Container ===== */
        .container {
            width: 85%;
            margin: 40px auto;
            background-color: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 25px;
        }

        /* ===== Table ===== */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #27ae60;
            color: white;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        /* ===== Buttons ===== */
        .btn {
            padding: 6px 12px;
            border-radius: 5px;
            font-size: 14px;
            text-decoration: none;
            color: white;
            font-weight: 500;
            transition: background 0.3s;
        }

        .btn-edit {
            background-color: #2980b9;
        }

        .btn-edit:hover {
            background-color: #1c5988;
        }

        .btn-delete {
            background-color: #e74c3c;
        }

        .btn-delete:hover {
            background-color: #c0392b;
        }

        /* ===== Summary ===== */
        .summary {
            margin-top: 30px;
            text-align: right;
            font-size: 16px;
            font-weight: bold;
        }

        .income { color: #27ae60; }
        .expense { color: #c0392b; }
        .balance { color: #2c3e50; }
    </style>
</head>
<body>

<!-- ===== Navbar Section ===== -->
<div class="navbar">
    <h1>Expense Tracker</h1>

    <ul>
        <li><a href="index.html">Home</a></li>
        <li><a href="add_expense.html">Add Expense</a></li>
        <li><a href="monthlyExpenditure">Show History</a></li>
        <li><a href="logout">Logout</a></li>
        <li>
            <form action="sendExpenseSummary" method="post" style="display:inline;">
                <button type="submit">Send Expense Summary</button>
            </form>
        </li>
    </ul>
</div>

<!-- ===== Content Section ===== -->
<div class="container">
    <h2>Expense Summary</h2>

    <% if (request.getParameter("email") != null) { %>
        <p style="color:green; text-align:center;">
            ✅ Expense summary sent successfully to your email!
        </p>
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
            <th>Actions</th>
        </tr>

        <%
            double totalIncome = 0;
            double totalExpense = 0;

            try (Connection conn = DBConnection.getConnection()) {
                PreparedStatement ps;

                if ("ADMIN".equalsIgnoreCase(role)) {
                    ps = conn.prepareStatement(
                        "SELECT e.*, u.name AS username FROM expenses e JOIN users u ON e.user_id = u.id ORDER BY e.date DESC"
                    );
                } else {
                    ps = conn.prepareStatement("SELECT * FROM expenses WHERE user_id = ? ORDER BY date DESC");
                    ps.setInt(1, user.getId());
                }

                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    double amt = rs.getDouble("amount");
                    String cat = rs.getString("category");

                    if ("Income".equalsIgnoreCase(cat))
                        totalIncome += amt;
                    else if ("Expense".equalsIgnoreCase(cat))
                        totalExpense += Math.abs(amt);
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("description") %></td>
            <td><%= cat %></td>
            <td>Rs.<%= String.format("%.2f", amt) %></td>
            <td><%= rs.getDate("date") %></td>

            <% if ("ADMIN".equalsIgnoreCase(role)) { %>
                <td><%= rs.getString("username") %></td>
            <% } %>

            <td>
                <a href="edit_expense.jsp?id=<%=rs.getInt("id")%>" class="btn btn-edit">Edit</a>
                <a href="delete_expense?id=<%=rs.getInt("id")%>"
                   class="btn btn-delete"
                   onclick="return confirm('Are you sure you want to delete this?');">Delete</a>
            </td>
        </tr>
        <% } } catch (Exception e) {
            out.println("<tr><td colspan='7' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
        }

        double netBalance = totalIncome - totalExpense;
        %>
    </table>

    <div class="summary">
        <p>Total Income: <span class="income">Rs.<%= String.format("%.2f", totalIncome) %></span></p>
        <p>Total Expense: <span class="expense">Rs.<%= String.format("%.2f", totalExpense) %></span></p>
        <p>Net Balance: <span class="balance">Rs.<%= String.format("%.2f", netBalance) %></span></p>
    </div>
</div>

</body>
</html>
