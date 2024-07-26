package model;

public class Machine {
    private String id;
    private String name;
    private String details;
    private String model;
    private String department;

    public Machine() {
    }

    public Machine(String id, String name, String details, String model, String department) {
        this.id = id;
        this.name = name;
        this.details = details;
        this.model = model;
        this.department = department;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    @Override
    public String toString() {
        return "Machine{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", details='" + details + '\'' +
                ", model='" + model + '\'' +
                ", department='" + department + '\'' +
                '}';
    }
}
