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

import java.io.*;
import java.util.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
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
public class TimeOutEmp extends HttpServlet {

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
            out.println("<title>Servlet TimeOutEmp</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TimeOutEmp at " + request.getContextPath() + "</h1>");
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
        Connection con = null;
        PreparedStatement stmt = null;
        String picture = null;
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
            String date = null, hour = null, minute = null, pastHour = null, pastMinute = null;
            int hour2 = 0, minute2 = 0, pastHour2 = 0, pastMinute2 = 0;
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
            String dayCheck = null;
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("hh");
            DateTimeFormatter dtf2 = DateTimeFormatter.ofPattern("mm");
            LocalDateTime now = LocalDateTime.now();

            String time_out = dtf.format(now) + ":" + dtf2.format(now);
            hour2 = Integer.parseInt(dtf.format(now));
            minute2 = Integer.parseInt(dtf2.format(now));
             DateTimeFormatter dtf3 = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            
            date = dtf3.format(now);
            String attendance = "Absent";
            String timed_out = null;
            String sql7 = "SELECT timed_out FROM Emp_Info WHERE ID ='" + ID + "'";
            stmt = con.prepareStatement(sql7);
            rs = stmt.executeQuery();
            while (rs.next()) {

                timed_out = rs.getString("timed_out");

            }

            if (timed_out.equals("YES")) {
                //Already Timed Out
                try (PrintWriter out = response.getWriter()) {
                    /* TODO output your page here. You may use following sample code. */
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Already Timed Out!');");
                    out.println("location='" + webpage + "';");
                    out.println("</script>");
                }
                response.sendRedirect(webpage);
            } else {

                if (date.length() > 4) {

                    dayCheck = date.substring(date.length() - 2);
                    if (dayCheck.equals("01")) {
                        String sql6 = "UPDATE Emp_Info SET hours = '0' WHERE ID ='" + ID + "'";
                        stmt = con.prepareStatement(sql6);
                        stmt.executeUpdate();
                    }
                }

                String sql = "UPDATE Attendance SET time_out ='" + time_out + "' WHERE ID ='" + ID + "' AND date ='" + date + "'";
                stmt = con.prepareStatement(sql);

                stmt.executeUpdate();

                sql2 = "UPDATE Emp_Info SET attendance ='" + attendance + "' WHERE ID = '" + ID + "'";
                stmt = con.prepareStatement(sql2);
                stmt.executeUpdate();

                String sql3 = "SELECT hour, minute FROM Attendance WHERE ID ='" + ID + "' AND date ='" + date + "'";
                stmt = con.prepareStatement(sql3);
                rs = stmt.executeQuery();
                while (rs.next()) {

                    pastHour = rs.getString("hour");
                    pastMinute = rs.getString("minute");
                }
                pastHour2 = Integer.parseInt(pastHour);
                pastMinute2 = Integer.parseInt(pastMinute);
                time_out = time_out + ":00";
                String time_in = pastHour + ":" + pastMinute + ":00";

                System.out.println(time_in);
                System.out.println(time_out);

                SimpleDateFormat simpleDateFormat
                        = new SimpleDateFormat("HH:mm:ss");
                Date date1;
                date1 = simpleDateFormat.parse(time_in);
                Date date2 = simpleDateFormat.parse(time_out);

                long differenceInMilliSeconds
                        = Math.abs(date2.getTime() - date1.getTime());

                long differenceInHours
                        = (differenceInMilliSeconds / (60 * 60 * 1000)) % 24;

                long differenceInMinutes
                        = (differenceInMilliSeconds / (60 * 1000)) % 60;
                System.out.println(differenceInMinutes);

                float minutesInFraction = (float) differenceInMinutes;

                minutesInFraction = minutesInFraction / 60;

                System.out.println(minutesInFraction + " fraction");
                System.out.println((float) differenceInHours + " hours");
                if (differenceInHours >= 1) {
                    minutesInFraction = (float) differenceInHours + minutesInFraction;
                }

                String currentHours = null;
                float currentHours2 = 0;
                String salary = null;
                float currentSalary = 0;
                String rate = null;
                float currentRate = 0;
                String sql4 = "SELECT hours, salary,rate FROM Emp_Info WHERE ID ='" + ID + "'";
                stmt = con.prepareStatement(sql4);
                rs = stmt.executeQuery();
                while (rs.next()) {
                    currentHours = rs.getString("hours");
                    salary = rs.getString("salary");
                    rate = rs.getString("rate");
                }

                currentHours2 = Float.valueOf(currentHours);

                currentSalary = Float.valueOf(salary);

                currentRate = Float.valueOf(rate);

                currentHours2 = currentHours2 + minutesInFraction;

                currentHours = String.format("%.2f", currentHours2);
                currentSalary = currentHours2 * currentRate;

                salary = String.format("%.2f", currentSalary);

                String sql5 = "UPDATE Emp_Info SET hours = '" + currentHours + "', salary='" + salary + "', timed_out='YES' WHERE ID ='" + ID + "'";
                stmt = con.prepareStatement(sql5);
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
            try {
                if (con != null) {
                    con.close();
                }
                try (PrintWriter out = response.getWriter()) {
                    /* TODO output your page here. You may use following sample code. */
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Succesfully Timed Out!');");
                    out.println("location='" + webpage + "';");
                    out.println("</script>");
                }
                response.sendRedirect(webpage);
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
