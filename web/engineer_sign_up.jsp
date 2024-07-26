<%@ page import="dao.Database" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Engineer Sign Up</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            background-color: #f8f9fa;
        }

        .container {
            margin-top: 50px;
        }

        .home-button {
            position: absolute;
            top: 10px;
            left: 10px;
        }
    </style>
</head>
<body>

<a href="admin_dashboard.jsp" class="btn btn-outline-primary home-button">Home</a>

<div class="container">
    <h2>Engineer Sign Up</h2>
    <form action="engineer_sign_up.jsp" method="post">
        <div class="form-group">
            <label for="id">ID</label>
            <input type="text" class="form-control" id="id" name="id" placeholder="Enter ID" required>
        </div>
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" class="form-control" id="username" name="username" placeholder="Enter Username" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" class="form-control" id="password" name="password" placeholder="Enter Password" required>
        </div>
        <div class="form-group">
            <label for="specialization">Specialization</label>
            <select class="form-control" id="specialization" name="specialization" required>
                <option value="Mechanical Failure">Mechanical Failure</option>
                <option value="Electrical Failure">Electrical Failure</option>
                <option value="Software/Control System Issues">Software/Control System Issues</option>
                <option value="Performance Degradation">Performance Degradation</option>
                <option value="Noise or Vibration">Noise or Vibration</option>
                <option value="Overheating">Overheating</option>
                <option value="Leaks">Leaks</option>
                <option value="Calibration Issues">Calibration Issues</option>
                <option value="Safety Concerns">Safety Concerns</option>
                <option value="Power Supply Problems">Power Supply Problems</option>
                <option value="Operational Errors">Operational Errors</option>
                <option value="Material Handling Problems">Material Handling Problems</option>
                <option value="Sensor Malfunctions">Sensor Malfunctions</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Submit</button>
    </form>
</div>

<%
    String id = request.getParameter("id");
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String specialization = request.getParameter("specialization"); // Added specialization

    if (id != null && username != null && password != null && specialization != null) { // Modified condition
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = Database.getConnection();
            ps = conn.prepareStatement("INSERT INTO engineer_login_table ( id, user_name, user_pwd, specialization ) VALUES (?, ?, ?, ?)"); // Modified query
            ps.setString(1, id);
            ps.setString(2, username);
            ps.setString(3, password);
            ps.setString(4, specialization); // Set specialization
            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                out.println("<div class=\"alert alert-success mt-3\" role=\"alert\">Engineer registered successfully!</div>");
            } else {
                out.println("<div class=\"alert alert-danger mt-3\" role=\"alert\">Failed to register engineer.</div>");
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
