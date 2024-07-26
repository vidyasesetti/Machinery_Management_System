package dao;

import model.Complaint;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;

public class ComplaintDAO {

    public void insertComplaint(Complaint complaint) {
        String insertSQL = "INSERT INTO complaints (machine_id, complaint, image, status, date_posted, posted_by, assigned_to, feedback, complaint_type, date_closed) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection connection = Database.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insertSQL)) {
            preparedStatement.setString(1, complaint.getMachineId());
            preparedStatement.setString(2, complaint.getComplaint());
            preparedStatement.setString(3, complaint.getImage());
            preparedStatement.setString(4, complaint.getStatus());
            preparedStatement.setDate(5, complaint.getDatePosted());
            preparedStatement.setString(6, complaint.getPostedBy());
            preparedStatement.setString(7, complaint.getAssignedTo());
            preparedStatement.setString(8, complaint.getFeedback());
            preparedStatement.setString(9, complaint.getComplaintType());
            preparedStatement.setDate(10, complaint.getDateClosed());

            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Complaint> getComplaintsByMachineIdAndUser(String machineId, String postedBy) {
        List<Complaint> complaints = new ArrayList<>();
        String query = "SELECT * FROM complaints WHERE machine_id = ? AND posted_by = ?";
        try (Connection connection = Database.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, machineId);
            preparedStatement.setString(2, postedBy);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                Complaint complaint = mapResultSetToComplaint(resultSet);
                complaints.add(complaint);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }

    public Complaint getComplaint(String complaintId) {
        String SELECT_COMPLAINT_BY_ID = "SELECT * FROM complaints WHERE id = ?";
        try (Connection connection = Database.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_COMPLAINT_BY_ID)) {
            preparedStatement.setString(1, complaintId);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return mapResultSetToComplaint(resultSet);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Complaint> getComplaintsByMachineId(String machineId) {
        List<Complaint> complaints = new ArrayList<>();
        String query = "SELECT * FROM complaints WHERE machine_id = ?";
        try (Connection connection = Database.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, machineId);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                Complaint complaint = mapResultSetToComplaint(resultSet);
                complaints.add(complaint);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }

    public void updateComplaint(Complaint complaint) {
        String updateSQL = "UPDATE complaints SET assigned_to = ? WHERE id = ?";
        try (Connection connection = Database.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(updateSQL)) {
            preparedStatement.setString(1, complaint.getAssignedTo());
            preparedStatement.setInt(2, complaint.getId());
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean updateStatus(String complaintId, String status) {
        String sql = "UPDATE complaints SET status = ?, date_closed = ? WHERE id = ?";
        try (Connection connection = Database.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, status);
            preparedStatement.setDate(2, new Date(System.currentTimeMillis())); // Set date_closed to current date
            preparedStatement.setString(3, complaintId);
            int rowsUpdated = preparedStatement.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Complaint mapResultSetToComplaint(ResultSet resultSet) throws SQLException {
        int id = resultSet.getInt("id");
        String machineId = resultSet.getString("machine_id");
        String complaintText = resultSet.getString("complaint");
        String image = resultSet.getString("image");
        String status = resultSet.getString("status");
        Date datePosted = resultSet.getDate("date_posted");
        String postedBy = resultSet.getString("posted_by");
        String assignedTo = resultSet.getString("assigned_to");
        String feedback = resultSet.getString("feedback");
        String complaintType = resultSet.getString("complaint_type");
        Date dateClosed = resultSet.getDate("date_closed");

        // Handle potential null date values
        datePosted = (datePosted != null) ? datePosted : null;
    dateClosed = (dateClosed != null) ? dateClosed : null;

        return new Complaint(id, machineId, complaintText, image, status, datePosted, postedBy, assignedTo, feedback, complaintType, dateClosed);
    }
    
    
    public List<Complaint> getComplaintsByEngineerId(String engineerId) {
    List<Complaint> complaints = new ArrayList<>();
    String query = "SELECT * FROM complaints WHERE assigned_to = ?";
    try (Connection connection = Database.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(query)) {
        preparedStatement.setString(1, engineerId);
        ResultSet resultSet = preparedStatement.executeQuery();
        while (resultSet.next()) {
            int id = resultSet.getInt("id");
            String machineIdDb = resultSet.getString("machine_id");
            String complaintText = resultSet.getString("complaint");
            String image = resultSet.getString("image");
            String status = resultSet.getString("status");
            Date datePosted = resultSet.getDate("date_posted");
            String postedBy = resultSet.getString("posted_by");
            String assignedTo = resultSet.getString("assigned_to");
            String feedback = resultSet.getString("feedback");
            String complaintType = resultSet.getString("complaint_type");
            Date dateClosed = resultSet.getDate("date_closed");

            Complaint complaint = new Complaint(id, machineIdDb, complaintText, image, status, datePosted, postedBy, assignedTo, feedback, complaintType, dateClosed);
            complaints.add(complaint);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return complaints;
}

    
    public void updateFeedback(String complaintId, String feedback) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = Database.getConnection();
            String query = "UPDATE complaints SET feedback = ? WHERE id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, feedback);
            pstmt.setString(2, complaintId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
