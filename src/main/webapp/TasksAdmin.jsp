<%-- 
    Document   : TasksAdmin
    Created on : Feb 5, 2022, 8:28:06 PM
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
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>View Task Admin</title>
        <link rel="stylesheet" href="CSS/View_Task_Admin.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.1/css/all.min.css">
        <link rel="stylesheet" href="https://unicons.iconscout.com/release/v2.1.6/css/unicons.css">
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
        <header>
            <label for="check">
                <i class="fas fa-bars" id="sidebar_btn"></i>
            </label>
            <div class="left_area"><a href="WelcomeAdmin.jsp">
                    <img src="Assets/light purp.png" alt="logo"/></a>
                    <h3><span>TASK OVERVIEW</span></h3>
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

                <a href="#" style="background: #CCCFFF;"><i class="fas fa-search"></i><span>Task Overview</span></a>

            </div>
        </div>
        <!--mobile navigation bar end-->

        <!--sidebar start-->
        <div class="sidebar">
            <div class="profile_info">
                <img src="<%out.print("/Files/" + picture);%>" class="profile_image" alt="" id="photo">
                <h4 id="Name"><%out.println(username);%></h4>

            </div>
            <a href="#" style="background: #CCCFFF;"><i class="fas fa-search"></i><span> Task Overview</span></a>

        </div>
        <!--sidebar end-->

        <%
            Connection con = null;
            PreparedStatement stmt = null;
            int index = 1;
            try {

                Class.forName("org.sqlite.JDBC");
                con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");

                String sql2 = "SELECT * FROM Task_Assignment";

                stmt = con.prepareStatement(sql2);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {

        %>


        <!-- The Modals -->
        <div id="<%out.print(rs.getString("TaskID"));%>" class="modal">
            <div class="modal-content">
                <span class="close" name="1">&times;</span>
                <p><%out.print(rs.getString("TaskDesc"));%></p>
            </div>
        </div>
        <%}
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                System.out.println("SQL Exception" + e.getMessage());
            }

        %>
        <!--My modal ends here-->

        <div class="content">

            <!-- Accordion starts here -->
            <h3 class="sectheader">Completed Tasks</h3>
            <section>
                <div class="container">
                    <div class="accordion">	
                        <%                                    //Completed Query
                            Class.forName("org.sqlite.JDBC");
                            con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");

                            String sql = "SELECT * FROM Task_Assignment WHERE Status='Completed'";
                            stmt = con.prepareStatement(sql);
                            ResultSet rs = stmt.executeQuery();

                            while (rs.next()) {

                        %>
                        <div class="accordion-item" id="<%out.print(rs.getString("Title")+index);%>">
                            <a class="accordion-link" href="#<%out.print(rs.getString("Title")+index);%>" onclick="javascript:void(0);">
                                <div class="flex">
                                    <h3 id="task_title"><%out.print(rs.getString("TaskID") + ". " + rs.getString("Title") + "- Completed on " + rs.getString("DateComplete"));%></h3> 
                                    <button id="0" name="<%out.print(rs.getString("TaskID"));%>" class="modal-button"><i id="descript_btn" class="fas fa-exclamation-circle"></i></button>
                                    <i class="icon icon-md-arrow-forward"></i>
                                    <i class="icon icon-md-arrow-down"></i>

                            </a>
                        </div>
                        <div class="answer">
                            <div class="row">
                                <div class="column">
                                    <p> Subtasks:</p>
                                    <ul id="myUL">
                                        <%
                                            index++;
                                            String sql2 = "SELECT * FROM SubTasks WHERE TaskID ='" + rs.getString("TaskID") + "'";
                                            PreparedStatement stmt2 = null;
                                            stmt2 = con.prepareStatement(sql2);
                                            ResultSet rs2 = stmt2.executeQuery();
                                            while (rs2.next()) {

                                        %>
                                        <!-- hardcoded na subtasks toh tanggalin niyo if gusto niyo itest-->
                                        <li><%out.print(rs2.getString("Task"));%></li><%}%>

                                    </ul>
                                </div>
                            </div>
                            <div class="column">
                                <p> Date Created: <%out.println(rs.getString("DateCreate"));%></p>
                                <p> Assigned on:</p>
                                <ol id= "right_area_column">
                                    <%

                                        String sql3 = "SELECT * FROM Assignment LEFT JOIN Emp_Info ON Assignment.EmpID = Emp_Info.ID WHERE TaskID = '" + rs.getString("TaskID") + "'";
                                        PreparedStatement stmt3 = null;
                                        stmt3 = con.prepareStatement(sql3);
                                        ResultSet rs3 = stmt3.executeQuery();
                                        while (rs3.next()) {

                                    %>
                                    <li>
                                        <%out.print(rs3.getString("name"));%>
                                    </li><%}%>
                                </ol>
                                <br><br>

                            </div>
                        </div>
                        <hr>
                    </div><%}%>

                </div>	
        </div>
    </section>



    <h3 class="sectheader">Pending Tasks</h3>
    <section>
        <div class="container">
            <div class="accordion">	
                <%
                    //Pending Query
                    String sql7 = "SELECT * FROM Task_Assignment WHERE Status='In Progress'";
                    PreparedStatement stmt7 = con.prepareStatement(sql7);
                    ResultSet rs7 = stmt7.executeQuery();

                    while (rs7.next()) {

                %>
                <div class="accordion-item" id="<%out.print(rs7.getString("Title")+index);%>">
                    <a class="accordion-link" href="#<%out.print(rs7.getString("Title")+index);%>" onclick="javascript:void(0);">
                        <div class="flex">
                            <h3 id="task_title"><%out.print(rs7.getString("TaskID") + ". " + rs7.getString("Title") + "- Due on " + rs7.getString("Deadline"));%></h3> 
                            <button id="myBtn3"  name="<%out.print(rs7.getString("TaskID"));%>"class="modal-button">	<i id="descript_btn" class="fas fa-exclamation-circle"></i></button>
                            <i class="icon ion-md-arrow-forward"></i>
                            <i class="icon ion-md-arrow-down"></i>

                    </a>
                </div>
                <div class="answer">
                    <div class="row">
                        <div class="column">
                            <p> Subtasks:</p>
                            <ul id="myUL">
                                <%
                                    index++;
                                    String sql8 = "SELECT * FROM SubTasks WHERE TaskID ='" + rs7.getString("TaskID") + "'";
                                    PreparedStatement stmt8 = null;
                                    stmt8 = con.prepareStatement(sql8);
                                    ResultSet rs8 = stmt8.executeQuery();
                                    while (rs8.next()) {

                                %>
                                <!-- hardcoded na subtasks toh tanggalin niyo if gusto niyo itest-->
                                <li><%out.print(rs8.getString("Task"));%></li><%}%>
                            </ul>
                        </div>
                    </div>
                    <div class="column">
                        <p> Date Created: <%out.println(rs7.getString("DateCreate"));%></p>
                        <p> Assigned on:</p>
                        <ol id= "right_area_column">
                            <%

                                String sql9 = "SELECT * FROM Assignment LEFT JOIN Emp_Info ON Assignment.EmpID = Emp_Info.ID WHERE TaskID = '" + rs7.getString("TaskID") + "'";
                                PreparedStatement stmt9 = null;
                                stmt9 = con.prepareStatement(sql9);
                                ResultSet rs9 = stmt9.executeQuery();
                                while (rs9.next()) {

                            %>
                            <li>
                                <%out.print(rs9.getString("name"));%>
                            </li><%}%>

                        </ol>
                        <br><br>

                    </div>
                </div>
                <hr>
            </div>
            <%
                }
            %>
        </div>
    </div>
</section>

<h3 class="sectheader">Flagged Tasks</h3>
<section>
    <div class="container">
        <div class="accordion">	
            <%
                //Query Flagged
                String sql10 = "SELECT * FROM Task_Assignment WHERE Status='Flagged'";
                PreparedStatement stmt10 = con.prepareStatement(sql10);
                ResultSet rs10 = stmt10.executeQuery();

                while (rs10.next()) {

            %>
            <div class="accordion-item" id="<%out.print(rs10.getString("Title")+index);%>">
                <a class="accordion-link" href="#<%out.print(rs10.getString("Title")+index);%>" onclick="javascript:void(0);">
                    <div class="flex">
                        <h3 id="task_title"><%out.print(rs10.getString("TaskID") + ". " + rs10.getString("Title") + "- Due on " + rs10.getString("Deadline"));%></h3> 
                        <button id="myBtn4"  name="<%out.print(rs10.getString("TaskID"));%>"class="modal-button">	<i id="descript_btn" class="fas fa-exclamation-circle"></i></button>
                        <i class="icon ion-md-arrow-forward"></i>
                        <i class="icon ion-md-arrow-down"></i>

                </a>
            </div>
            <div class="answer">
                <div class="row">
                    <div class="column">
                        <p> Subtasks:</p>
                        <ul id="myUL">
                            <%
                                index++;
                                String sql11 = "SELECT * FROM SubTasks WHERE TaskID ='" + rs10.getString("TaskID") + "'";
                                PreparedStatement stmt11 = null;
                                stmt11 = con.prepareStatement(sql11);
                                ResultSet rs11 = stmt11.executeQuery();
                                while (rs11.next()) {

                            %>
                            <!-- hardcoded na subtasks toh tanggalin niyo if gusto niyo itest-->
                            <li><%out.print(rs11.getString("Task"));%></li><%}%>

                        </ul>
                    </div>
                </div>
                <div class="column">
                    <p> Date Created: <%out.println(rs10.getString("DateCreate"));%>
                        <br><br><br>
                        Assigned on:
                    <ol id= "right_area_column">
                        <%

                            String sql12 = "SELECT * FROM Assignment LEFT JOIN Emp_Info ON Assignment.EmpID = Emp_Info.ID WHERE TaskID = '" + rs10.getString("TaskID") + "'";
                            PreparedStatement stmt12 = null;
                            stmt12 = con.prepareStatement(sql12);
                            ResultSet rs12 = stmt12.executeQuery();
                            while (rs12.next()) {

                        %>
                        <li>
                            <%out.print(rs12.getString("name"));%>
                        </li><%}%>
                        <br><br>
                    </ol>
                    <h4>
                        Reason for flag:</h4>
                    <textarea readonly rows="5" cols="50"> <%out.print(rs10.getString("Flagged"));%></textarea>
                    </p>


                </div>

            </div>
                    <hr>
        </div>
        <%
            }
        %>
        <hr>
    </div>



</section>
<h3 class="sectheader">Cancelled Tasks</h3>
<section>

    <div class="container">
        <div class="accordion">	
            <%
                //Cancelled Query
                String sql4 = "SELECT * FROM Task_Assignment WHERE Status='Cancelled'";
                PreparedStatement stmt4 = con.prepareStatement(sql4);
                ResultSet rs4 = stmt4.executeQuery();

                while (rs4.next()) {

            %>
            <div class="accordion-item" id="<%out.print(rs4.getString("Title")+index);%>">
                <a class="accordion-link" href="#<%out.print(rs4.getString("Title")+index);%>" onclick="javascript:void(0);">
                    <div class="flex">
                        <h3 id="task_title"><%out.print(rs4.getString("TaskID") + ". " + rs4.getString("Title") + "- Due on " + rs4.getString("Deadline"));%></h3> 
                        <button id="myBtn2" name="<%out.print(rs4.getString("TaskID"));%>" class="modal-button"> 	<i id="descript_btn" class="fas fa-exclamation-circle"></i></button>
                        <i class="icon ion-md-arrow-forward"></i>
                        <i class="icon ion-md-arrow-down"></i>

                </a>
            </div>
            <div class="answer">
                <div class="row">
                    <div class="column">
                        <p> Subtasks:</p>

                        <ul id="myUL">
                            <%
                                index++;
                                String sql5 = "SELECT * FROM SubTasks WHERE TaskID ='" + rs4.getString("TaskID") + "'";
                                PreparedStatement stmt5 = null;
                                stmt5 = con.prepareStatement(sql5);
                                ResultSet rs5 = stmt5.executeQuery();
                                while (rs5.next()) {

                            %>
                            <!-- hardcoded na subtasks toh tanggalin niyo if gusto niyo itest-->
                            <li><%out.print(rs5.getString("Task"));%></li><%}%>

                        </ul>
                    </div>
                </div>
                <div class="column">
                    <p> Date Created: <%out.println(rs4.getString("DateCreate"));%></p>
                    <p> Assigned on:</p>
                    <ol id= "right_area_column">
                        <%

                            String sql6 = "SELECT * FROM Assignment LEFT JOIN Emp_Info ON Assignment.EmpID = Emp_Info.ID WHERE TaskID = '" + rs4.getString("TaskID") + "'";
                            PreparedStatement stmt6 = null;
                            stmt6 = con.prepareStatement(sql6);
                            ResultSet rs6 = stmt6.executeQuery();
                            while (rs6.next()) {

                        %>
                        <li>
                            <%out.print(rs6.getString("name"));%>
                        </li><%}%>

                    </ol>
                    <br><br>

                </div>
            </div>
            <hr>
        </div>
        <%
            }
        %>
    </div>
</div>

</section>

</div>


<!-- script-->
<script type="text/javascript">
    /*modal scripts*/
    // Get the modal
    var modalClass = document.querySelectorAll(".modal"), i;
    // Get the button that opens the modal
    var btnClass = document.querySelectorAll(".modal-button");

    // Get the <span> element that closes the modal
    var span = document.querySelectorAll(".close");



    for (i = 0; i < btnClass.length; ++i) {
        btnClass[i].addEventListener('click', function () {
            var id = this.name;
            var modal = document.getElementById(id).setAttribute("style", "display:block");
        });
    }



    for (i = 0; i < btnClass.length; i++) {
        span[i].addEventListener('click', function () {
            var id = this.parentElement;
            var id2 = id.parentElement;
            id2.setAttribute("style", "display:none");
        });

    }



    // When the user clicks anywhere outside of the modal, close it
    window.onclick = function (event) {
        for (i = 0; i < btnClass.length; i++) {
            if (event.target === modalClass[i]) {
                modalClass[i].style.display = "none";
            }
            ;

        }
    };
    /*nav bar script*/
    $(document).ready(function () {
        $('.nav_btn').click(function () {
            $('.mobile_nav_items').toggleClass('active');
        });
    });

    $(document).ready(function () {
        $(".default_option").click(function () {
            $(".dropdown ul").addClass("active");
        });

        $(".dropdown ul li").click(function () {
            var text = $(this).text();
            $(".default_option").text(text);
            $(".dropdown ul").removeClass("active");
        });
    });
</script>


<script type="text/javascript">(function () {
        window['__CF$cv$params'] = {r: '6d8811d78e13b469', m: '8Ln6FGcOV6JC2VoiCrvEj0nwN0NfefhuCP5o_Jw7gvg-1644021441-0-AZVfwXN98W3y3IhrYA0ltvnPLW7gmzc58DS+4jOae/A0X+iGdkJZUbm75rNWfyCOaITFo20AmXsbxIjqMN7XTndm+vf6s9j1vwskdZ8cNnXq9+HoPkdFSH3LGiMalaY/j2BGVOSuKXuS/cFk7LVOLHpuevJvnBcQWdpn0xD9/U5nWwQ2S9zg3SlLWJZtpfqRFYrRTiYiYybgXY5VtbimlsM=', s: [0x1f09291f10, 0xd1b4aac9fa]};
    })();</script></body>

</body>
</html>
