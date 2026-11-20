<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Customer8"%>
<%
    Customer8 customer = (Customer8) session.getAttribute("customer");
    if (customer == null) {
        response.sendRedirect(request.getContextPath() + "/member/LoginView8.jsp");
        return;
    }
    session.removeAttribute("order");
    session.removeAttribute("listProduct");
    session.removeAttribute("searchKeyword");
    session.removeAttribute("stockChanged");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Trang chủ khách hàng</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                margin: 0;
                padding: 40px;
            }
            .container {
                width: 450px;
                margin: 40px auto;
                background: #ffffff;
                border: 1px solid #cccccc;
                padding: 25px;
                text-align: center;
            }
            h2 {
                margin-top: 0;
                margin-bottom: 10px;
                font-size: 20px;
            }
            .customer-info {
                font-size: 14px;
                margin-bottom: 20px;
                color: #333333;
            }
            .btn-link {
                display: inline-block;
                padding: 8px 20px;
                border: 1px solid #666666;
                background-color: #e0e0e0;
                color: #000000;
                text-decoration: none;
                font-size: 14px;
            }
            .btn-link:hover {
                background-color: #d0d0d0;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Trang chủ khách hàng</h2>
            <div class="customer-info">Khách hàng: <strong><%= customer.getFullName() %></strong></div>
            <div>
                <a id="btnSearchAndOrder" class="btn-link" href="<%= request.getContextPath() %>/customer/SearchOrderView8.jsp">Tìm kiếm và đặt hàng</a>
            </div>
        </div>
    </body>
</html>
