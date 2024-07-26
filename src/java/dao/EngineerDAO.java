package dao;

import model.Engineer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EngineerDAO {

    public List<Engineer> getAllEngineers() {
        List<Engineer> engineers = new ArrayList<>();
        String query = "SELECT * FROM engineer_login_table";
        try (Connection connection = Database.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                String id = resultSet.getString("id");
                String username = resultSet.getString("user_name");
                String password = resultSet.getString("user_pwd");
                String specialization = resultSet.getString("specialization");

                Engineer engineer = new Engineer(id, username, password, specialization);
                engineers.add(engineer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return engineers;
    }
}
