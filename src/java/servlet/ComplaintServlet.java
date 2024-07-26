package servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import model.Complaint;
import dao.ComplaintDAO;
import javax.servlet.http.HttpSession;
import java.sql.Date;

@WebServlet("/ComplaintServlet")
@MultipartConfig
public class ComplaintServlet extends HttpServlet {
    private static final String IMAGES_FOLDER_PATH = "web/complaint_images/";

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    // Handle the form data
    String machineId = request.getParameter("machineId");
    String complaintText = request.getParameter("complaint");
    String complaintType = request.getParameter("complaintType"); // Get the complaint type


    HttpSession session = request.getSession();
        String postedBy = (String) session.getAttribute("username");

        if (postedBy == null) {
            response.sendRedirect("login.jsp"); // Redirect to login page if user is not logged in
            return;
        }
    // Get the absolute path to the web/complaint_images folder
    String IMAGES_FOLDER_PATH = "/complaint_images/";
    String imagesFolderPath = request.getServletContext().getRealPath(IMAGES_FOLDER_PATH);

    // Ensure the images folder exists
    if (imagesFolderPath == null) {
        // If the folder path is null, create the folder
        File webInfFolder = new File(request.getServletContext().getRealPath("/WEB-INF"));
        imagesFolderPath = webInfFolder.getParentFile().getAbsolutePath() + IMAGES_FOLDER_PATH;
        File imagesFolder = new File(imagesFolderPath);
        if (!imagesFolder.exists()) {
            if (!imagesFolder.mkdirs()) {
                System.err.println("Failed to create images folder!");
                return; // Exit the method if folder creation fails
            }
            System.out.println("Images folder created: " + imagesFolder.getAbsolutePath());
        }
    }

    // Handle the file upload
    Part filePart = request.getPart("image"); // Part is the uploaded file
    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); // MSIE fix
    String filePath = imagesFolderPath + File.separator + fileName;

    // Save the file
    Files.copy(filePart.getInputStream(), Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);

    // Create a Complaint object to encapsulate the complaint details
    Complaint complaint = new Complaint();
    complaint.setMachineId(machineId);
    complaint.setComplaint(complaintText);
    complaint.setImage(fileName);
    complaint.setStatus("Not Completed");
    complaint.setDatePosted(new Date(System.currentTimeMillis())); // Set current date as the datePosted
    complaint.setPostedBy(postedBy); // Set the postedBy field to the current session user
    complaint.setAssignedTo(null); // Set assignedTo to null
    complaint.setFeedback(null);
    complaint.setComplaintType(complaintType);
    complaint.setDateClosed(null);
        
        
    // Store the complaint in the database
    ComplaintDAO complaintDAO = new ComplaintDAO();
    complaintDAO.insertComplaint(complaint);

    response.sendRedirect("complaints.jsp?machineId=" + machineId);
}

}
