package com.expensetracker.controller;

import com.expensetracker.dao.ExpenseDAO;
import com.expensetracker.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/monthlyExpenditure")
public class ViewMonthlyExpenditureServlet extends HttpServlet {
    private ExpenseDAO expenseDAO = new ExpenseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (User) (session != null ? session.getAttribute("user") : null);

        if (user == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        // ✅ Declare correct type for data
        Map<String, Map<String, Double>> monthlyTotals;

        // ✅ Choose query based on role
        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            monthlyTotals = expenseDAO.getAllUsersMonthlyTotalsByCategory();
        } else {
            monthlyTotals = expenseDAO.getMonthlyTotalsByCategory(user.getId());
        }

        // ✅ Send to JSP
        req.setAttribute("monthlyTotals", monthlyTotals);
        RequestDispatcher rd = req.getRequestDispatcher("monthly_expenditure.jsp");
        rd.forward(req, res);
    }
}
