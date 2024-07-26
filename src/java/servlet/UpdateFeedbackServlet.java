package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.ComplaintDAO;
import model.Complaint;

@WebServlet("/UpdateFeedbackServlet")
public class UpdateFeedbackServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve parameters from the request
        String complaintId = request.getParameter("id");
        String feedback = request.getParameter("feedback");
        
        // Update the feedback in the database
        ComplaintDAO complaintDAO = new ComplaintDAO();
        complaintDAO.updateFeedback(complaintId, feedback);
        
        // Redirect back to the complaint details page
        response.sendRedirect("engineer_complaintDetails.jsp?id=" + complaintId);
    }
}
