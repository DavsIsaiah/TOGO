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
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileUploadException;

/**
 *
 * @author Isaiah Dava
 */
public class FlagTaskEmp extends HttpServlet {

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
            out.println("<title>Servlet FlagTaskEmp</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FlagTaskEmp at " + request.getContextPath() + "</h1>");
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
        ServletContext context = request.getServletContext();
        String ID = request.getParameter("value");
        String EmpID = (String) context.getAttribute("ID");
        String reason = null;
        List<FileItem> multiparts = null;
        try {
            multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
        } catch (FileUploadException ex) {
            Logger.getLogger(FlagTaskEmp.class.getName()).log(Level.SEVERE, null, ex);
        }
        String inputName = null;
        Connection con = null;
        PreparedStatement stmt = null;
        for (FileItem item : multiparts) {
            if (item.isFormField()) {  // Check regular field.
                inputName = (String) item.getFieldName();
                if (inputName.equalsIgnoreCase("reason")) {
                    reason = (String) item.getString();
                }
            }
        }
        try {
            Class.forName("org.sqlite.JDBC");
            con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd");
            LocalDateTime now = LocalDateTime.now();
            //Insert into task assignment

            String sql3 = "UPDATE Task_Assignment SET Status = 'Flagged', Flagged = '" + reason + "' WHERE TaskID='" + ID + "'";
            stmt = con.prepareStatement(sql3);
            stmt.executeUpdate();

            String sql4 = "UPDATE Emp_Info SET Flags = Flags + 1 WHERE ID='" + EmpID + "'";
            stmt = con.prepareStatement(sql4);
            stmt.executeUpdate();

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
                    out.println("alert('Flagged Task!');");
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
