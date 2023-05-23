<%-- 
    Document   : attendance
    Created on : Jan 21, 2022, 6:37:26 PM
    Author     : Isaiah Dava
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" dir="ltr">
    <head>
        <link rel="shortcut icon" href="Assets/logo.png">
        <%
            ServletContext context = request.getServletContext();
            String username = (String) context.getAttribute("username");
            String password = (String) context.getAttribute("password");
            String picture = null;
            String ID = null;
            String hours = null;
            String rate = null;
            String salary = null;
            String name = null;
            String department = null;
            String title = null;
            String release = null;
            try {

                Connection con = null;
                PreparedStatement stmt = null;

                Class.forName("org.sqlite.JDBC");
                con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");

                String sql2 = "select picture, ID from credentials where picture IS NOT NULL AND username= '" + username + "' and password = '" + password + "'";

                stmt = con.prepareStatement(sql2);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    picture = rs.getString("picture");
                    ID = rs.getString("ID");
                }

                String sql = "SELECT * FROM Emp_Info WHERE ID ='" + ID + "'";
                stmt = con.prepareStatement(sql);
                rs = stmt.executeQuery();
                while (rs.next()) {
                    hours = rs.getString("hours");
                    rate = rs.getString("rate");
                    salary = rs.getString("salary");
                    name = rs.getString("name");
                    department = rs.getString("department");
                    title = rs.getString("title");
                    release = rs.getString("release");

                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                System.out.println("SQL Exception" + e.getMessage());
            }


        %>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Salary</title>
        <link rel="stylesheet" href="CSS/attendance.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.1/css/all.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js" charset="utf-8"></script>
        <style>
            h2 {
                font-size: 30px;
            }
            h3 {
                font-size: 20px;
            }

            h4 {

                font-size: 20px;
                font-weight: lighter;

            }
            p{
                font-size: 25px;
                font-weight: lighter;
            }



            </style>
        </head>




        <body>

            <!--Checking validity of session-->
            <%            HttpSession nsession = request.getSession(false);
                if (nsession == null || session.getAttribute("loggedInUser") == null) {
            %>
            <script>

                alert("Session is not active!");
                window.location.href = "index.html";

            </script>
            <%
                }
            %>




            <div class="hc" style="padding-top:20px">
                <div class="div-2">
                    <img src="<%out.print("/Files/" + picture);%>" id="photo" alt="profile" style="padding-top: 50px;">
                    <br />
                    <h1><%out.println(name);%></h1>
                    <h2>Department: <%out.println(department);%></h2>
                    <h4>Title: <%out.println(title);%></h4>
                </div>
            </div>
            <div class="rightdiv" >
                <p >Salary: <%out.print(salary);%></p>
                <p>Hours Worked: <%out.print(hours);%></p>
                <p>Rate per Hour: <%out.print(rate);%></p>
                <p>Released: <%out.print(release);%></p>
                
                <button onclick="history.back()" class="btn" style="padding:20%; margin-left: 0%;"><i class="far fa-arrow-alt-circle-left"></i></button>
                <p>Back</p>
            </div>


        </body>





    </html>

