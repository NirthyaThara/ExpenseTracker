<%@ page import="com.expensetracker.model.User" %>
<%
User user = (User) request.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit User</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f9fc; padding: 30px; }
        .container { max-width: 500px; margin: auto; background: #fff; padding: 25px; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        h2 { text-align: center; color: #333; }
        label { display: block; margin-top: 15px; }
        input, select { width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ccc; border-radius: 5px; }
        button { margin-top: 20px; background: #28a745; color: white; border: none; padding: 10px; border-radius: 5px; width: 100%; cursor: pointer; }
        button:hover { background: #218838; }
        a { display: block; text-align: center; margin-top: 10px; color: #007bff; text-decoration: none; }
    </style>
</head>
<body>
<div class="container">
    <h2>Edit User</h2>
    <form action="updateUser" method="post">
        <input type="hidden" name="id" value="<%= user.getId() %>">

        <label>Name:</label>
        <input type="text" name="name" value="<%= user.getName() %>" required>

        <label>Email:</label>
        <input type="email" name="email" value="<%= user.getEmail() %>" required>

        <label>Role:</label>
        <select name="role" required>
            <option value="user" <%= user.getRole().equals("user") ? "selected" : "" %>>User</option>
            <option value="admin" <%= user.getRole().equals("admin") ? "selected" : "" %>>Admin</option>
        </select>

        <button type="submit">Update User</button>
    </form>
    <a href="manageUsers"> Back to Manage Users</a>
</div>
</body>
</html>
