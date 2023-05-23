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
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
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
public class UpdateAccountDB extends HttpServlet {

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
            out.println("<title>Servlet UpdateAccountDB</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateAccountDB at " + request.getContextPath() + "</h1>");
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
        response.setContentType("text/html");
        String name = "EditAcc.jsp";
        boolean check = true;
        ServletContext context = request.getServletContext();
        String username = (String) context.getAttribute("username");
        String password = (String) context.getAttribute("password");
        String position = (String) context.getAttribute("position");
        String ID = (String) context.getAttribute("ID");
        String newUser = null;
        String newPass = null;
        List<FileItem> multiparts = null;
        try {
            multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
        } catch (FileUploadException ex) {
            //Logger.getLogger(UpdateAccountDB.class.getName()).log(Level.SEVERE, null, ex);
        }
        String inputName = null;
        for (FileItem item : multiparts) {
            if (!item.isFormField()) {
                try {
                    // Check regular field.
                    //Write file into server files.
                    item.write(new File("C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\" + item.getName()));
                    Connection con = null;
                    PreparedStatement stmt = null;
                    Class.forName("org.sqlite.JDBC");
                    con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");

                    String sql = "UPDATE Credentials SET picture ='" + item.getName() + "' WHERE username = '" + username + "' and password = '" + password + "'";

                    stmt = con.prepareStatement(sql);
                    stmt.executeUpdate();

                    sql = "UPDATE Emp_Info SET picture ='" + item.getName() + "' WHERE ID='" + ID + "';";
                    stmt = con.prepareStatement(sql);
                    stmt.executeUpdate();

                    if (con != null) {
                        con.close();
                    }
                } catch (Exception ex) {
                    //Logger.getLogger(UpdateAccountDB.class.getName()).log(Level.SEVERE, null, ex);
                    try (PrintWriter out = response.getWriter()) {
                        /* TODO output your page here. You may use following sample code. */
                        out.println("<script type=\"text/javascript\">");
                        out.println("alert('Missing Input! Add a picture by clicking on the image!');");
                        out.println("location='EditAcc.jsp';");
                        out.println("</script>");
                    }
                    response.sendRedirect("EditAcc.jsp");
                }

            }
            if (item.isFormField()) {  // Check regular field.
                inputName = (String) item.getFieldName();
                if (inputName.equalsIgnoreCase("user")) {
                    newUser = (String) item.getString();

                }
                if (inputName.equalsIgnoreCase("pass")) {
                    newPass = (String) item.getString();

                }

            }
        }


        if (!((newPass.length() >= 8)
                && (newPass.length() <= 15))) {
            check = false;
        }
        if (newPass.contains(" ")) {
            check = false;
        }

        if (true) {
            int count = 0;

            // check digits from 0 to 9
            for (int i = 0; i <= 9; i++) {

                // to convert int to string
                String str1 = Integer.toString(i);

                if (newPass.contains(str1)) {
                    count = 1;
                }
            }
            if (count == 0) {
                check = false;
            }
        }

        if (!(newPass.contains("@") || newPass.contains("#")
                || newPass.contains("!") || newPass.contains("~")
                || newPass.contains("$") || newPass.contains("%")
                || newPass.contains("^") || newPass.contains("&")
                || newPass.contains("*") || newPass.contains("(")
                || newPass.contains(")") || newPass.contains("-")
                || newPass.contains("+") || newPass.contains("/")
                || newPass.contains(":") || newPass.contains(".")
                || newPass.contains(", ") || newPass.contains("<")
                || newPass.contains(">") || newPass.contains("?")
                || newPass.contains("|"))) {
            check = false;
        }

        if (true) {
            int count = 0;

            // checking capital letters
            for (int i = 65; i <= 90; i++) {

                // type casting
                char c = (char) i;

                String str1 = Character.toString(c);
                if (newPass.contains(str1)) {
                    count = 1;
                }
            }
            if (count == 0) {
                check = false;
            }
        }

        if (true) {
            int count = 0;

            // checking small letters
            for (int i = 90; i <= 122; i++) {

                // type casting
                char c = (char) i;
                String str1 = Character.toString(c);

                if (newPass.contains(str1)) {
                    count = 1;
                }
            }
            if (count == 0) {
                check = false;
            }
        }

        // if all conditions fails


        if (check) {
            System.out.println("Password Pass");
            Connection con = null;
            PreparedStatement stmt = null;
            try {
                Class.forName("org.sqlite.JDBC");
                con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");
                System.out.println(con != null);

                String sql = "UPDATE Credentials SET username ='" + newUser + "',password ='" + newPass + "', Changed ='YES' WHERE username = '" + username + "' and password = '" + password + "'";

                stmt = con.prepareStatement(sql);
                stmt.executeUpdate();

            } catch (SQLException se) {
                System.out.println("SQL Exception" + se.getMessage());
                try (PrintWriter out = response.getWriter()) {
                    /* TODO output your page here. You may use following sample code. */
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Invalid Input!');");
                    out.println("location='EditAcc.jsp';");
                    out.println("</script>");
                }
                response.sendRedirect("EditAcc.jsp");
            } catch (Exception e) {
                System.out.println("Exception:" + e.getMessage());
                try (PrintWriter out = response.getWriter()) {
                    /* TODO output your page here. You may use following sample code. */
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Invalid Input!');");
                    out.println("location='EditAcc.jsp';");
                    out.println("</script>");
                }
                response.sendRedirect("EditAcc.jsp");
            } finally {
                try {
                    if (con != null) {
                        con.close();
                    }
                    context.setAttribute("username", newUser);
                    context.setAttribute("password", newPass);
                    context.setAttribute("Changed", "YES");
                    if ("ADMIN".equals(position)) {
                        try (PrintWriter out = response.getWriter()) {
                            /* TODO output your page here. You may use following sample code. */
                            out.println("<script type=\"text/javascript\">");
                            out.println("alert('Account Credentials Changed!');");
                            out.println("location='WelcomeAdmin.jsp';");
                            out.println("</script>");
                        }

                        response.sendRedirect("WelcomeAdmin.jsp");
                    } else {
                        try (PrintWriter out = response.getWriter()) {
                            /* TODO output your page here. You may use following sample code. */
                            out.println("<script type=\"text/javascript\">");
                            out.println("alert('Account Credentials Changed!');");
                            out.println("location='WelcomeEmployee.jsp';");
                            out.println("</script>");
                        }
                        response.sendRedirect("WelcomeEmployee.jsp");

                    }
                } catch (SQLException se) {
                    System.out.println("SQL Exception" + se.getMessage());
                    try (PrintWriter out = response.getWriter()) {
                        /* TODO output your page here. You may use following sample code. */
                        out.println("<script type=\"text/javascript\">");
                        out.println("alert('Invalid Input!');");
                        out.println("location='EditAcc.jsp';");
                        out.println("</script>");
                    }
                    response.sendRedirect("EditAcc.jsp");
                }
            }
        } else {
            System.out.println("Checking password 3");
            try (PrintWriter out = response.getWriter()) {
                /* TODO output your page here. You may use following sample code. */
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Password should not contain any space and should be 8 to 15 characters long, it should also contain atleast one of the following: one uppercase letter, one lowercase letter, one digit, one special character.');");
                out.println("location='EditAcc.jsp';");
                out.println("</script>");

            }

            response.sendRedirect("EditAcc.jsp");


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
