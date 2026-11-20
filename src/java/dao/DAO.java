package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DAO {
    public static Connection con;

    public DAO() {
        try {
            if (con == null || con.isClosed()) {
                String dbUrl = "jdbc:mysql://localhost:3306/shop_man_db?autoReconnect=true&useSSL=false&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=UTF-8";
                String dbClass = "com.mysql.cj.jdbc.Driver";
                Class.forName(dbClass);
                try {
                    con = DriverManager.getConnection(dbUrl, "root", "123456");
                } catch (Exception ex1) {
                    try {
                        con = DriverManager.getConnection(dbUrl, "root", "");
                    } catch (Exception ex2) {
                        con = DriverManager.getConnection(dbUrl, "root", "root");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
