<%-- 
    Document   : specificProduct
    Created on : Apr 16, 2025, 9:17:28 PM
    Author     : LENOVO
--%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="model.Plant" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cart</title>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            /* Chrome, Safari, Edge, Opera */
            input[type=number]::-webkit-outer-spin-button,
            input[type=number]::-webkit-inner-spin-button {
                -webkit-appearance: none;
                margin: 0;
            }

            /* Firefox */
            input[type=number] {
                -moz-appearance: textfield;
            }
        </style>

    </head>
    <body data-user-id="<%= session.getAttribute("user_id")%>" class="h-[98vh] mt-[-0.25rem] w-full flex flex-col ">

        <nav class="sticky z-10 flex justify-around p-4 sm:p-10 text-xl ">
            <h1 class="text-2xl font-bold">Plant Shop</h1>
            <div onclick="displayList()" class="sm:hidden mt-1.5"><i class="fa-solid fa-bars "></i></div>


            <ul class="sm:flex sm:justify-around hidden items-center">
                <li class="px-4 "><a href="home">Home</a></li>
                <li class="mx-4"><a href="products">Products</a></li>
                <li class="mx-4"><a href="#"><i class="fa-solid fa-cart-shopping opacity-60 hover:opacity-90"></i></a></li>
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
            <li class="py-2 px-8 hover:bg-amber-50"><a href="#"><i class="fa-solid fa-cart-shopping opacity-60 hover:opacity-90"></i></a></li>
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
            int addedToCart = 0;
            Integer userId = (Integer) session.getAttribute("user_id");

            double total_price = 0;
            double discount = 0;
            double delivery = 40;

            int productId = 0;
            String productName = "";
            String productCategory = "";
            double price = 0;
            int totalstock = 0;
            int quantityInCart = 0;
            String base64Image = "";
            String description = "";
            
            List<Plant> plantList = new ArrayList<>();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                String sqlForCart = "select * from cartitems WHERE user_id = ? ";
                String sqlForProduct = "select * from products WHERE product_id = ? ";
                String sqlForImages = "select * from images WHERE product_id = ? ";

                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/plantdb", "root", "Shiv26@333");
                PreparedStatement ps = conn.prepareStatement(sqlForCart);
                PreparedStatement ps1 = conn.prepareStatement(sqlForProduct);
                PreparedStatement ps2 = conn.prepareStatement(sqlForImages);

                ps.setInt(1, userId);

                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    productId = rs.getInt("product_id");
                    quantityInCart = rs.getInt("quantity");

                    ps1.setInt(1, productId);

                    ResultSet rs1 = ps1.executeQuery();

                    if (rs1.next()) {
                        productName = rs1.getString("name");
                        productCategory = rs1.getString("category");
                        price = rs1.getDouble("price");
                        totalstock = rs1.getInt("total_stock");
                        description = rs1.getString("description");
                    }

                    ps2.setInt(1, productId);
                    ResultSet rs2 = ps2.executeQuery();

                    if (rs2.next()) {
                        Blob imageData = rs2.getBlob("image_data");

                        byte[] imageBytes = imageData.getBytes(1, (int) imageData.length());
                        base64Image = Base64.getEncoder().encodeToString(imageBytes);
                    }

                    Plant p = new Plant(
                            productId,
                            productName,
                            productCategory,
                            totalstock,
                            price,
                            quantityInCart,
                            base64Image,
                             description
                    );

                    plantList.add(p);

                }

                rs.close();

                ps.close();
                ps1.close();
                ps2.close();
                conn.close();
                //                    ps.close();
                //                    conn.close();

            } catch (Exception e) {
                e.printStackTrace();
            }


        %>

        <%            if (userId == null) {
        %>


        <div class=" h-fit md:h-[80vh] w-full p-8 md:pl-4 md:py-12 flex flex-col items-center self-center  md:flex-row md:justify-center md:items-start bg-gray-100 gap-6 md:gap-0 lg:gap-6 lg:mx-auto mb-5 md:mb-8 lg:rounded-2xl lg:w-[60rem] bg-white ">
            <div class="flex flex-col gap-8 items-center justify-center w-full h-full ">
                <img class="h-[20rem] " src="./assets/not-found.png"/>
                <p class="text-xl font-semibold">No items in cart...<br> Please log in and add products</p>
            </div>
        </div>

        <%
            }
            if (plantList.size() > 0) {

        %>
        <div class="bg-gray-100  h-fit  w-full sm:p-8 flex justify-center self-center   gap-6 md:gap-0 lg:gap-6 lg:mx-auto mb-5 md:mb-8  ">

            <div class="flex flex-col  p-10 md:p-4 md:flex-row gap-6   h-fit mx-auto   ">
                <div class="divide-y-2 divide-gray-100 flex flex-col bg-white w-fit p-10 pt-6 md:w-[24rem] lg:w-[30rem] ">

                    <%                        for (Plant p : plantList) {

                            total_price += p.getPrice() * (double) p.getQuantityInCart();
                    %>

                    <div class="flex gap-6 py-4 lg:gap-8"  >
                        <img src="data:image/jpeg;base64,<%= p.getBase64Image()%>" alt="alt" class=" size-28 sm:size-35  rounded-xl transition-transform duration-300 hover:scale-115"/>
                        <div class="flex flex-col gap-0.5 sm:gap-1">
                            <div class="flex items-center gap-2">
                                <p class="sm:text-lg sm:font-semibold"><%= p.getName()%> </p> 
                                <span class=" hidden lg:inline text-xs ml-1  px-1.5 border-2 border-blue-300 bg-blue-100 rounded-2xl"> in stock </span>
                            </div>
                            <p class="text-md text-gray-500"><%= p.getCategory()%> </p>
                            <p class="font-semibold">Rs. <%= p.getPrice()%> </p>

                            <div class=" ">

                                <div class="flex h-fit w-22 sm:w-30 items-center border-2 border-gray-200 rounded-3xl divide-x-2 divide-gray-200  sm:px-2 mt-2 ">

                                    <form action="cartItems" method="post">
                                        <input type="hidden" name="action" value="decrease" />
                                        <input type="hidden" name="productId" value="<%= p.getId()%>" />
                                        <input type="hidden" name="userId" value="<%= userId%>" />
                                        <input type="hidden" name="source" value="cartItems.jsp">

                                        <button data-product-id =" <%= p.getId()%>" data-user-id="<%= userId%>" type="submit" onclick="decreaseQuantity(this)" class="px-1.5 sm:px-2  sm:py-1"><i class="fa-solid fa-minus text-sm sm:text-md"></i></button>
                                    </form>

                                    <form action="cartItems" method="post">
                                        <input type="hidden" name="productId" value="<%= p.getId()%>" />
                                        <input type="hidden" name="userId" value="<%= userId%>" />
                                        <input type="hidden" name="source" value="cartItems.jsp">
                                        <input data-product-id =" <%= p.getId()%>"  data-user-id="<%= userId%>" type="number" name="quantity" value="<%= p.getQuantityInCart()%>" min="0" class="w-8 sm:w-10 py-1 text-center   focus:outline-none " />

                                    </form>

                                    <form action="cartItems" method="post">
                                        <input type="hidden" name="action" value="increase" />
                                        <input type="hidden" name="productId" value="<%= p.getId()%>" />
                                        <input type="hidden" name="userId" value="<%= userId%>" />
                                        <input type="hidden" name="source" value="cartItems.jsp">

                                        <button data-product-id =" <%= p.getId()%>" data-user-id="<%= userId%>" type="submit" onclick="increaseQuantity(this)" class="px-1.5 sm:px-2  sm:py-1"><i class="fa-solid fa-plus text-sm sm:text-md"></i></button>
                                    </form>

                                </div>

                            </div>   

                            <div class="flex  gap-3 items-center justify-between md:w-[15rem]">


                                <form action="cartItems" method="post"  >
                                    <input type="hidden" name="action" value="remove" />
                                    <input type="hidden" name="productId" value="<%= p.getId()%>" />
                                    <input type="hidden" name="userId" value="<%= userId%>" />
                                    <input type="hidden" name="source" value="cartItems.jsp">

                                    <button type="submit" class="sm:text-lg sm:flex items-center mt-1 lg:ml-2" title="Remove product from cart"><i class="fa-solid fa-trash text-gray-400 hover:text-red-600"></i></button> 
                                </form>

                                <form id="buyNowForm"  action="buyServlet" method="post" class="self-end " >
                                    <input type="hidden" name="productId" value="<%= p.getId()%>" />
                                    <input type="hidden" name="userId" value="<%= userId%>" />

                                    <button  type="submit" class="bg-amber-300 hover:bg-amber-400   py-0.5 px-2 ">Buy now</button>

                                </form>  
                            </div>


                        </div>
                    </div>

                    <%
                        }
                    %>

                </div>


                <div class="divide-y-2 divide-gray-50 bg-white flex flex-col gap-1 border-2 border-gray-200 p-6  md:w-[22rem] h-fit sm:p-10 lg:w-[25rem]" >
                    <p class="text-lg font-semibold py-1.5">Price Details</p>
                    <div class="flex justify-between py-1.5 ">
                        <p>Price <span class="text-sm text-gray-400"> (<span><%= plantList.size()%></span>) items</span> </p>
                        <p><%= total_price%></p>
                    </div>
                    <div class="flex justify-between py-1.5">
                        <p>Discount </p>
                        <p><%= discount%></p>
                    </div>
                    <div class="flex justify-between py-1.5">
                        <p>Delivery charge</p>
                        <p><%= delivery%></p>
                    </div>
                    <div class="flex justify-between py-1.5 text-md font-semibold">
                        <p>Total amount</p>
                        <p><%= total_price + discount + delivery%></p>
                    </div>
                       
                    <form action="orderServlet" method="post"> 
                        <input class="hidden" name="userId" value="<%= userId %>" />
                        <button type="submit" class="mt-6 w-fit md:text-xl bg-amber-300 py-2.5 px-5 hover:bg-amber-400  self-end">Place Order</button>

                    </form>
                </div>


            </div>

        </div>

        <%      }
            if (userId != null && plantList.size() == 0) {


        %>



        <div class="flex flex-col gap-8 items-center justify-center w-full h-full ">
            <img class="h-[20rem] " src="./assets/not-found.png"/>
            <p class="text-xl font-semibold">No items in cart...<br> Please add products</p>
        </div>


        <%                }

        %>

        <script>




//            function increaseQuantity(button) {
//                const input = button.parentElement.querySelector('input[name="quantity"]');
//                let value = parseInt(input.value);
//                if (!isNaN(value)) {
//                    input.value = value + 1;
//
//                    const productId = button.getAttribute('data-product-id');
//                    const userId = button.getAttribute('data-user-id');
//
//                    console.log(productId, userId);
//
////                    updateQuantity(productId,userId , 1);
//
//                }
//            }
//
//            function decreaseQuantity(button) {
//                const input = button.parentElement.querySelector('input[name="quantity"]');
//                let value = parseInt(input.value);
//                if (!isNaN(value) && value > 1) {
//                    input.value = value - 1;
//
//                    const productId = button.getAttribute('data-product-id');
//                    const userId = button.getAttribute('data-user-id');
////                      updateQuantity(productId,userId, -1);
//
//                }
//            }
        </script>

        <script>
            window.addEventListener('beforeunload', function () {
                sessionStorage.setItem("scrollPos", window.scrollY);
            });
        </script>
        <script>
            window.addEventListener('load', function () {
                const scrollPos = sessionStorage.getItem("scrollPos");
                if (scrollPos !== null) {
                    window.scrollTo(0, parseInt(scrollPos));
                }
            });
        </script>


        <script>
            const smallList = document.querySelector('#small-list');
            function displayList() {
                smallList.classList.toggle("hidden");
            }
            ;

        </script>


    </body>
</html>
