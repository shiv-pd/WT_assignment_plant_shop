<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="ISO-8859-1">
        <title>Product Form</title>
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
    <body class="bg-image">

        <nav class="sticky flex justify-around p-4 sm:p-10 sm:pb-6 text-xl bg-white ">
            <h1 class="text-2xl font-bold">Plant Shop</h1>
            <div onclick="displayList()" class="sm:hidden mt-1.5"><i class="fa-solid fa-bars "></i></div>


            <ul class="sm:flex sm:justify-around hidden items-center">
                <li class="px-4 "><a href="home">Home</a></li>
                <li class="mx-4"><a href="products">Products</a></li>
                <li class="mx-4"><a href="#">cart</a></li>
                    <%
                        String userName = (String) session.getAttribute("username");
                        Integer userId = (Integer) session.getAttribute("user_id");
                        
                        if (userName != null) {
                    %>
                <li class="mx-4"><a href="profile.jsp"><i class="fa-regular fa-user"></i></a></li>
                <li title="logout" class=" px-2"><a href="logout"><i class="fa-solid fa-arrow-right-from-bracket "></i></a></li>
                        <%
                        } else {
                        %>
                <li class="px-4 py-1.75 mx-1.5 border-2 border-gray-400 rounded-xl hover:bg-gray-100"><a href="login.jsp">Login</a></li>
                    <%
                        }
                    %>
            </ul>
        </nav>
        <ul id="small-list" class="bg-gray-100 text-xl w-full py-4 hidden sm:hidden ">
            <li class="py-2 px-8 hover:bg-amber-50"><a href="home">Home</a></li>
            <li class="py-2 px-8 hover:bg-amber-50"><a href="products">Products</a></li>
            <li class="py-2 px-8 hover:bg-amber-50"><a href="#">cart</a></li>
                <%
                    if (userName != null) {
                %>
            <li class="py-2 px-8 hover:bg-amber-50"><a href="profile.jsp"><i class="fa-regular fa-user"></i></a></li>
            <li title="logout" class=" py-2 px-8 hover:bg-amber-50"><a href="logout"> <i class="fa-solid fa-arrow-right-from-bracket "></i></a></li>
                    <%
                    } else {
                    %>
            <li class="py-2 px-8 hover:bg-amber-50"><a href="login.jsp">Login</a></li>
                <%
                    }
                %>
        </ul>
         <%
                    if (userName != null) {
         %>
        
        <div class=" bg-gray-50 md:w-[40rem] lg:w-[50rem] md:mx-auto flex flex-col justify-center items-center  p-8 md:mt-12    md:mb-12 md:rounded-2xl ">
            <h2 class="text-2xl text-emerald-800 font-semibold">Enter Product Information</h2>
            <form action="productForm?id=<%= userId %>" method="POST" enctype="multipart/form-data"  class="flex flex-col min-w-[25rem] sm:w-[35rem] gap-1 p-8 bg-gray-50 rounded-2xl">
                <label for="name" class="ml-1.5 text-lg" >Product Name</label>
                <input type="text" id="name" name="name"  name="full_name" required class="text-sm mb-6   bg-white border-2 border-gray-200   rounded-lg p-3 focus:outline-none"/>

                <label for="category"class="ml-1.5 text-lg" >Category</label>
                <select id="category" name="category" class="text-sm mb-6   bg-white border-2 border-gray-200   rounded-lg p-3 focus:outline-none">
                    <option value="indoor">Indoor Plants</option>
                    <option value="outdoor">Outdoor Plants</option>
                    <option value="flowering">Flowering Plants</option>
                    <option value="succulents">Succulents</option>
                    <option value="potsandaccesories">Pots & Accessories</option>  
                </select>

                <div class="flex gap-2 sm:gap-8">
                    <div  class="flex flex-col">
                        <label for="price" class="ml-1.5 text-lg" >Price</label>
                        <input type="text" id="price" name="price"  required class="w-30 text-sm mb-6  bg-white border-2 border-gray-200  rounded-lg p-3 focus:outline-none"/>
                    </div>
                      
                    <div  class="flex flex-col" >
                        <label for="total_stock" class="ml-1.5 text-lg" >Total Stock</label>
                        <input type="number" id="totalStock" name="total_stock" required class="w-30 text-sm mb-6  bg-white border-2 border-gray-200  rounded-lg p-3 focus:outline-none"/>
                    </div>
                    
                </div>

               

                <label for="image" class="ml-1.5 text-lg">Product Image</label>
                <!--                <input type="file" id="image" name="image" accept="image/*" required class="  border-2 border-gray-200 bg-white p-2  w-fit rounded-lg focus:outline-none" />-->
                <input
                    type="file"
                    id="image"
                    name="image"
                    accept="image/*"
                    required
                    class="ml-2 file:mr-4 file:py-2 file:px-4
                    file:rounded-lg file:border-0
                    file:text-sm file:font-semibold
                    file:bg-emerald-700 file:text-white
                    hover:file:bg-emerald-800
                    transition duration-200 text-gray-500"
                    />
          
                 <label for="description" class=" mt-8 ml-1.5 text-lg">Description</label>
                 <textarea id="description" name="description"  required  class="text-sm mb-6 bg-white border-2 border-gray-200  rounded-lg p-2 focus:outline-none min-h-40" placeholder="Describe your product here.."></textarea>
        <button type="submit" class="m-7 text-xl bg-gray-100 border-2 border-gray-300 rounded-xl  w-fit px-4 py-2  self-center">Save & Continue</button>
    </form>
</div>
         
         <%
             }else{
                   response.sendRedirect("login.jsp");
             }
         %>

<!--        <form action="productForm" method="POST" enctype="multipart/form-data" class="bg-gray-100 md:w-[40rem] lg:w-[50rem] md:mx-auto flex flex-col justify-center items-center p-8 pb-0 mb-12 md:rounded-2xl">
            <h2 class="text-2xl text-emerald-600 font-semibold">Enter Product Information</h2>

            <label for="name"class="ml-1.5 text-lg" >Product Name:</label>
            <input type="text" id="name" name="name" required class="text-sm mb-6   bg-white border-2 border-gray-200  border-b-emerald-700 rounded-lg p-2 focus:outline-none"/>


            <label for="category"class="ml-1.5 text-lg" >Category:</label>
            <select id="category" name="category">
                <option value="indoor">Indoor Plants</option>
                <option value="outdoor">Outdoor Plants</option>
                <option value="flowering">Flowering Plants</option>
                <option value="succulents">Succulents</option>
                <option value="potsandaccesories">Pots & Accessories</option>  
            </select>

            <label for="price" class="ml-1.5 text-lg" >Price:</label>
            <input type="text" id="price" name="price" required class="text-sm mb-6   bg-white border-2 border-gray-200  border-b-emerald-700 rounded-lg p-2 focus:outline-none"/>

            <label for="totalStock" class="ml-1.5 text-lg" >Total Stock:</label>
            <input type="number" id="totalStock" name="total_stock" required class="text-sm mb-6   bg-white border-2 border-gray-200  border-b-emerald-700 rounded-lg p-2 focus:outline-none"/>

            <label for="description" class="ml-1.5 text-lg" >Description:</label>
            <textarea id="description" name="description" required class="text-sm mb-6   bg-white border-2 border-gray-200  border-b-emerald-700 rounded-lg p-2 focus:outline-none">Describe your product here..</textarea>

            <label for="image"class="ml-1.5 text-lg" >Product Image:</label>
            <input type="file" id="image" name="image" accept="image/*" required class="text-sm mb-6   bg-white border-2 border-gray-200  border-b-emerald-700 rounded-lg p-2 focus:outline-none"/>

            <button type="submit">Submit</button>
        </form>-->


<script>
            const smallList = document.querySelector('#small-list')
            function displayList() {

                smallList.classList.toggle("hidden");
            }
        </script>
        <script>
            const form = document.querySelector('#form-to-be-displayed')
            function displayForm() {

                form.classList.toggle("hidden");
            }
        </script>

</body>
</html>
