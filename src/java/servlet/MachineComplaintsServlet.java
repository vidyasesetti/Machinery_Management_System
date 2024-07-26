package servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.ComplaintDAO;
import dao.EngineerDAO;
import model.Complaint;
import model.Engineer;

@WebServlet("/MachineComplaintsServlet")
public class MachineComplaintsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String machineId = request.getParameter("id");
        
        if (machineId == null || machineId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Machine ID is missing or invalid");
            return;
        }
        
        ComplaintDAO complaintDAO = new ComplaintDAO();
        List<Complaint> complaints = complaintDAO.getComplaintsByMachineId(machineId);
        
        EngineerDAO engineerDAO = new EngineerDAO();
        List<Engineer> engineers = engineerDAO.getAllEngineers();
        
        System.out.println("Machine ID: " + machineId);
        System.out.println("Number of Complaints: " + complaints.size());
        System.out.println("Number of Engineers: " + engineers.size());
        
        request.setAttribute("machineId", machineId);
        request.setAttribute("complaints", complaints);
        request.setAttribute("engineers", engineers);
        
        request.getRequestDispatcher("machinecomplaints.jsp").forward(request, response);
    }
}
