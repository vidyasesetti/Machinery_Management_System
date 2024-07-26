<%@page import="login.login"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Machine Management</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <style>
        .header-buttons {
            display: flex;
            justify-content: flex-end;
            margin-top: 20px;
        }
        .header-buttons a {
            margin-left: 10px;
        }
        .voice-search {
            margin-bottom: 20px;
            text-align: center;
        }
        .voice-search input {
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="voice-search">
        <input type="text" id="voiceSearchInput" class="form-control" placeholder="Say machine name..." readonly>
        <button id="voiceSearchBtn" class="btn btn-primary mt-2">Start Voice Search</button>
    </div>
    <div id="usernameGreeting"></div> <!-- This div will contain the greeting message -->
    <h1 class="mb-4">Machine Table</h1>
    <div class="header-buttons">
        <a href="LogoutServlet" class="btn btn-danger">Logout</a>
    </div>
    <div class="table-responsive mt-3">
        <table class="table table-bordered table-striped table-hover">
            <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Details</th>
                    <th>Model</th>
                    <th>Department</th>
                    <th>QR Code</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="machineTableBody">
                <!-- Data will be populated by jQuery -->
            </tbody>
        </table>
    </div>
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
                        '<td><img src="<%= request.getContextPath() %>/images/' + machine.id + '.png" alt="QR Code for ' + machine.id + '" class="img-fluid"></td>' +
                        '<td>' +
                            '<a href="MachineServlet?action=manageComplaints&id=' + machine.id + '" class="btn btn-info btn-sm">Manage Complaints</a>' +
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
                    speak('Machine found');
                    redirectToMachine(data.id);
                } else {
                    speak('Machine not found');
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
        const targetUrl = 'MachineServlet?action=manageComplaints&id=' + machineId;
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
