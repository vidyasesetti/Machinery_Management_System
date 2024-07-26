<%@page import="java.util.List"%>
<%@page import="model.Complaint"%>
<%@page import="dao.ComplaintDAO"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String complaintId = request.getParameter("complaintId");
    String engineerId = request.getParameter("engineer");

    ComplaintDAO complaintDAO = new ComplaintDAO();
    Complaint complaint = complaintDAO.getComplaint(complaintId);

    complaint.setAssignedTo(engineerId);
    complaintDAO.updateComplaint(complaint);

    response.sendRedirect("/loginapp/MachineComplaintsServlet?id=" + complaint.getMachineId() );
%>
