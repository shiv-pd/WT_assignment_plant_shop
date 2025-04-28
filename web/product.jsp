<%@ page import="model.Plant" %>

<%@ page import="java.util.* "%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Plant Shop</title>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    </head>
    <body class="  ">
        <nav class="sticky z-10 flex justify-around p-4 sm:p-10 text-xl ">
            <h1 class="text-2xl font-bold">Plant Shop</h1>
            <div onclick="displayList()" class="sm:hidden mt-1.5"><i class="fa-solid fa-bars "></i></div>


            <ul class="sm:flex sm:justify-around hidden items-center">
                <li class="px-4 "><a href="home">Home</a></li>
                <li class="mx-4"><a href="products">Products</a></li>
                <li class="mx-4"><a href="cartItems.jsp"><i class="fa-solid fa-cart-shopping opacity-60 hover:opacity-90"></i></a></li>
                    <%
                        String userName = (String) session.getAttribute("username");
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
            <li class="py-2 px-8 hover:bg-amber-50"><a href="cartItems.jsp"><i class="fa-solid fa-cart-shopping opacity-60 hover:opacity-90"></i></a></li>
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


        <div class="md:hidden px-6 py-4 bg-gray-50 mb-4 ">

            <div class="flex justify-around items-center" onclick="displayForm()" >
                <span class="text-md ">Filter Options</span>
                <i  class="fa-solid fa-chevron-right ml-40 text-md "></i>
            </div>

            <form action="products" class="flex px-8 my-4 py-4 gap-8 hidden border-2 border-gray-50 border-t-gray-300 " id="form-to-be-displayed">

                <div>
                    <p class="font-semibold mt-4 mb-2">Category</p>
                    <label class="flex gap-2 items-center"> 
                        <input type="checkbox" value="indoor" name="category">Indoor Plant
                    </label>
                    <label class="flex gap-2 items-center"> 
                        <input type="checkbox" value="outdoor " name="category" >Outdoor Plant
                    </label>
                    <label class="flex gap-2 items-center"> 
                        <input type="checkbox" value="flowering" name="category">Flowering Plants
                    </label>
                    <label class="flex gap-2 items-center"> 
                        <input type="checkbox" value="succulents" name="category"> Succulents
                    </label>
                    <label class="flex gap-2 items-center"> 
                        <input type="checkbox" value="potsandaccesories" name="category">Pots & Accessories
                    </label>

                </div>
                <div>
                    <p class="font-semibold mt-4 mb-2">Price</p>
                    <div class="flex flex-col gap-2.5">
                        <input type="number" value="min-price" class="max-w-17 bg-white pl-2 border-gray-300 border-2">
                        <input type="number" value="max-price" class="max-w-17 bg-white pl-2 border-gray-300 border-2">
                    </div>
                </div>

                <div>
                    <p class="font-semibold mt-4 mb-2">Availability</p>
                    <label class="flex gap-2 items-center"> 
                        <input type="checkbox" value="instock" name="availability">In Stock
                    </label>
                    <label class="flex gap-2 items-center"> 
                        <input type="checkbox" value="outofstock" name="availability">Out of Stock
                    </label>

                </div>

                <div class="mt-4 flex flex-col gap-4">
                    <button class="border-gray-400 border-2 px-2 py-1 rounded-xl" type="submit">Submit</button>
                    <button class="border-gray-400 border-2 px-2 py-1 rounded-xl bg-gray-200" type="reset">Reset</button>
                </div>
            </form>
        </div>
        <div class="flex w-full  sm:w-[90vw] m-auto lg:w-[80vw] gap-4 justify-center">
            <div class="hidden md:flex md:flex-col bg-gray-100 w-60 h-[80vh] rounded-2xl p-8 ">
                <form action="products" class="flex flex-col">
                    <p class="text-xl font-semibold">Filter Options</p>

                    <p class="font-semibold mt-4 mb-2">Category</p>
                    <label class="flex gap-2 items-center"> 
                        <input type="checkbox" value="indoor" name="category">Indoor Plant
                    </label>
                    <label class="flex gap-2 items-center"> 
                        <input type="checkbox" value="outdoor" name="category" >Outdoor Plant
                    </label>
                    <label class="flex gap-2 items-center"> 
                        <input type="checkbox" value="flowering" name="category">Flowering Plants
                    </label>
                    <label class="flex gap-2 items-center"> 
                        <input type="checkbox" value="succulents" name="category"> Succulents
                    </label>
                    <label class="flex gap-2 items-center"> 
                        <input type="checkbox" value="potsandaccesories"  name="category">Pots & Accessories
                    </label>

                    <p class="font-semibold mt-4 mb-2">Price</p>
                    <div class="flex gap-2.5">
                        <label class="flex flex-col">min<input type="number" name="minPrice" class="max-w-17 bg-white pl-2 border-gray-300 border-2"></label>
                        <label class="flex flex-col">max<input type="number" name="maxPrice" class="max-w-17 bg-white pl-2 border-gray-300 border-2"></label>
                    </div>

                    <p class="font-semibold mt-4 mb-2">Availability</p>
                    <label class="flex gap-2 items-center"> 
                        <input type="checkbox" value="instock" name="availability">In Stock
                    </label>
                    <label class="flex gap-2 items-center"> 
                        <input type="checkbox" value="outofstock" name="availability" >Out of Stock
                    </label>

                    <div class="mt-4 flex gap-4">
                        <button class="border-gray-400 border-2 px-2 py-1 rounded-xl hover:bg-gray-300" type="submit">Submit</button>
                        <button class="border-gray-400 border-2 px-2 py-1 rounded-xl bg-gray-300 hover:bg-gray-100" type="reset">Reset</button>
                    </div>
                </form>

            </div>

            <!--sm:bg-red-100 md:bg-red-500 lg:bg-red-800-->

            <div class=" grid grid-cols-2 sm:grid-cols-3 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 border-gray-100 p-0 sm:border-2  gap-4 sm:gap-8  sm:flex-1/2 md:min-w-[32rem] md:max-w-[34rem]  lg:min-w-[45rem] xl:min-w-[60rem] rounded-2xl sm:p-8 h-[85vh] md:h-[80vh] overflow-scroll">

                <%
                    List<Plant> plants = (List<Plant>) request.getAttribute("plants");
                    if (plants != null && !plants.isEmpty()) {
                        for (Plant p : plants) {
                %> 
                <div class=" rounded-xl overflow-hidden h-75  md:h-80 lg:h-75">

                
                    
                    <a href="specificProduct?id=<%= p.getId()%>" class="flex justify-center">
                        <img  src="data:image/jpeg;base64,<%= p.getBase64Image()%>" class="h-50  md:h-60 lg:h-55 rounded-xl " >  
                    </a>


                    <div class="ml-4 mt-2">
                        <p class="text-sm opacity-60"><%= p.getCategory()%></p>
                        <p class="text-md"> <%= p.getName()%></p>
                        <p class="text-xl font-semibold">&#8377 <%= p.getPrice()%></p>

                    </div> 
                </div>
                <%
                    }
                } else {
                %>
                <div class="flex flex-col gap-8 items-center justify-center w-full h-full ">

                    <img class="h-[20rem] " src="./assets/not-found.png"/>
                    <p class="text-xl font-semibold">No products found...</p>
                </div>
                <%
                    }
                %>
            </div> 

        </div>





        <script>
            const smallList = document.querySelector('#small-list');
            function displayList() {

                smallList.classList.toggle("hidden");
            }
        </script>
        <script>
            const form = document.querySelector('#form-to-be-displayed');
            function displayForm() {

                form.classList.toggle("hidden");
            }
        </script>
    </body>
</html>
