package model;

public class Plant {
    private int id;
    private String name;
    private String category;
    private double price;
    private int total_stock;
    private String description;
    private String image_name;
    private String base64Image; 

    public Plant(int id, String name,String category, double price, int total_stock ,String description,  String image_name, String base64Image) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.price = price;
        this.total_stock = total_stock;
        this.description= description;
        this.image_name = image_name;
        this.base64Image = base64Image;
    }

    public Plant(int id, String name,String category, double price, String image, String base64Image) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.price = price;
        this.image_name = image;
        this.base64Image = base64Image;
    }

    public Plant(int id, String name, double price,int total_stock , String base64Image) {
         this.id = id;
        this.name = name;        
        this.price = price;
         this.total_stock = total_stock;
        this.base64Image = base64Image;
    }
    
    
//    rs2.getString("name"),
//                        rs2.getDouble("price"),
//                        rs2.getInt("total_stock"),
//                        rs2.getString("image_name"),                       
//                        base64Image
    
    public int getId() { return id; }
    public String getName() { return name; }
    public String getCategory() { return category; }
    public double getPrice() { return price; }
    public int getTotalStock() { return total_stock; }
    public String getDescription() { return description; }
    public String getImageName() { return image_name; }
    public String getBase64Image() { return base64Image; }
    
//     @Override
//    public String toString() {
//        return "Plant{" +
//                "id=" + id +
//                ", name='" + name + '\'' +
//                ", category='" + category + '\'' +
//                ", price=" + price +
//                ", image='" + image + '\'' +
//                '}';
//    }
}
