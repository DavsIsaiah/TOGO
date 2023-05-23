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
          String username = (String)context.getAttribute("username");
          String password = (String)context.getAttribute("password");
          String picture = null;
          try{
            
                  Connection con = null;
                  PreparedStatement stmt = null;

      Class.forName("org.sqlite.JDBC");
      con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");
    
      String sql2 = "select picture from credentials where picture IS NOT NULL AND username= '" + username + "' and password = '" + password + "'";
    
      stmt = con.prepareStatement(sql2);
      ResultSet rs = stmt.executeQuery();
    
    
      while(rs.next()){
          picture = rs.getString("picture");
        
      }
      if(con!= null){
              con.close();
          }
          }
          catch (SQLException e){
              System.out.println("SQL Exception" +e.getMessage());
          }


        %>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Employee Attendance</title>
        <link rel="stylesheet" href="CSS/attendance.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.1/css/all.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js" charset="utf-8"></script>

    </head>




    <body onload="startTime()">

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




        <div class="hc">
            <div class="div-1">
                <p id="date"></p>
                <p>&emsp;|&emsp;</p>
                <p id="time"></p>
            </div>
            <div class="div-2">
                <img src="<%out.print("/Files/" + picture);%>" id="photo" alt="profile">
                </br>
                <h1>Good day, <%out.println(username);%>!</h1>
            </div>
        </div>
        <div class="rightdiv" style="padding-bottom: 100px;">
            <form method="POST" action="TimeInEmp" enctype="multipart/form-data">
                <input type="date" id="datePicker" hidden="true" name="date"/>
                <input type="text" id="hour" hidden="true" name="hour"/>
                <input type="text" id="minute" hidden="true" name="minute"/>

                <button type="submit" class="btn"><i class="far fa-check-circle"></i></button>
            </form>
            <p>Time In</p>
            </br>
            <form method="POST" action="TimeOutEmp" enctype="multipart/form-data">
                <input type="date" id="datePicker2" hidden="true" name="date"/>
                <input type="text" id="hour2" hidden="true" name="hour"/>
                <input type="text" id="minute2" hidden="true" name="minute"/>    


                <button type="submit" class="btn"><i class="far fa-times-circle"></i></button>
            </form>
            <p>Time Out</p>
            <button onclick="history.back()" class="btn"><i class="far fa-arrow-alt-circle-left"></i></button>
            
            <p>Back</p>
        </div>
        <script type="text/javascript">
            function startTime()
            {
                var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
                var today = new Date();
                var h = today.getHours();
                var m = today.getMinutes();
                var s = today.getSeconds(); /*seconds not shown anymore*/
                var da = today.getDate();
                var mo = today.getMonth();
                var ye = today.getFullYear();




                var mos = h.toString();
                var yes = m.toString();

                // add a zero in front of numbers<10
                m = checkTime(m);
                s = checkTime(s);
                document.getElementById('time').innerHTML = h + ":" + m;
                document.getElementById('date').innerHTML = months[mo] + " " + da + ", " + ye;
                document.getElementById('datePicker').value = new Date().toISOString().substring(0, 10);
                document.getElementById('datePicker2').value = new Date().toISOString().substring(0, 10);
                document.getElementById('hour').value = h;
                document.getElementById('minute').value = m;
                document.getElementById('hour2').value = h;
                document.getElementById('minute2').value = m;

                t = setTimeout('startTime()', 500);
            }
            function checkTime(i)
            {
                if (i < 10)
                {
                    i = "0" + i;
                }
                return i;
            }



        </script>

    </body>





</html>

