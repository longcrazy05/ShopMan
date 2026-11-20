package model;

import java.io.Serializable;

public class ReceiptDetail8 implements Serializable {
    private int id;
    private long importPrice;
    private int quantity;
    private Product8 product;

    public ReceiptDetail8() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public long getImportPrice() {
        return importPrice;
    }

    public void setImportPrice(long importPrice) {
        this.importPrice = importPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Product8 getProduct() {
        return product;
    }

    public void setProduct(Product8 product) {
        this.product = product;
    }
}
