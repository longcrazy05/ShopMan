package model;

import java.io.Serializable;

public class Product8 implements Serializable {
    private int id;
    private String productCode;
    private String productName;
    private String description;
    private String unit;
    private long price;
    private String image;
    private int inventory;
    private ProductType8 type;

    public Product8() {
    }

    public Product8(int id, String productCode, String productName, String description, String unit, long price, String image, int inventory, ProductType8 type) {
        this.id = id;
        this.productCode = productCode;
        this.productName = productName;
        this.description = description;
        this.unit = unit;
        this.price = price;
        this.image = image;
        this.inventory = inventory;
        this.type = type;
    }

    public Product8(String productCode, String productName, String description, String unit, long price, String image, int inventory, ProductType8 type) {
        this.productCode = productCode;
        this.productName = productName;
        this.description = description;
        this.unit = unit;
        this.price = price;
        this.image = image;
        this.inventory = inventory;
        this.type = type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public long getPrice() {
        return price;
    }

    public void setPrice(long price) {
        this.price = price;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public int getInventory() {
        return inventory;
    }

    public void setInventory(int inventory) {
        this.inventory = inventory;
    }

    public ProductType8 getType() {
        return type;
    }

    public void setType(ProductType8 type) {
        this.type = type;
    }
}
