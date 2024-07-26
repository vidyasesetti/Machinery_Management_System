<%@page import="dao.ComplaintDAO"%>
<%@page import="model.Complaint"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String complaintId = request.getParameter("id");
    ComplaintDAO complaintDAO = new ComplaintDAO();
    Complaint complaint = complaintDAO.getComplaint(complaintId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Complaint Details</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <a href="EngineerComplaintsServlet?username=<%= complaint.getAssignedTo()%>" class="btn btn-outline-primary">Back</a>
    <h2 class="mt-3">Complaint Details</h2>
    <div class="row mt-3">
        <div class="col-md-6">
            <div class="form-group">
                <label for="complaintId">ID</label>
                <input type="text" class="form-control" id="complaintId" value="<%= complaint.getId() %>" readonly>
            </div>
            <div class="form-group">
                <label for="machineId">Machine ID</label>
                <input type="text" class="form-control" id="machineId" value="<%= complaint.getMachineId() %>" readonly>
            </div>
            <div class="form-group">
                <label for="complaint">Complaint</label>
                <textarea class="form-control" id="complaint" rows="3" readonly><%= complaint.getComplaint() %></textarea>
            </div>
            <div class="form-group">
                <label for="complaintType">Complaint Type</label>
                <input type="text" class="form-control" id="complaintType" value="<%= complaint.getComplaintType() %>" readonly>
            </div>
            <div class="form-group">
                <label for="status">Status</label>
                <input type="text" class="form-control" id="status" value="<%= complaint.getStatus() %>" readonly>
            </div>
            <div class="form-group">
                <label for="datePosted">Date Posted</label>
                <input type="text" class="form-control" id="datePosted" value="<%= complaint.getDatePosted() %>" readonly>
            </div>
            <div class="form-group">
                <label for="postedBy">Posted By</label>
                <input type="text" class="form-control" id="postedBy" value="<%= complaint.getPostedBy() %>" readonly>
            </div>
            <div class="form-group">
                <label for="assignedTo">Assigned To</label>
                <input type="text" class="form-control" id="assignedTo" value="<%= complaint.getAssignedTo() %>" readonly>
            </div>
            <form action="UpdateFeedbackServlet" method="post">
                <div class="form-group">
                    <label for="feedback">Feedback</label>
                    <textarea class="form-control" id="feedback" name="feedback" rows="3"><%= complaint.getFeedback() %></textarea>
                </div>
                <div class="form-group">
                    <label for="datePosted">Date Posted</label>
                    <input type="text" class="form-control" id="datePosted" value="<%= complaint.getDatePosted() %>" readonly>
                </div>
                <input type="hidden" name="id" value="<%= complaint.getId() %>">
                <button type="submit" class="btn btn-primary">Submit</button>
            </form>
        </div>
        <div class="col-md-6">
            <div class="form-group">
                <label for="image">Image</label>
                <img src="complaint_images/<%= complaint.getImage() %>" class="img-fluid" alt="Complaint Image">
            </div>
        </div>
    </div>
</div>
</body>
</html>
