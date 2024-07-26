<%@page import="dao.MachineDAO"%>
<%@page import="model.Machine"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Complaints</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }
        .container {
            max-width: 800px;
        }
        .back-button {
            margin-bottom: 20px;
        }
        .machine-details, .qr-code {
            margin-top: 20px;
            background-color: #fff;
            border: 1px solid #dee2e6;
            padding: 20px;
            border-radius: 5px;
        }
        .qr-code img {
            max-width: 100%;
        }
        .buttons {
            margin-top: 20px;
        }
        .btn-primary, .btn-secondary {
            margin-top: 10px;
            margin-right: 10px;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <a href="user_machine-list.jsp" class="btn btn-outline-primary back-button">Back</a>
    <div class="row">
        <div class="col-md-6 machine-details">
            <h3>Machine Details</h3>
            <%
                String machineId = request.getParameter("machineId");
                MachineDAO machineDAO = new MachineDAO();
                Machine machine = machineDAO.getMachine(machineId);
                if (machine != null) {
            %>
                <p><strong>ID:</strong> <%= machine.getId() %></p>
                <p><strong>Name:</strong> <%= machine.getName() %></p>
                <p><strong>Details:</strong> <%= machine.getDetails() %></p>
                <p><strong>Model:</strong> <%= machine.getModel() %></p>
                <p><strong>Department:</strong> <%= machine.getDepartment() %></p>
            <%
                } else {
                    out.println("<p>Machine not found.</p>");
                }
            %>
        </div>
        <div class="col-md-6 qr-code text-center">
            <h3>QR Code</h3>
            <%
                if (machine != null) {
            %>
                <img src="<%= request.getContextPath() %>/images/<%= machine.getId() %>.png" alt="QR Code for <%= machine.getId() %>">
            <%
                }
            %>
        </div>
    </div>
    <div class="row buttons text-center">
        <div class="col-md-12">
            <a href="addComplaint.jsp?machineId=<%= machineId %>" class="btn btn-primary">Add Complaint</a>
            <a href="viewStatus.jsp?machineId=<%= machineId %>" class="btn btn-secondary">View Complaint Status</a>
        </div>
    </div>
</div>

<script>
    window.addEventListener('load', function() {
        speakMachineDetails();
    });

    function speakMachineDetails() {
        var details = "";
        <%
            if (machine != null) {
        %>
            details += "Machine ID is <%= machine.getId() %>. ";
            details += "Machine Name is <%= machine.getName() %>. ";
            details += "Details are <%= machine.getDetails() %>. ";
            details += "Model is <%= machine.getModel() %>. ";
            details += "Department is <%= machine.getDepartment() %>. ";
        <%
            } else {
                out.println("details += 'Machine not found.';");
            }
        %>
        speak(details);
    }

    function speak(message) {
        const speech = new SpeechSynthesisUtterance();
        speech.text = message;
        window.speechSynthesis.speak(speech);
    }
</script>

</body>
</html>
