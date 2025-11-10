package com.expensetracker.controller;

import com.expensetracker.model.User;
import com.expensetracker.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AddExpenseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("✅ AddExpenseServlet triggered!");

        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String amountStr = request.getParameter("amount");
        String date = request.getParameter("date");

        double amount = Double.parseDouble(amountStr);

        // ✅ Get logged-in user info from session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // User not logged in, redirect to login
            response.sendRedirect("login.jsp?error=Please+login+first");
            return;
        }

        // ✅ Retrieve user object from session
        User user = (User) session.getAttribute("user");
        int userId = user.getId();
        String username = user.getName();

        System.out.println("User ID: " + userId);
        System.out.println("Username: " + username);

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try (Connection conn = DBConnection.getConnection()) {
            // ✅ Insert expense with userId and username
            String sql = "INSERT INTO expenses (description, category, amount, date, user_id, username) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, description);
            stmt.setString(2, category);
            stmt.setDouble(3, amount);
            stmt.setString(4, date);
            stmt.setInt(5, userId);
            stmt.setString(6, username);

            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
//                out.println("<html><body style='font-family: sans-serif; text-align:center;'>");
//                out.println("<h2 style='color:green;'>Expense added successfully!</h2>");
//                out.println("<a href='add_expense.html'>Add Another</a> | <a href='view_expenses.jsp'>View All</a>");
//                out.println("</body></html>");
                response.sendRedirect("view_expenses.jsp");
            } else {
                out.println("<h2 style='color:red;'>Failed to add expense!</h2>");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
}
