package model;

import java.io.Serializable;

public class ProductType8 implements Serializable {
    private int id;
    private String typeName;

    public ProductType8() {
    }

    public ProductType8(int id, String typeName) {
        this.id = id;
        this.typeName = typeName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }
}
