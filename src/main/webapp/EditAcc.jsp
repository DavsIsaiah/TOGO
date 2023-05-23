<%-- 
    Document   : EditAcc
    Created on : Jan 12, 2022, 8:36:36 PM
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
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Account Settings</title>
        <link rel="stylesheet" href="CSS/New_Employee.css" type="text/css"/>






        <style>
            #parent #popup {
                display: none;
            }

            #parent:hover #popup {
                display: block;
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


        <div class="wrapper">

            <div class="title">
                Edit Account
            </div>
            <form action ="UpdateAccountDB" method="POST" enctype="multipart/form-data">
                <div id="parent">
                    <div class="profile-pic" >


                        <label>

                            <img src="Assets/profile_upload.png">
                            <input type="file" name="file" style="display:none" id="file">
                        </label>

                    </div>
                    <div id="popup" class="inputfield" style="text-align:center;">Click the image to upload a picture.</div></div>
                <div class="form">
                    <div class="inputfield">
                        <label for="user">Username
                            <input type="text" id="Name" name="user"  value=""  class="input" required>
                        </label>
                    </div>  

                    <div class="inputfield">
                        <label for="pass">Password
                            <input type="Password" id="Password" name="pass" value="" class="input" required>
                        </label>
                    </div> 

                    <div class="inputfield">
                        <input type="submit" class="btn" name="update"/>
                    </div>
                    <div class="inputfield">
                        <input type="reset" class="btn" name="delete"/>
                    </div>
                    <div class="inputfield">
                        <input type="button" value="Go back!" class="btn" onclick="history.back()">
                    </div>
                </div>
            </form>

        </div>	
        <script>

            $().ready(function () {
                $('[type="file"]').change(function () {
                    var fileInput = $(this);
                    if (fileInput.length && fileInput[0].files && fileInput[0].files.length) {
                        var url = window.URL || window.webkitURL;
                        var image = new Image();
                        image.onload = function () {
                            alert('Valid Image');
                        };
                        image.onerror = function () {
                            alert('Invalid image');
                            $('[type="file"]').val("");
                        };
                        image.src = url.createObjectURL(fileInput[0].files[0]);
                    }
                });
            });
        </script>
    </body>
</html>
