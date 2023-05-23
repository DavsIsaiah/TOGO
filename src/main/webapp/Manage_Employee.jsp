<%-- 
    Document   : Manage_Employee
    Created on : Jan 13, 2022, 6:50:34 PM
    Author     : Isaiah Dava
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>


    <head>
        <link rel="shortcut icon" href="Assets/logo.png">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Employee</title>
        <link rel="stylesheet" href="CSS/Manage_Employee.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.1/css/all.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js" charset="utf-8"></script>
        <%
            ServletContext context = request.getServletContext();
            String username = (String) context.getAttribute("username");
            String password = (String) context.getAttribute("password");
            String picture = null;
            try {

                Connection con = null;
                PreparedStatement stmt = null;

                Class.forName("org.sqlite.JDBC");
                con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");

                String sql2 = "select picture from credentials where picture IS NOT NULL AND username= '" + username + "' and password = '" + password + "'";

                stmt = con.prepareStatement(sql2);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    picture = rs.getString("picture");

                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                System.out.println("SQL Exception" + e.getMessage());
            }


        %>


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
            //Checking session position.
            String position = (String) context.getAttribute("position");
            if (position.equals("ADMIN")) {

            } else {
        %>
        <script>

            alert("You are not allowed here!");
            window.location.href = "index.html";

        </script>
        <%
            }
        
        %>  




        <!--header area start-->
        <header>
            <label for="check">
                <i class="fas fa-bars" id="sidebar_btn"></i>
            </label>
                <div class="left_area"><a href="WelcomeAdmin.jsp">
                    <img src="Assets/light purp.png" alt="logo"/></a>
                    <h3><span>EMPLOYEE</span></h3>
                </div>
            <div class="right_area">
                <a href="LogoutProcess" class="logout_btn">Logout</a> 
            </div>
        </header>
        <!--header area end-->

        <!--mobile navigation bar start-->
        <div class="mobile_nav">
            <div class="nav_bar">
                <img src="<%out.print("/Files/" + picture);%>" class="mobile_profile_image" id="photo"alt="profile">
                <i class="fa fa-bars nav_btn"></i>
            </div>
            <div class="mobile_nav_items">

                <a href="Employee_Overview.jsp"><i class="fas fa-search"></i><span>Overview</span></a>
                <a href="#" style="background: #CCCFFF;"><i class="fas fa-user-friends"></i><span>Manage Employee</span></a>
            </div>
        </div>
        <!--mobile navigation bar end-->

        <!--sidebar start-->
        <div class="sidebar">
            <div class="profile_info">
                <img src="<%out.print("/Files/" + picture);%>" class="profile_image" alt="">
                <h4 id="Name"><%out.print(username);%></h4>
            </div>
            <a href="Employee_Overview.jsp"><i class="fas fa-search"></i><span>Overview</span></a>
            <a href="#" style="background: #CCCFFF;"><i class="fas fa-user-friends"></i><span>Manage Employee</span></a>

        </div>
        <!--sidebar end-->

        <div class="content">
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Photo</th>
                        <th>Name</th>
                        <th>Job Title</th>
                        <th>Department</th>
                        <th>Date Hired</th>
                        <th>Rate per Hour</th>
                        <th>No. of Flags</th>
                        <th>Edit</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>

                    <!-- Iteration code for the table. Displaying of employees from the database. -->


                    <%

                        try {

                            Connection con = null;
                            PreparedStatement stmt = null;

                            Class.forName("org.sqlite.JDBC");
                            con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");

                            String sql2 = "select * from Emp_Info";

                            stmt = con.prepareStatement(sql2);
                            ResultSet rs = stmt.executeQuery();

                            while (rs.next()) {
                    %>
                    <tr> 
                        <th class="sm-mmargin">     

                            <%        out.print(rs.getString("ID"));%>

                        </th>
                        <td data-title="Photo"><img src="<%out.print("/Files/" + rs.getString("picture"));%>"class="tableimg"></td>

                        <td data-title="Name"><%out.print(rs.getString("name"));%></td>

                        <td data-title="Job Title"><%out.print(rs.getString("title"));%></td>

                        <td data-title="Department"><%out.print(rs.getString("department"));%></td>

                        <td data-title="Date Hired"><%out.print(rs.getString("hire_date"));%></td>
                        <td data-title="Date Hired"><%out.print(rs.getString("rate"));%></td>

                        <td data-title="Flags"><%out.print(rs.getString("Flags"));%></td>

                        <td data-title="Email"><a href="Edit_Employee.jsp?value=<%out.print(rs.getString("ID"));%>"><i class="fas fa-user-edit"></i></a></td>

                        <td data-title="Status"><button type="button" name="fired" class="<%out.print(rs.getString("status"));%>"><%out.print(rs.getString("status"));%></button></td>

                    </tr>   

                    <%

                            }
                            if (con != null) {
                                con.close();
                            }
                        } catch (SQLException e) {
                            System.out.println("SQL Exception" + e.getMessage());
                        }


                    %>  


                    <!--End of iteration.-->    







                </tbody>
            </table>


        </div>

        <script type="text/javascript">
            $(document).ready(function () {
                $('.nav_btn').click(function () {
                    $('.mobile_nav_items').toggleClass('active');
                });
            });
        </script>
    </body>
</html>
