package com.chat.app;

import com.chat.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.*;
import java.sql.*;

@WebServlet("/api/signup")
@MultipartConfig
public class SignupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String name = request.getParameter("name");
        String password = request.getParameter("password");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (username == null || password == null || name == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{success: false, message: Missing required fields.}");
            return;
        }

        if (username.length() < 4 || username.length() > 20) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{success: false, message: Username must be between 4 and 20 characters.}");
            return;
        }

        if (password.length() < 6 || password.length() > 20) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Password must be between 6 and 20 characters.\"}");
            return;
        }

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement checkStmt = conn.prepareStatement("SELECT id FROM users WHERE username = ?");
            checkStmt.setString(1, username);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                out.print("{success: false, message: Username already exists.}");
                return;
            }

            PreparedStatement insertStmt = conn.prepareStatement(
                    "INSERT INTO users (username, name, password) VALUES (?, ?, ?)");
            insertStmt.setString(1, username);
            insertStmt.setString(2, name);
            insertStmt.setString(3, hashedPassword);

            int rows = insertStmt.executeUpdate();
            if (rows > 0) {
                response.setStatus(HttpServletResponse.SC_OK);
                out.print("{success: true, message: Signup successful.}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{success: false, message: Signup failed. Try again.}");
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{success: false, message: Database error.}");
            e.printStackTrace(out);
        }
    }
}
