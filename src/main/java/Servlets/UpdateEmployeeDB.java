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
public class UpdateEmployeeDB extends HttpServlet {

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
            out.println("<title>Servlet UpdateEmployeeDB</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateEmployeeDB at " + request.getContextPath() + "</h1>");
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
        String picture = null;
        String newID = null, oldID = null, newDept = null, newTitle = null, email = null, contact = null, address = null, status = null, rate = null;

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

                    if (inputName.equalsIgnoreCase("old_id")) {
                        oldID = (String) item.getString();
                        System.out.println(oldID);
                    }
                    if (inputName.equalsIgnoreCase("staff_id")) {
                        newID = (String) item.getString();
                        System.out.println(newID);
                    }
                    if (inputName.equalsIgnoreCase("department")) {
                        newDept = (String) item.getString();
                        System.out.println(newDept);
                    }
                    if (inputName.equalsIgnoreCase("job_title")) {
                        newTitle = (String) item.getString();
                        System.out.println(newTitle);
                    }
                    if (inputName.equalsIgnoreCase("email_add")) {
                        email = (String) item.getString();
                        System.out.println(email);
                    }
                    if (inputName.equalsIgnoreCase("contact_num")) {
                        contact = (String) item.getString();
                        System.out.println(contact);
                    }
                    if (inputName.equalsIgnoreCase("address")) {
                        address = (String) item.getString();
                        System.out.println(address);
                    }
                    if (inputName.equalsIgnoreCase("status")) {
                        status = (String) item.getString();
                        System.out.println(status);
                    }
                    if (inputName.equalsIgnoreCase("money")) {
                        rate = (String) item.getString();
                        System.out.println(rate);
                    }
                }
            }

            //SQL Query for updating values
            String sql = "UPDATE Emp_Info SET SET Once = '0', Department = ?, ID = ?, title = ?, email = ?, contact_no = ?, address = ?, status = ?, picture = ?, rate = ? WHERE ID = ?";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, newDept);
            stmt.setString(2, newID);
            stmt.setString(3, newTitle);
            stmt.setString(4, email);
            stmt.setString(5, contact);
            stmt.setString(6, address);
            stmt.setString(7, status);
            stmt.setString(8, picture);
            stmt.setString(9, rate);
            stmt.setString(10, oldID);

            stmt.executeUpdate();

            String sql2 = "UPDATE Credentials SET username = ?, picture = ? WHERE ID = ?";
            stmt = con.prepareStatement(sql2);
            stmt.setString(1, newID);
            stmt.setString(2, picture);
            stmt.setString(3, newID);

            stmt.executeUpdate();

        } catch (SQLException se) {
            System.out.println("SQL Exception" + se.getMessage());
                        try (PrintWriter out = response.getWriter()) {
                /* TODO output your page here. You may use following sample code. */
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Invalid Input!');");
                out.println("location='Manage_Employee.jsp';");
                out.println("</script>");
            }
            response.sendRedirect("Manage_Employee.jsp");
        } catch (Exception e) {
                    try (PrintWriter out = response.getWriter()) {
                        /* TODO output your page here. You may use following sample code. */
                        out.println("<script type=\"text/javascript\">");
                        out.println("alert('Missing Input! Add a picture by clicking on the image!');");
                        out.println("location='Manage_Employee.jsp';");
                        out.println("</script>");
                    }
                    response.sendRedirect("Manage_Employee.jsp");
        } finally {
            try {
                if (con != null) {
                    con.close();
                }
                try (PrintWriter out = response.getWriter()) {
                    /* TODO output your page here. You may use following sample code. */
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Employee Edited\\n\\\n"
                            + "Username is the New Employee ID.\\n\\\n"
                            + "Password is the same');");
                    out.println("location='Manage_Employee.jsp';");
                    out.println("</script>");
                }
                response.sendRedirect("Manage_Employee.jsp");
            } catch (SQLException se) {
                System.out.println("SQL Exception" + se.getMessage());
                            try (PrintWriter out = response.getWriter()) {
                /* TODO output your page here. You may use following sample code. */
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Invalid Input!');");
                out.println("location='Manage_Employee.jsp';");
                out.println("</script>");
            }
            response.sendRedirect("Manage_Employee.jsp");
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
