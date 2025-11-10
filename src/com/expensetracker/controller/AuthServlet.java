package com.expensetracker.controller;

import com.expensetracker.dao.UserDAO;
import com.expensetracker.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getServletPath();

        switch (action) {

            // 🧩 REGISTER
            case "/register": {
                String name = req.getParameter("name");
                String email = req.getParameter("email");
                String password = req.getParameter("password");

                User user = new User();
                user.setName(name);
                user.setEmail(email);
                user.setPassword(password);
                user.setRole("USER"); // default role for registration

                boolean success = userDAO.register(user);

                if (success) {
                    res.sendRedirect("login.jsp?success=registered");
                } else {
                    res.sendRedirect("register.jsp?error=failed");
                }
                break;
            }

// 🧩 LOGIN
            case "/login": {
                String email = req.getParameter("email");
                String password = req.getParameter("password");

                User user = userDAO.login(email, password);

                if (user != null) {
                    HttpSession session = req.getSession();
                    session.setAttribute("user", user);
                    session.setAttribute("userId", user.getId());
                    session.setAttribute("username", user.getName());
                    session.setAttribute("role", user.getRole());

                    // ✅ Redirect based on role
                    if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                        res.sendRedirect("admin_home.jsp");
                    } else {
                        res.sendRedirect("index.html");
                    }

                } else {
                    res.sendRedirect("login.jsp?error=invalid");
                }
                break;
            }


        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        if ("/logout".equals(req.getServletPath())) {
            HttpSession session = req.getSession(false);
            if (session != null) session.invalidate();

            res.sendRedirect("login.jsp?logout=1");
        }
    }
}
