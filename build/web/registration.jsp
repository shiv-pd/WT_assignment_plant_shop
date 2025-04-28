<%-- 
    Document   : registration
    Created on : Apr 15, 2025, 12:31:05 PM
    Author     : LENOVO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registration</title>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            .bg-image{
                background-image: url('./assets/login-background.jpg');
                background-size: cover;
                background-repeat: no-repeat;
                backdrop-filter: blur(7px);
                /* background-position: right; */
            }
        </style>
    </head>
    <body class="h-[100vh] flex items-center justify-center bg-image">
        <form action="register" method="post" class="h-[80vh] border-2 bg-white border-gray-200 sm:w-[28rem] rounded-xl p-12 min-w-[22rem] flex flex-col gap-2  ">
            <h1 class="text-3xl font-semibold self-center mb-4" >Registration</h1>
            <label for="fullname" class="text-lg mt-2"> </label>
            <input type="text" id="fullname" name="fullname" placeholder="Full Name" class="border-2 border-gray-200 rounded-lg p-2 focus:outline-none" required >
            
            <label for="email" class="text-lg mt-2">  </label>
            <input type="email" id="email" name="email" placeholder="Email" class="border-2 border-gray-200 rounded-lg p-2 focus:outline-none" required>

            <label for="username" class="text-lg mt-2"></label>
            <input type="text" id="username" name="username" placeholder=" Username" class="border-2 border-gray-200 rounded-lg p-2 focus:outline-none" required >

            <label for="password" class="text-lg mt-4"> </label>
            <input type="text" id="password" name="password" placeholder="Password" class="border-2 border-gray-200 rounded-lg p-2 focus:outline-none" required>

            <button type="submit" class="m-7 text-2xl bg-emerald-700 text-white rounded-xl  w-fit px-4 py-2  self-center">Submit</button>
            <p class="self-center mt-[-1rem]">Already have an account? &nbsp; <a href="login.jsp" class=" text-blue-600 underline hover:text-blue-800 visited:text-purple-600 ">Signin here</a> </p>
            
             <%
                String error = (String) request.getAttribute("errorMessage");
                if (error != null) {
            %>
                <div class=" mt-4 text-red-500 self-center"><%= error %></div>
            <%
                }
            %>  
        </form>

    </body>
</html>
