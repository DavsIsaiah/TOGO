<%-- 
    Document   : New_Employee
    Created on : Jan 16, 2022, 11:53:33 AM
    Author     : Isaiah Dava
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="shortcut icon" href="Assets/logo.png">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Employee Application Form</title>
        <link rel="stylesheet" href="CSS/New_Employee.css">

        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
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
                Create New Employee
            </div>
            <form id="myform" action="InputEmployeeDB" method="POST" enctype="multipart/form-data">
                <div id="parent">
                    <div class="profile-pic">
                        <label>

                            <img src="Assets/profile_upload.png">
                            <input type="file" name="file" style="display:none" id="file">
                        </label></div>
                    <div id="popup" class="inputfield" style="text-align:center;">Click the image to upload a picture. <br /><br /><br /></div></div>
                <div class="form">
                    <div class="inputfield">
                        <label for="Staff_Id">Staff ID</label>
                        <input type="text" id="Staff_Id" name="ID" value=""class="input" required>
                    </div>  
                    <div class="inputfield">
                        <label for="Name">Name</label>
                        <input type="text" id="Name" name="Name"  value="" class="input" required>
                    </div>  
                    <div class="inputfield">
                        <label for="Department">Department</label>
                        <input type="text"class="input" id="Department" name="Department" value="" required>
                    </div>  
                    <div class="inputfield">
                        <label for="Job_Title">Job Title</label>
                        <input type="text" id="Job_Title" name="Job_Title" value="" class="input" required>
                    </div>  
                    <div class="inputfield">
                        <label for="Dob">Date of Birth</label>
                        <input type="date" id="Dob" name="Dob" value="" class="input" required>
                    </div> 
                    <div class="inputfield">
                        <label for="De">Date Hired</label>
                        <input type="date" id="De" name="DH" value="" class="input" required>
                    </div> 

                    <div class="inputfield">
                        <label for="Gender">Sex</label>
                        <div class="custom_select" required>
                            <select id="Gender" name="gender">
                                <option value="">Select</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                            </select>
                        </div>
                    </div> 
                    <div class="inputfield">
                        <label for="Marital_Status">Employment Status</label>
                        <div class="custom_select" required>
                            <select id="Marital_Status" name="status">
                                <option value="">Select</option>
                                <option value="Hired">Hired</option>
                                <option value="Probation">Probation</option>
                            </select>
                        </div>
                    </div>
                    <div class="inputfield">
                        <label for="Gender2">Account Type</label>
                        <div class="custom_select" required>
                            <select id="Gender2" name="gender2">
                                <option value="">Select</option>
                                <option value="ADMIN">Admin</option>
                                <option value="EMP">Employee</option>

                            </select>
                        </div>
                    </div> 

                    <div class="inputfield">
                        <label for="Money">Rate per Hour</label>
                        <input type="number" id="Money" name="Money" value="" class="input" required>
                    </div> 
                    <div class="inputfield">
                        <label for="Email_Add">Email Address</label>
                        <input type="text" id="Email_Add" name="Email_Add" value=""class="input" required>
                    </div> 

                    <div class="inputfield">
                        <label for="Contact_Num">Contact Number</label>
                        <input type="text" id="Contact_Num" name="Contact_Num" value=""class="input" required>
                    </div> 
                    <div class="inputfield">
                        <label for="Address">Address</label>
                        <textarea name="address"id="Address" class="textarea" required></textarea>
                    </div> 
                    <div class="inputfield terms">
                        <label for="Agree_Terms">
                            <input type="checkbox" id="Agree_Terms" value="Agree_Check" required>
                            <span class="checkmark"></span>
                        </label>
                        <p>Agreed to terms and conditions</p>
                    </div> 
                    <input type="text" id="occurred" name="occurred" hidden="true" >
                    <div class="inputfield">
                        <input type="submit" value="Create" class="btn">
                    </div>
                    <div class="inputfield">
                        <input type="button" value="Go back!" class="btn" onclick="history.back()">
                    </div>
                </div>


                <script>

                    $('#myform').submit(function () {
                        // DO STUFF...

                        var userinput = document.getElementById("Dob").value;
                        var dob = new Date(userinput);
                        var inputF = document.getElementById("occurred");

                        //calculate month difference from current date in time  
                        var month_diff = Date.now() - dob.getTime();

                        //convert the calculated difference in date format  
                        var age_dt = new Date(month_diff);

                        //extract year from date      
                        var year = age_dt.getUTCFullYear();

                        //now calculate the age of the user  
                        var age = Math.abs(year - 1970);

                        //display the calculated age  
                        $('#occurred').val(age);
                        inputF.value = age;
                        alert(getElementByID("occurred").value);

                        return true; // return false to cancel form action
                    });
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
                </script></form>
        </div>	
    </body>
</html>
