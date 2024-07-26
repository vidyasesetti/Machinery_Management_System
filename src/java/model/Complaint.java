package model;

import java.sql.Date;

public class Complaint {
    private int id;
    private String machineId;
    private String complaint;
    private String image;
    private String status;
    private Date datePosted;
    private String postedBy;
    private String assignedTo;
    private String feedback;
    private String complaintType;
    private Date dateClosed; // New field

    // Constructor with all fields
    public Complaint(int id, String machineId, String complaint, String image, String status, Date datePosted, String postedBy, String assignedTo, String feedback, String complaintType, Date dateClosed) {
        this.id = id;
        this.machineId = machineId;
        this.complaint = complaint;
        this.image = image;
        this.status = status;
        this.datePosted = datePosted;
        this.postedBy = postedBy;
        this.assignedTo = assignedTo;
        this.feedback = feedback;
        this.complaintType = complaintType;
        this.dateClosed = dateClosed; // Set the new field
    }

    // Default constructor
    public Complaint() {}

    // Getters and setters for all fields
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMachineId() {
        return machineId;
    }

    public void setMachineId(String machineId) {
        this.machineId = machineId;
    }

    public String getComplaint() {
        return complaint;
    }

    public void setComplaint(String complaint) {
        this.complaint = complaint;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getDatePosted() {
        return datePosted;
    }

    public void setDatePosted(Date datePosted) {
        this.datePosted = datePosted;
    }

    public String getPostedBy() {
        return postedBy;
    }

    public void setPostedBy(String postedBy) {
        this.postedBy = postedBy;
    }

    public String getAssignedTo() {
        return assignedTo;
    }

    public void setAssignedTo(String assignedTo) {
        this.assignedTo = assignedTo;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public String getComplaintType() {
        return complaintType;
    }

    public void setComplaintType(String complaintType) {
        this.complaintType = complaintType;
    }

    public Date getDateClosed() { // Getter for dateClosed
        return dateClosed;
    }

    public void setDateClosed(Date dateClosed) { // Setter for dateClosed
        this.dateClosed = dateClosed;
    }
}
