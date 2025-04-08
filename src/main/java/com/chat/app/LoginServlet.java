package com.chat.app;

import com.chat.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.*;
import java.sql.*;

@WebServlet("/api/login")
@MultipartConfig
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (username == null || password == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{success: false, message: Missing username or password.}");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT password, name FROM users WHERE username = ?");
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password");

                if (BCrypt.checkpw(password, storedHash)) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    String name = rs.getString("name");
                    out.print("{success: true, message: Login successful., name: " + name + ", username: " + username + "}");
                } else {
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    out.print("{success: false, message: Invalid username or password.}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{success: false, message: Invalid username or password.}");
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{success: false, message: Database error.}");
            e.printStackTrace(out);
        }
    }
}
