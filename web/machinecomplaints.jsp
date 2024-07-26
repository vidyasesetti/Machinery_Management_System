<%@page import="java.util.List"%>
<%@page import="model.Complaint"%>
<%@page import="dao.ComplaintDAO"%>
<%@page import="model.Engineer"%>
<%@page import="dao.EngineerDAO"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Machine Complaints</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            background-color: #f8f9fa;
        }
        .main-content {
            padding: 20px;
        }
        .header-buttons {
            display: flex;
            justify-content: flex-end;
            margin-top: 20px;
        }
        .header-buttons a {
            margin-left: 10px;
        }
        .table thead th {
            background-color: #343a40;
            color: #fff;
            border-color: #dee2e6;
        }
        .table tbody tr:nth-child(odd) {
            background-color: #f8f9fa;
        }
        .table tbody tr:hover {
            background-color: #e9ecef;
            cursor: pointer;
        }
        .modal-content {
            background-color: #f8f9fa;
        }
        .modal-title {
            color: #343a40;
        }
        .modal-footer {
            background-color: #f8f9fa;
        }
        .btn-primary, .btn-secondary, .btn-danger {
            padding: 0.375rem 0.75rem;
            font-size: 0.9rem;
        }
        .text-success {
            color: #28a745;
        }
        .text-danger {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="header-buttons">
        <a href="admin_machine-list.jsp" class="btn btn-secondary">Back to Machine List</a>
    </div>
    <div class="main-content">
        <h1 class="mb-4">Complaints for Machine ID: ${machineId}</h1>
        <table class="table table-bordered mt-3">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Machine ID</th>
                    <th>Date Posted</th>
                    <th>Complaint Type</th>
                    <th>Posted By</th>
                    <th>Assigned To</th>
                    <th>Status</th>
                    <th>Feedback</th>
                    <th>Date Closed</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="complaint" items="${complaints}">
                    <tr style="background-color: ${empty complaint.dateClosed ? 'lightcoral' : 'lightgreen'};">
                        <td>${complaint.id}</td>
                        <td>${complaint.machineId}</td>
                        <td>${complaint.datePosted}</td>
                        <td>${complaint.complaintType}</td> <!-- This line -->
                        <td>${complaint.postedBy}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty complaint.assignedTo}">
                                    ${complaint.assignedTo}
                                </c:when>
                                <c:otherwise>
                                    <button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#assignModal_${complaint.id}">Assign</button>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <select class="form-control" id="status_${complaint.id}" name="status" onchange="updateStatus(${complaint.id})">
                                <option value="${complaint.status}" selected>${complaint.status}</option>
                                <option value="Completed">Completed</option>
                            </select>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty complaint.feedback}">
                                    <span class="text-success">&#10004;</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-danger">&#10008;</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        
                        <td>${complaint.dateClosed}</td>
                    </tr>
                    <!-- Modal for Assigning Engineer -->
                    <div class="modal fade" id="assignModal_${complaint.id}" tabindex="-1" role="dialog" aria-labelledby="assignModalLabel_${complaint.id}" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="assignModalLabel_${complaint.id}">Assign Engineer</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <form action="assignEngineer.jsp" method="post">
                                        <div class="form-group">
                                            <label for="engineer_${complaint.id}">Select Engineer</label>
                                            <select class="form-control" id="engineer_${complaint.id}" name="engineer" required>
                                                <option value="">Select Engineer</option>
                                                <c:forEach var="engineer" items="${engineers}">
                                                    <c:if test="${engineer.getSpecialization().equals(complaint.complaintType)}">
                                                        <option value="${engineer.getId()}">${engineer.getUsername()}</option>
                                                    </c:if>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <input type="hidden" name="complaintId" value="${complaint.id}">
                                        <button type="submit" class="btn btn-primary">Assign</button>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- End of Modal -->
                </c:forEach>
            </tbody>
        </table>
    </div>
    
    <script>
        function updateStatus(complaintId) {
            var status = document.getElementById("status_" + complaintId).value;
            $.ajax({
                type: "POST",
                url: "updateStatus",
                data: { complaintId: complaintId, status: status },
                success: function(data) {
                    console.log("Status updated successfully");
                },
                error: function(xhr, status, error) {
                    console.error("Error updating status: " + error);
                }
            });
            
        }
    </script>
</body>
</html>
