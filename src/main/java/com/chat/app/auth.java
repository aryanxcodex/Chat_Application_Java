package com.chat.app;

import com.chat.util.DBConnection;

import java.io.*;
import java.sql.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

class SignupServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String name = request.getParameter("name");
        String password = request.getParameter("password");

        PrintWriter out = response.getWriter();
        response.setContentType("text/plain");

        if (username.length() < 4 || username.length() > 20) {
            out.println("Username must be between 4 and 20 characters.");
            return;
        }

        if (password.length() < 6 || password.length() > 20) {
            out.println("Password must be between 6 and 20 characters.");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement checkStmt = conn.prepareStatement("SELECT id FROM users WHERE username = ?");
            checkStmt.setString(1, username);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                out.println("Username already exists.");
                return;
            }

            PreparedStatement insertStmt = conn.prepareStatement("INSERT INTO users (username, name, password) VALUES (?, ?, ?)");
            insertStmt.setString(1, username);
            insertStmt.setString(2, name);
            insertStmt.setString(3, password); // Use hashing in production

            int rows = insertStmt.executeUpdate();
            if (rows > 0) {
                out.println("Signup successful.");
            } else {
                out.println("Signup failed. Try again.");
            }

        } catch (SQLException e) {
            e.printStackTrace(out);
        }
    }
}

class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        PrintWriter out = response.getWriter();
        response.setContentType("text/plain");

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE username = ? AND password = ?");
            stmt.setString(1, username);
            stmt.setString(2, password); // Again, use hashing in real-world

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                out.println("Login successful.");
                // You can start a session here
                // request.getSession().setAttribute("user", rs.getString("username"));
            } else {
                out.println("Invalid username or password.");
            }

        } catch (SQLException e) {
            e.printStackTrace(out);
        }
    }
}

