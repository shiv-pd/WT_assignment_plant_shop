/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import model.CartDAO;
import java.sql.*;
import java.util.Base64;
import model.Plant;

@WebServlet(urlPatterns = {"/cartItems"})
public class cartItemsServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int productId = Integer.parseInt(request.getParameter("productId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        String action = request.getParameter("action");
        String source = request.getParameter("source");

        String productName = "";
        String productCategory = "";
        double price = 0;
        int totalstock = 0;
        int quantityInCart = 0;
        String base64Image = "";
        String description ="";

        PrintWriter out = response.getWriter();
        out.println("Action: " + action);
        out.println("Product ID: " + productId);
        out.println("User ID: " + userId);

        CartDAO dao = new CartDAO();

        if (null != action) {
            switch (action) {
                case "increase" ->
                    dao.updateQuantity(productId, userId, 1);
                case "decrease" ->
                    dao.updateQuantity(productId, userId, -1);
                case "remove" ->
                    dao.removeItem(productId, userId);
                default -> {
                }
            }
        }

        if ("buy.jsp".equals(source)) {

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                String sqlForCart = "select * from cartitems WHERE user_id = ? and product_id = ? ";
                String sqlForProduct = "select * from products WHERE product_id = ? ";
                String sqlForImages = "select * from images WHERE product_id = ? ";

                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/plantdb", "root", "Shiv26@333");
                PreparedStatement ps = conn.prepareStatement(sqlForCart);
                PreparedStatement ps1 = conn.prepareStatement(sqlForProduct);
                PreparedStatement ps2 = conn.prepareStatement(sqlForImages);

                ps.setInt(1, userId);
                ps.setInt(2, productId);

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
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

                    request.setAttribute("plantToBuy", p);

                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            RequestDispatcher dispatcher = request.getRequestDispatcher("buy.jsp");
            dispatcher.forward(request, response);
        }
        
        if ("buy-jsp-delete".equals(source)) {

            response.sendRedirect("products");
        }
        
        if ("cartItems.jsp".equals(source)) {
            response.sendRedirect("cartItems.jsp");
        }

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
