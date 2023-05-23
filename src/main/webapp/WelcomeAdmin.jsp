<%-- 
    Document   : Welcome
    Created on : Jan 7, 2022, 11:08:34 AM
    Author     : Isaiah Dava
--%>

<%@page import="java.util.Calendar"%>
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
        <%
            ServletContext context = request.getServletContext();
            String username = (String) context.getAttribute("username");
            String password = (String) context.getAttribute("password");
            String picture = null;
            String Check = (String)context.getAttribute("Changed");
        
       if(Check.equals("NO")){
           
        %>
        <script>

            alert("Please Change your Password!");
            window.location.href = "EditAcc.jsp";

        </script>
        <%
    }
            
            
            
            
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
        <meta charset="UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet"> 
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
        <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="CSS/Employee_Overview.css" type="text/css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.1/css/all.min.css" type="text/css" />
        <title>Admin</title>
        <style>
            .welcomerectangle {
                position: relative;
                top: 200px;
                height: 120px;
                width: 100%;
                background-color:  #CCCFFF;
                font-size: 55px;
                text-align: center;
                padding-top: 20px;
                font-family:'Montserrat', sans-serif; 

            }


            .button {
                border: none;
                background-color: #404480;
                border-radius: 25px;
                text-align: center;
                cursor: pointer;
                height: 180px;
                width: 180px;
                margin-top: 20px; 
            }

            .button2 {
                border: none;
                background-color: #404480;
                border-radius: 25px;
                text-align: center;
                cursor: pointer;
                height: 180px;
                width: 180px;
                margin-top: 20px; 
            }


            .label {
                font-family:'Montserrat', sans-serif; 
                font-weight: 600;  
                font-size: 30px;
                text-align: center;
            }

            .mycentered-text {
                text-align:center
            }

            .picture {
                height: 900px;
                width: 100%;
                margin: 0px;
                padding: 0%;
                left: -217px;
                display: block;
            }

            .picture2 {
                height: 100%;
                width: 100%;
                margin: 0px;
                padding: 0%;
                left: -217px;
                display: block;
            }

            .jumbotron{ 
                position: relative;
                margin-top:120px;
                background: #CCCFFF;
                text-align:center;
                margin-bottom: 0 !important;
                padding-top: 10px;
                padding-bottom: 10px;

            }

            .bg { 
                background-image: url("https://mdbootstrap.com/img/Photos/Horizontal/Nature/full%20page/img(20).jpg");
                height: 100%; 
                background-position: center;
                background-repeat: no-repeat;
                background-size: cover;
            }

        </style>
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

        <header>

            <div class="left_area">

            </div>
            <div class="right_area" style="padding-top: 10px;">
                <a href="LogoutProcess" class="logout_btn">Logout</a> 
            </div>
        </header>
        <div class="mycentered-text">   
            <div class="jumbotron jumbotron-fluid text-center">

                <div class="container">

                    <h1 class="display-4">Welcome, <%out.println(username);%>!</h1>
                    <!-- <p class="lead">This is a modified jumbotron that occupies the entire horizontal space of its parent.</p> -->
                </div>
            </div> 
        </div> 
        <div class="container">
            <div class="row">
                <div class="col"> 
                    <div class="mycentered-text"> 
                        <div class="btn-group">
                            <form method="post" action="Employee_Overview.jsp">
                                <button class="btn btn-primary button mx-auto d-block"><img src="Assets/employee.png" width= 100px height= 100px/></button>
                            </form>
                        </div>    
                    </div>
                </div>
                <div class="col"> 
                    <div class="mycentered-text">
                        <div class="btn-group">
                            <form action="Attendance_Admin.jsp" method="POST">
                                <button type="submit" class="btn btn-primary button mx-auto d-block"><img src="Assets/attendance.png" width= 100px height= 100px/></button>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <div class="mycentered-text">
                        <div class="btn-group">
                            <form action="Project_Manager.jsp" method="POST">
                                <button class=" btn-primary button mx-auto d-block"><img src="Assets/project.png" width= 100px height= 100px/></button>
                            </form>
                        </div>
                    </div>
                </div> 
            </div>
            <div class="row">
                <div class="col"> 
                    <h1 class="label"> Employee </h1>
                </div>
                <div class="col"> 
                    <h1 class="label"> Attendance </h1>
                </div>
                <div class="col"> 
                    <h1 class="label"> Project Manager </h1>
                </div>  
            </div>

            <div class="row justify-content-center">
                <div class="col-md-4">
                    <div class="mycentered-text">
                        <div class="btn-group">
                            <form method="post" action="SalaryOverview.jsp">
                                <button class=" btn-primary button2 mx-auto d-block"><img src="Assets/salary.png" width= 100px height= 100px/></button>
                            </form>
                        </div>
                    </div>
                </div> 
                <div class="col-md-4">
                    <div class="mycentered-text">
                        <div class="btn-group">
                            <form method="post" action="TasksAdmin.jsp">
                                <button type="submit" class=" btn-primary button2 mx-auto d-block"><img src="Assets/tasks.png" width= 100px height= 100px/></button>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <div class="mycentered-text">
                        <div class="btn-group">
                            <form method="post" action="EditAcc.jsp">
                                <button type="submit" class=" btn-primary button mx-auto d-block"><img src="Assets/settings.png" width= 100px height= 100px/></button>
                            </form>
                        </div>
                    </div>
                </div>  
            </div>

            <div class="row justify-content-center">
                <div class="col-md-4"> 
                    <h1 class="label"> Salary </h1>
                </div>
                <div class="col-md-4"> 
                    <h1 class="label"> View Tasks </h1>
                </div>
                <div class="col-md-4"> 
                    <h1 class="label"> Account Settings </h1>
                </div>   
            </div>

        </div>    

    </body>
</html>
