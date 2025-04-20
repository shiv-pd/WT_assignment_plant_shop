/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;



@WebServlet(urlPatterns = {"/updateProfile"})
public class updateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
         HttpSession session = request.getSession();
         Integer userId =(Integer) session.getAttribute("user_id");    
       
          String fullName = request.getParameter("full_name");
          String email = request.getParameter("email");
          String phoneNo = request.getParameter("phoneno");
          String addressLine = request.getParameter("address_line");
          String city = request.getParameter("city");
          String state = request.getParameter("state");
          int postalCode = Integer.parseInt(request.getParameter("postal_code"));
          String country = request.getParameter("country");
          
          
          
          
           try{
              Class.forName("com.mysql.cj.jdbc.Driver");
              
             
              String checkForId = "SELECT * from addresses where user_id = ?";             
              String setId = "INSERT INTO addresses (user_id) values (?)";
              String sqlForUsers = "UPDATE users SET full_name = ? , email = ?, phone_number=?  where user_id=? ";
              String sqlForAddresses = "UPDATE addresses SET address_line= ?, city = ?, state =?, postal_code =?, country =?  where user_id=? ";
              
                try(
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/plantdb","root", "Shiv26@333");    
                    PreparedStatement psForIdCheck = conn.prepareStatement(checkForId);
                    PreparedStatement psForSetId = conn.prepareStatement(setId);
                    PreparedStatement psForUsers = conn.prepareStatement(sqlForUsers);
                    PreparedStatement psForAddresses = conn.prepareStatement(sqlForAddresses);
                ){
                    
                    psForIdCheck.setInt(1, userId);
                    ResultSet rs = psForIdCheck.executeQuery();
                    
                   
                    
                    if(!rs.next()){
                        
                         psForSetId.setInt(1, userId);
                         psForSetId.executeUpdate();
                        
                    }
                    
                    psForUsers.setString(1,fullName);
                            psForUsers.setString(2,email);
                            psForUsers.setString(3,phoneNo);
                            psForUsers.setInt(4,userId);

                            psForAddresses.setString(1,addressLine);
                            psForAddresses.setString(2,city);
                            psForAddresses.setString(3,state);
                            psForAddresses.setInt(4,postalCode);
                            psForAddresses.setString(5,country);
                            psForAddresses.setInt(6,userId);

                            psForUsers.executeUpdate();
                            psForAddresses.executeUpdate();

                            RequestDispatcher dispatcher = request.getRequestDispatcher("home");
                            dispatcher.forward(request, response);
                    
                }    
                              
          }catch(Exception e){
              e.printStackTrace();
              RequestDispatcher dispatcher = request.getRequestDispatcher("updateProfile");
              dispatcher.forward(request, response);
             
          }
          
          
        
        
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
   
    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
  

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
