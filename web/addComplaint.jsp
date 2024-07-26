<%@page import="java.io.*" %>
<%@page import="javax.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Complaint</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("index.html");
        return;
    }
%>
<div class="container mt-5">
    <h3>Add Complaint</h3>
    <form action="ComplaintServlet" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label for="complaintType">Complaint Type</label>
            <select class="form-control" id="complaintType" name="complaintType" required>
                <option value="">Select Complaint Type</option>
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
        <div class="form-group">
            <label for="complaint">Complaint</label>
            <textarea class="form-control" id="complaint" name="complaint" rows="5" required></textarea>
        </div>
        <div class="form-group">
            <label for="image">Upload Image</label>
            <input type="file" class="form-control-file" id="image" name="image" required>
        </div>
        <input type="hidden" name="machineId" value="<%= request.getParameter("machineId") %>">
        <button type="submit" class="btn btn-primary">Submit</button>
    </form>
</div>
</body>
</html>
