/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Plant;
import java.sql.*;
import java.util.*;

/**
 *
 * @author LENOVO
 */
@WebServlet(urlPatterns = {"/orderServlet"})
public class orderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = Integer.parseInt(request.getParameter("userId"));
        System.out.println("User ID: " + userId);

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

            String sqlForOrders = "insert into orders (user_id, order_date, total_amount,payment_status, delivery_status) values (?,?,?,?,?)";
            String sqlForOrderitems = "insert into orderitems (order_id, product_id, quantity, price) values(?,?,?,?)";

            String sqlForDeleteCart = "delete from cartitems WHERE user_id = ? ";

            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/plantdb", "root", "Shiv26@333");
            PreparedStatement ps = conn.prepareStatement(sqlForCart);
            PreparedStatement ps1 = conn.prepareStatement(sqlForProduct);
            PreparedStatement ps2 = conn.prepareStatement(sqlForImages);
            PreparedStatement ps3 = conn.prepareStatement(sqlForOrders, Statement.RETURN_GENERATED_KEYS);
            PreparedStatement ps4 = conn.prepareStatement(sqlForOrderitems);
            PreparedStatement ps5 = conn.prepareStatement(sqlForDeleteCart);

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

                total_price += price * quantityInCart;
            }

            total_price += delivery;

            java.sql.Date date = new java.sql.Date(System.currentTimeMillis());

            ps3.setInt(1, userId);
            ps3.setDate(2, date);
            ps3.setDouble(3, total_price);
            ps3.setString(4, "Pending");
            ps3.setString(5, "Processing");

            int result = ps3.executeUpdate();

            int orderId = 0;

            if (result > 0) {
                System.out.println("your order was created");

                ResultSet res = ps3.getGeneratedKeys();
                if (res.next()) {
                    orderId = res.getInt(1);
                }
            }

            for (Plant p : plantList) {

                ps4.setInt(1, orderId);
                ps4.setInt(2, p.getId());
                ps4.setInt(3, p.getQuantityInCart());
                ps4.setDouble(4, p.getPrice());

                ps4.executeUpdate();

            }

            ps5.setInt(1, userId);
            ps5.executeUpdate();

            rs.close();

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
        }

        response.sendRedirect("cartItems.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
