<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add New User</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f9fc; padding: 30px; }
        .container { max-width: 500px; margin: auto; background: #fff; padding: 25px; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        h2 { text-align: center; color: #333; }
        label { display: block; margin-top: 15px; }
        input, select { width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ccc; border-radius: 5px; }
        button { margin-top: 20px; background: #007bff; color: white; border: none; padding: 10px; border-radius: 5px; width: 100%; cursor: pointer; }
        button:hover { background: #0056b3; }
        a { display: block; text-align: center; margin-top: 10px; color: #007bff; text-decoration: none; }
    </style>
</head>
<body>
<div class="container">
    <h2>Add New User</h2>
    <form action="addUser" method="post">
        <label>Name:</label>
        <input type="text" name="name" required>

        <label>Email:</label>
        <input type="email" name="email" required>

        <label>Password:</label>
        <input type="password" name="password" required>

        <label>Role:</label>
        <select name="role" required>
            <option value="user">User</option>
            <option value="admin">Admin</option>
        </select>

        <button type="submit">Add User</button>
    </form>
    <a href="manageUsers">Back to Manage Users</a>
</div>
</body>
</html>
