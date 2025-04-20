<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Plant Shop - home</title>
         <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
         <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
         <style>
            .hero-img{
                background-image: url('./assets/background.png');
                background-size: cover;
                background-repeat: no-repeat;
                background-position: right;
            }
        </style>
    </head>
    <body>
        <nav class="sticky flex justify-around p-4 sm:p-10 text-xl ">
        <h1 class="text-2xl font-bold">Plant Shop</h1>
        <div onclick="displayList()" class="sm:hidden mt-1.5"><i class="fa-solid fa-bars "></i></div>
        
       
        <ul class="sm:flex sm:justify-around hidden items-center">
             <li class="px-4 "><a href="home">Home</a></li>
             <li class="mx-4"><a href="products">Products</a></li>
             <li class="mx-4"><a href="#">cart</a></li>
             
             <% 
                String userName = (String) session.getAttribute("username");
                if(userName != null){
              %>
              <li class="mx-4"><a href="profile.jsp"><i class="fa-regular fa-user"></i></a></li>
              <li title="logout" class=" px-2"><a href="logout"><i class="fa-solid fa-arrow-right-from-bracket "></i></a></li>
              <%
               }else{
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
                if(userName != null){
         %>
        <li class="py-2 px-8 hover:bg-amber-50"><a href="profile.jsp"><i class="fa-regular fa-user"></i></a></li>
        <li title="logout" class=" py-2 px-8 hover:bg-amber-50"><a href="logout"> <i class="fa-solid fa-arrow-right-from-bracket "></i></a></li>
        <%
                }else{
        %>
        <li class="py-2 px-8 hover:bg-amber-50"><a href="login.jsp">Login</a></li>
        <%
               }
        %>
   </ul>
    
    <div class="hero-img h-[50vh] md:h-[70vh] p-4 flex items-center justify-center sm:justify-start lg:mx-20 mb-5 md:mb-8 lg:rounded-2xl ">
        <div class="backdrop-blur-sm p-8 flex flex-col gap-8">
            <p class="text-2xl font-semibold sm:text-4xl md:text-6xl ">The Ultimate Plant <br> Shopping Destination</p>
            <div class="flex gap-4 items-center">
                <a href="products"><button class="md:text-xl bg-amber-300 py-3 px-6 rounded-3xl hover:bg-amber-400">Shop Now</button></a>
                <a href="productForm.jsp"> <button class="md:text-xl bg-emerald-600 py-3 px-6 rounded-3xl  hover:bg-emerald-700 text-white ">Sell Products</button></a>
            </div>
        </div>
    </div>

    <div class="p-6 mb-8 flex flex-col items-center md:my-12">
        <p class="text-xl pb-2">Our Categories</p>
        <p class="text-2xl font-semibold pb-8 md:text-4xl md:pb-14">Shop By Category</p>
        <div class=" flex flex-wrap gap-6  justify-center lg:gap-[calc(5vw)]">
            <div class="transition-transform duration-300 hover:scale-105">
                <a href="products?category=indoor">
                <img class="h-40  md:h-60 rounded-xl " src="./assets/plant3.jpg" alt="">
                <p class="my-1">Indoor Plants</p>
                </a>
            </div>
            <div class="transition-transform duration-300 hover:scale-105">
                <a href="products?category=outdoor">
                <img class="h-40 md:h-60 rounded-xl" src="./assets/plant7.jpg" alt="">
                <p class="my-1">Outdoor Plants</p>
                </a>
            </div>
             <div class="transition-transform duration-300 hover:scale-105">
                 <a href="products?category=flowering">
                <img class="h-40 md:h-60 rounded-xl" src="./assets/plant10.jpg" alt="">
                <p class="my-1">Flowering Plants</p>
                </a>
            </div>
            <div class="transition-transform duration-300 hover:scale-105">
                <a href="products?category=potsandaccesories">
                <img class="h-40 w-40  md:h-60 md:w-60 rounded-xl" src="./assets/classic ribbed teracotta planter.jpg" alt="">
                <p class="my-1">Pots & Accessories</p>
                </a>
            </div>
        </div>
    </div>

     <div class="bg-gray-100 flex justify-center flex-wrap gap-4 sm:gap-8 md:gap-18 md:pt-20 lg:gap-24 p-8 md:p-10 lg:mx-20  lg:rounded-2xl">
        <img class="w-70 rounded-2xl lg:w-90" src="./assets/bringing-nature-close.jpg" alt="">
        <div class=" flex flex-col gap-4 ml-2 justify-center ">
            <p class="font-semibold  mb-[-0.5rem] lg:text-xl">About us</p>
            <p class="text-3xl font-semibold lg:text-[40px]  ">Bringing nature closer <br> to your doorstep</p>
            <p class="max-w-[23rem] lg:text-lg lg:my-2">Whether it’s a quiet corner of your home, a sunny balcony, or a busy office desk — there’s a plant waiting to bring life, calm, and inspiration into your space. Because every leaf is a reminder that growth begins wherever you're rooted.</p>
            <div class="p-4 bg-emerald-800 rounded-2xl w-[20rem] flex justify-between">
                <div class="flex flex-col">
                    <p class="text-yellow-400 text-2xl">20+</p>
                    <p class="text-white text-sm">Categories</p>
                </div>
                <div class="flex flex-col">
                    <p class="text-yellow-400 text-2xl">600+</p>
                    <p class="text-white text-sm">Products</p>
                </div>
                <div class="flex flex-col">
                    <p class="text-yellow-400 text-2xl">99%</p>
                    <p class="text-white text-sm">Satisfied customer</p>
                </div>

            </div>
        </div>
    </div>





    <script>
        const smallList = document.querySelector('#small-list');
        function displayList() {
        
          smallList.classList.toggle("hidden");
        }
    </script>
    </body>
</html>
