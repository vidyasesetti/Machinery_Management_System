<%@page import="login.login"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String username = request.getParameter("username");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Machine Management</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            background-color: #f8f9fa;
        }

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            width: 250px;
            background-color: #343a40;
            padding-top: 70px;
        }

        .nav-link {
            color: #fff;
        }

        .nav-link:hover {
            color: #f8f9fa !important;
            background-color: #343a40;
        }

        .main-content {
            margin-left: 250px;
            padding: 20px;
        }

        .header-buttons {
            display: flex;
            justify-content: flex-end;
            margin-top: 20px;
        }

        .header-buttons a {
            margin-left: 10px;
        }

        .home-button {
            position: absolute;
            top: 10px;
            left: 10px;
        }

        .table thead th {
            background-color: #343a40;
            color: #fff;
            border-color: #dee2e6;
        }

        .table tbody tr:hover {
            background-color: #f8f9fa;
            cursor: pointer;
        }

        .table tbody td, .table tbody th {
            vertical-align: middle;
        }

        .table tbody tr:hover td {
            color: #343a40;
        }

        .btn {
            padding: 0.375rem 0.75rem;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
<a href="index.html" class="btn btn-outline-primary home-button">Home</a>

<div class="sidebar">
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link" href="index.html">Home</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="admin_dashboard.jsp?username=<%= username %>">Dashboard</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="admin_machine-list.jsp?username=<%= username %>">Machine List</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="engineer_sign_up.jsp">Sign Up Engineers</a>
        </li>
        <li class="nav-item">
            <form action="LogoutServlet" method="post" id="logoutForm">
                <input type="hidden" name="logout" value="true">
                <a class="nav-link" href="#" onclick="document.getElementById('logoutForm').submit();">Logout</a>
            </form>
        </li>
    </ul>
</div>

<div class="main-content">
    <div id="usernameGreeting"></div> <!-- This div will contain the greeting message -->
    <div class="voice-search-container">
        <input type="text" id="voiceSearchInput" class="form-control" placeholder="Speack the Machine name">
        <button id="voiceSearchBtn" class="btn btn-primary">Search</button>
    </div>
    <h1 class="mb-4">Machine Table</h1>
    <div class="header-buttons">
        <a href="MachineServlet?action=new" class="btn btn-primary">+ Add Machine</a>
        <a href="LogoutServlet" class="btn btn-danger">Logout</a>
    </div>
    <table class="table table-bordered mt-3">
        <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Details</th>
            <th>Model</th>
            <th>Department</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody id="machineTableBody">
        <!-- Data will be populated by jQuery -->
        </tbody>
    </table>
</div>

<script>
    $(document).ready(function() {
        $.ajax({
            url: 'MachineServlet',
            type: 'GET',
            data: { action: 'list' },
            dataType: 'json',
            success: function(data) {
                var tableBody = $('#machineTableBody');
                tableBody.empty(); // Clear existing rows

                data.forEach(function(machine) {
                    var row = '<tr>' +
                        '<td>' + machine.id + '</td>' +
                        '<td>' + machine.name + '</td>' +
                        '<td>' + machine.details + '</td>' +
                        '<td>' + machine.model + '</td>' +
                        '<td>' + machine.department + '</td>' +
                        '<td>' +
                        '<a href="MachineServlet?action=edit&id=' + machine.id + '" class="btn btn-warning btn-sm">Edit</a> ' +
                        '<a href="MachineServlet?action=delete&id=' + machine.id + '" class="btn btn-danger btn-sm">Delete</a> ' +
                        '<a href="MachineComplaintsServlet?id=' + machine.id + '" class="btn btn-info btn-sm">View Complaints</a>' +
                        '</td>' +
                        '</tr>';
                    tableBody.append(row);
                });
            },
            error: function(xhr, status, error) {
                console.error('Error: ' + error);
                console.error('Status: ' + status);
                console.dir(xhr);
                alert('Failed to fetch machines');
            }
        });
    });

    // Extracting the username from the URL query parameters
    var urlParams = new URLSearchParams(window.location.search);
    var username = urlParams.get('username');

    // Displaying the greeting message
    if (username) {
        document.getElementById('usernameGreeting').innerHTML = '<h2>Hello ' + username + '</h2>';
    }
    
    
    // Voice Search Feature
    const voiceSearchInput = document.getElementById('voiceSearchInput');
    const voiceSearchBtn = document.getElementById('voiceSearchBtn');

    if ('webkitSpeechRecognition' in window) {
        const recognition = new webkitSpeechRecognition();
        recognition.continuous = false;
        recognition.interimResults = false;
        recognition.lang = 'en-US';

        recognition.onstart = function() {
            voiceSearchInput.value = 'Listening...';
        };

        recognition.onresult = function(event) {
            const transcript = event.results[0][0].transcript.trim().toLowerCase();
            voiceSearchInput.value = transcript;
            if (transcript === 'logout') {
                speak("Logging Out");
                window.location.href = 'LogoutServlet';
            } else {
                fetchMachineIdByName(transcript);
            }
        };

        recognition.onerror = function(event) {
            console.error('Speech recognition error:', event.error);
            voiceSearchInput.value = 'Error occurred';
        };

        recognition.onend = function() {
            if (voiceSearchInput.value === 'Listening...') {
                voiceSearchInput.value = '';
            }
        };

        voiceSearchBtn.onclick = function() {
            recognition.start();
        };
    } else {
        console.error('Speech recognition not supported');
        voiceSearchBtn.disabled = true;
    }

    function fetchMachineIdByName(machineName) {
        $.ajax({
            url: 'MachineServlet',
            type: 'GET',
            data: { action: 'getMachineIdByName', name: machineName },
            dataType: 'json',
            success: function(data) {
                if (data.id !== "null") {
                    speak("Machine Found");
                    redirectToMachine(data.id);
                } else {
                    speak("Machine not Found");
                    alert('Machine not found');
                }
            },
            error: function(xhr, status, error) {
                console.error('Error: ' + error);
                console.error('Status: ' + status);
                console.dir(xhr);
                alert('Failed to fetch machine ID');
            }
        });
    }

    function redirectToMachine(machineId) {
        console.log('Recognized Machine ID:', machineId);
        const targetUrl = 'MachineComplaintsServlet?id=' + machineId;
        console.log('Redirecting to:', targetUrl);
        window.location.href = targetUrl;
    }
    
    function speak(message) {
        const speech = new SpeechSynthesisUtterance();
        speech.text = message;
        window.speechSynthesis.speak(speech);
    }
    
</script>

</body>
</html>
