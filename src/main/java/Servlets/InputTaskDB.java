/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.FileItem;
import java.sql.*;
import java.io.*;
import java.util.*;
import java.io.IOException;
import java.io.PrintWriter;
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
public class InputTaskDB extends HttpServlet {

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
            out.println("<title>Servlet InputTaskDB</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet InputTaskDB at " + request.getContextPath() + "</h1>");
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
        String name = null;
        boolean full = false;
        String tasks = null;
        String Title = null;
        String Desc = null;
        String deadline = null;
        String assignment = null;
        String[] valueArray = null;
        String[] taskArray = null;
        List<FileItem> multiparts = null;
        try {
            multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
        } catch (FileUploadException ex) {
            Logger.getLogger(InputTaskDB.class.getName()).log(Level.SEVERE, null, ex);
        }
        String inputName = null;
        for (FileItem item : multiparts) {
            if (!item.isFormField()) {
            }
            if (item.isFormField()) {  // Check regular field.
                inputName = (String) item.getFieldName();
                if (inputName.equalsIgnoreCase("title")) {
                    Title = (String) item.getString();
                }
                if (inputName.equalsIgnoreCase("subtitle")) {
                    Desc = (String) item.getString();
                }
                if (inputName.equalsIgnoreCase("deadline")) {
                    deadline = (String) item.getString();
                }
                if (inputName.equalsIgnoreCase("multipleSelectValues")) {
                    assignment = (String) item.getString();
                    valueArray = assignment.split(",");
                }
                if (inputName.equalsIgnoreCase("tasks")) {
                    tasks = (String) item.getString();
                    taskArray = tasks.split(",");

                }

            }
        }

        Connection con = null;
        PreparedStatement stmt = null;
        PreparedStatement stmt2 = null;
        try {
            Class.forName("org.sqlite.JDBC");
            con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
            LocalDateTime now = LocalDateTime.now();

            for (int i = 0; i < valueArray.length; i++) {
                String value = valueArray[i].trim();
                String sql = "SELECT COUNT (TaskID) as count FROM (SELECT Assignment.TaskID, Assignment.EmpID, status FROM Assignment INNER JOIN Task_Assignment ON Assignment.TaskID = Task_Assignment.TaskID) WHERE Status ='In Progress' and EmpID ='" + value + "'";
                stmt = con.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    int count = rs.getInt("count");
                    System.out.println(count + " : count");
                    if (count >= 5) {
                        full = true;
                        String sql2 = "SELECT name FROM Emp_Info WHERE ID ='" + value + "'";
                        stmt2 = con.prepareStatement(sql2);
                        ResultSet rs2 = stmt2.executeQuery();
                        while (rs2.next()) {
                            name = rs2.getString("name");
                        }
                    }

                }

            }

            if (!full) {
                //Insert into task assignment
                String sql = "INSERT INTO Task_Assignment(Title,TaskDesc,DateCreate,Deadline,Status) VALUES (?,?,?,?,?);";
                stmt = con.prepareStatement(sql);
                stmt.setString(1, Title);
                stmt.setString(2, Desc);
                stmt.setString(3, dtf.format(now));
                stmt.setString(4, deadline);
                stmt.setString(5, "In Progress");
                stmt.executeUpdate();

                String taskID = null;
                String sql2 = "SELECT MAX(TaskID) FROM Task_Assignment";
                stmt = con.prepareStatement(sql2);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    taskID = rs.getString("MAX(TaskID)");
                }

                String sql4 = "INSERT INTO Assignment (TaskID, EmpID) VALUES (?,?)";
                stmt = con.prepareStatement(sql4);
                for (int i = 0; i < valueArray.length; i++) {
                    String value = valueArray[i].trim();
                    stmt.setString(1, taskID);
                    stmt.setString(2, value);
                    stmt.executeUpdate();
                }

                String sql3 = "INSERT INTO SubTasks (TaskID, Task) VALUES (?,?)";
                stmt = con.prepareStatement(sql3);
                for (int i = 0; i < taskArray.length; i++) {
                    String value = taskArray[i].trim();
                    stmt.setString(1, taskID);
                    stmt.setString(2, value);
                    stmt.executeUpdate();
                }
                try (PrintWriter out = response.getWriter()) {
                    /* TODO output your page here. You may use following sample code. */
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Succesfully Added Task!');");
                    out.println("location='Project_Manager.jsp';");
                    out.println("</script>");
                }
                response.sendRedirect("Project_Manager.jsp");
            } else {
                try (PrintWriter out = response.getWriter()) {
                    /* TODO output your page here. You may use following sample code. */
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Employee: " + name + " has already 5 task assigned to him/her!');");
                    out.println("location='New_Task_Form.jsp';");
                    out.println("</script>");
                }
                response.sendRedirect("New_Task_Form.jsp");
            }
        } catch (SQLException se) {
            System.out.println("SQL Exception" + se.getMessage());
            try (PrintWriter out = response.getWriter()) {
                /* TODO output your page here. You may use following sample code. */
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Invalid Input!');");
                out.println("location='Project_Manager.jsp';");
                out.println("</script>");
            }
            response.sendRedirect("Project_Manager.jsp");
        } catch (Exception e) {
            System.out.println("Exception:" + e.getMessage());
            try (PrintWriter out = response.getWriter()) {
                /* TODO output your page here. You may use following sample code. */
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Invalid Input!');");
                out.println("location='Project_Manager.jsp';");
                out.println("</script>");
            }
            response.sendRedirect("Project_Manager.jsp");
        } finally {
            try {
                if (con != null) {
                    con.close();
                }

            } catch (SQLException se) {
                System.out.println("SQL Exception" + se.getMessage());
                try (PrintWriter out = response.getWriter()) {
                    /* TODO output your page here. You may use following sample code. */
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Invalid Input!');");
                    out.println("location='Project_Manager.jsp';");
                    out.println("</script>");
                }
                response.sendRedirect("Project_Manager.jsp");
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
