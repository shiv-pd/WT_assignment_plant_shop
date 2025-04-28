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
import jakarta.servlet.http.HttpSession;
import static java.lang.System.out;
import java.sql.*;
import java.util.Base64;
import model.Plant;

/**
 *
 * @author LENOVO
 */
@WebServlet(urlPatterns = {"/buyServlet"})
public class buyServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        int productId = Integer.parseInt(request.getParameter("productId"));
        int userId = Integer.parseInt(request.getParameter("userId"));

        boolean hasCartItem = false;

        String productName = "";
        String productCategory = "";
        double price = 0;
        int totalstock = 0;
        int quantityInCart = 0;
        String base64Image = "";
        String description ="";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String sqlForCart = "select * from cartitems WHERE user_id = ? and product_id = ? ";
            String sqlForProduct = "select * from products WHERE product_id = ? ";
            String sqlForImages = "select * from images WHERE product_id = ? ";

            String updateQtySql = "insert into cartitems(user_id, product_id, quantity, added_at) values(?,?,?,?) on duplicate key  UPDATE  quantity = 1 ";

            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/plantdb", "root", "Shiv26@333");
            PreparedStatement ps = conn.prepareStatement(sqlForCart);
            PreparedStatement ps1 = conn.prepareStatement(sqlForProduct);
            PreparedStatement ps2 = conn.prepareStatement(sqlForImages);

            PreparedStatement updateStmt = conn.prepareStatement(updateQtySql);

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {                                     //cart

                quantityInCart = rs.getInt("quantity");
                hasCartItem = true;

            }

            if (quantityInCart == 0) {
                // update quantity to 1
                java.sql.Date date = new java.sql.Date(System.currentTimeMillis());

                updateStmt.setInt(1, userId);
                updateStmt.setInt(2, productId);
                updateStmt.setInt(3, 1);
                updateStmt.setDate(4, date);

                updateStmt.executeUpdate();

                quantityInCart = 1; // update local variable too
            }
            ps1.setInt(1, productId);
            ResultSet rs1 = ps1.executeQuery();

            if (rs1.next()) {                                 //product
                productName = rs1.getString("name");
                productCategory = rs1.getString("category");
                price = rs1.getDouble("price");
                totalstock = rs1.getInt("total_stock");
                description = rs1.getString("description");
            }

            ps2.setInt(1, productId);
            ResultSet rs2 = ps2.executeQuery();

            if (rs2.next()) {                                  //images
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

            out.println("p is " + p);
            out.println("Product ID: " + p.getId());
            out.println("Product Name: " + p.getName());
            out.println("Product Category: " + p.getCategory());
            out.println("Price: " + p.getPrice());
            out.println("Quantity in Cart: " + p.getQuantityInCart());
            out.println("Total Stock: " + p.getTotalStock());
            out.println("Base64 Image: " + p.getBase64Image());

            request.setAttribute("plantToBuy", p);

         

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

        RequestDispatcher dispatcher = request.getRequestDispatcher("buy.jsp");
        dispatcher.forward(request, response);

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
