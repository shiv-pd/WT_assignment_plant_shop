<%-- 
    Document   : specificProduct
    Created on : Apr 16, 2025, 9:17:28 PM
    Author     : LENOVO
--%>
<%@ page import="java.sql.*" %>
<%@ page import="model.Plant" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Specific product</title>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    </head>
    <body data-user-id="<%= session.getAttribute("user_id")%>" class="h-[98vh] mt-[-0.25rem] w-full flex flex-col ">

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
        <ul id="small-list" class="bg-gray-100 text-xl w-full py-4 hidden sm:hidden  mb-8 ">
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



        <%
            Plant p = (Plant) request.getAttribute("plant");

            int addedToCart = 0;
            Integer userId = (Integer) session.getAttribute("user_id");

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                String sqlForCart = "select * from cartitems WHERE user_id = ? AND product_id = ?  ";

                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/plantdb", "root", "Shiv26@333");
                PreparedStatement ps = conn.prepareStatement(sqlForCart);

                ps.setInt(1, userId);
                ps.setInt(2, p.getId());

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    addedToCart = 1;
                }
                rs.close();
                ps.close();
                conn.close();
                //                    ps.close();
                //                    conn.close();

            } catch (Exception e) {
                e.printStackTrace();
            }


        %>

        <%                        
              if (p != null) {
        %>


        <div class=" h-fit md:h-[80vh] w-full p-8 md:pl-4 md:py-12 flex flex-col items-center self-center  md:flex-row md:justify-center md:items-start bg-gray-100 gap-6 md:gap-0 lg:gap-6 lg:mx-auto mb-5 md:mb-8 lg:rounded-2xl lg:w-[60rem] ">
            <img class="min-w-[18rem] w-[20rem] sm:min-w-[22rem] md:ml-4  md:min-w-[20rem]   mb-4 rounded-2xl" src="data:image/jpeg;base64,<%= p.getBase64Image()%>" alt="">
            <div class="flex flex-col gap-1.5 md:p-4 ml-[2rem]">
                <p class="opacity-50 text-sm"><%= p.getCategory()%></p>
                <div> <span class="text-lg font-semibold"><%= p.getName()%></span>

                    <%
                        int stock = p.getTotalStock();
                        if (stock > 0) {
                    %>
                    <span class=" text-xs ml-1  px-1.5 border-2 border-blue-300 bg-blue-100 rounded-2xl">
                        in stock </span>
                        <%
                        } else {
                        %>
                    <span class=" text-xs ml-1  px-1.5 border-2 border-red-300 bg-red-100 rounded-2xl"> 
                        out of stock</span>
                        <%
                            }
                        %>

                </div>
                <p class="text-2xl font-semibold"><%= p.getPrice()%></p>
                <p class="opacity-60 max-w-[22rem]"><%= p.getDescription()%></p>
                <div class="mt-2 flex gap-3 ">

                    <form id="addToCartForm" action="specificProduct" method="post"  >
                        <input type="hidden" name="id" value="<%= p.getId()%>"/>
                        <%
                            if (addedToCart == 1) {
                        %>

                        <button type="submit" class=" bg-gray-400 text-white rounded-3xl py-3 px-5  hover:bg-gray-600" disabled>Already in cart</button>

                        <%
                        } else {
                        %>
                        <button type="submit" class=" bg-emerald-600 text-white rounded-3xl py-3 px-5 hover:bg-emerald-700">Add to cart</button>
                        <%
                            }

                        %>


                    </form>
                        <form id="buyNowForm"  action="buyServlet" method="post" >
                             <input type="hidden" name="productId" value="<%= p.getId()%>" />
                             <input type="hidden" name="userId" value="<%= userId%>" />
                                     
                             <button  type="submit" class="bg-amber-300 hover:bg-amber-400  rounded-3xl py-3 px-5">buy now</button>
 
                        </form>
                </div>
            </div>
        </div>

        <%            
            } else {
                System.out.println("p is null");
            }
        %>

        <script>
            const smallList = document.querySelector('#small-list');
                function displayList() {
                  smallList.classList.toggle("hidden");
                };
            
        </script>
        
        <script>
           
            document.addEventListener("DOMContentLoaded", function () {
           
                const userId = document.body.dataset.userId;
                const addToCartForm = document.getElementById("addToCartForm");
                const buyNowForm = document.getElementById("buyNowForm");
              

                addToCartForm.addEventListener("submit", function(e) {
                    if (!userId || userId === "null") {
                        e.preventDefault(); 
                        alert("Please log in first to add items to cart.");

                        
                        window.location.href = `login.jsp`;
                        
                        
                    }});
                
                  buyNowForm.addEventListener("submit", function(e) {
                    if (!userId || userId === "null") {
                        e.preventDefault(); 
                        alert("Please log in first to buy the item.");

                        
                        window.location.href = `login.jsp`;
                        
                        
                    }});
               
                });

    
              
       
        </script>
    </body>
</html>
