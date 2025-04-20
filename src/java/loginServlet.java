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
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;


/**
 *
 * @author LENOVO
 */
@WebServlet(urlPatterns = {"/login"})
public class loginServlet extends HttpServlet {

    @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
         
          
          String username = request.getParameter("username");
          String password = request.getParameter("password");
          
          HttpSession session = request.getSession();

          String redirectTo = request.getParameter("redirectTo");
          System.out.println(redirectTo);
          
          try{
              Class.forName("com.mysql.cj.jdbc.Driver");
                            
              String sql = "select * from users WHERE username = ? ";
           
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/plantdb","root", "Shiv26@333");    
                    PreparedStatement ps = conn.prepareStatement(sql);
                 
                    ps.setString(1,username);
                    ResultSet rs = ps.executeQuery();

                    if(rs.next()){
                        String dbPassword = rs.getString("password");
                        
                        if(dbPassword.equals(password)){
                            session.setAttribute("user_id", rs.getInt("user_id"));
                            session.setAttribute("username", rs.getString("username"));
                            
                            if(redirectTo != null && !redirectTo.isEmpty()){
                                 response.sendRedirect(redirectTo);
                            }else{
                                 response.sendRedirect("home.jsp");
                            }
                            
                           
                        }else{
                            request.setAttribute("errorMessage", "Incorrect password!");
                            request.getRequestDispatcher("login.jsp").forward(request, response);
                        }
                    }else {
                           request.setAttribute("errorMessage", "User not found.");
                            request.getRequestDispatcher("login.jsp").forward(request, response);
                        }     
                    
                       rs.close();
                       ps.close();
                       conn.close();
//                    ps.close();
//                    conn.close();
           
              
          
          }catch(Exception e){
              e.printStackTrace();
              response.sendRedirect("login.jsp?error=exception");
          }
          
    }

}


