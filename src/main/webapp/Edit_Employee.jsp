<%-- 
    Document   : Edit_Employee
    Created on : Jan 20, 2022, 3:08:08 PM
    Author     : Isaiah Dava
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="shortcut icon" href="Assets/logo.png">
       	<meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Employee Form</title>
        <link rel="stylesheet" href="CSS/New_Employee.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>




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
        <%
            HttpSession nsession = request.getSession(false);
            ServletContext context = request.getServletContext();
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
            String ID = request.getParameter("value");
        %>




        <div class="wrapper">

            <div class="title">
                Edit Employee
            </div>
            <form action ="UpdateEmployeeDB" id="EditForm" method="POST" enctype="multipart/form-data">
                <div id="parent">
                    <div class="profile-pic" >


                        <label>

                            <img src="Assets/profile_upload.png">
                            <input type="file" name="file" style="display:none" id="file">
                        </label>

                    </div>
                    <div id="popup" class="inputfield" style="text-align:center;">Click the image to upload a picture.</div></div>
                <div class="form">
                    <input type="text" value="<%out.print(ID);%>" hidden="true" name="old_id">
                    <div class="inputfield">
                        <label for="Staff_Id" >New Staff ID</label>
                        <input type="text" id="Staff_Id" name="Staff_Id" value="" class="input" required>
                    </div>  

                    <div class="inputfield">
                        <label for="Department" >New Department</label>
                        <input type="text"  id="Department" name="Department" value="" class="input" required>
                    </div>  
                    <div class="inputfield">
                        <label for="Job_Title">New Job Title</label>
                        <input type="text" id="Job_Title" name="Job_Title" value="" class="input" required>
                    </div>  
                    <div class="inputfield">
                        <label for="Money">Rate per Hour</label>
                        <input type="number" id="Money" name="Money" value="" class="input" required>
                    </div> 


                    <div class="inputfield">
                        <label for="Email_Add">Email Address</label>
                        <input type="text"  id="Email_Add" name="Email_Add" value="" class="input" required>
                    </div> 

                    <div class="inputfield">
                        <label for="Contact_Num">Contact Number</label>
                        <input type="text" id="Contact_Num" name="Contact_Num" value="" class="input" required>
                    </div> 
                    <div class="inputfield">
                        <label for="Address">Address</label>
                        <textarea name="address"id="Address" class="textarea" required></textarea>
                    </div> 
                    <div class="inputfield">
                        <label for="Status">Employment Status</label>
                        <div class="custom_select" required>
                            <select id="Marital_Status" name="status">
                                <option value="">Select</option>
                                <option value="Hired">Hired</option>
                                <option value="Probation">Probation</option>
                                <option value="Fired">Fired</option>
                            </select>
                        </div>
                    </div> 
                    <div class="inputfield">
                        <button type="submit" class="btn" name="update">Update</button>
                    </div>
                    <div class="inputfield">
                        <button type="button" class="btn" name="delete" onclick="myFunction()">Delete</button>
                    </div>
                    <div class="inputfield">
                        <input type="button" value="Go back!" class="btn" onclick="history.back()">
                    </div>
                </div>
            </form>
        </div>	
        <script>
            function myFunction() {
                let text = "Are you sure you want to delete this Employee?";
                if (confirm(text) === true) {
                    document.getElementById("EditForm").action = "DeleteEmployeeDB?value=<%out.print(ID);%>";
                    document.getElementById("EditForm").submit();


                } else {




                }

            }
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
