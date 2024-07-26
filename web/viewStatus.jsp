<%@page import="dao.ComplaintDAO"%>
<%@page import="model.Complaint"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Date"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Complaint Status</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .completed {
            background-color: #c3e6cb;
        }
        .pending {
            background-color: #f5c6cb;
        }
        tbody tr {
            cursor: pointer;
        }
        tbody tr:hover {
            background-color: #d8e8ff; /* Change to your desired hover color */
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <a href="complaints.jsp?machineId=<%= request.getParameter("machineId") %>" class="btn btn-outline-primary">Back</a>
    <h2 class="mt-3">Complaint Status</h2>
    <div class="table-responsive">
        <table class="table mt-3 table-bordered">
            <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>Machine ID</th>
                    <th>Complaint</th>
                    <th>Status</th>
                    <th>Date Posted</th>
                    <th>Date Closed</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String machineId = request.getParameter("machineId");
                    String postedBy = (String) session.getAttribute("username"); // Assuming username is stored in session
                    ComplaintDAO complaintDAO = new ComplaintDAO();
                    List<Complaint> complaints = complaintDAO.getComplaintsByMachineIdAndUser(machineId, postedBy);
                    for (Complaint complaint : complaints) {
                        String statusClass = (complaint.getStatus().equalsIgnoreCase("completed")) ? "completed" : "pending";
                %>
                    <tr onclick="window.location='complaintDetails.jsp?id=<%= complaint.getId() %>'">
                        <td><%= complaint.getId() %></td>
                        <td><%= complaint.getMachineId() %></td>
                        <td><%= complaint.getComplaint() %></td>
                        <td class="<%= statusClass %>"><%= complaint.getStatus() %></td>
                        <td><%= complaint.getDatePosted() %></td>
                        <td><%= complaint.getDateClosed() %></td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
