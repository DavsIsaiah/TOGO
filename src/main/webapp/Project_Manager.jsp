<%-- 
    Document   : Project_Manager
    Created on : Feb 3, 2022, 4:03:39 PM
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
        <style>
            .button{
                background-color: transparent; /* Green */
                border: none;
                color: #404480;
                padding: 15px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                margin: 4px 2px;
                cursor: pointer;
                font-size: 28px;

            }


        </style>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Tasks</title>
        <link rel="stylesheet" href="CSS/Manage_Tasks.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.1/css/all.min.css">
        <link rel="stylesheet" href="https://unicons.iconscout.com/release/v2.1.6/css/unicons.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js" charset="utf-8"></script>

        <link href="CSS/bootstrap.css" rel="stylesheet" type="text/css"/>
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
        <input type="checkbox" id="check">
        <!--header area start-->
        <header style="height:80px;">
            <label for="check">
                <i class="fas fa-bars" id="sidebar_btn"></i>
            </label>

            <div class="left_area" style="max-width:200px;"><a href="WelcomeAdmin.jsp">
                    <img src="Assets/light purp.png" alt="logo"/></a>
                <span><h3 style="max-width:200px;">Manage Tasks</h3></span>
            </div>
            <div class="right_area">
                <a href="LogoutProcess" class="logout_btn">Logout</a> 
            </div>
        </header>
        <!--header area end-->

        <!--mobile navigation bar start-->
        <div class="mobile_nav">
            <div class="nav_bar">
                <img src="<%out.print("/Files/" + picture);%>" class="mobile_profile_image" id="photo" alt="profile">
                <i class="fa fa-bars nav_btn"></i>
            </div>
            <div class="mobile_nav_items">

                <a href="#" style="background: #CCCFFF;"><i class="fas fa-user-friends"></i><span>Manage Tasks</span></a>
                <a href="Project_Manager_Completed.jsp"><i class="fas fa-user"></i><span>Completed</span></a>
                <a href="Project_Manager_Cancelled.jsp"><i class="fas fa-user-minus"></i><span>Cancelled</span></a>
                <a href="Project_Manager_IP.jsp" ><i class="fas fa-user-clock"></i><span>In Progress</span></a>
                <a href="Project_Manager_Flagged.jsp" ><i class="fas fa-user-friends"></i><span>Flagged</span></a>
            </div>
        </div>
        <!--mobile navigation bar end-->

        <!--sidebar start-->
        <div class="sidebar">
            <div class="profile_info">
                <img src="<%out.print("/Files/" + picture);%>" class="profile_image" alt="" id="photo">
                <h4 id="Name"><%out.print(username);%></h4>

            </div>

            <a href="#" style="background: #CCCFFF;"><i class="fas fa-user-friends"></i><span>Manage Tasks</span></a>
            <a href="Project_Manager_Completed.jsp"><i class="fas fa-user"></i><span>Completed</span></a>
            <a href="Project_Manager_Cancelled.jsp"><i class="fas fa-user-minus"></i><span>Cancelled</span></a>
            <a href="Project_Manager_IP.jsp" ><i class="fas fa-user-clock"></i><span>In Progress</span></a>
            <a href="Project_Manager_Flagged.jsp" ><i class="fas fa-user-friends"></i><span>Flagged</span></a>
        </div>
        <!--sidebar end-->

        <div class="content">
            <div class="container" style="margin-top:10px">

                <div>
                    <a href="New_Task_Form.jsp" class="create_btn">Create New Tasks</a> 
                </div>
            </div>

            <!--table start-->
            <table class="table">
                <thead>
                    <tr>
                        <th>Task No.</th>
                        <th>Title</th>
                        <th>Task Description</th>
                        <th>Subtasks</th>
                        <th>Date Created</th>
                        <th>Deadline</th>
                        <th>Assigned to</th>
                        <th>Edit</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String sql = "SELECT * FROM Task_Assignment";

                        try {

                            Connection con = null;
                            PreparedStatement stmt = null;
                            PreparedStatement stmt2 = null;
                            PreparedStatement stmt3 = null;

                            Class.forName("org.sqlite.JDBC");
                            con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");

                            stmt = con.prepareStatement(sql);
                            ResultSet rs = stmt.executeQuery();

                            while (rs.next()) {

                    %>

                    <tr>
                        <th class="sm-mmargin"><%out.println(rs.getString("TaskID"));%></th>
                        <td data-title="Title"><%out.println(rs.getString("Title"));%></td>

                        <td data-title="Task Description"><button type="button" class="button" name="Open" data-toggle="modal" data-target="#<%out.print(rs.getString("TaskID"));%>"><i id="descript_btn" class="fas fa-exclamation-circle"></i> </button></td>
                        <%
                            String sql2 = "SELECT * FROM SubTasks WHERE TaskID ='" + rs.getString("TaskID") + "'";
                            stmt2 = con.prepareStatement(sql2);
                            ResultSet rs2 = stmt2.executeQuery();

                        %>

                        <td data-title="Subtasks">
                            <ul >
                                <%while (rs2.next()) {%>
                                <li><%out.println(rs2.getString("Task"));%></li><%}%>
                            </ul>
                        </td>
                        <td data-title="Date Created"><%out.println(rs.getString("DateCreate"));%></td>
                        <td data-title="Deadline"><%out.println(rs.getString("Deadline"));%></td>
                        <td data-title="Assigned on">
                            <ul>
                                <%
                                    String sql3 = "SELECT * FROM Assignment LEFT JOIN Emp_Info ON Emp_Info.ID = Assignment.EmpID WHERE TaskID = '" + rs.getString("TaskID") + "'";
                                    stmt3 = con.prepareStatement(sql3);
                                    ResultSet rs3 = stmt3.executeQuery();

                                    while (rs3.next()) {
                                        
                                        
                                    
                                %>

                                <li>
                                    <img src="<%out.println("/Files/" + rs3.getString("picture"));%>" class="tableimg">
                                <figcaption><%out.println(rs3.getString("name"));%></figcaption>
                                </li><%
                                    }%>

                            </ul>
                        <td data-title="Edit"><a href="Edit_Task.jsp?value=<%out.print(rs.getString("TaskID"));%>"><i class="fas fa-edit"></i></a></td>
                        <td data-title="Status"><button type="button" name="complete" class="<%out.println(rs.getString("Status"));%>"><%out.println(rs.getString("Status"));%></button></td>

                    </tr>


                    <%

                        }


                    %>

                </tbody>
            </table>
            <br><br>
            <!--Modal Task Desc-->

            <%    stmt = con.prepareStatement(sql);
                rs = stmt.executeQuery();

                while (rs.next()) {

            %>
            <div class="modal fade" id="<%out.print(rs.getString("TaskID"));%>" tabindex="-1" role="dialog" aria-labelledby="<%out.print(rs.getString("TaskID"));%>" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h3 class="modal-title" id="exampleModalLongTitle">Description</h3>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <%out.println(rs.getString("TaskDesc"));%>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">Close</button>

                        </div>
                    </div>
                </div>
            </div>

        </div>
        <%
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                System.out.println("SQL Exception" + e.getMessage());
            }


        %>
        <script type="text/javascript">
            $(document).ready(function () {
                $('.nav_btn').click(function () {
                    $('.mobile_nav_items').toggleClass('active');
                });
            });

            document.getElementById('edit').addEventListener("click", function () {
                document.querySelector('.bg-modal').style.display = "flex";
            });

            document.querySelector('.close').addEventListener("click", function () {
                document.querySelector('.bg-modal').style.display = "none";
            });
        </script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

    </body>
</html>
