<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Monthly Expenditure Summary</title>
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }

        .navbar {
            background-color: #343a40;
            padding: 12px;
            text-align: center;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
            font-weight: 600;
        }

        .navbar a:hover {
            color: #28a745;
        }

        .container {
            width: 85%;
            margin: 40px auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }

        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #28a745;
            color: white;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .income { color: green; font-weight: bold; }
        .expense { color: red; font-weight: bold; }
        .balance { color: #333; font-weight: bold; }
    </style>
</head>
<body>

<div class="navbar">
    <%@ page import="com.expensetracker.model.User" %>


        <%
            // Get the logged-in user from the session
            User user = (User) session.getAttribute("user");
            String homePage = "index.html"; // default
            String view="view_expenses.jsp";

            if (user != null && "ADMIN".equalsIgnoreCase(user.getRole())) {
                homePage = "admin_home.jsp";
                 view="view_expenses_admin.jsp";// or whatever your admin homepage file is
            } else if (user != null && "USER".equalsIgnoreCase(user.getRole())) {
                homePage = "index.html";
                 view="view_expenses.jsp";// or your normal user homepage
            }
        %>

        <a href="<%= homePage %>">Home</a>
        <a href="<%= view %>">View Expenses</a>
        <a href="monthlyExpenditure">Monthly Summary</a>
        <a href="logout" style="color:#dc3545;">Logout</a>
    </div>

    <a href="view_expenses.jsp">View Expenses</a>
    <a href="monthlyExpenditure">Monthly Summary</a>
</div>

<div class="container">
    <h2>📊 Monthly Income and Expense Summary</h2>

    <table>
        <tr>
            <th>Month</th>
            <th>Total Income (Rs)</th>
            <th>Total Expense (Rs)</th>
            <th>Net Balance (Rs)</th>
        </tr>

        <%
            Map<String, Map<String, Double>> monthlyTotals =
                    (Map<String, Map<String, Double>>) request.getAttribute("monthlyTotals");

            if (monthlyTotals == null || monthlyTotals.isEmpty()) {
        %>
            <tr>
                <td colspan="4" style="color:gray;">No data available.</td>
            </tr>
        <%
            } else {
                for (Map.Entry<String, Map<String, Double>> entry : monthlyTotals.entrySet()) {
                    String month = entry.getKey();
                    Map<String, Double> totals = entry.getValue();

                    double income = totals.getOrDefault("Income", 0.0);
                    double expense = totals.getOrDefault("Expense", 0.0);
                    double balance = income - expense;
        %>
                    <tr>
                        <td><%= month %></td>
                        <td class="income"><%= String.format("%.2f", income) %></td>
                        <td class="expense"><%= String.format("%.2f", expense) %></td>
                        <td class="balance"><%= String.format("%.2f", balance) %></td>
                    </tr>
        <%
                }
            }
        %>
    </table>
</div>

</body>
</html>
