package servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/images/*")
public class ImageServlet extends HttpServlet {
    private static final String IMAGE_DIRECTORY = "C:/Users/Ramya Rahul/personal_domain_1/config/web/images/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String requestedImage = request.getPathInfo().substring(1); // Get the image name from the URL
        File imageFile = new File(IMAGE_DIRECTORY, requestedImage);

        if (imageFile.exists() && !imageFile.isDirectory()) {
            try (FileInputStream fis = new FileInputStream(imageFile); OutputStream os = response.getOutputStream()) {
                response.setContentType("image/png");
                response.setContentLength((int) imageFile.length());

                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = fis.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND); // 404 if the image is not found
        }
    }
}
