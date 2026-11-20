package model;

import java.time.LocalDate;

public class Staff8 extends Member8 {
    private String staffCode;
    private String position;

    public Staff8() {
        super();
    }

    public Staff8(String staffCode, String position) {
        super();
        this.staffCode = staffCode;
        this.position = position;
    }

    public Staff8(int id, String userName, String password, String fullName, String address, LocalDate dob, String phone, String email, String staffCode, String position) {
        super(id, userName, password, fullName, address, dob, phone, email);
        this.staffCode = staffCode;
        this.position = position;
    }

    public String getStaffCode() {
        return staffCode;
    }

    public void setStaffCode(String staffCode) {
        this.staffCode = staffCode;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }
}
