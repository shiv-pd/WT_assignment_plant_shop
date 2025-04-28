<%@ page import="java.util.*" %>
<%@ page import="model.Plant" %>
<%@ page import="java.util.Date" %>

<%@ page import="model.order" %>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Profile</title>
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            .bg-image{
                background-image: url('./assets/login-background.jpg');
                background-size: cover;
                background-repeat: no-repeat;
                backdrop-filter: blur(9px);
                /* background-position: right; */
            }
        </style>
    </head>
    <body class="bg-image">
        <nav class="sticky flex justify-around p-4 sm:p-10 sm:pb-6 text-xl bg-white">
            <h1 class="text-2xl font-bold">Plant Shop</h1>
            <div onclick="displayList()" class="sm:hidden mt-1.5"><i class="fa-solid fa-bars "></i></div>


            <ul class="sm:flex sm:justify-around hidden">
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



        <%
            String username = (String) session.getAttribute("username");

            Integer userId = (Integer) session.getAttribute("user_id");

            String fullName = "";
            String email = "";
            String phoneNo = "";
            String addressLine = "";
            String city = "";
            String state = "";
            int postalCode = 0;
            String country = "";

            boolean areOrders = false;

//            String productName = "";
//            double price = 0;
//            int total_stock = 0;
//            String image_name = "";
//            String base64Image  = "";
            int orderId;
            Date order_date;
            double total_amount;
            String payment_status = "";
            String delivery_status = "";
            int orderItemId;
            int orderProductId;
            int orderquantity;
            double orderPrice;

//            
            List<Plant> plantList = new ArrayList<>();
            List<order> ordersList = new ArrayList<>();
            List<order> ordersItemsList = new ArrayList<>();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                String sqlForUsers = "select * from users WHERE user_id = ? ";
                String sqlForAddresses = "select * from addresses where user_id = ?";
                String sqlForProducts = "select p.product_id, p.name, p.price, p.total_stock, i.image_name, i.image_data from products p JOIN images i ON p.product_id = i.product_id where p.seller_id = ? ";
                String sqlForOrders = "select * from orders where user_id = ?";
                String sqlForOrderItems = "select * from orderitems where order_id = ? ";
                String sqlForOrderItemImage = "select * from images where product_id = ? ";

                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/plantdb", "root", "Shiv26@333");
                PreparedStatement ps = conn.prepareStatement(sqlForUsers);
                PreparedStatement ps1 = conn.prepareStatement(sqlForAddresses);
                PreparedStatement ps2 = conn.prepareStatement(sqlForProducts);
                PreparedStatement ps3 = conn.prepareStatement(sqlForOrders);
                PreparedStatement ps4 = conn.prepareStatement(sqlForOrderItems);
                PreparedStatement ps5 = conn.prepareStatement(sqlForOrderItemImage);

                ps.setInt(1, userId);
                ps1.setInt(1, userId);
                ps2.setInt(1, userId);

                ResultSet rs = ps.executeQuery();
                ResultSet rs1 = ps1.executeQuery();
                ResultSet rs2 = ps2.executeQuery();

                if (rs.next()) {
                    fullName = rs.getString("full_name");
                    email = rs.getString("email");
                    phoneNo = rs.getString("phone_number");
                }

                if (rs1.next()) {
                    addressLine = rs1.getString("address_line");
                    city = rs1.getString("city");
                    state = rs1.getString("state");
                    postalCode = rs1.getInt("postal_code");
                    country = rs1.getString("country");
                }

                while (rs2.next()) {

                    String imageName = rs2.getString("image_name");
                    Blob imageData = rs2.getBlob("image_data");

                    byte[] imageBytes = imageData.getBytes(1, (int) imageData.length());
                    String base64Image = Base64.getEncoder().encodeToString(imageBytes);

                    Plant p = new Plant(
                            rs2.getInt("product_id"),
                            rs2.getString("name"),
                            rs2.getDouble("price"),
                            rs2.getInt("total_stock"),
                            base64Image
                    );

                    plantList.add(p);
                }

                // for orders
                ps3.setInt(1, userId);
                ResultSet rs3 = ps3.executeQuery();

                while (rs3.next()) {
                    areOrders = true;

                    orderId = rs3.getInt("order_id");
                    order_date = rs3.getDate("order_date");
                    total_amount = rs3.getDouble("total_amount");
                    payment_status = rs3.getString("payment_status");
                    delivery_status = rs3.getString("delivery_status");

                    order o = new order(
                            orderId,
                            userId,
                            order_date,
                            total_amount,
                            payment_status,
                            delivery_status
                    );
                    ordersList.add(o);
                }

                for (order o : ordersList) {
                    int orderNumber = o.getOrderId();

                    ps4.setInt(1, orderNumber);
                    ResultSet rs4 = ps4.executeQuery();

                    while (rs4.next()) {
//                        orderItemId = rs3.getInt("order_item_id");
                        orderProductId = rs4.getInt("product_id");
                        orderquantity = rs4.getInt("quantity");
                        orderPrice = rs4.getDouble("price");

                        ps5.setInt(1, orderProductId);

                        ResultSet rs5 = ps5.executeQuery();
                        String orderBase64Image = "";

                        if (rs5.next()) {
                            Blob orderImageData = rs5.getBlob("image_data");

                            byte[] orderImageBytes = orderImageData.getBytes(1, (int) orderImageData.length());
                            orderBase64Image = Base64.getEncoder().encodeToString(orderImageBytes);

                        }
                        rs5.close();
                        order o1 = new order(
                                orderNumber,
                                orderProductId,
                                orderquantity,
                                orderPrice,
                                orderBase64Image
                        );
                        ordersItemsList.add(o1);

                    }
                    rs4.close();

                }

                rs.close();
                rs1.close();
                rs2.close();
                ps.close();
                ps1.close();
                ps2.close();
                ps3.close();
                ps4.close();
                ps5.close();
                conn.close();
                //                    ps.close();
                //                    conn.close();

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("login.jsp");
            }


        %>
        <!-- <div class="  form-container w-full flex flex-col justify-center items-center gap-4 py-8"> -->

        <div class="flex bg-gray-100 md:w-[40rem] lg:w-[50rem] md:mx-auto  md:rounded-xl  text-lg justify-evenly md:my-6 ">
            <div onclick="showProfile()" id="profile-btn" class="px-6 py-4 sm:px-12 bg-gray-200 hover:bg-gray-200 cursor-pointer">Profile</div>
            <div onclick="showProducts()" id="products-btn" class="px-6 py-4 sm:px-10 hover:bg-gray-200 cursor-pointer">My products</div>
            <div onclick="showOrders()" id="orders-btn" class="px-6 py-4 sm:px-12 hover:bg-gray-200 cursor-pointer">My Orders</div>
        </div>

        <div id="profile-container" class="">
            <div class="bg-gray-100 md:w-[40rem] lg:w-[50rem] md:mx-auto flex flex-col justify-center items-center p-8 md:mt-8 pb-0 md:mb-12 md:rounded-2xl">





                <div> <span class="text-2xl text-emerald-800 font-semibold">Hi <%= username%>!</span> <span class="text-lg text-black ml-2 font-small ">Edit Your Profile</span></div>
                <form action="updateProfile" method="post" class="flex flex-col min-w-[25rem] sm:w-[35rem] gap-1 p-8 bg-gray-100 rounded-2xl">
                    <label for="full_name" class="ml-1.5 text-lg" >Full Name </label>
                    <input value="<%= fullName%>" id="full_name" type="text" name="full_name" required class="text-sm mb-6   bg-white border-2 border-gray-200  rounded-lg p-3 focus:outline-none"/>
                    <label for="email" class="ml-1.5 text-lg" >Email </label>
                    <input value="<%= email%>" id="email" type="text" name="email" required class="text-sm mb-6  bg-white border-2 border-gray-200  rounded-lg p-3 focus:outline-none"/>
                    <label for="phoneno" class="ml-1.5 text-lg" >Phone number </label>
                    <input value="<%= phoneNo%>" id="phoneno" type="text" name="phoneno" required class="text-sm mb-6  bg-white border-2 border-gray-200 rounded-lg p-3 focus:outline-none"/>
                    <label for="adressline" class="ml-1.5 text-lg">Address Line</label>
                    <input value="<%= addressLine%>" id="adressline" type="text" name="address_line" required  class="text-sm mb-6 bg-white border-2 border-gray-200  rounded-lg p-3 focus:outline-none"/>
                    <label for="city" class="ml-1.5 text-lg">City</label>
                    <input value="<%= city%>" id="city" type="text" name="city" required class="text-sm mb-6 bg-white border-2 border-gray-200 rounded-lg p-3 focus:outline-none" />
                    <label for="state" class="ml-1.5 text-lg">State</label>
                    <input value="<%= state%>" id="state" type="text" name="state"  required  class="text-sm mb-6 bg-white border-2 border-gray-200  rounded-lg p-3 focus:outline-none"/>
                    <label for="postalcode" class="ml-1.5 text-lg">Postal Code</label>
                    <input value="<%= postalCode%>" id="postalcode" type="text" name="postal_code"  required class="text-sm mb-6  bg-white border-2 border-gray-200 rounded-lg p-3 focus:outline-none" />
                    <label for="country" class="ml-1.5 text-lg">Country</label>
                    <input value="<%= country%>" id="country" type="text" name="country"  required  class="text-sm mb-6  bg-white border-2 border-gray-200  rounded-lg p-3 focus:outline-none"/>



                    <button type="submit" class="m-7 text-xl bg-emerald-700 text-white rounded-xl  w-fit px-4 py-2  self-center">Save & Continue</button>
                </form>
            </div>

        </div>
        <div id="product-container" class="min-h-[80vh] max-h-[81vh] hidden md:mb-20 " >

            <%
                if (plantList.size() > 0) {

            %>

            <div class=" overflow-y-scroll  h-[75vh] divide-y-2 divide-gray-300 bg-gray-100  md:w-[40rem] lg:w-[50rem] md:mx-auto flex flex-col items-center p-6 sm:p-8 md:mt-8 pb-0 md:mb-12 md:rounded-2xl ">
                <form action="productForm.jsp" class="mb-8">
                    <button type="submit" class="bg-emerald-600 hover:bg-emerald-700 px-4 py-2 text-white rounded-lg ">Sell more products</button>
                </form>
                <div
                    class="pb-4  grid  grid-cols-[20vw_16vw_12vw_6vw_1vw]  sm:grid-cols-[8rem_5rem_4rem_1.5rem_2.5rem_2rem] lg:grid-cols-[9rem_9rem_6rem_3rem_3rem_3rem] gap-y-6 gap-x-5 sm:gap-x-8">

                    <div class=" text-lg lg:text-xl font-semibold ">Product</div>
                    <p class="text-lg lg:text-xl  font-semibold hidden sm:inline">Name</p>
                    <p class="text-lg lg:text-xl  font-semibold">Price<span class="text-sm font-medium">(Rs)</span></p>
                    <p class="text-lg lg:text-xl  font-semibold">Stock</p>
                    <div></div>
                    <div></div>
                </div>

                <%                    for (Plant p : plantList) {


                %>
                <div class=" mt-4 pb-4 grid  grid-cols-[20vw_16vw_12vw_6vw_1vw]  sm:grid-cols-[8rem_5rem_4rem_1.5rem_2.5rem_2rem] lg:grid-cols-[9rem_9rem_6rem_3rem_3rem_3rem] gap-y-6 gap-x-5 sm:gap-x-8">

                    <div class="flex flex-col ">
                        <a href="specificProduct?id=<%= p.getId()%>" class="flex justify-center">
                            <img src="data:image/jpeg;base64,<%= p.getBase64Image()%>" alt="" class="size-20 sm:size-25  rounded-xl transition-transform duration-300 hover:scale-115">
                        </a>
                    </div>
                    <p class="hidden  lg:text-lg sm:flex items-center"><%= p.getName()%> </p>
                    <p class="lg:text-lg sm:flex items-center"> <%= p.getPrice()%></p>
                    <p class="lg:text-lg sm:flex items-center"><%=p.getTotalStock()%></p>
                    <div class="sm:ml-4 lg:text-lg sm:flex items-center"><i
                            class="fa-solid fa-pencil text-gray-500 hover:text-green-600"></i></div>
                    <div class="lg:text-lg sm:flex items-center"><i
                            class="fa-solid fa-trash text-gray-500 hover:text-red-600"></i></div>

                </div>
                <%
                    }
                %>

            </div>
            <%
            } else {
            %> 

            <div class=" min-h-[70vh]  bg-gray-100  md:w-[40rem] lg:w-[50rem] md:mx-auto flex flex-col items-center p-6 sm:p-8 md:mt-12 pb-0 md:mb-12 md:rounded-2xl">

                <div class="text-xl md:text-2xl font-semibold mt-8">You Don't have any plants on sell!!</div>
                <img class="h-[20rem] " src="./assets/not-found.png"/>
                <form action="productForm.jsp" class="my-8">
                    <button type="submit" class="bg-emerald-600 hover:bg-emerald-700 px-4 py-2 text-white rounded-lg ">Sell products</button>
                </form>

            </div>


            <%
                }
            %>

        </div>    

        <div id="order-container" class="min-h-[80vh] max-h-[81vh] hidden md:mb-20 p-0 sm:p-8" >

            <%
                if (ordersList.size() > 0) {

            %>

            <div class="  overflow-y-scroll  h-[75vh]  bg-gray-100  md:w-[40rem] lg:w-[50rem] md:mx-auto flex flex-col items-center p-0  sm:p-8 md:mt-8 pb-0 md:mb-12 md:rounded-2xl ">
                <form action="products" class="mb-8">
                    <button type="submit" class="bg-amber-300 hover:bg-amber-400 px-4 py-2 text-white rounded-lg ">order more </button>
                </form>
                <div
                    class="pb-4  grid  grid-cols-[4vw_20vw_12vw_12.5vw_12.5vw_4vw]  sm:grid-cols-[4rem_4rem_4rem_4rem_4rem_2rem] lg:grid-cols-[2rem_7rem_4rem_6rem_6rem_3.5rem] gap-y-6 gap-x-5 sm:gap-x-8 border-b-2 border-gray-200">

                    <div class=" text-md lg:text-lg font-semibold  "></div>
                    <p class="text-md lg:text-lg  font-semibold  ">Placed On</p>
                    <p class="text-md lg:text-lg  font-semibold ">Total<span class="text-sm font-medium">(Rs)</span></p>
                    <p class="text-md lg:text-lg  font-semibold  ">Payment</p>
                    <p class="text-md lg:text-lg  font-semibold ">Delivery</p>
                    <div></div>

                </div>

                <%   for (order o : ordersList) {%>

                <div class=" mt-4 pb-4 grid  grid-cols-[4vw_20vw_12vw_12.5vw_12.5vw_4vw]  sm:grid-cols-[4rem_4rem_4rem_4rem_4rem_2rem] lg:grid-cols-[2rem_7rem_4rem_6rem_6rem_3.5rem] gap-y-6 gap-x-5 sm:gap-x-8">

                    <div class="text-sm  flex "> <%= o.getOrderId()%></div>
                    <p class="text-sm   lg:text-md sm:flex items-center"><%=o.getOrderDate()%> </p>
                    <p class="text-sm  lg:text-md sm:flex items-center"> <%= o.getTotalAmount()%></p>
                    <p class="text-sm  lg:text-md sm:flex items-center"><%=o.getPaymentStatus()%></p>
                    <p class="text-sm  lg:text-md sm:flex items-center"><%=o.getDeliveryStatus()%></p>
                    <button data-order-id="<%= o.getOrderId()%>" class="flex items-center justify-center bg-gray-50 text-sm sm:ml-4 sm:py-2 lg:text-lg sm:flex items-center" onclick="showOrderItems(event)"><i class="fa-solid  fa-chevron-right text-gray-500 hover:text-green-600"></i></button>
                </div>


                <div  id="order-items-<%= o.getOrderId()%>" class="hidden bg-white py-4 px-6 w-[90%] ">
<!--                    <div class="pb-4  grid  grid-cols-[20vw_20vw_6vw_8vw]  sm:grid-cols-[8rem_5rem_4rem_4rem] lg:grid-cols-[9rem_5rem_4rem_4rem] gap-y-6 gap-x-5 sm:gap-x-8">-->
<div class="pb-4  grid  grid-cols-[2fr_2fr_2fr_2fr]  gap-y-6 gap-x-5 sm:gap-x-8">

                        <div class=" text-sm lg:text-md font-semibold ">Product</div>
                        <p class="text-sm lg:text-md  font-semibold ">Name</p>
                        <p class="text-sm lg:text-md  font-semibold ">Quantity</p>
                        <p class="text-sm lg:text-md  font-semibold">Price</p>

                    </div>
                    <%
                        for (order o1 : ordersItemsList) {

                            if (o.getOrderId() == o1.getOrderId()) {


                    %>  
                    <div class=" mt-4 pb-4 grid  grid-cols-[2fr_2fr_2fr_2fr]   gap-y-6 gap-x-5 sm:gap-x-8">

                        <a href="specificProduct?id=<%= o1.getOrderProductId() %>">
                            
                              <div class="flex text-sm lg:text-md">  <img src="data:image/jpeg;base64,<%= o1.getOrderBase64Image() %>"  class="size-20 sm:size-25  rounded-xl transition-transform duration-300 hover:scale-115"/></div>
                      
                            
                        </a>
                        
                        <p class="flex items-center  text-sm lg:text-md ">name </p>
                        <p class="flex items-center  text-sm lg:text-md "><%=o1.getorderquantity()%> </p>
                        <p class="flex items-center  text-sm lg:text-md "> <%= o1.getorderPrice()%></p>

                    </div>

                    <%   }
                        }  %>

                </div> 



                <%
                    }
                %>

            </div>
            <%
            } else {
            %> 

            <div class=" min-h-[70vh]  bg-gray-100  md:w-[40rem] lg:w-[50rem] md:mx-auto flex flex-col items-center p-6 sm:p-8 md:mt-12 pb-0 md:mb-12 md:rounded-2xl">

                <div class="text-xl md:text-2xl font-semibold mt-8">You Don't have any orders!!</div>
                <img class="h-[20rem] " src="./assets/not-found.png"/>
                <form action="products" class="my-8">
                    <button type="submit" class="bg-emerald-600 hover:bg-emerald-700 px-4 py-2 text-white rounded-lg ">Order something..</button>
                </form>

            </div>


            <%
                }
            %>

        </div>    





        <script>
            const smallList = document.querySelector('#small-list');
            function displayList() {

                smallList.classList.toggle("hidden");
            }
        </script>

        <script>
            const profile = document.getElementById("profile-container");
            const product = document.getElementById("product-container");
            const orders = document.getElementById("order-container");

            const profileBtn = document.getElementById("profile-btn");
            const productBtn = document.getElementById("products-btn");
            const ordersBtn = document.getElementById("orders-btn");



            function showProfile() {
                profile.classList.remove('hidden');
                product.classList.add('hidden');
                orders.classList.add('hidden');

                profileBtn.classList.add('bg-gray-200');
                productBtn.classList.remove('bg-gray-200');
                ordersBtn.classList.remove('bg-gray-200');
            }

            function showProducts() {
                product.classList.remove('hidden');
                profile.classList.add('hidden');
                orders.classList.add('hidden');

                productBtn.classList.add('bg-gray-200');
                profileBtn.classList.remove('bg-gray-200');
                ordersBtn.classList.remove('bg-gray-200');
            }

            function showOrders() {
                orders.classList.remove('hidden');
                profile.classList.add('hidden');
                product.classList.add('hidden');

                ordersBtn.classList.add('bg-gray-200');
                profileBtn.classList.remove('bg-gray-200');
                productBtn.classList.remove('bg-gray-200');
            }

            function getOrderItems() {

            }

            const itemContainer = document.querySelector("#order-items");

            function showOrderItems(e) {
                e.preventDefault();

                const button = event.currentTarget;

                const orderId = button.getAttribute('data-order-id');
                const itemsDiv = document.getElementById('order-items-' + orderId);

                if (itemsDiv) {
                    itemsDiv.classList.toggle('hidden');
                }

            }

//            document.querySelectorAll('button[data-order-id]').forEach(button => {
//                button.addEventListener('click',showOrderItems );
//            });
        </script>
    </body>
</html>
