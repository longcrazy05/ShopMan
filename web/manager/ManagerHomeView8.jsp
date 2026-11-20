<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Manager8"%>
<%
    Manager8 manager = (Manager8) session.getAttribute("manager");
    if (manager == null) {
        response.sendRedirect(request.getContextPath() + "/member/LoginView8.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Trang chủ quản lý</title>
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
                margin-bottom: 20px;
                font-size: 20px;
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
            <h2>Trang chủ quản lý</h2>
            <div>
                <a id="btnManageProduct" class="btn-link" href="<%= request.getContextPath() %>/manager/ManageProductView8.jsp">Quản lý mặt hàng</a>
            </div>
        </div>
    </body>
</html>
