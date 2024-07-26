package servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.ComplaintDAO;
import model.Complaint;

@WebServlet("/EngineerComplaintsServlet")
public class EngineerComplaintsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String engineerId = request.getParameter("username");
        ComplaintDAO complaintDAO = new ComplaintDAO();
        List<Complaint> complaints = complaintDAO.getComplaintsByEngineerId(engineerId);
        
        System.out.println(complaints.size());
        request.setAttribute("engineerId", engineerId);
        request.setAttribute("complaints", complaints);
        
        request.getRequestDispatcher("engineer_machine-list.jsp").forward(request, response);
    }
}
