package model;

public class Engineer {
    private String id;
    private String username;
    private String password;
    private String specialization;

    public Engineer(String id, String username, String password, String specialization) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.specialization = specialization;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }
}
