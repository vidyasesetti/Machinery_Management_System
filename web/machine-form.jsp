<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Machine Form</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h1 class="mb-4">${machine == null ? "Add" : "Edit"} Machine</h1>
    <form action="MachineServlet" method="post">
        <input type="hidden" name="id" value="${machine != null ? machine.id : ''}">
        <input type="hidden" name="action" value="${machine == null ? 'insert' : 'edit'}">
        <div class="form-group">
            <label for="name">Name</label>
            <input type="text" class="form-control" id="name" name="name" value="${machine != null ? machine.name : ''}" required>
        </div>
        <div class="form-group">
            <label for="details">Details</label>
            <input type="text" class="form-control" id="details" name="details" value="${machine != null ? machine.details : ''}" required>
        </div>
        <div class="form-group">
            <label for="model">Model</label>
            <input type="text" class="form-control" id="model" name="model" value="${machine != null ? machine.model : ''}" required>
        </div>
        <div class="form-group">
            <label for="department">Department</label>
            <select class="form-control" id="department" name="department" required>
                <option value="">Select Department</option>
                <option value="Raw Material Handling Department" ${machine != null && machine.department == 'Raw Material Handling Department' ? 'selected' : ''}>Raw Material Handling Department</option>
                <option value="Coke Oven and By-Product Plant" ${machine != null && machine.department == 'Coke Oven and By-Product Plant' ? 'selected' : ''}>Coke Oven and By-Product Plant</option>
                <option value="Sinter Plant" ${machine != null && machine.department == 'Sinter Plant' ? 'selected' : ''}>Sinter Plant</option>
                <option value="Blast Furnace Department" ${machine != null && machine.department == 'Blast Furnace Department' ? 'selected' : ''}>Blast Furnace Department</option>
                <option value="Steel Melting Shop (SMS)" ${machine != null && machine.department == 'Steel Melting Shop (SMS)' ? 'selected' : ''}>Steel Melting Shop (SMS)</option>
                <option value="Continuous Casting Department" ${machine != null && machine.department == 'Continuous Casting Department' ? 'selected' : ''}>Continuous Casting Department</option>
                <option value="Hot Rolling Mill" ${machine != null && machine.department == 'Hot Rolling Mill' ? 'selected' : ''}>Hot Rolling Mill</option>
                <option value="Cold Rolling Mill" ${machine != null && machine.department == 'Cold Rolling Mill' ? 'selected' : ''}>Cold Rolling Mill</option>
                <option value="Galvanizing and Coating Department" ${machine != null && machine.department == 'Galvanizing and Coating Department' ? 'selected' : ''}>Galvanizing and Coating Department</option>
                <option value="Quality Control and Testing Department" ${machine != null && machine.department == 'Quality Control and Testing Department' ? 'selected' : ''}>Quality Control and Testing Department</option>
                <option value="Maintenance and Utilities Department" ${machine != null && machine.department == 'Maintenance and Utilities Department' ? 'selected' : ''}>Maintenance and Utilities Department</option>
                <option value="Logistics and Dispatch Department" ${machine != null && machine.department == 'Logistics and Dispatch Department' ? 'selected' : ''}>Logistics and Dispatch Department</option>
                <option value="Research and Development (R&D) Department" ${machine != null && machine.department == 'Research and Development (R&D) Department' ? 'selected' : ''}>Research and Development (R&D) Department</option>
                <option value="Safety and Environmental Management Department" ${machine != null && machine.department == 'Safety and Environmental Management Department' ? 'selected' : ''}>Safety and Environmental Management Department</option>
                <option value="Human Resources and Administration Department" ${machine != null && machine.department == 'Human Resources and Administration Department' ? 'selected' : ''}>Human Resources and Administration Department</option>
                <option value="Finance and Accounts Department" ${machine != null && machine.department == 'Finance and Accounts Department' ? 'selected' : ''}>Finance and Accounts Department</option>
                <option value="Information Technology (IT) Department" ${machine != null && machine.department == 'Information Technology (IT) Department' ? 'selected' : ''}>Information Technology (IT) Department</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">${machine == null ? "Add" : "Update"} Machine</button>
    </form>
</div>
</body>
</html>
