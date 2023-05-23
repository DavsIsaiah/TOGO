<%-- 
    Document   : New_Task_Form
    Created on : Feb 4, 2022, 1:06:23 PM
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
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Task Form</title>
        <link rel="stylesheet" href="CSS/New_Task_Form.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    </head>
    <body>
        <!--Checking validity of session-->
        <%
            ServletContext context = request.getServletContext();
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
        <div class="wrapper">

            <div class="title">
                Create New Task
            </div>
            <form id="myform" action="InputTaskDB" method="POST" enctype="multipart/form-data" onsubmit="return validate()">
                <input type="text" id="Index" name="Index" value="" class="input" hidden>
                <input type="text" id="tasks" name="tasks" value="" class="input" hidden>
                <input type="hidden" id="multipleSelectValues" name="multipleSelectValues" />

                <div class="form">
                    <div class="inputfield">
                        <label for="Title">Title</label>
                        <input type="text" id="Title" name="Title" value=""class="input" required>
                    </div>  
                    <div class="inputfield">
                        <label for="SubTitle">Task Description</label>
                        <input type="textarea" id="SubTitle" name="SubTitle" value=""class="input" required>
                    </div>  
                    <div id="myDIV" class="header">
                        <h3>Subtask List</h3>
                        <input type="text" id="myInput" placeholder="Type here">
                        <span onclick="newElement()" class="addBtn">Add</span>
                    </div>
                    <ul id="myUL">

                    </ul>
                    <br><br>

                    <div class="inputfield">
                        <label for="Deadline">Deadline</label>
                        <input type="date" id="Deadline" name="Deadline" value="" class="input" required>
                    </div>



                    <div class="inputfield">
                        <label for="assignment">Assigned to</label>
                        <div class="chosen-select" >
                            <select id="assignment" name="multipleSelect" multiple required>
                                <%                                    try {

                                        Connection con = null;
                                        PreparedStatement stmt = null;

                                        Class.forName("org.sqlite.JDBC");
                                        con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");

                                        String sql2 = "select ID, name from Emp_Info";

                                        stmt = con.prepareStatement(sql2);
                                        ResultSet rs = stmt.executeQuery();

                                        while (rs.next()) {

                                %>


                                <option value="<%out.println(rs.getString("ID"));%>"><%out.println(rs.getString("name"));%></option>
                                <%

                                        }
                                        if (con != null) {
                                            con.close();
                                        }
                                    } catch (SQLException e) {
                                        System.out.println("SQL Exception" + e.getMessage());
                                    }


                                %>
                            </select>


                        </div>
                    </div> 

                    <div class="inputfield">
                        <label for="Status">Status</label>
                        <div class="custom_select" required>
                            <select id="Status" name="Status">
                                <option value="Progress">In Progress</option>
                            </select>
                        </div>
                    </div> 
                    <div class="inputfield">
                        <input type="submit" value="Create" class="btn">
                    </div>
                    <div class="inputfield">
                        <input type="button" value="Go back!" class="btn" onclick="history.back()">
                    </div>
                </div>
            </form>
        </div>	

        <script>
            $("select[name='multipleSelect']").change(function () {
                var arr = $("select[name='multipleSelect']").val(); //automatically creates an array of selected values
                var foo = arr.join(","); //creates a comma delimited string (i.e:'ring,necklace')
                $("#multipleSelectValues").val(foo); //update hidden field value
            });
            //Variable Index


            var index = 0;
            var indexhold = 1;
            var check = true;
            var arrayIndex = new Array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
            var arrayRemoved = new Array();
            var append = new Array();
            // Create a "close" button and append it to each list item


            // Click on a close button to hide the current list item
            var close = document.getElementsByClassName("close");
            var i = 0;

            for (i = 0; i < close.length; i++) {
                close[i].onclick = function () {
                    var div = this.parentElement;

                    div.remove();

                };
            }

            function validate() {
                var close = document.getElementsByClassName("close");
                for (i = 0; i < close.length; i++) {
                    append.push(close[i].title);
                }
                var tasks = document.getElementById("tasks");
                tasks.setAttribute('value', append);
                return true;
            }





            // Create a new list item when clicking on the "Add" button
            function newElement() {
                if (index > 9) {
                    alert("Maximum of 10 Subtasks Only!");
                } else {

                    var li = document.createElement("li");
                    var inputValue = document.getElementById("myInput").value;
                    var t = document.createTextNode(inputValue);
                    li.appendChild(t);
                    if (inputValue === '') {
                        alert("You must write something!");
                        index--;
                    } else {
                        document.getElementById("myUL").appendChild(li);
                    }
                    document.getElementById("myInput").value = "";

                    var span = document.createElement("SPAN");
                    var txt = document.createTextNode("\u00D7");
                    span.className = "close";

                    if (arrayRemoved.length === 0) {
                        var indexShift = arrayIndex[0];
                        span.setAttribute('id', indexShift);
                        span.setAttribute('title', inputValue);
                        span.setAttribute('name', indexShift);

                    } else {
                        var removeShift = arrayRemoved[0];
                        span.setAttribute('id', removeShift);
                        span.setAttribute('title', inputValue);
                        span.setAttribute('name', removeShift);

                    }

                    span.appendChild(txt);
                    li.appendChild(span);
                    index++;


                    var inputIndex = document.getElementById("Index");
                    inputIndex.setAttribute('value', index);
                    close = document.getElementsByClassName("close");

                    for (i = 0; i < close.length; i++) {
                        close[i].onclick = function () {
                            var div = this.parentElement;
                            div.remove();



                        };
                    }



                }
            }





            //for the chosen-select
            $(".chosen-select").chosen({
                no_results_text: "Oops, nothing found!"

            });
        </script>

    </body>
</html>
