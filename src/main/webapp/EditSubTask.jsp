<%-- 
    Document   : EditSubTask
    Created on : Feb 6, 2022, 3:30:44 PM
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
        <link rel="stylesheet" href="CSS/New_Task_Form.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <title>Edit SubTasks</title>
        <%
            String ID = request.getParameter("value");
            int index = 1;
            int indexx = 1;
        %>
    </head>
    <body>
        <div class="wrapper">

            <div class="title">
                Edit Task
            </div>
            <form id="myform" action="SubTaskEditDB?value=<%out.print(ID);%>" method="POST" enctype="multipart/form-data" onsubmit="return validate()">
                <input type="text" id="check" name="check" class="input" hidden>
                <input type="text" id="tasks" name="tasks" class="input" hidden>
                <div class="form">
                    <div id="myDIV" class="header">
                        <h3>Subtask List</h3>
                    </div>
                    <ul id="myUL">
                        <%
                            Connection con = null;
                            PreparedStatement stmt = null;

                            Class.forName("org.sqlite.JDBC");
                            con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");
                            String sql = "SELECT Task, Checked FROM SubTasks WHERE TaskID = '" + ID + "'";
                            stmt = con.prepareStatement(sql);
                            ResultSet rs = stmt.executeQuery();
                            while (rs.next()) {
                        %>

                        <li title="<%out.print(rs.getString("Task"));%>" class="<%out.print(rs.getString("Checked"));%>"><%out.println(rs.getString("Task"));%></li>


                        <%
                                index++;
                            }
                            indexx = index;

                        %>
                    </ul>
                    <div class="inputfield">
                        <input type="submit" value="Save" class="btn">
                    </div>
                    <div class="inputfield">
                        <input type="button" value="Go back!" class="btn" onclick="history.back()">
                    </div>
                </div>
            </form>
        </div>
        <script>
            var nodeListLI = document.querySelectorAll("li");
            var i;
            var checked = new Array();
            var tasks = new Array();
            for (i = 0; i < nodeListLI.length; i++) {
                nodeListLI[i].onclick = function () {
                    var div = this;
                    if (div.classList.contains('checked')) {
                        div.setAttribute("class", "");
                    } else {
                        div.setAttribute("class", "checked");
                    }

                };
            }


            function validate() {
                var nodeListLI = document.querySelectorAll("li");
                var i;
                for (i = 0; i < nodeListLI.length; i++) {
                    if (nodeListLI[i].classList.contains('checked')) {
                        checked.push(nodeListLI[i].title);
                    } else {
                        tasks.push(nodeListLI[i].title);
                    }
                }

                var task = document.getElementById("tasks");
                task.setAttribute('value', tasks);
                var check = document.getElementById("check");
                check.setAttribute('value', checked);

                return true;
            }

        </script>
    </body>
</html>
