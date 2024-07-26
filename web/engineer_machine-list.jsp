<%@ page import="java.util.List"%>
<%@ page import="model.Complaint"%>
<%@ page import="dao.ComplaintDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>Engineer Machine Complaints</title>
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
            margin-left: 250px; /* Adjusted margin to accommodate the sidebar */
        }
        .header-buttons {
            display: flex;
            justify-content: flex-end;
            margin-top: 20px;
        }
        .header-buttons a {
            margin-left: 10px;
        }
        .red-mark {
            color: red;
        }
        .green-mark {
            color: green;
        }
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            width: 250px;
            background-color: #343a40;
            padding-top: 70px;
        }
        .nav-link {
            color: #fff;
        }
        .nav-link:hover {
            color: #f8f9fa !important;
            background-color: #343a40;
        }
        table tbody tr:hover {
            background-color: #f8f9fa;
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="sidebar">
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link" href="index.html">Home</a>
        </li>
        <li class="nav-item">
            <form action="LogoutServlet" method="post" id="logoutForm">
                <input type="hidden" name="logout" value="true">
                <a class="nav-link" href="#" onclick="document.getElementById('logoutForm').submit();">Logout</a>
            </form>
        </li>
    </ul>
</div>

<div class="main-content">
    <h1 class="mb-4">Complaints Assigned to Engineer ID: ${engineerId}</h1>
    <div class="table-responsive">
        <table class="table table-bordered table-hover">
            <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>Machine ID</th>
                    <th>Status</th>
                    <th>Date Posted</th>
                    <th>Feedback</th>
                    <th>Complaint Type</th>
                    <th>Date Closed</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="complaint" items="${complaints}">
                    <tr onclick="window.location='engineer_complaintDetails.jsp?id=${complaint.id}'">
                        <td>${complaint.id}</td>
                        <td>${complaint.machineId}</td>
                        <td>${complaint.status}</td>
                        <td><fmt:formatDate value="${complaint.datePosted}" pattern="yyyy-MM-dd"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${empty complaint.feedback}">
                                    <span class="red-mark">&#10008;</span> <!-- Red cross mark -->
                                </c:when>
                                <c:otherwise>
                                    <span class="green-mark">&#10004;</span> <!-- Green tick mark -->
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${complaint.complaintType}</td>
                        <td><fmt:formatDate value="${complaint.dateClosed}" pattern="yyyy-MM-dd"/></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
