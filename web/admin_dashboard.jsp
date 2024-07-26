<%@ page import="dao.Database" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = request.getParameter("username");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

        .home-button {
            position: absolute;
            top: 10px;
            left: 10px;
        }

        .graph-container {
            border: 1px solid #ced4da;
            border-radius: 10px;
            padding: 20px;
            background-color: #fff;
            margin-bottom: 20px;
            height: 400px; /* Adjust the height */
        }

        .graph-container canvas {
            max-height: 300px; /* Adjust the height of the chart */
        }

        h3 {
            font-size: 1.2rem; /* Reduce font size of headers */
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
    <div class="voice-search-container">
        <input type="text" id="voiceSearchInput" class="form-control" placeholder="Speak the machine name">
        <button id="voiceSearchBtn" class="btn btn-primary">Search</button>
    </div>
</div>

<div class="main-content">
    <h2>Welcome to the Admin Dashboard</h2>
    <div class="row">
        <div class="col-md-6">
            <div class="graph-container">
                <h3>Complaints by Department</h3>
                <canvas id="complaintsPieChart"></canvas>
            </div>
        </div>
        <div class="col-md-6">
            <div class="graph-container">
                <h3>Complaints by Type</h3>
                <canvas id="complaintsTypePieChart"></canvas>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6">
            <div class="graph-container">
                <h3>Complaints by Engineer</h3>
                <canvas id="complaintsBarChart"></canvas>
            </div>
        </div>
        <div class="col-md-6">
            <div class="graph-container">
                <h3>Complaints Status</h3>
                <canvas id="complaintsStatusChart"></canvas>
            </div>
        </div>
    </div>
</div>

<%
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    Map<String, Integer> complaintCounts = new HashMap<String, Integer>();
    Map<String, Integer> complaintTypeCounts = new HashMap<String, Integer>();
    Map<String, Integer> engineerComplaintCounts = new HashMap<String, Integer>();
    int completedCount = 0;
    int notCompletedCount = 0;

    try {
        conn = Database.getConnection();
        
        // Query for complaints by department
        String sql = "SELECT department, COUNT(*) AS count FROM machines GROUP BY department";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();
        
        while (rs.next()) {
            complaintCounts.put(rs.getString("department"), rs.getInt("count"));
        }

        // Query for complaints by type
        sql = "SELECT complaint_type, COUNT(*) AS count FROM complaints GROUP BY complaint_type";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();
        
        while (rs.next()) {
            complaintTypeCounts.put(rs.getString("complaint_type"), rs.getInt("count"));
        }

        // Query for complaints by engineer
        sql = "SELECT el.user_name, COUNT(c.id) AS count " +
              "FROM complaints c " +
              "JOIN engineer_login_table el ON c.assigned_to = el.id " +
              "GROUP BY el.user_name";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();
        
        while (rs.next()) {
            engineerComplaintCounts.put(rs.getString("user_name"), rs.getInt("count"));
        }
        
        // Query for completed and not completed complaints
        sql = "SELECT COUNT(*) AS completed FROM complaints WHERE status = 'Completed'";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();
        
        if (rs.next()) {
            completedCount = rs.getInt("completed");
        }
        
        sql = "SELECT COUNT(*) AS notCompleted FROM complaints WHERE status = 'Not Completed'";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();
        
        if (rs.next()) {
            notCompletedCount = rs.getInt("notCompleted");
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }

    StringBuilder jsonLabels = new StringBuilder("[");
    StringBuilder jsonData = new StringBuilder("[");
    StringBuilder jsonTypeLabels = new StringBuilder("[");
    StringBuilder jsonTypeData = new StringBuilder("[");
    StringBuilder jsonEngineerLabels = new StringBuilder("[");
    StringBuilder jsonEngineerData = new StringBuilder("[");
    StringBuilder jsonStatusLabels = new StringBuilder("[");
    StringBuilder jsonStatusData = new StringBuilder("[");

    for (Map.Entry<String, Integer> entry : complaintCounts.entrySet()) {
        jsonLabels.append("\"").append(entry.getKey()).append("\"").append(",");
        jsonData.append(entry.getValue()).append(",");
    }

    for (Map.Entry<String, Integer> entry : complaintTypeCounts.entrySet()) {
        jsonTypeLabels.append("\"").append(entry.getKey()).append("\"").append(",");
        jsonTypeData.append(entry.getValue()).append(",");
    }

    for (Map.Entry<String, Integer> entry : engineerComplaintCounts.entrySet()) {
        jsonEngineerLabels.append("\"").append(entry.getKey()).append("\"").append(",");
        jsonEngineerData.append(entry.getValue()).append(",");
    }
    
    // Adding data for completed and not completed complaints
    jsonStatusLabels.append("\"Completed\", \"Not Completed\"");
    jsonStatusData.append(completedCount).append(",").append(notCompletedCount);

    if (jsonLabels.length() > 1) jsonLabels.setLength(jsonLabels.length() - 1); // Remove trailing comma
    if (jsonData.length() > 1) jsonData.setLength(jsonData.length() - 1); // Remove trailing comma
    if (jsonTypeLabels.length() > 1) jsonTypeLabels.setLength(jsonTypeLabels.length() - 1); // Remove trailing comma
    if (jsonTypeData.length() > 1) jsonTypeData.setLength(jsonTypeData.length() - 1); // Remove trailing comma
    if (jsonEngineerLabels.length() > 1) jsonEngineerLabels.setLength(jsonEngineerLabels.length() - 1); // Remove trailing comma
    if (jsonEngineerData.length() > 1) jsonEngineerData.setLength(jsonEngineerData.length() - 1); // Remove trailing comma

    jsonLabels.append("]");
    jsonData.append("]");
    jsonTypeLabels.append("]");
    jsonTypeData.append("]");
    jsonEngineerLabels.append("]");
    jsonEngineerData.append("]");
    jsonStatusLabels.append("]");
    jsonStatusData.append("]");
%>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        var ctx = document.getElementById('complaintsPieChart').getContext('2d');
        var labels = <%= jsonLabels.toString() %>;
        var data = <%= jsonData.toString() %>;

        new Chart(ctx, {
            type: 'pie',
            data: {
                labels: labels,
                datasets: [{
                    data: data,
                    backgroundColor: [
                        '#FF6384',
                        '#36A2EB',
                        '#FFCE56',
                        '#4BC0C0',
                        '#9966FF',
                        '#FF9F40',
                        '#FF6384',
                        '#36A2EB',
                        '#FFCE56',
                        '#4BC0C0',
                        '#9966FF',
                        '#FF9F40',
                        '#FF6384',
                        '#36A2EB',
                        '#FFCE56',
                        '#4BC0C0',
                        '#9966FF'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false, // Maintain aspect ratio to fit container
                plugins: {
                    legend: {
                        position: 'bottom', // Adjusted legend position
                        labels: {
                            boxWidth: 10, // Adjusted legend box width
                            font: {
                                size: 10 // Adjusted legend font size
                            }
                        }
                    }
                }
            }
        });

        // Second Pie Chart
        var ctxType = document.getElementById('complaintsTypePieChart').getContext('2d');
        var typeLabels = <%= jsonTypeLabels.toString() %>;
        var typeData = <%= jsonTypeData.toString() %>;

        new Chart(ctxType, {
            type: 'pie',
            data: {
                labels: typeLabels,
                datasets: [{
                    data: typeData,
                    backgroundColor: [
                        '#FF6384',
                        '#36A2EB',
                        '#FFCE56',
                        '#4BC0C0',
                        '#9966FF',
                        '#FF9F40',
                        '#FF6384',
                        '#36A2EB',
                        '#FFCE56',
                        '#4BC0C0',
                        '#9966FF',
                        '#FF9F40',
                        '#FF6384',
                        '#36A2EB',
                        '#FFCE56',
                        '#4BC0C0',
                        '#9966FF'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false, // Maintain aspect ratio to fit container
                plugins: {
                    legend: {
                        position: 'bottom', // Adjusted legend position
                        labels: {
                            boxWidth: 10, // Adjusted legend box width
                            font: {
                                size: 10 // Adjusted legend font size
                            }
                        }
                    }
                }
            }
        });

        // Bar Chart for Complaints by Engineer
        var ctxEngineer = document.getElementById('complaintsBarChart').getContext('2d');
        var engineerLabels = <%= jsonEngineerLabels.toString() %>;
        var engineerData = <%= jsonEngineerData.toString() %>;

        new Chart(ctxEngineer, {
            type: 'bar',
            data: {
                labels: engineerLabels,
                datasets: [{
                    label: 'Number of Complaints',
                    data: engineerData,
                    backgroundColor: '#36A2EB'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false, // Maintain aspect ratio to fit container
                plugins: {
                    legend: {
                        position: 'bottom', // Adjusted legend position
                        labels: {
                            boxWidth: 10, // Adjusted legend box width
                            font: {
                                size: 10 // Adjusted legend font size
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        // Stacked Bar Chart for Complaints Status
var ctxStatus = document.getElementById('complaintsStatusChart').getContext('2d');
var statusLabels = <%= jsonStatusLabels.toString() %>;
var statusData = <%= jsonStatusData.toString() %>;

new Chart(ctxStatus, {
    type: 'bar',
    data: {
        labels: ['Completed', 'Not Completed'],
        datasets: [{
            label: 'Completed',
            data: [statusData[0], 0],
            backgroundColor: '#36A2EB'
        }, {
            label: 'Not Completed',
            data: [0, statusData[1]],
            backgroundColor: '#FF6384'
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false, // Maintain aspect ratio to fit container
        plugins: {
            legend: {
                position: 'bottom', // Adjusted legend position
                labels: {
                    boxWidth: 10, // Adjusted legend box width
                    font: {
                        size: 10 // Adjusted legend font size
                    }
                }
            }
        },
        scales: {
            x: {
                stacked: true
            },
            y: {
                stacked: true
            }
        }
    }
});

    });
    
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
