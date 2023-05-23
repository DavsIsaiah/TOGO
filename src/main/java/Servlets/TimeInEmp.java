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

/**
 *
 * @author Isaiah Dava
 */
public class TimeInEmp extends HttpServlet {

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
            out.println("<title>Servlet TimeInEmp</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TimeInEmp at " + request.getContextPath() + "</h1>");
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
        String username = (String) context.getAttribute("username");
        String password = (String) context.getAttribute("password");
        String position = (String) context.getAttribute("position");
        String ID = (String) context.getAttribute("ID");
        String picture = null;
        Connection con = null;
        PreparedStatement stmt = null;
        String webpage = null;
        if (position.equals("EMP")) {
            webpage = "WelcomeEmployee.jsp";
        } else {
            webpage = "WelcomeAdmin.jsp";
        }

        try {

            Class.forName("org.sqlite.JDBC");
            con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");
            String sql2 = "select picture from credentials where picture IS NOT NULL AND username= '" + username + "' and password = '" + password + "'";
            stmt = con.prepareStatement(sql2);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                picture = rs.getString("picture");

            }

            String date = null, hour = null, minute = null;
            int hour2 = 0, minute2 = 0;
            List<FileItem> multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);

            String inputName = null;

            for (FileItem item : multiparts) {
                if (item.isFormField()) {
                    inputName = (String) item.getFieldName();
                    if (inputName.equalsIgnoreCase("date")) {
                        date = (String) item.getString();
                        System.out.println(date);
                    }
                    if (inputName.equalsIgnoreCase("hour")) {
                        hour = (String) item.getString();
                        hour2 = Integer.parseInt(hour);
                        System.out.println(hour);
                    }
                    if (inputName.equalsIgnoreCase("minute")) {
                        minute = (String) item.getString();
                        minute2 = Integer.parseInt(minute);
                        System.out.println(minute);
                    }

                }
            }
            
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("hh");
            DateTimeFormatter dtf2 = DateTimeFormatter.ofPattern("mm");
            LocalDateTime now = LocalDateTime.now();
            DateTimeFormatter dtf3 = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            
            date = dtf3.format(now);
            hour = dtf.format(now);
            minute = dtf2.format(now);
            String time_in = dtf.format(now) + ":" + dtf2.format(now);
            hour2 = Integer.parseInt(dtf.format(now));
            minute2 = Integer.parseInt(dtf2.format(now));
            String attendance = null;
            if (hour2 < 7) {
                attendance = "Present";
            }

            if (hour2 == 7) {
                if (minute2 <= 30) {
                    attendance = "Present";
                }
                if (minute2 > 30) {
                    attendance = "Late";
                }
            }

            if (hour2 > 7) {
                attendance = "Late";
            }
            boolean check = false;
            String sql3 = "SELECT * FROM Attendance WHERE ID ='" + ID + "' and date ='" + date + "'";
            stmt = con.prepareStatement(sql3);
            rs = stmt.executeQuery();
            while (rs.next()) {

                if (rs.getString("ID").equals(ID)) {
                    check = true;
                }

            }

            if (check) {
                //Timed In already
                try (PrintWriter out = response.getWriter()) {
                    /* TODO output your page here. You may use following sample code. */
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Already Timed In!');");
                    out.println("location='" + webpage + "';");
                    out.println("</script>");
                }
                response.sendRedirect(webpage);

            } else {
                String sql = "INSERT INTO Attendance(ID, date, attendance, hour, minute, time_in) VALUES (?,?,?,?,?,?);";
                stmt = con.prepareStatement(sql);
                stmt.setString(1, ID);
                stmt.setString(2, date);
                stmt.setString(3, attendance);
                stmt.setString(4, hour);
                stmt.setString(5, minute);
                stmt.setString(6, time_in);
                stmt.executeUpdate();

                sql2 = "UPDATE Emp_Info SET attendance ='" + attendance + "', timed_out = 'NO' WHERE ID = '" + ID + "'";
                stmt = con.prepareStatement(sql2);
                stmt.executeUpdate();

            }
        } catch (SQLException se) {
            System.out.println("SQL Exception" + se.getMessage());
            try (PrintWriter out = response.getWriter()) {
                /* TODO output your page here. You may use following sample code. */
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Invalid Input!');");
                out.println("location='" + webpage + "';");
                out.println("</script>");
            }
            response.sendRedirect(webpage);

        } catch (Exception e) {
            System.out.println("Exception:" + e.getMessage());
            try (PrintWriter out = response.getWriter()) {
                /* TODO output your page here. You may use following sample code. */
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Invalid Input!');");
                out.println("location='" + webpage + "';");
                out.println("</script>");
            }
            response.sendRedirect(webpage);

        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException ex) {
                    Logger.getLogger(TimeInEmp.class.getName()).log(Level.SEVERE, null, ex);
                    try (PrintWriter out = response.getWriter()) {
                        /* TODO output your page here. You may use following sample code. */
                        out.println("<script type=\"text/javascript\">");
                        out.println("alert('Invalid Input!');");
                        out.println("location='" + webpage + "';");
                        out.println("</script>");
                    }
                    response.sendRedirect(webpage);

                }
            }
            try (PrintWriter out = response.getWriter()) {
                /* TODO output your page here. You may use following sample code. */
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Succesfully Timed In!');");
                out.println("location='" + webpage + "';");
                out.println("</script>");
            }
            response.sendRedirect(webpage);

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
