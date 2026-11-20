package model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Invoice8 implements Serializable {
    private int id;
    private String invoiceCode;
    private LocalDateTime createdAt;
    private LocalDateTime paidAt;
    private String status;
    private String paymentMethod;
    private Order8 order;

    public Invoice8() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getInvoiceCode() {
        return invoiceCode;
    }

    public void setInvoiceCode(String invoiceCode) {
        this.invoiceCode = invoiceCode;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Order8 getOrder() {
        return order;
    }

    public void setOrder(Order8 order) {
        this.order = order;
    }
}
