<%-- 
    Document   : Attendance_Admin
    Created on : Jan 21, 2022, 6:21:06 PM
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
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Attendance</title>
        <link href="CSS/admin_attendance.css" rel="stylesheet" type="text/css"/>
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

            String ID = request.getParameter("value");
            System.out.println(ID);
        %>
    </head>
    <body>

        <!--Checking validity of session-->
        <%
            HttpSession nsession = request.getSession(false);

            System.out.println(nsession + "session");

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
        %>


        <input type="checkbox" id="check">
        <!--header area start-->
        <header>
            <label for="check">
                <i class="fas fa-bars" id="sidebar_btn"></i>
            </label>
            <div class="left_area">
                <a href="WelcomeAdmin.jsp">
                    <img src="Assets/light purp.png" alt="logo"/>
                </a>
                    <h3><span class="attlabel">ATTENDANCE</span></h3>
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

                <a href="Attendance_Present.jsp"  style="background: #CCCFFF;"><i class="fas fa-user"></i><span>Present</span></a>
                <a href="Attendance_Absent.jsp"><i class="fas fa-user-minus"></i><span>Absent</span></a>
                <a href="Attendance_Late.jsp" ><i class="fas fa-user-clock"></i><span>Late</span></a>
                <a href="Attendance_Admin.jsp" ><i class="far fa-calendar-alt"></i><span>Daily Report</span></a>
            </div>
        </div>
        <!--mobile navigation bar end-->

        <!--sidebar start-->
        <div class="sidebar">
            <div class="profile_info">
                <img src="<%out.print("/Files/" + picture);%>" class="profile_image" alt="">
                <h4 id="Name"><%out.print(username);%></h4>
            </div>
            <a href="Attendance_Present.jsp"  style="background: #CCCFFF;"><i class="fas fa-user"></i><span>Present</span></a>
            <a href="Attendance_Absent.jsp"><i class="fas fa-user-minus"></i><span>Absent</span></a>
            <a href="Attendance_Late.jsp" ><i class="fas fa-user-clock"></i><span>Late</span></a>
            <a href="Attendance_Admin.jsp" ><i class="far fa-calendar-alt"></i><span>Daily Report</span></a>
        </div>
        <!--sidebar end-->


        <div class="content">
            <div class="dropdown" style="overflow:visible;">
                <button onclick="myFunction()" class="dropbtn">Select Date</button>
                <div id="myDropdown" class="dropdown-content" style="max-height:150px;overflow:scroll;">
                    <%
                        try {

                            Connection con = null;
                            PreparedStatement stmt = null;

                            Class.forName("org.sqlite.JDBC");
                            con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");

                            String sql2 = "select Distinct date from Attendance";

                            stmt = con.prepareStatement(sql2);
                            ResultSet rs = stmt.executeQuery();

                            while (rs.next()) {

                    %>
                    <a href="Attendance_Present.jsp?value=<%out.print(rs.getString("date"));%>"><%out.print(rs.getString("date"));%></a>             
                    <%

                            }
                            if (con != null) {
                                con.close();
                            }
                        } catch (SQLException e) {
                            System.out.println("SQL Exception" + e.getMessage());
                        }


                    %>    

                </div>
            </div>
            <div style="text-align:center;">
                <h1>
                    <%                        if (ID == null) {
                        } else {
                            out.println(ID);
                        }
                    %>
                </h1>
            </div>
            <table class="table">
                <thead>
                    <tr>
                        <th></th>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Department</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>

                    <%
                        try {

                            Connection con = null;
                            PreparedStatement stmt = null;

                            Class.forName("org.sqlite.JDBC");
                            con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");

                            String sql2 = null;

                            if (ID == null) {
                                sql2 = "select * from Emp_Info WHERE attendance ='Present'";
                            } else {
                                sql2 = "Select Emp_Info.picture, attendance.ID, Emp_Info.department, date, name, Attendance.attendance from attendance LEFT JOIN Emp_Info on attendance.ID = Emp_Info.ID WHERE date ='" + ID + "' AND attendance.attendance ='Present'";
                            }
                            boolean check = false;

                            stmt = con.prepareStatement(sql2);
                            ResultSet rs = stmt.executeQuery();

                            while (rs.next()) {
                    %>

                    <tr>
                        <td data-title="Photo"><img src="<%out.print("/Files/" + rs.getString("picture"));%>" class="tableimg"></td>
                        <th class="sm-mmargin"> <%out.print(rs.getString("ID"));%> </th>
                        <td data-title="Name"><%out.print(rs.getString("name"));%></td>
                        <td data-title="Department"><%out.print(rs.getString("department"));%></td>

                        <%if (ID == null) {%>
                        <td data-title="Status"><button type="button" name="fired" class="<%out.print(rs.getString("attendance"));%>"><%out.print(rs.getString("attendance"));%></button></td>
                            <%} else {
                                System.out.println(rs.getString("ID"));
                                String sql3 = "Select * from Attendance WHERE date ='" + ID + "' AND ID ='" + rs.getString("ID") + "' AND attendance='Present'";

                                PreparedStatement stmt2 = null;
                                stmt2 = con.prepareStatement(sql3);
                                ResultSet rs2 = stmt2.executeQuery();

                                while (rs2.next()) {
                                    if (rs.getString("ID").equals(rs2.getString("ID"))) {

                            %>

                        <td data-title="Status"><button type="button" name="fired" class="<%out.print(rs2.getString("attendance"));%>"><%out.print(rs2.getString("attendance"));%></button></td>

                        <%
                                    check = true;
                                }

                            }
                            if (!check) {
                        %>
                        <td data-title="Status"><button type="button" name="fired" class="Absent">Absent</button></td>

                        <%
                                }
                            }
                            check = false;


                        %>

                    </tr>

                    <%                            }
                            if (con != null) {
                                con.close();
                            }
                        } catch (SQLException e) {
                            System.out.println("SQL Exception" + e.getMessage());
                        }


                    %>  




                </tbody>
            </table>
        </div>



        <script type="text/javascript">
            $(document).ready(function () {
                $('.nav_btn').click(function () {
                    $('.mobile_nav_items').toggleClass('active');
                });
            });

            /* When the user clicks on the button, 
             toggle between hiding and showing the dropdown content */
            function myFunction() {
                document.getElementById("myDropdown").classList.toggle("show");
            }

            // Close the dropdown if the user clicks outside of it
            window.onclick = function (event) {
                if (!event.target.matches('.dropbtn')) {
                    var dropdowns = document.getElementsByClassName("dropdown-content");
                    var i;
                    for (i = 0; i < dropdowns.length; i++) {
                        var openDropdown = dropdowns[i];
                        if (openDropdown.classList.contains('show')) {
                            openDropdown.classList.remove('show');
                        }
                    }
                }
            }
        </script>

    </body>
</html>
