/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package login;

import static dao.Database.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author lenovo
 */
public class login {

    
    private String user_pwd;
    private String user_name;
    private String role;

    public login(String user_name, String user_pwd, String role) {
        this.user_name = user_name;
        this.user_pwd = user_pwd;
        this.role = role;
    }

    public boolean login_validate() {
        Connection conn = null;
        boolean login_success = false;
        String tableName = "";
        try {
            
            switch (role) {
                case "admin":
                    tableName = "admin_login_table";
                    break;
                case "engineer":
                    tableName = "engineer_login_table";
                    break;
                case "user":
                    tableName = "login_table"; // Assuming there is a user_login_table
                    break;
                default:
                    throw new IllegalArgumentException("Invalid role");
            }
            conn = getConnection();
            if(role.equals("engineer")){
                PreparedStatement ps = conn.prepareStatement("select * from " + tableName + " where id=? and user_pwd=?");
                ps.setString(1, this.user_name);
                ps.setString(2, this.user_pwd);
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    this.user_name = user_name;
                    login_success = true;
                }
            }
            else{
                PreparedStatement ps = conn.prepareStatement("select * from " + tableName + " where user_name=? and user_pwd=?");
                ps.setString(1, this.user_name);
                ps.setString(2, this.user_pwd);
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    this.user_name = user_name;
                    login_success = true;
                }
            }
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            close(conn);
            return login_success;
        }
    }

    public String getName() {
        return this.user_name;
    }

    public static void main(String args[]) {
        login login_obj = null;
        boolean login_indicator = false;
        String user_name = "";
        try {
            login_obj = new login("admin", "adminpwd","admin");

            login_indicator = login_obj.login_validate();
            if (login_indicator == true) {
                user_name = login_obj.getName();
                System.out.println("hello User " + user_name);
            } else {
                System.out.println("===login failed====");
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            login_obj = null;
        }

    }
}