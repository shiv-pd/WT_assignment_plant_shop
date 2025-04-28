package model;

import java.util.Date;
import java.util.List;

public class order {

    private int order_id;
    private int userId;
    private Date order_date;
    private double total_amount;
    private String payment_status;
    private String delivery_status;
    
    private int orderItemId;
    private int orderProductId;
     private int orderquantity;
    private double orderPrice;
   private String orderBase64Image;
    
    public order(int orderId, int userId, Date orderDate, double totalAmount,String paymentStatus, String deliveryStatus ){
        this.order_id = orderId;
        this.userId = userId ;
        
        this.order_date= orderDate;
        this.total_amount= totalAmount;
        this.payment_status= paymentStatus;
        this.delivery_status= deliveryStatus ;
      
       
    }
    
    
    public order ( int orderId, int productId, int itemquantity, double price , String orderBase64Image){
         this.order_id = orderId;
        this.orderProductId = productId;
        this.orderquantity = itemquantity;
       this.orderPrice = price;
       this.orderBase64Image = orderBase64Image;
    }
    
    public int getOrderId() { return order_id; }
    public int getUserId() { return userId; }
    public Date getOrderDate() { return order_date; }
    public double getTotalAmount() { return total_amount; }
    public String getPaymentStatus() { return payment_status; }
    public String getDeliveryStatus() { return delivery_status; }
    public int getOrderItemId() {return orderItemId; }

    public int getOrderProductId() { return orderProductId;}
    public int getorderquantity() { return orderquantity;}
    public double getorderPrice() { return orderPrice; }
    public String getOrderBase64Image() {return orderBase64Image;};
} 
