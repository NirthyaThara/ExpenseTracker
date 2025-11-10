package com.expensetracker.controller;

import com.expensetracker.dao.ExpenseDAO;
import com.expensetracker.dao.UserDAO;
import com.expensetracker.model.User;
import com.expensetracker.util.EmailUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/sendExpenseSummary")
public class SendExpenseSummaryServlet extends HttpServlet {
    private ExpenseDAO expenseDAO = new ExpenseDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (User) (session != null ? session.getAttribute("user") : null);

        if (user == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        // ✅ CASE 1: ADMIN — Send to all users
        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            for (User u : userDAO.getAllUsers()) {

                Map<String, Map<String, Double>> monthlyData =
                        expenseDAO.getMonthlyTotalsByCategory(u.getId());

                StringBuilder emailBody = new StringBuilder();
                emailBody.append("Hello ").append(u.getName()).append(",\n\n");
                emailBody.append("Here’s your monthly expense summary:\n\n");

                for (Map.Entry<String, Map<String, Double>> entry : monthlyData.entrySet()) {
                    String month = entry.getKey();
                    double income = entry.getValue().getOrDefault("Income", 0.0);
                    double expense = entry.getValue().getOrDefault("Expense", 0.0);
                    double balance = income - expense;

                    emailBody.append(String.format("📅 %s\n", month));
                    emailBody.append(String.format("   Income:  Rs. %.2f\n", income));
                    emailBody.append(String.format("   Expense: Rs. %.2f\n", expense));
                    emailBody.append(String.format("   Balance: Rs. %.2f\n\n", balance));
                }

                emailBody.append("Thank you for using Expense Tracker!\n\n— Expense Tracker Team");

                // ✅ Send email to each user
                EmailUtil.sendEmail(u.getEmail(), "Your Monthly Expense Summary", emailBody.toString());
            }

            // ✅ Optional: Admin confirmation email
            EmailUtil.sendEmail(
                    user.getEmail(),
                    "Admin Confirmation — Expense Summary Sent",
                    "Hello Admin " + user.getName() + ",\n\n" +
                            "Expense summary emails have been successfully sent to all users.\n\n" +
                            "— Expense Tracker System"
            );

            // ✅ Show alert (no redirect)
            res.setContentType("text/html");
            res.getWriter().println("<script>");
            res.getWriter().println("alert('✅ Expense summary emails sent to all users successfully!');");
            res.getWriter().println("window.history.back();");
            res.getWriter().println("</script>");
            return;
        }

        // ✅ CASE 2: REGULAR USER — Send only to themselves
        Map<String, Map<String, Double>> monthlyData =
                expenseDAO.getMonthlyTotalsByCategory(user.getId());

        StringBuilder emailBody = new StringBuilder();
        emailBody.append("Hello ").append(user.getName()).append(",\n\n");
        emailBody.append("Here’s your monthly expense summary:\n\n");

        for (Map.Entry<String, Map<String, Double>> entry : monthlyData.entrySet()) {
            String month = entry.getKey();
            double income = entry.getValue().getOrDefault("Income", 0.0);
            double expense = entry.getValue().getOrDefault("Expense", 0.0);
            double balance = income - expense;

            emailBody.append(String.format("📅 %s\n", month));
            emailBody.append(String.format("   Income:  Rs. %.2f\n", income));
            emailBody.append(String.format("   Expense: Rs. %.2f\n", expense));
            emailBody.append(String.format("   Balance: Rs. %.2f\n\n", balance));
        }

        emailBody.append("Thank you for using Expense Tracker!\n\n— Expense Tracker Team");

        // ✅ Send email to user
        EmailUtil.sendEmail(user.getEmail(), "Your Monthly Expense Summary", emailBody.toString());

        // ✅ Show alert and stay on same page
        res.setContentType("text/html");
        res.getWriter().println("<script>");
        res.getWriter().println("alert('✅ Expense summary email sent successfully!');");
        res.getWriter().println("window.history.back();");
        res.getWriter().println("</script>");
    }
}
