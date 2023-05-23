package Servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import java.io.*;
import java.util.*;
import java.sql.SQLException;
import javax.servlet.ServletContext;

/**
 *
 * @author Isaiah Dava
 */
public class SignIn extends HttpServlet {

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
            out.println("<title>Servlet SignIn</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SignIn at " + request.getContextPath() + "</h1>");
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
        String username = request.getParameter("user");
        String password = request.getParameter("pass");

        response.setContentType("text/html");

        ServletContext context = request.getServletContext();

        context.setAttribute("username", username);
        context.setAttribute("password", password);
        String Check = null;
        Connection con = null;
        PreparedStatement stmt = null;
        Calendar calendar = Calendar.getInstance();
        int dayOfMonth = calendar.get(Calendar.DAY_OF_MONTH);
        try {
            Class.forName("org.sqlite.JDBC");
            con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");
            System.out.println(con != null);

            String sql = "select * from credentials where username= '" + username + "' and password = '" + password + "'";

            stmt = con.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                context.setAttribute("ID", rs.getString("ID"));
                context.setAttribute("Changed", rs.getString("Changed"));

                if (rs.getString("username").equals(username) && rs.getString("password").equals(password)) {
                    request.getSession().setAttribute("loggedInUser", username);
                    String sql3 = "select position from credentials where username= '" + username + "' and password = '" + password + "'";
                    PreparedStatement pstmt2 = con.prepareStatement(sql3);
                    ResultSet rs3 = pstmt2.executeQuery();

                    while (rs3.next()) {

                        if (rs3.getString("position").equals("ADMIN")) {
                            try (PrintWriter out = response.getWriter()) {
                                /* TODO output your page here. You may use following sample code. */
                                out.println("<script type=\"text/javascript\">");
                                out.println("alert('Record Found');");
                                out.println("location='WelcomeAdmin.jsp';");
                                out.println("</script>");
                            }
                            if (dayOfMonth == 1) {
                                String sql6 = "SELECT * FROM DatabaseClean";
                                PreparedStatement stmt3 = con.prepareStatement(sql6);
                                ResultSet rs2 = stmt3.executeQuery();
                                while (rs2.next()) {
                                    Check = rs2.getString("Clean");
                                }

                                if (Check.equals("NO")) {
                                    String sql2 = "DELETE FROM Attendance";
                                    PreparedStatement stmt4 = con.prepareStatement(sql2);
                                    stmt4.executeUpdate();
                                    String sql4 = "PRAGMA foreign_keys = ON;";
                                    stmt4 = con.prepareStatement(sql4);
                                    stmt4.executeUpdate();
                                    String sql5 = "DELETE FROM Emp_Info WHERE Status = 'Fired'";
                                    stmt4 = con.prepareStatement(sql5);
                                    stmt4.executeUpdate();
                                    sql5 = "DELETE FROM Task_Assignment WHERE Status = 'Completed'";
                                    stmt4 = con.prepareStatement(sql5);
                                    stmt4.executeUpdate();
                                    sql5 = "DELETE FROM Task_Assignment WHERE Status = 'Cancelled'";
                                    stmt4 = con.prepareStatement(sql5);
                                    stmt4.executeUpdate();

                                    String sql10 = "SELECT * FROM Emp_Info WHERE Flags >= 3";
                                    stmt4 = con.prepareStatement(sql10);
                                    rs2 = stmt4.executeQuery();

                                    while (rs2.next()) {
                                        String sql7 = "UPDATE Emp_Info SET First_Time='1' WHERE ID ='" + rs.getString("ID") + "'";
                                        PreparedStatement stmt5 = con.prepareStatement(sql7);
                                        stmt5.executeUpdate();

                                    }

                                    String sql8 = "UPDATE Emp_Info SET Flags='0'";
                                    stmt4 = con.prepareStatement(sql8);
                                    stmt4.executeUpdate();
                                    String sql7 = "UPDATE DatabaseClean SET Clean='YES'";
                                    stmt4 = con.prepareStatement(sql7);
                                    stmt4.executeUpdate();
                                    String sql9 = "UPDATE Emp_Info SET Once = '0', hours='0', salary='0', release='NO'";
                                    stmt4 = con.prepareStatement(sql9);
                                    stmt4.executeUpdate();
                                }

                            } else {
                                String esql = "UPDATE DatabaseClean SET Clean='NO'";
                                PreparedStatement stmt3 = con.prepareStatement(esql);
                                stmt3.executeUpdate();
                            }
                            if (con != null) {
                                con.close();
                            }

                            context.setAttribute("position", "ADMIN");
                            response.sendRedirect("WelcomeAdmin.jsp");

                        }
                        if (rs3.getString("position").equals("EMP")) {
                            try (PrintWriter out = response.getWriter()) {
                                /* TODO output your page here. You may use following sample code. */
                                out.println("<script type=\"text/javascript\">");
                                out.println("alert('Record Found');");
                                out.println("location='WelcomeEmployee.jsp';");
                                out.println("</script>");
                            }
                            context.setAttribute("position", "EMP");
                            response.sendRedirect("WelcomeEmployee.jsp");

                        }

                    }

                }
            }
            try (PrintWriter out = response.getWriter()) {
                /* TODO output your page here. You may use following sample code. */
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Record Not Found');");
                out.println("location='index.html';");
                out.println("</script>");
            }
            response.sendRedirect("index.html");

        } catch (SQLException se) {
            System.out.println("SQL Exception" + se.getMessage());
        } catch (Exception e) {
            System.out.println("Exception:" + e.getMessage());
        } finally {
            try {
                if (con != null) {
                    con.close();
                }
            } catch (SQLException se) {
                System.out.println("SQL Exception" + se.getMessage());
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
