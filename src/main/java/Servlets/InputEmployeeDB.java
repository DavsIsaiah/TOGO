/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.FileItem;
import java.sql.*;
import java.io.*;
import java.util.*;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Isaiah Dava
 */
public class InputEmployeeDB extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet InputEmployeeDB</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet InputEmployeeDB at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //Strings for sql statement    
        String id = null, name = null, department = null, title = null, dob = null, age = null, dh = null, gender = null, email = null, contact = null, address = null, status = null, picture = null, rate = null, accStatus = null;

        Connection con = null;
        PreparedStatement stmt = null;
        try {
            Class.forName("org.sqlite.JDBC");
            con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");
            System.out.println(con != null);

            List<FileItem> multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
            String inputName = null;
            for (FileItem item : multiparts) { //Getting information from the form.
                if (!item.isFormField()) {   // Check regular field.
                    //Write file into server files.
                    item.write(new File("C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\" + item.getName()));
                    //Write name of file into string.
                    picture = item.getName();
                }
                if (item.isFormField()) {  // Check regular field.
                    inputName = (String) item.getFieldName();
                    System.out.println(inputName);
                    if (inputName.equalsIgnoreCase("id")) {
                        id = (String) item.getString();
                        System.out.println(id);
                    }
                    if (inputName.equalsIgnoreCase("name")) {
                        name = (String) item.getString();
                        System.out.println(name);
                    }
                    if (inputName.equalsIgnoreCase("department")) {
                        department = (String) item.getString();
                        System.out.println(department);
                    }
                    if (inputName.equalsIgnoreCase("job_title")) {
                        title = (String) item.getString();
                        System.out.println(title);
                    }
                    if (inputName.equalsIgnoreCase("dob")) {
                        dob = (String) item.getString();
                        System.out.println(dob);
                    }
                    if (inputName.equalsIgnoreCase("dh")) {
                        dh = (String) item.getString();
                        System.out.println(dh);
                    }
                    if (inputName.equalsIgnoreCase("gender")) {
                        gender = (String) item.getString();
                        System.out.println(gender);
                    }
                    if (inputName.equalsIgnoreCase("gender2")) {
                        accStatus = (String) item.getString();
                        System.out.println(accStatus);
                    }
                    if (inputName.equalsIgnoreCase("email_add")) {
                        email = (String) item.getString();
                        System.out.println(email);
                    }
                    if (inputName.equalsIgnoreCase("contact_num")) {
                        contact = (String) item.getString();
                    }
                    if (inputName.equalsIgnoreCase("address")) {
                        address = (String) item.getString();
                    }
                    if (inputName.equalsIgnoreCase("status")) {
                        status = (String) item.getString();
                    }
                    if (inputName.equalsIgnoreCase("occurred")) {
                        age = (String) item.getString();
                        System.out.println(age);
                    }
                    if (inputName.equalsIgnoreCase("money")) {
                        rate = (String) item.getString();
                        System.out.println(age);
                    }
                }
            }

            //SQL Query for inserting values
            String sql = "INSERT INTO Emp_Info(name,department,ID,title,dob,hire_date,age,gender,email,contact_no,address,picture,status,rate) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, department);
            stmt.setString(3, id);
            stmt.setString(4, title);
            stmt.setString(5, dob);
            stmt.setString(6, dh);
            stmt.setString(7, age);
            stmt.setString(8, gender);
            stmt.setString(9, email);
            stmt.setString(10, contact);
            stmt.setString(11, address);
            stmt.setString(12, picture);
            stmt.setString(13, status);
            stmt.setString(14, rate);
            stmt.executeUpdate();

            String sql2 = "INSERT INTO Credentials(username,password,picture,position,ID) values (?,?,?,?,?);";
            stmt = con.prepareStatement(sql2);
            stmt.setString(1, id);
            stmt.setString(2, "changeme");
            stmt.setString(3, picture);
            stmt.setString(4, accStatus);
            stmt.setString(5, id);
            stmt.executeUpdate();

        } catch (SQLException se) {
            System.out.println("SQL Exception" + se.getMessage());
            try (PrintWriter out = response.getWriter()) {
                /* TODO output your page here. You may use following sample code. */
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Invalid Input!');");
                out.println("location='New_Employee.jsp';");
                out.println("</script>");
            }
            response.sendRedirect("New_Employee.jsp");
        } catch (Exception e) {
            //System.out.println("Exception:" + e.getMessage());
            try (PrintWriter out = response.getWriter()) {
                /* TODO output your page here. You may use following sample code. */
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Missing Input! Add a picture by clicking on the image!');");
                out.println("location='New_Employee.jsp';");
                out.println("</script>");
            }
            response.sendRedirect("New_Employee.jsp");
        } finally {
            try {
                if (con != null) {
                    con.close();
                }
                try (PrintWriter out = response.getWriter()) {
                    /* TODO output your page here. You may use following sample code. */
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Employee Added\\n\\\n"
                            + "Username is the Employee ID.\\n\\\n"
                            + "Password is \\\"changeme\\\"');");
                    out.println("location='Employee_Overview.jsp';");
                    out.println("</script>");
                }
                response.sendRedirect("Employee_Overview.jsp");
            } catch (SQLException se) {
                System.out.println("SQL Exception" + se.getMessage());
                try (PrintWriter out = response.getWriter()) {
                    /* TODO output your page here. You may use following sample code. */
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Invalid Input!');");
                    out.println("location='New_Employee.jsp';");
                    out.println("</script>");
                }
                response.sendRedirect("New_Employee.jsp");

            }
        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
