<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.OrderDAO8"%>
<%@page import="dao.ProductDAO8"%>
<%@page import="model.Customer8"%>
<%@page import="model.Order8"%>
<%@page import="model.OrderDetail8"%>
<%@page import="model.Product8"%>
<%
    request.setCharacterEncoding("UTF-8");

    Customer8 customer = (Customer8) session.getAttribute("customer");
    if (customer == null) {
        response.sendRedirect(request.getContextPath() + "/member/LoginView8.jsp");
        return;
    }

    String action = request.getParameter("action");

    // Bước 32 - 33: Khách hàng ấn Ok của thông báo -> gọi trang SearchOrderView8.jsp
    if ("ok".equals(action)) {
        response.sendRedirect(request.getContextPath() + "/customer/SearchOrderView8.jsp");
        return;
    }

    Order8 order = (Order8) session.getAttribute("order");
    if (order == null) {
        response.sendRedirect(request.getContextPath() + "/customer/SearchOrderView8.jsp");
        return;
    }

    // Bước 25 - 30: Gọi OrderDAO8.createOrder(order) (bên trong gọi ProductDAO8.getStock())
    OrderDAO8 orderDAO = new OrderDAO8();
    int result = orderDAO.createOrder(order);

    String message;
    if (result == 1) {
        // Đặt hàng thành công: xoá giỏ hàng và kết quả tìm kiếm cũ để quay về giao diện như bước 2
        session.removeAttribute("order");
        session.removeAttribute("listProduct");
        session.removeAttribute("searchKeyword");
        session.removeAttribute("stockChanged");
        message = "Đơn hàng được đặt thành công";
    } else if (result == -1) {
        // Ngoại lệ 7.1: Tồn kho thay đổi, cập nhật tồn kho mới cho kết quả tìm kiếm và giữ nguyên giỏ hàng
        Product8[] listProduct = (Product8[]) session.getAttribute("listProduct");
        if (listProduct != null) {
            ProductDAO8 productDAO = new ProductDAO8();
            for (Product8 p : listProduct) {
                p.setInventory(productDAO.getStock(p.getId()));
            }
            session.setAttribute("listProduct", listProduct);
        }
        session.setAttribute("order", order);
        session.setAttribute("stockChanged", Boolean.TRUE);
        message = "Tồn kho thay đổi, vui lòng kiểm tra và chỉnh sửa giỏ hàng";
    } else {
        message = "Đặt hàng thất bại";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thông báo</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                margin: 0;
                padding: 40px;
            }
            .container {
                width: 420px;
                margin: 60px auto;
                background: #ffffff;
                border: 1px solid #cccccc;
                padding: 25px;
                text-align: center;
            }
            p {
                font-size: 15px;
                margin-top: 0;
                margin-bottom: 20px;
            }
            button {
                padding: 6px 24px;
                border: 1px solid #666666;
                background-color: #e0e0e0;
                cursor: pointer;
                font-size: 14px;
            }
            button:hover {
                background-color: #d0d0d0;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <p><%= message %></p>
            <form action="<%= request.getContextPath() %>/customer/doOrder8.jsp" method="post">
                <input type="hidden" name="action" value="ok">
                <button type="submit">Ok</button>
            </form>
        </div>
    </body>
</html>
