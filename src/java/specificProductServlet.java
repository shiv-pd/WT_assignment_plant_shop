/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

//import com.sun.jdi.connect.spi.Connection;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Plant;
import java.sql.*;
import java.util.Base64;



/**
 *
 * @author LENOVO
 */
@WebServlet(urlPatterns = {"/specificProduct"})
public class specificProductServlet extends HttpServlet {

   
   @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
            int productId = Integer.parseInt(request.getParameter("id"));
            
            System.out.println(productId);
            
                               
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
//             
             String sql = "SELECT * FROM products where product_id = ?";
             String sqlForImages = "SELECT * FROM images where product_id = ?";
             
             
            try (
                Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/plantdb", "root", "Shiv26@333");
//                    Connection conn = ds.getConnection();
                   
                PreparedStatement stmt = conn.prepareStatement(sql);
                PreparedStatement stmt1 = conn.prepareStatement(sqlForImages);
            ) {
                
                stmt.setInt(1,productId);
               
              
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    
                     stmt1.setInt(1,productId);
                     ResultSet imgRs = stmt1.executeQuery();
                     
                     
                     if(imgRs.next()){
                         
                        String  imageName = imgRs.getString("image_name");
                        Blob imageData = imgRs.getBlob("image_data");

                        byte[] imageBytes = imageData.getBytes(1,(int) imageData.length());
                        String base64Image = Base64.getEncoder().encodeToString(imageBytes);
                    
                        
                        
                        Plant p = new Plant(
                            rs.getInt("product_id"),
                            rs.getString("name"),
                            rs.getString("category"),
                            rs.getDouble("price"),
                            rs.getInt("total_stock"),
                            rs.getString("description"),
                            imageName,
                            base64Image 
                            
                        );
                        
                        request.setAttribute("plant", p);
                         
                     }
                    
                   
                }

            }} catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        
         
        RequestDispatcher dispatcher = request.getRequestDispatcher("specificProduct.jsp");
        dispatcher.forward(request, response);
    }

    
   @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int productId = Integer.parseInt(request.getParameter("id"));
        
          HttpSession session = request.getSession();
          int userId = (Integer) session.getAttribute("user_id");
                     
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
//             
            String sqlForCarts = "insert into cartitems (user_id, product_id, quantity, added_at) values(?,?,?,?) on duplicate key update quantity = quantity + 1";
            String sqlForProducts = "select p.*, i.image_name, i.image_data from products p JOIN images i ON p.product_id = i.product_id where p.product_id = ?  ";
             
             
            try (
                Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/plantdb", "root", "Shiv26@333");
//                    Connection conn = ds.getConnection();
                   
                PreparedStatement stmt = conn.prepareStatement(sqlForCarts);
                PreparedStatement stmt1 = conn.prepareStatement(sqlForProducts);
            ) {
                java.sql.Date date = new java.sql.Date(System.currentTimeMillis());

                
                stmt.setInt(1,userId);
                stmt.setInt(2,productId);
                stmt.setInt(3, 1);
                stmt.setDate(4, date);
               
              
                int rs = stmt.executeUpdate();

                if (rs > 0) {
                    
                     stmt1.setInt(1,productId);
                     ResultSet imgRs = stmt1.executeQuery();
                     
                     
                     if(imgRs.next()){
                         
                        String  imageName = imgRs.getString("image_name");
                        Blob imageData = imgRs.getBlob("image_data");

                        byte[] imageBytes = imageData.getBytes(1,(int) imageData.length());
                        String base64Image = Base64.getEncoder().encodeToString(imageBytes);
                    
                        
                        
                        Plant p = new Plant(
                            imgRs.getInt("product_id"),
                            imgRs.getString("name"),
                            imgRs.getString("category"),
                            imgRs.getDouble("price"),
                            imgRs.getInt("total_stock"),
                            imgRs.getString("description"),
                            imageName,
                            base64Image 
                            
                        );
                        request.setAttribute("plant", p);
                     }
                    
                   
                }

            }} catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        
         
        RequestDispatcher dispatcher = request.getRequestDispatcher("specificProduct.jsp");
        dispatcher.forward(request, response);
   
        
         
      
    }

   

    
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
