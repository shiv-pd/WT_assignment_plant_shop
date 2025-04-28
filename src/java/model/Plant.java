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
    private int quantityInCart;

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
    
     public Plant(int id, String name,String category , int total_stock ,double price,int quantityInCart, String base64Image, String description) {
         this.id = id;
        this.name = name;  
        this.category = category;      
        this.total_stock = total_stock;
        this.price = price;
        this.quantityInCart = quantityInCart;
        this.base64Image = base64Image;
        this.description= description;
    }
    

     
    public int getId() { return id; }
    public String getName() { return name; }
    public String getCategory() { return category; }
    public double getPrice() { return price; }
    public int getTotalStock() { return total_stock; }
    public String getDescription() { return description; }
    public String getImageName() { return image_name; }
    public String getBase64Image() { return base64Image; }
    public int getQuantityInCart() { return quantityInCart; }
    
    
}
