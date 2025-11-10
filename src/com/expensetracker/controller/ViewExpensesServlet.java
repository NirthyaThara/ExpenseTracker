package com.expensetracker.controller;

import com.expensetracker.model.User;
import com.expensetracker.util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.*;
import java.sql.*;

public class ViewExpensesServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=Please+login+first");
            return;
        }

        User user = (User) session.getAttribute("user");
        String role = user.getRole();
        int userId = user.getId();

        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement ps;
            if ("ADMIN".equalsIgnoreCase(role)) {
                // ✅ Admin can see all expenses
                ps = conn.prepareStatement("SELECT * FROM expenses ORDER BY date DESC");
            } else {
                // ✅ Regular user sees only their own expenses
                ps = conn.prepareStatement("SELECT * FROM expenses WHERE user_id = ? ORDER BY date DESC");
                ps.setInt(1, userId);
            }

            ResultSet rs = ps.executeQuery();

            double totalIncome = 0, totalExpense = 0;

            out.println("<html><head><title>View Expenses</title>");
            out.println("<style>");
            out.println("body{font-family:Arial;background-color:#f8f9fa;}");
            out.println("table{width:90%;margin:50px auto;border-collapse:collapse;}");
            out.println("th,td{border:1px solid #ddd;padding:10px;text-align:center;}");
            out.println("th{background-color:#28a745;color:white;}");
            out.println("tr:nth-child(even){background-color:#f2f2f2;}");
            out.println("</style></head><body>");
            out.println("<h2 style='text-align:center;'>Expense Summary</h2>");
            out.println("<table><tr>");

            if ("ADMIN".equalsIgnoreCase(role)) {
                out.println("<th>User</th>");
            }

            out.println("<th>Description</th><th>Category</th><th>Amount</th><th>Date</th></tr>");

            while (rs.next()) {
                String username = rs.getString("username");
                String desc = rs.getString("description");
                String cat = rs.getString("category");
                double amt = rs.getDouble("amount");
                String date = rs.getString("date");

                out.println("<tr>");
                if ("ADMIN".equalsIgnoreCase(role)) {
                    out.println("<td>" + username + "</td>");
                }
                out.println("<td>" + desc + "</td>");
                out.println("<td>" + cat + "</td>");
                out.println("<td>$" + amt + "</td>");
                out.println("<td>" + date + "</td>");
                out.println("</tr>");

                if (cat.equalsIgnoreCase("Income")) totalIncome += amt;
                else totalExpense += amt;
            }

            double net = totalIncome - totalExpense;

            out.println("</table>");
            out.println("<div style='text-align:center;margin-top:20px;'>");
            out.println("<p>Total Income: <span style='color:green;'>$" + totalIncome + "</span></p>");
            out.println("<p>Total Expense: <span style='color:red;'>$" + totalExpense + "</span></p>");
            out.println("<p>Net Balance: <strong>$" + net + "</strong></p>");
            out.println("</div>");
            out.println("</body></html>");

        } catch (Exception e) {
            e.printStackTrace(out);
        }
    }
}
