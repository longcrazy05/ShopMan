package model;

import java.time.LocalDate;

public class DeliverStaff8 extends Staff8 {
    public DeliverStaff8() {
        super();
    }

    public DeliverStaff8(int id, String userName, String password, String fullName, String address, LocalDate dob, String phone, String email, String staffCode) {
        super(id, userName, password, fullName, address, dob, phone, email, staffCode, "DELIVER");
    }
}
