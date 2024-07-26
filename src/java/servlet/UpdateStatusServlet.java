package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.ComplaintDAO;
import model.Complaint;

@WebServlet("/updateStatus")
public class UpdateStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String complaintId = request.getParameter("complaintId");
        String status = request.getParameter("status");
        
        ComplaintDAO complaintDAO = new ComplaintDAO();
        boolean success = complaintDAO.updateStatus(complaintId, status);
        Complaint complaint = complaintDAO.getComplaint(complaintId);
        
        if (success) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
