package dao;

import model.Machine;
import util.QRCodeGenerator;
import com.google.zxing.WriterException;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.io.File;
import java.io.IOException;
import java.util.logging.Logger;

public class MachineDAO {
    
    private static final Logger LOGGER = Logger.getLogger(MachineDAO.class.getName());

    private Connection getConnection() throws SQLException {
        return Database.getConnection();
    }

    public List<Machine> getAllMachines() {
        List<Machine> machines = new ArrayList<>();
        try (Connection connection = getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery("SELECT * FROM machines")) {

            while (resultSet.next()) {
                Machine machine = extractMachineFromResultSet(resultSet);
                machines.add(machine);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return machines;
    }

    public Machine getMachine(String id) {
        Machine machine = null;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement("SELECT * FROM machines WHERE id = ?")) {

            preparedStatement.setString(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                machine = extractMachineFromResultSet(resultSet);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return machine;
    }

    public void deleteMachine(String id) {
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement("DELETE FROM machines WHERE id = ?")) {

            preparedStatement.setString(1, id);
            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


public void insertMachine(Machine machine) {
        String insertSQL = "INSERT INTO machines (name, details, model, department) VALUES (?, ?, ?, ?)";
        String urlTemplate = "http://192.168.147.112:29493/loginapp/complaints.jsp?machineId=";
        String imagesFolderPath = "web/images/"; // Path relative to the project root

        // Ensure the images folder exists
        File imagesFolder = new File(imagesFolderPath);
        if (!imagesFolder.exists()) {
            if (imagesFolder.mkdirs()) {
                System.out.println("Images folder created: " + imagesFolder.getAbsolutePath());
            } else {
                System.err.println("Failed to create images folder!");
                return; // Exit the method if folder creation fails
            }
        }

        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insertSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {

            // Set the machine properties
            preparedStatement.setString(1, machine.getName());
            preparedStatement.setString(2, machine.getDetails());
            preparedStatement.setString(3, machine.getModel());
            preparedStatement.setString(4, machine.getDepartment());
            preparedStatement.executeUpdate();
            System.out.println("New machine inserted into the database");

            // Retrieve the ID based on the machine name
            String selectIdSQL = "SELECT id FROM machines WHERE name = ?";
            try (PreparedStatement selectStatement = connection.prepareStatement(selectIdSQL)) {
                selectStatement.setString(1, machine.getName());
                try (ResultSet resultSet = selectStatement.executeQuery()) {
                    if (resultSet.next()) {
                        String machineId = resultSet.getString("id");
                        String qrCodeURL = urlTemplate + machineId;
                        String qrFilePath = imagesFolderPath + machineId + ".png";

                        // Generate and save the QR code
                        QRCodeGenerator.generateQRCode(qrCodeURL, qrFilePath);
                        System.out.println("QR code generated and saved to: " + qrFilePath);

                        // Optionally, store the QR code URL in the database
                        String updateSQL = "UPDATE machines SET qr_code_url = ? WHERE id = ?";
                        try (PreparedStatement updateStatement = connection.prepareStatement(updateSQL)) {
                            updateStatement.setString(1, qrCodeURL);
                            updateStatement.setString(2, machineId);
                            updateStatement.executeUpdate();
                            System.out.println("QR code URL updated in the database");
                        }
                    } else {
                        System.out.println("Machine ID not found for machine name: " + machine.getName());
                    }
                }
            }

        } catch (SQLException | IOException | WriterException e) {
            e.printStackTrace();
        }
    }




    public void updateMachine(Machine machine) {
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement("UPDATE machines SET name = ?, details = ?, model = ?, department = ? WHERE id = ?")) {

            preparedStatement.setString(1, machine.getName());
            preparedStatement.setString(2, machine.getDetails());
            preparedStatement.setString(3, machine.getModel());
            preparedStatement.setString(4, machine.getDepartment());
            preparedStatement.setString(5, machine.getId());
            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Machine extractMachineFromResultSet(ResultSet resultSet) throws SQLException {
        Machine machine = new Machine();
        machine.setId(resultSet.getString("id"));
        machine.setName(resultSet.getString("name"));
        machine.setDetails(resultSet.getString("details"));
        machine.setModel(resultSet.getString("model"));
        machine.setDepartment(resultSet.getString("department"));
        return machine;
    }
    
    public String getMachineIdByName(String name) {
        LOGGER.info("getMachineIdByName called with name: " + name);
        String machineId = null;
        String query = "SELECT id FROM machines WHERE LOWER(name) = LOWER(?)";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setString(1, name);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    machineId = rs.getString("id");
                    LOGGER.info("Found machineId: " + machineId);
                } else {
                    LOGGER.info("No machine found with name: " + name);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("SQL Exception: " + e.getMessage());
            throw new RuntimeException(e);
        }
        
        return machineId;
    }
}
