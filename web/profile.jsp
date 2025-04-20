<%@ page import="java.util.*" %>
<%@ page import="model.Plant" %>


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
                <li class="mx-4"><a href="#">cart</a></li>
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

//            String productName = "";
//            double price = 0;
//            int total_stock = 0;
//            String image_name = "";
//            String base64Image  = "";
//            
            List<Plant> plantList = new ArrayList<>();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                String sqlForUsers = "select * from users WHERE user_id = ? ";
                String sqlForAddresses = "select * from addresses where user_id = ?";
                String sqlForProducts = "select p.product_id, p.name, p.price, p.total_stock, i.image_name, i.image_data from products p JOIN images i ON p.product_id = i.product_id where p.seller_id = ? ";

                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/plantdb", "root", "Shiv26@333");
                PreparedStatement ps = conn.prepareStatement(sqlForUsers);
                PreparedStatement ps1 = conn.prepareStatement(sqlForAddresses);
                PreparedStatement ps2 = conn.prepareStatement(sqlForProducts);

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

                rs.close();
                rs1.close();
                rs2.close();
                ps.close();
                ps1.close();
                ps2.close();
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





                <div> <span class="text-2xl text-emerald-800 font-semibold">Hi <%= username %>!</span> <span class="text-lg text-black ml-2 font-small ">Edit Your Profile</span></div>
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
                if(plantList.size() > 0){
                   
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
                
                <%
                  for (Plant p : plantList) {
                   
                
                %>
                <div class=" mt-4 pb-4 grid  grid-cols-[20vw_16vw_12vw_6vw_1vw]  sm:grid-cols-[8rem_5rem_4rem_1.5rem_2.5rem_2rem] lg:grid-cols-[9rem_9rem_6rem_3rem_3rem_3rem] gap-y-6 gap-x-5 sm:gap-x-8">

                    <div class="flex flex-col ">
                        <a href="specificProduct?id=<%= p.getId() %>" class="flex justify-center">
                            <img src="data:image/jpeg;base64,<%= p.getBase64Image()%>" alt="" class="size-20 sm:size-25  rounded-xl transition-transform duration-300 hover:scale-115">
                        </a>
                        </div>
                    <p class="hidden  lg:text-lg sm:flex items-center"><%= p.getName()%> </p>
                    <p class="lg:text-lg sm:flex items-center"> <%= p.getPrice() %></p>
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
           }else{
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






        <script>
            const smallList = document.querySelector('#small-list');
            function displayList() {

                smallList.classList.toggle("hidden");
            }
        </script>

        <script>
            const profile = document.getElementById("profile-container");
            const product = document.getElementById("product-container");
            const profileBtn = document.getElementById("profile-btn");
            const productBtn = document.getElementById("products-btn");

            function showProfile() {
                product.classList.add('hidden');
                profile.classList.remove('hidden');
                profileBtn.classList.add('bg-gray-200');
                productBtn.classList.remove('bg-gray-200');
            }

            function showProducts() {
                product.classList.remove('hidden');
                profile.classList.add('hidden');
                productBtn.classList.add('bg-gray-200');
                profileBtn.classList.remove('bg-gray-200');
            }
        </script>
    </body>
</html>
