import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import model.Plant;


//http://localhost:8080/plant_shop/products
@WebServlet(urlPatterns = {"/products"})
public class productServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String[] categories = request.getParameterValues("category");
        String[] availability = request.getParameterValues("availability");
        String minPrice = request.getParameter("minPrice");
        String maxPrice = request.getParameter("maxPrice");
        
        if (categories != null) {
            for (String c : categories) {
                System.out.println(c);
            }
        } else {
            System.out.println("No categories selected.");
        }

       
        List<Plant> plantList = new ArrayList<>();
        
               
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
//              Context initContext = new InitialContext();
//              DataSource ds = (DataSource) initContext.lookup("java:comp/env/jdbc/plantdb");

            // Step 1: Build SQL and conditions
            String sql = "SELECT * FROM products";
            String sqlForImages = "SELECT * FROM images where product_id = ?";
            
            List<String> conditions = new ArrayList<>();

            if (categories != null && categories.length > 0) {
                String[] qMarks = new String[categories.length];
                Arrays.fill(qMarks, "?");
                String categoryPlaceholders = String.join(",", qMarks);
                conditions.add("category IN (" + categoryPlaceholders + ")");
            }

            if (minPrice != null && !minPrice.isEmpty() && maxPrice != null && !maxPrice.isEmpty()) {
                conditions.add("price BETWEEN ? AND ?");
            }

            if (availability != null && availability.length > 0) {
                String[] qMarks = new String[availability.length];
                Arrays.fill(qMarks, "?");
                String availPlaceholders = String.join(",", qMarks);
                conditions.add("availability IN (" + availPlaceholders + ")");
            }

            if (!conditions.isEmpty()) {
                sql += " WHERE " + String.join(" AND ", conditions);
            }

            // Step 2: Open connection and prepare statement
            try (
                Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/plantdb", "root", "Shiv26@333");
//                    Connection conn = ds.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                PreparedStatement stmt1 = conn.prepareStatement(sqlForImages);
            ) {
                int index = 1;

                if (categories != null) {
                    for (String c : categories) {
                        stmt.setString(index++, c);
                    }
                }

                if (minPrice != null && !minPrice.isEmpty() && maxPrice != null && !maxPrice.isEmpty()) {
                    stmt.setDouble(index++, Double.parseDouble(minPrice));
                    stmt.setDouble(index++, Double.parseDouble(maxPrice));
                }

                if (availability != null) {
                    for (String a : availability) {
                        stmt.setString(index++, a);
                    }
                }

                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    
                    int productId = rs.getInt("product_id");
                    stmt1.setInt(1,productId );
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
                            imageName,
                            base64Image
                                                   
                            
                    );
                    plantList.add(p);
                }
                }
                System.out.println("Total plants fetched: " + plantList.size());
            }} catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("plants", plantList);
         
        RequestDispatcher dispatcher = request.getRequestDispatcher("product.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Optional: handle POST logic here if needed
    }

    @Override
    public String getServletInfo() {
        return "Displays list of plant products";
    }
}

