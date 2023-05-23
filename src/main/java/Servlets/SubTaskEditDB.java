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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileUploadException;

/**
 *
 * @author Isaiah Dava
 */
public class SubTaskEditDB extends HttpServlet {

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
            out.println("<title>Servlet SubTaskEditDB</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SubTaskEditDB at " + request.getContextPath() + "</h1>");
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
        String ID = request.getParameter("value");

        String inputName = null;
        String tasks = null;
        String check = null;
        String[] checkArray = null;
        String[] taskArray = null;
        boolean empty = false;
        boolean checknotEmpty = false;
        boolean tasksnotEmpty = false;
        Connection con = null;
        PreparedStatement stmt = null;
        PreparedStatement stmt2 = null;
        try {
            List<FileItem> multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
            for (FileItem item : multiparts) {
                if (!item.isFormField()) {
                }
                if (item.isFormField()) {  // Check regular field.
                    inputName = (String) item.getFieldName();
                    if (inputName.equalsIgnoreCase("check")) {
                        check = (String) item.getString();
                        if (!(check.equals("") || check.equals(null))) {
                            checkArray = check.split(",");
                            System.out.println(":" + checkArray.length + " length to" + ";;;;;;;");
                        }
                        checknotEmpty = true;
                        empty = true;
                    }
                    if (inputName.equalsIgnoreCase("tasks")) {

                        tasks = (String) item.getString();
                        if (!(tasks.equals("") || tasks.equals(null))) {
                            taskArray = tasks.split(",");
                            System.out.println(";" + taskArray.length + " secret" + ":::");
                            tasksnotEmpty = true;
                            empty = true;

                        }
                    }
                }

            }

            Class.forName("org.sqlite.JDBC");
            con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
            LocalDateTime now = LocalDateTime.now();
            //Insert into task assignment
            System.out.println(empty + ":check");
            if (empty) {
                String sql2 = "DELETE FROM SubTasks WHERE TaskID ='" + ID + "'";
                stmt = con.prepareStatement(sql2);
                stmt.executeUpdate();
            }

            String sql3 = "INSERT INTO SubTasks (TaskID, Task, Checked) VALUES (?,?,?)";
            stmt = con.prepareStatement(sql3);
            if (tasksnotEmpty) {
                for (int i = 0; i < taskArray.length; i++) {
                    String value = taskArray[i].trim();
                    stmt.setString(1, ID);
                    stmt.setString(2, value);
                    stmt.setString(3, "no");

                    stmt.executeUpdate();

                }
            }

            stmt = con.prepareStatement(sql3);
            if (checknotEmpty) {
                for (int i = 0; i < checkArray.length; i++) {
                    String value = checkArray[i].trim();
                    stmt.setString(1, ID);
                    stmt.setString(2, value);
                    stmt.setString(3, "checked");

                    stmt.executeUpdate();
                }
            }

        } catch (SQLException se) {
            System.out.println("SQL Exception" + se.getMessage());
            try (PrintWriter out = response.getWriter()) {
                /* TODO output your page here. You may use following sample code. */
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Invalid Input!');");
                out.println("location='TasksEmp.jsp';");
                out.println("</script>");
            }
            response.sendRedirect("TasksEmp.jsp");
        } catch (Exception e) {
            System.out.println("Exception:" + e.getMessage());
            try (PrintWriter out = response.getWriter()) {
                /* TODO output your page here. You may use following sample code. */
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Invalid Input!');");
                out.println("location='TasksEmp.jsp';");
                out.println("</script>");
            }
            response.sendRedirect("TasksEmp.jsp");
        } finally {
            try {
                if (con != null) {
                    con.close();
                }
                try (PrintWriter out = response.getWriter()) {
                    /* TODO output your page here. You may use following sample code. */
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Edited Sub-Tasks!!');");
                    out.println("location='TasksEmp.jsp';");
                    out.println("</script>");
                }
                response.sendRedirect("TasksEmp.jsp");

            } catch (SQLException se) {
                System.out.println("SQL Exception" + se.getMessage());
                try (PrintWriter out = response.getWriter()) {
                    /* TODO output your page here. You may use following sample code. */
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Invalid Input!');");
                    out.println("location='TasksEmp.jsp';");
                    out.println("</script>");
                }
                response.sendRedirect("TasksEmp.jsp");
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
