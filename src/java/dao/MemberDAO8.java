package dao;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import model.Customer8;
import model.DeliverStaff8;
import model.Manager8;
import model.Member8;
import model.SaleStaff8;

public class MemberDAO8 extends DAO {

    public MemberDAO8() {
        super();
    }

    public Member8 checkLogin(Member8 member) {
        String sql = "SELECT m.id, m.userName, m.password, m.fullName, m.address, m.dob, m.phone, m.email, "
                   + "c.custCode, s.staffCode, s.position "
                   + "FROM tblMember8 m "
                   + "LEFT JOIN tblCustomer8 c ON m.id = c.memberId "
                   + "LEFT JOIN tblStaff8 s ON m.id = s.memberId "
                   + "WHERE m.userName = ? AND m.password = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, member.getUserName());
            ps.setString(2, member.getPassword());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    String userName = rs.getString("userName");
                    String password = rs.getString("password");
                    String fullName = rs.getString("fullName");
                    String address = rs.getString("address");
                    Date dobSql = rs.getDate("dob");
                    LocalDate dob = (dobSql != null) ? dobSql.toLocalDate() : null;
                    String phone = rs.getString("phone");
                    String email = rs.getString("email");
                    String custCode = rs.getString("custCode");
                    String staffCode = rs.getString("staffCode");
                    String position = rs.getString("position");

                    if ("MANAGER".equalsIgnoreCase(position)) {
                        return new Manager8(id, userName, password, fullName, address, dob, phone, email, staffCode);
                    } else if (custCode != null) {
                        return new Customer8(id, userName, password, fullName, address, dob, phone, email, custCode);
                    } else if ("SALE".equalsIgnoreCase(position)) {
                        return new SaleStaff8(id, userName, password, fullName, address, dob, phone, email, staffCode);
                    } else if ("DELIVER".equalsIgnoreCase(position)) {
                        return new DeliverStaff8(id, userName, password, fullName, address, dob, phone, email, staffCode);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
