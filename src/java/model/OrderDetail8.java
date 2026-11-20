package model;

import java.io.Serializable;

public class OrderDetail8 implements Serializable {
    private int id;
    private int quantity;
    private long price;
    private Product8 product;

    public OrderDetail8() {
    }

    public OrderDetail8(Product8 product, int quantity, long price) {
        this.product = product;
        this.quantity = quantity;
        this.price = price;
    }

    public OrderDetail8(int id, int quantity, long price, Product8 product) {
        this.id = id;
        this.quantity = quantity;
        this.price = price;
        this.product = product;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public long getPrice() {
        return price;
    }

    public void setPrice(long price) {
        this.price = price;
    }

    public Product8 getProduct() {
        return product;
    }

    public void setProduct(Product8 product) {
        this.product = product;
    }
}
