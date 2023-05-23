<%-- 
    Document   : TasksEmp
    Created on : Feb 6, 2022, 2:32:39 PM
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
        <title>Task Overview</title>
        <link rel="stylesheet" href="CSS/View_Tasks_Overview.css">
        <script src="https://unpkg.com/ionicons@5.1.2/dist/ionicons.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.1/css/all.min.css">
        <link rel="stylesheet" href="https://unicons.iconscout.com/release/v2.1.6/css/unicons.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js" charset="utf-8"></script>
        <link href="https://unpkg.com/ionicons@4.5.10-0/dist/css/ionicons.min.css" rel="stylesheet">
        <script async src='/cdn-cgi/bm/cv/669835187/api.js'></script>
        <%
            ServletContext context = request.getServletContext();
            String username = (String) context.getAttribute("username");
            String password = (String) context.getAttribute("password");
            String picture = null;
            String ID = null;
            try {

                Connection con = null;
                PreparedStatement stmt = null;

                Class.forName("org.sqlite.JDBC");
                con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");

                String sql2 = "select picture, ID from credentials where picture IS NOT NULL AND username= '" + username + "' and password = '" + password + "'";

                stmt = con.prepareStatement(sql2);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    picture = rs.getString("picture");
                    ID = rs.getString("ID");
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

        <input type="checkbox" id="check">
        <!--header area start-->
        <header>
            <label for="check">
                <i class="fas fa-bars" id="sidebar_btn"></i>
            </label>
            <div class="left_area"><a href="WelcomeEmployee.jsp">
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

                <a href="TasksEmp.jsp" ><i class="fas fa-search"></i><span> Overview</span></a>
            <a href="TasksEmp_Pending.jsp"><i class="fas fa-user-friends"></i><span>Pending</span></a>
            <a href="#" style="background: #CCCFFF;"><i class="fas fa-sliders-h"></i><span>Completed</span></a>
            <a href="TasksEmp_Flagged.jsp"><i class="fas fa-sliders-h"></i><span>Flagged</span></a>
            </div>
        </div>
        <!--mobile navigation bar end-->

        <!--sidebar start-->
        <div class="sidebar">
            <div class="profile_info">
                <img src="<%out.print("/Files/" + picture);%>" class="profile_image" alt="" id="photo">
                <h4 id="Name"><%out.println(username);%></h4>

            </div>
            <a href="TasksEmp.jsp" ><i class="fas fa-search"></i><span> Overview</span></a>
            <a href="TasksEmp_Pending.jsp"><i class="fas fa-user-friends"></i><span>Pending</span></a>
            <a href="#" style="background: #CCCFFF;"><i class="fas fa-sliders-h"></i><span>Completed</span></a>
            <a href="TasksEmp_Flagged.jsp"><i class="fas fa-sliders-h"></i><span>Flagged</span></a>
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

    <h3 class="sectheaderb">Completed Tasks</h3>
    <!--2 accordion view task start-->
    <section>
        <div class="container">
            <div class="accordion">	

                <%                                    //Completed Query
Class.forName("org.sqlite.JDBC");
                            con = DriverManager.getConnection("jdbc:sqlite:C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Files\\Database.db");
                    String sql = "SELECT *, Assignment.TaskID as Task FROM Assignment LEFT JOIN Task_Assignment ON Assignment.TaskID = Task_Assignment.TaskID WHERE Assignment.EmpID = '" + ID + "' and Task_Assignment.Status = 'Completed'";
                    stmt = con.prepareStatement(sql);
                    ResultSet rs = stmt.executeQuery();

                    while (rs.next()) {

                %>
                <div class="accordion-item" id="<%out.print(rs.getString("Title") + index);%>">
                    <a class="accordion-link" href="#<%out.print(rs.getString("Title") + index);%>" onclick="javascript:void(0);">
                        <div class="flex">
                            <h3 id="task_title"><%out.print(rs.getString("Task") + ". " + rs.getString("Title") + "- Completed on " + rs.getString("DateComplete"));%></h3> 
                            <button id="myBtn3" name="<%out.print(rs.getString("Task"));%>" class="modal-button">	<i id="descript_btn" class="fas fa-exclamation-circle"></i></button>
                            <i class="icon ion-md-arrow-forward"></i>
                            <i class="icon ion-md-arrow-down"></i>

                    </a>
                </div>
                <div class="answer">
                    <div class="row">
                        <div class="compflag">
                            <p> Subtasks:</p>
                            <ul id="myUL">
                                <%         
                                    index++;
                                    String sql2 = "SELECT * FROM SubTasks WHERE TaskID ='" + rs.getString("Task") + "'";
                                    PreparedStatement stmt2 = null;
                                    stmt2 = con.prepareStatement(sql2);
                                    ResultSet rs2 = stmt2.executeQuery();
                                    while (rs2.next()) {

                                %>
                                <!-- hardcoded na subtasks toh tanggalin niyo if gusto niyo itest-->
                                <li class="<%out.print(rs2.getString("Checked"));%>"><%out.print(rs2.getString("Task"));%></li><%}%>
                            </ul>
                        </div>
                    </div>
                    <div class="column">
                        <p> Assigned on:</p>
                        <ol id= "right_area_column">
                            <%

                                String sql3 = "SELECT * FROM Assignment LEFT JOIN Emp_Info ON Assignment.EmpID = Emp_Info.ID WHERE TaskID = '" + rs.getString("Task") + "'";
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

            <!--2 accordion view task end-->
    </section>

</div>


<!--navigation bar script-->
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
        window['__CF$cv$params'] = {r: '6d85782839d94acc', m: '_IQVUETLkakHADr4FFXP8Z5SRVW4zdbl1q23fwo35hI-1643994174-0-AUhlfVqs0z/ELa/MJ0SF9sUPtlLc73nBGeevavz6rIXB1yMPQLzjmIr9AG7e0oXXOENeu6l98NySZvRWvFm61MPmWHiQ2mBy8WCGsnxxSDIFCYP99TiLwLvp/xprPfyYmE9qon2oPbdblZavStvyomFV08r+Y6Hg6enQo8InTECKMHDbiay5LzElug/MCPFkvj+s5rGRghgGiRo9Kv9q4EQ=', s: [0x34e9000b9e, 0x7326435591]};
    })();</script>
</body>
</html>
