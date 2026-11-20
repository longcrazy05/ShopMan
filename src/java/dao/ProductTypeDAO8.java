package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.ProductType8;

public class ProductTypeDAO8 extends DAO {

    public ProductTypeDAO8() {
        super();
    }

    public ProductType8[] getProductType() {
        List<ProductType8> list = new ArrayList<>();
        String sql = "SELECT id, typeName FROM tblProductType8";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ProductType8 type = new ProductType8(
                        rs.getInt("id"),
                        rs.getString("typeName")
                );
                list.add(type);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list.toArray(new ProductType8[0]);
    }
}
