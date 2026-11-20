<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.ProductDAO8"%>
<%@page import="model.Manager8"%>
<%@page import="model.Product8"%>
<%
    request.setCharacterEncoding("UTF-8");

    Manager8 manager = (Manager8) session.getAttribute("manager");
    if (manager == null) {
        response.sendRedirect(request.getContextPath() + "/member/LoginView8.jsp");
        return;
    }

    String action = request.getParameter("action");

    // Bước 22 - 23: Quản lý ấn Ok của thông báo -> gọi trang ManageProductView8.jsp
    if ("ok".equals(action)) {
        response.sendRedirect(request.getContextPath() + "/manager/ManageProductView8.jsp");
        return;
    }
    if ("retry".equals(action)) {
        response.sendRedirect(request.getContextPath() + "/manager/AddProductView8.jsp?retry=1");
        return;
    }

    Product8[] listProduct = (Product8[]) session.getAttribute("listProduct");
    if (listProduct == null) {
        response.sendRedirect(request.getContextPath() + "/manager/AddProductView8.jsp");
        return;
    }

    // Bước 18 - 20: Gọi ProductDAO8.addProduct(listProduct)
    ProductDAO8 productDAO = new ProductDAO8();
    int result = productDAO.addProduct(listProduct);

    String message;
    String nextAction;
    if (result == 1) {
        session.removeAttribute("listProduct");
        session.removeAttribute("draftRows");
        session.removeAttribute("existError");
        message = "Thêm mặt hàng thành công";
        nextAction = "ok";
    } else if (result < 0) {
        int idx = (-result) - 1;
        String existCode = (idx >= 0 && idx < listProduct.length) ? listProduct[idx].getProductCode() : "";
        session.setAttribute("existError", "Mã mặt hàng " + existCode + " đã tồn tại");
        response.sendRedirect(request.getContextPath() + "/manager/AddProductView8.jsp?retry=1");
        return;
    } else {
        message = "Lưu mặt hàng thất bại";
        nextAction = "retry";
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
                width: 380px;
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
            <form action="<%= request.getContextPath() %>/manager/doSaveProduct8.jsp" method="post">
                <input type="hidden" name="action" value="<%= nextAction %>">
                <button type="submit">Ok</button>
            </form>
        </div>
    </body>
</html>
