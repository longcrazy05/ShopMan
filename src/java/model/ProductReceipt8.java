package model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class ProductReceipt8 implements Serializable {
    private int id;
    private String receiptCode;
    private long total;
    private LocalDateTime createdAt;
    private LocalDateTime paidAt;
    private ReceiptDetail8[] receiptDetail;
    private Supplier8 supplier;
    private Manager8 manager;

    public ProductReceipt8() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getReceiptCode() {
        return receiptCode;
    }

    public void setReceiptCode(String receiptCode) {
        this.receiptCode = receiptCode;
    }

    public long getTotal() {
        return total;
    }

    public void setTotal(long total) {
        this.total = total;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
    }

    public ReceiptDetail8[] getReceiptDetail() {
        return receiptDetail;
    }

    public void setReceiptDetail(ReceiptDetail8[] receiptDetail) {
        this.receiptDetail = receiptDetail;
    }

    public Supplier8 getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier8 supplier) {
        this.supplier = supplier;
    }

    public Manager8 getManager() {
        return manager;
    }

    public void setManager(Manager8 manager) {
        this.manager = manager;
    }
}
