<%@ page import="dao.Database" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sign Up</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            background-color: #f8f9fa;
        }

        .container {
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .form-container {
            max-width: 400px;
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0px 0px 15px 0px rgba(0, 0, 0, 0.1);
        }

        .form-title {
            text-align: center;
            margin-bottom: 30px;
        }

        .home-button {
            position: absolute;
            top: 10px;
            left: 10px;
        }
    </style>
</head>
<body>

<a href="index.html" class="btn btn-outline-primary home-button">Home</a>

<div class="container">
    <div class="form-container">
        <h2 class="form-title">Sign Up</h2>
        <form action="signup.jsp" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" class="form-control" id="username" name="username" placeholder="Enter Username" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" class="form-control" id="password" name="password" placeholder="Enter Password" required>
            </div>
            <button type="submit" class="btn btn-primary btn-block">Submit</button>
        </form>
    </div>
</div>

<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (username != null && password != null) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = Database.getConnection();
            ps = conn.prepareStatement("INSERT INTO login_table ( user_name, user_pwd ) VALUES (?, ?)");
            ps.setString(1, username);
            ps.setString(2, password);
            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                out.println("<div class=\"alert alert-success mt-3\" role=\"alert\">User registered successfully!</div>");
            } else {
                out.println("<div class=\"alert alert-danger mt-3\" role=\"alert\">Failed to register user.</div>");
            }
        } catch (SQLException e) {
            out.println("<div class=\"alert alert-danger mt-3\" role=\"alert\">" + e.getMessage() + "</div>");
        } finally {
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    out.println("<div class=\"alert alert-danger mt-3\" role=\"alert\">" + e.getMessage() + "</div>");
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    out.println("<div class=\"alert alert-danger mt-3\" role=\"alert\">" + e.getMessage() + "</div>");
                }
            }
        }
    }
%>

</body>
</html>
