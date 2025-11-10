package com.expensetracker.dao;

import com.expensetracker.util.DBConnection;
import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.HashMap;

public class ExpenseDAO {

    /**
     * ✅ For a specific user: Monthly totals grouped by category (Income & Expense)
     */
    public Map<String, Map<String, Double>> getMonthlyTotalsByCategory(int userId) {
        Map<String, Map<String, Double>> monthlyTotals = new LinkedHashMap<>();

        String sql = """
                SELECT DATE_FORMAT(date, '%Y-%m') AS month, category, SUM(amount) AS total
                FROM expenses
                WHERE user_id = ?
                GROUP BY DATE_FORMAT(date, '%Y-%m'), category
                ORDER BY month DESC
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String month = rs.getString("month");
                String category = rs.getString("category");
                double total = rs.getDouble("total");

                monthlyTotals
                        .computeIfAbsent(month, k -> new LinkedHashMap<>())
                        .put(category, total);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return monthlyTotals;
    }

    /**
     * ✅ For Admin: All users' monthly totals grouped by category (Income & Expense)
     * Includes username in the key for clarity.
     */
    public Map<String, Map<String, Double>> getAllUsersMonthlyTotalsByCategory() {
        Map<String, Map<String, Double>> allUsersTotals = new LinkedHashMap<>();

        String sql = """
                SELECT u.name AS username,
                       DATE_FORMAT(e.date, '%Y-%m') AS month,
                       e.category,
                       SUM(e.amount) AS total
                FROM expenses e
                JOIN users u ON e.user_id = u.id
                GROUP BY u.name, DATE_FORMAT(e.date, '%Y-%m'), e.category
                ORDER BY u.name, month DESC
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String username = rs.getString("username");
                String month = rs.getString("month");
                String category = rs.getString("category");
                double total = rs.getDouble("total");

                // Combine username + month so each entry is unique per user per month
                String key = username + " (" + month + ")";

                allUsersTotals
                        .computeIfAbsent(key, k -> new LinkedHashMap<>())
                        .put(category, total);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return allUsersTotals;
    }

    /**
     * ✅ For Admin Dashboard Overview: Total income & expenses (all users)
     */
    public Map<String, Double> getOverallTotalsForAllUsers() {
        Map<String, Double> totals = new HashMap<>();

        String sql = """
                SELECT category, SUM(amount) AS total
                FROM expenses
                GROUP BY category
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String category = rs.getString("category");
                double total = rs.getDouble("total");
                totals.put(category, total);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return totals;
    }
}
