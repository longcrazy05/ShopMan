package model;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Order8 implements Serializable {
    private int id;
    private String orderCode;
    private LocalDateTime createdAt;
    private long total;
    private String status;
    private OrderDetail8[] orderDetail;
    private Customer8 customer;
    private SaleStaff8 saleStaff;
    private DeliverStaff8 deliverStaff;

    public Order8() {
        this.status = "PENDING";
        this.orderDetail = new OrderDetail8[0];
        this.total = 0;
    }

    public Order8(String orderCode, LocalDateTime createdAt, long total, String status, OrderDetail8[] orderDetail, Customer8 customer) {
        this.orderCode = orderCode;
        this.createdAt = createdAt;
        this.total = total;
        this.status = status;
        this.orderDetail = orderDetail;
        this.customer = customer;
    }

    public void addToCart(Product8 product, int quantity) {
        if (this.orderDetail == null) {
            this.orderDetail = new OrderDetail8[0];
        }
        boolean found = false;
        for (int i = 0; i < this.orderDetail.length; i++) {
            if (this.orderDetail[i].getProduct().getId() == product.getId()) {
                int newQty = this.orderDetail[i].getQuantity() + quantity;
                OrderDetail8 detail = new OrderDetail8(product, newQty, product.getPrice());
                this.orderDetail[i] = detail;
                found = true;
                break;
            }
        }
        if (!found) {
            OrderDetail8 detail = new OrderDetail8(product, quantity, product.getPrice());
            OrderDetail8[] newArr = new OrderDetail8[this.orderDetail.length + 1];
            System.arraycopy(this.orderDetail, 0, newArr, 0, this.orderDetail.length);
            newArr[this.orderDetail.length] = detail;
            this.orderDetail = newArr;
        }
        long sum = 0;
        for (OrderDetail8 d : this.orderDetail) {
            sum += d.getPrice() * d.getQuantity();
        }
        this.total = sum;
    }

    public void removeFromCart(Product8 product) {
        if (this.orderDetail == null || product == null) {
            return;
        }
        List<OrderDetail8> list = new ArrayList<>();
        for (OrderDetail8 d : this.orderDetail) {
            if (d.getProduct().getId() != product.getId()) {
                list.add(d);
            }
        }
        this.orderDetail = list.toArray(new OrderDetail8[0]);
        long sum = 0;
        for (OrderDetail8 d : this.orderDetail) {
            sum += d.getPrice() * d.getQuantity();
        }
        this.total = sum;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public long getTotal() {
        return total;
    }

    public void setTotal(long total) {
        this.total = total;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public OrderDetail8[] getOrderDetail() {
        return orderDetail;
    }

    public void setOrderDetail(OrderDetail8[] orderDetail) {
        this.orderDetail = orderDetail;
    }

    public Customer8 getCustomer() {
        return customer;
    }

    public void setCustomer(Customer8 customer) {
        this.customer = customer;
    }

    public SaleStaff8 getSaleStaff() {
        return saleStaff;
    }

    public void setSaleStaff(SaleStaff8 saleStaff) {
        this.saleStaff = saleStaff;
    }

    public DeliverStaff8 getDeliverStaff() {
        return deliverStaff;
    }

    public void setDeliverStaff(DeliverStaff8 deliverStaff) {
        this.deliverStaff = deliverStaff;
    }
}
