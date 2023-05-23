<%-- 
    Document   : WelcomeEmployee
    Created on : Jan 12, 2022, 7:38:17 PM
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
        <%
       ServletContext context = request.getServletContext();
       String username = (String)context.getAttribute("username");
       String password = (String)context.getAttribute("password");
       String Check = (String)context.getAttribute("Changed");
        
       if(Check.equals("NO")){
           
        %>
        <script>

            alert("Please Change your Password!");
            window.location.href = "EditAcc.jsp";

        </script>
        <%
    }
    String picture = null;
    String ID = null;
    try{
            
            Connection con = null;
            PreparedStatement stmt = null;
            PreparedStatement stmt2 = null;
            PreparedStatement stmt3 = null;
            PreparedStatement stmt4 = null;

Class.forName("org.sqlite.JDBC");
con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");
    
String sql2 = "select picture, ID from credentials where picture IS NOT NULL AND username= '" + username + "' and password = '" + password + "'";
    
stmt = con.prepareStatement(sql2);
ResultSet rs = stmt.executeQuery();
    
    
while(rs.next()){
    picture = rs.getString("picture");
    ID = rs.getString("ID");
     String sql = "select * from Emp_Info WHERE ID ='"+ID+"'";
     stmt2 = con.prepareStatement(sql);
     ResultSet rs2 = stmt2.executeQuery();
     while(rs2.next()){
         
     if(rs2.getInt("Flags") >= 3){
String sql3 ="UPDATE Emp_Info SET Status ='Probation' WHERE ID='"+ID+"'";
    stmt3 = con.prepareStatement(sql3);
    stmt3.executeUpdate();
if(rs2.getString("Once").equals("0")){
        %>
        <script>
            alert("Because of the Number of Flags, you have been set to a Probationary Status!");
        </script>
        <%
            String sql4 ="UPDATE Emp_Info SET Once ='1' WHERE ID='"+ID+"'";
                stmt4 = con.prepareStatement(sql4);
                stmt4.executeUpdate();
                }
        }

                }


            }

    



            if(con!= null){
                    con.close();
                }
                }
                catch (SQLException e){
                    System.out.println("SQL Exception" +e.getMessage());
                }


        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet"> 
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
        <title>Employee</title>
        <link rel="stylesheet" href="CSS/Employee_Overview.css" type="text/css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.1/css/all.min.css" type="text/css" />
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
                height: 200px;
                width: 200px;
                margin-top: 60px;

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

                margin-top:150px !important;
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

        <header>

            <div class="left_area">

            </div>
            <div class="right_area" style="padding-top: 10px;">
                <a href="LogoutProcess" class="logout_btn">Logout</a> 
            </div>
        </header>
        <!--Checking validity of session-->
        <%
        HttpSession nsession = request.getSession(false);
        if(nsession == null || session.getAttribute("loggedInUser") == null){
        %>
        <script>

            alert("Session is not active!");
            window.location.href = "index.html";

        </script>
        <%
    }
        %>


        <!-- <div class="welcomerectangle"> Welcome, User </div> -->
        <!-- <div class="jumbotron text-center">
            <h1>My First Bootstrap Page</h1>
            <p>Resize this responsive page to see the effect!</p> 
          </div> -->

        <div class="jumbotron jumbotron-fluid text-center">
            <div class="container">
                <h1 class="display-4">Welcome, <%out.println(username);%>!</h1>
                <!-- <p class="lead">This is a modified jumbotron that occupies the entire horizontal space of its parent.</p> -->
            </div>
        </div>  
        <div class="container">
            <div class="row">
                <div class="col"> 
                    <div class="mycentered-text"> 
                        <div class="btn-group">
                            <form method="POST" action="attendance.jsp">
                                <button type="submit" class="btn btn-primary button mx-auto d-block"><img src="Assets/attendance.png" width= 100px height= 100px/></button>
                            </form>
                        </div>    
                    </div>
                </div>
                <div class="col"> 
                    <div class="mycentered-text">
                        <div class="btn-group">
                            <form method="post" action="SalaryView.jsp">
                            <button class="btn btn-primary button mx-auto d-block"><img src="Assets/salary.png" width= 100px height= 100px/></button>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <div class="mycentered-text">
                        <div class="btn-group">
                            <form method="post" action="TasksEmp.jsp">
                            <button class=" btn-primary button mx-auto d-block"><img src="Assets/tasks.png" width= 100px height= 100px/></button>
                            </form>
                        </div>
                    </div>
                </div>  
                <div class="col">
                    <div class="mycentered-text">
                        <div class="btn-group">
                            <div class="btn-group"> <form method="post" action="EditAcc.jsp">
                                <button type="submit" class=" btn-primary button mx-auto d-block"><img src="Assets/settings.png" width= 100px height= 100px/></button>
                            </form>
                        </div>
                    </div>
                </div>  
            </div>
                </div>
            <div class="row">
                <div class="col"> 
                    <h1 class="label">Attendance</h1>
                </div>
                <div class="col"> 
                    <h1 class="label">Salary</h1>
                </div>
                <div class="col"> 
                    <h1 class="label">Tasks</h1>
                </div>  
                <div class="col" > 
                    <h1 class="label">Account Settings</h1>
                </div>
            </div>
        </div>
        

        <!-- <div class="col">
                   <button class="button"> </button>
               </div>
               <div class="col">
                   <button class="button"> </button>
               </div>
               <div class="col">
                   <button class="button"> </button>
               </div> -->



        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    </body>
</html>
