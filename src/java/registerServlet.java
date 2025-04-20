/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;


/**
 *
 * @author LENOVO
 */
@WebServlet(urlPatterns = {"/register"})
public class registerServlet extends HttpServlet {

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
          String fullName = request.getParameter("fullname");
          String email = request.getParameter("email");
          String username = request.getParameter("username");
          String password = request.getParameter("password");
          
          
          if(password.length() < 6){
              request.setAttribute("errorMessage", "Password must be atleast 6 characters long!");
              request.getRequestDispatcher("registration.jsp").forward(request, response);
              return;
          }
          
        
          try{
              Class.forName("com.mysql.cj.jdbc.Driver");
                            
              String sql = "INSERT INTO users (full_name, email, username, password) values (?,?,?,?)";
              String checkEmailSql = "SELECT * FROM users WHERE email = ?";
              
                try(
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/plantdb","root", "Shiv26@333");    
                    PreparedStatement checkStmt = conn.prepareStatement(checkEmailSql);
                ){
                    checkStmt.setString(1,email);
                    ResultSet rs = checkStmt.executeQuery();
                    
                    if (rs.next()) {
                        request.setAttribute("errorMessage", "Email already registered. Try logging in instead.");
                        request.getRequestDispatcher("registration.jsp").forward(request, response);
                        return;
                    }
                    try(PreparedStatement ps = conn.prepareStatement(sql)){
                        ps.setString(1,fullName);
                    ps.setString(2,email);
                    ps.setString(3,username);
                    ps.setString(4,password);

                            
                    int result = ps.executeUpdate();
          
                    if(result>0){
                        response.sendRedirect("login.jsp");
                    }else{
                       request.setAttribute("errorMessage", "Registration failed 🤨🤨");
                       request.getRequestDispatcher("registration.jsp").forward(request, response);
                       
                    }
                    }
                }    
                    
                 
                    
                
//                    ps.close();
//                    conn.close();
           
              
          
          }catch(Exception e){
              e.printStackTrace();
              response.sendRedirect("registration.jsp?error=exception");
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
