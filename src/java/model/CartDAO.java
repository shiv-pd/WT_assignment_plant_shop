package model;

import java.sql.*;

public class CartDAO {
    
    private Connection conn;
    
    public CartDAO() {
        try{
             Class.forName("com.mysql.cj.jdbc.Driver");
             conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/plantdb", "root", "Shiv26@333");
          
            }catch(ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void updateQuantity(int productId, int userID,  int change) {
        try {
            
            PreparedStatement ps2 = conn.prepareStatement("select * from cartitems WHERE product_id = ? AND user_id = ?");
            ps2.setInt(1, productId);
            ps2.setInt(2, userID);
            
            ResultSet rs = ps2.executeQuery();
            
            if(rs.next()){
               if( rs.getInt("quantity") == 0 && change == -1){
                   return;
               }
                
                
            }
            
            PreparedStatement ps1 = conn.prepareStatement("UPDATE cartitems SET quantity = quantity + ? WHERE product_id = ? AND user_id = ?");
            ps1.setInt(1, change);
            ps1.setInt(2, productId);
            ps1.setInt(3, userID);
            ps1.executeUpdate();

           
           
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    
     public void removeItem(int productId, int userID) {
        try {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM cartitems WHERE product_id = ? AND user_id = ?");
            ps.setInt(1, productId);
            ps.setInt(2, userID);
            
            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
