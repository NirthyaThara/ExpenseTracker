<%@ page import="java.sql.*, com.expensetracker.util.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Expense</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }
        .container {
            width: 40%;
            margin: 80px auto;
            background-color: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        input, select {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
        }
        button {
            background-color: #28a745;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Edit Expense</h2>

    <%
        int id = Integer.parseInt(request.getParameter("id"));
        String description = "", category = "", date = "";
        double amount = 0;

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM expenses WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                description = rs.getString("description");
                category = rs.getString("category");
                amount = rs.getDouble("amount");
                date = rs.getString("date");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>

    <form action="update_expense" method="post"> <!-- ✅ maps to your UpdateExpenseServlet -->
        <input type="hidden" name="id" value="<%= id %>">

        <label>Description:</label>
        <input type="text" name="description" value="<%= description %>" required>

        <label>Category:</label>
        <select name="category" required>
            <option value="Income" <%= "Income".equals(category) ? "selected" : "" %>>Income</option>
            <option value="Expense" <%= "Expense".equals(category) ? "selected" : "" %>>Expense</option>
        </select>

        <label>Amount:</label>
        <input type="number" name="amount" value="<%= amount %>" step="0.01" required>

        <label>Date:</label>
        <input type="date" name="date" value="<%= date.substring(0,10) %>" required>

        <button type="submit">Update Expense</button>
    </form>
</div>
</body>
</html>
