package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Product8;
import model.ProductType8;

public class ProductDAO8 extends DAO {

    public ProductDAO8() {
        super();
    }

    public int addProduct(Product8[] listProduct) {
        if (listProduct == null || listProduct.length == 0) {
            return 0;
        }
        String checkSql = "SELECT COUNT(*) FROM tblProduct8 WHERE productCode = ?";
        String insertSql = "INSERT INTO tblProduct8 (productCode, productName, description, unit, price, image, inventory, typeId) "
                         + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            // Kiểm tra trùng mã mặt hàng trong CSDL ngay trong hàm addProduct()
            try (PreparedStatement checkPs = con.prepareStatement(checkSql)) {
                for (int i = 0; i < listProduct.length; i++) {
                    checkPs.setString(1, listProduct[i].getProductCode());
                    try (ResultSet rs = checkPs.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            return -(i + 1); // Mã MH đã tồn tại tại vị trí i
                        }
                    }
                }
            }

            con.setAutoCommit(false);
            try (PreparedStatement insertPs = con.prepareStatement(insertSql)) {
                for (Product8 p : listProduct) {
                    insertPs.setString(1, p.getProductCode());
                    insertPs.setString(2, p.getProductName());
                    if (p.getDescription() == null || p.getDescription().trim().isEmpty()) {
                        insertPs.setNull(3, java.sql.Types.VARCHAR);
                    } else {
                        insertPs.setString(3, p.getDescription());
                    }
                    insertPs.setString(4, p.getUnit());
                    insertPs.setLong(5, p.getPrice());
                    insertPs.setString(6, p.getImage());
                    insertPs.setInt(7, p.getInventory());
                    insertPs.setInt(8, p.getType().getId());
                    insertPs.executeUpdate();
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

    public Product8[] searchProduct(String keyword) {
        List<Product8> list = new ArrayList<>();
        String sql = "SELECT p.id, p.productCode, p.productName, p.description, p.unit, p.price, p.image, p.inventory, "
                   + "t.id AS typeId, t.typeName "
                   + "FROM tblProduct8 p "
                   + "INNER JOIN tblProductType8 t ON p.typeId = t.id "
                   + "WHERE p.productName LIKE ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductType8 type = new ProductType8(
                            rs.getInt("typeId"),
                            rs.getString("typeName")
                    );
                    Product8 product = new Product8(
                            rs.getInt("id"),
                            rs.getString("productCode"),
                            rs.getString("productName"),
                            rs.getString("description"),
                            rs.getString("unit"),
                            rs.getLong("price"),
                            rs.getString("image"),
                            rs.getInt("inventory"),
                            type
                    );
                    list.add(product);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list.toArray(new Product8[0]);
    }

    public int getStock(int productId) {
        String sql = "SELECT inventory FROM tblProduct8 WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("inventory");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
