package model;

import java.io.Serializable;
import java.time.LocalDate;

public class Member8 implements Serializable {
    private int id;
    private String userName;
    private String password;
    private String fullName;
    private String address;
    private LocalDate dob;
    private String phone;
    private String email;

    public Member8() {
    }

    public Member8(int id, String userName, String password, String fullName, String address, LocalDate dob, String phone, String email) {
        this.id = id;
        this.userName = userName;
        this.password = password;
        this.fullName = fullName;
        this.address = address;
        this.dob = dob;
        this.phone = phone;
        this.email = email;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public LocalDate getDob() {
        return dob;
    }

    public void setDob(LocalDate dob) {
        this.dob = dob;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
