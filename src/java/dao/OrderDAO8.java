package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import model.Order8;
import model.OrderDetail8;

public class OrderDAO8 extends DAO {

    public OrderDAO8() {
        super();
    }

    public int createOrder(Order8 order) {
        if (order == null || order.getOrderDetail() == null || order.getOrderDetail().length == 0) {
            return 0;
        }
        ProductDAO8 productDAO = new ProductDAO8();
        OrderDetail8[] details = order.getOrderDetail();
        boolean insufficient = false;
        for (OrderDetail8 detail : details) {
            int currentStock = productDAO.getStock(detail.getProduct().getId());
            detail.getProduct().setInventory(currentStock);
            if (currentStock < detail.getQuantity()) {
                insufficient = true;
            }
        }
        if (insufficient) {
            return -1; // Tồn kho thay đổi, không đủ số lượng
        }

        String insertOrderSql = "INSERT INTO tblOrder8 (orderCode, createdAt, total, status, customerId) VALUES (?, ?, ?, ?, ?)";
        String insertDetailSql = "INSERT INTO tblOrderDetail8 (quantity, price, orderId, productId) VALUES (?, ?, ?, ?)";
        String updateStockSql = "UPDATE tblProduct8 SET inventory = inventory - ? WHERE id = ?";

        try {
            con.setAutoCommit(false);
            int orderId = 0;
            try (PreparedStatement psOrder = con.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                String code = order.getOrderCode();
                if (code == null || code.trim().isEmpty()) {
                    code = "DH" + System.currentTimeMillis();
                    order.setOrderCode(code);
                }
                LocalDateTime createdAt = order.getCreatedAt();
                if (createdAt == null) {
                    createdAt = LocalDateTime.now();
                    order.setCreatedAt(createdAt);
                }
                String status = order.getStatus();
                if (status == null || status.trim().isEmpty()) {
                    status = "PENDING";
                    order.setStatus(status);
                }
                psOrder.setString(1, code);
                psOrder.setTimestamp(2, Timestamp.valueOf(createdAt));
                psOrder.setLong(3, order.getTotal());
                psOrder.setString(4, status);
                psOrder.setInt(5, order.getCustomer().getId());
                psOrder.executeUpdate();

                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                        order.setId(orderId);
                    }
                }
            }

            try (PreparedStatement psDetail = con.prepareStatement(insertDetailSql);
                 PreparedStatement psStock = con.prepareStatement(updateStockSql)) {
                for (OrderDetail8 detail : details) {
                    psDetail.setInt(1, detail.getQuantity());
                    psDetail.setLong(2, detail.getPrice());
                    psDetail.setInt(3, orderId);
                    psDetail.setInt(4, detail.getProduct().getId());
                    psDetail.executeUpdate();

                    psStock.setInt(1, detail.getQuantity());
                    psStock.setInt(2, detail.getProduct().getId());
                    psStock.executeUpdate();
                }
            }

            con.commit();
            con.setAutoCommit(true);
            return 1;
        } catch (Exception e) {
            try {
                if (con != null) {
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return 0;
        }
    }
}
