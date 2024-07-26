<%-- 
    Document   : login
    Created on : 4 Jun, 2024, 8:31:56 PM
    Author     : Ramya Rahul
--%>

<%@page import="login.login"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<%
    boolean login_indicator = false;
    String user = request.getParameter("user");
    String id = request.getParameter("id");
    String pswd = request.getParameter("pswd");
    String role = request.getParameter("role"); 
    
    login login_object;
    if("engineer".equals(role)){
        login_object = new login(id, pswd, role);
    }
    else{
        login_object = new login(user, pswd, role);
    }
    login_indicator = login_object.login_validate();
    if (login_indicator) {
        // Redirect to the appropriate page based on the role with the username as a query parameter
        String username = login_object.getName();
        session.setAttribute("username", username);
        String redirectURL = "";
        
        if ("admin".equals(role)) {
            redirectURL = "admin_dashboard.jsp?username=" + username;
        } else if ("user".equals(role)) {
            redirectURL = "user_machine-list.jsp?username=" + username;
        } else if ("engineer".equals(role)) {
            redirectURL = "EngineerComplaintsServlet?username=" + username;
        }
%>
        <script>
            window.location.href = "<%= redirectURL %>";
        </script>
<%
    } else {
        out.println("Login failed. Invalid username or password.");
    }
%>
