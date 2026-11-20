package model;

import java.time.LocalDate;

public class Customer8 extends Member8 {
    private String custCode;

    public Customer8() {
        super();
    }

    public Customer8(String custCode) {
        super();
        this.custCode = custCode;
    }

    public Customer8(int id, String userName, String password, String fullName, String address, LocalDate dob, String phone, String email, String custCode) {
        super(id, userName, password, fullName, address, dob, phone, email);
        this.custCode = custCode;
    }

    public String getCustCode() {
        return custCode;
    }

    public void setCustCode(String custCode) {
        this.custCode = custCode;
    }
}
