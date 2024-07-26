package servlet;

import dao.MachineDAO;
import dao.ComplaintDAO;
import model.Machine;
import model.Complaint;

import javax.json.Json;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObjectBuilder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/MachineServlet")
public class MachineServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(MachineServlet.class.getName());
    private MachineDAO machineDAO;
    private ComplaintDAO complaintDAO;

    @Override
    public void init() {
        machineDAO = new MachineDAO();
        complaintDAO = new ComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        LOGGER.info("Servlet doGet() method invoked.");

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteMachine(request, response);
                break;
            case "list":
                listMachines(request, response);
                break;
            case "manageComplaints":
                manageComplaints(request, response);
                break;
            case "viewComplaints":
                viewComplaints(request, response);
                break;
            case "getMachineIdByName":
                getMachineIdByName(request, response);
                break;
            default:
                listMachines(request, response);
                break;
        }

        LOGGER.info("Servlet doGet() method finished.");
    }

    private void listMachines(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        LOGGER.info("Retrieving list of machines from database.");
        List<Machine> machines = machineDAO.getAllMachines();
        LOGGER.info("Number of machines retrieved: " + machines.size());

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonArrayBuilder jsonArrayBuilder = Json.createArrayBuilder();
        for (Machine machine : machines) {
            JsonObjectBuilder jsonObjectBuilder = Json.createObjectBuilder()
                .add("id", machine.getId())
                .add("name", machine.getName())
                .add("details", machine.getDetails())
                .add("model", machine.getModel())
                .add("department", machine.getDepartment());
            jsonArrayBuilder.add(jsonObjectBuilder);
        }

        try (PrintWriter out = response.getWriter()) {
            out.print(jsonArrayBuilder.build().toString());
        }
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("machine-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        Machine machine = machineDAO.getMachine(id);
        request.setAttribute("machine", machine);
        request.getRequestDispatcher("machine-form.jsp").forward(request, response);
    }

    private void deleteMachine(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        machineDAO.deleteMachine(id);
        response.sendRedirect("admin_machine-list.jsp");
    }
    
    
    private void manageComplaints(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        // You can add logic to handle the complaints, for example, redirect to a complaints page
        response.sendRedirect("complaints.jsp?machineId=" + id);
    }
    
    private void viewComplaints(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String machineId = request.getParameter("id");
        List<Complaint> complaints = complaintDAO.getComplaintsByMachineId(machineId);
        request.setAttribute("complaints", complaints);
        request.setAttribute("machineId", machineId);
        request.getRequestDispatcher("machinecomplaints.jsp").forward(request, response);
    }
    
    
    private void getMachineIdByName(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String machineName = request.getParameter("name");
        String machineId = machineDAO.getMachineIdByName(machineName);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"id\": \"" + machineId + "\"}");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        LOGGER.info("Servlet doPost() method invoked.");

        String action = request.getParameter("action");
        LOGGER.info("Action parameter: " + action);

        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String details = request.getParameter("details");
        String model = request.getParameter("model");
        String department = request.getParameter("department");

        Machine machine = new Machine(id, name, details, model, department);

        if ("edit".equals(action)) {
            machineDAO.updateMachine(machine);
        } else if ("insert".equals(action)) {
            machineDAO.insertMachine(machine);
        }

       response.sendRedirect("admin_machine-list.jsp");
    }
}
