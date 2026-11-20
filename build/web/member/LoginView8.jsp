<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng nhập</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                margin: 0;
                padding: 40px;
            }
            .container {
                width: 340px;
                margin: 40px auto;
                background: #ffffff;
                border: 1px solid #cccccc;
                padding: 20px;
            }
            h2 {
                text-align: center;
                margin-top: 0;
                margin-bottom: 20px;
                font-size: 20px;
            }
            .form-group {
                margin-bottom: 12px;
            }
            .form-group label {
                display: block;
                margin-bottom: 4px;
                font-size: 14px;
            }
            .form-group input {
                width: 100%;
                padding: 6px;
                box-sizing: border-box;
                border: 1px solid #999999;
            }
            .btn-row {
                text-align: center;
                margin-top: 16px;
            }
            button {
                padding: 6px 18px;
                border: 1px solid #666666;
                background-color: #e0e0e0;
                cursor: pointer;
            }
            button:hover {
                background-color: #d0d0d0;
            }
            .error {
                color: #cc0000;
                font-size: 13px;
                text-align: center;
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Đăng nhập</h2>
            <% if ("1".equals(request.getParameter("err"))) { %>
                <div class="error">Sai tên đăng nhập hoặc mật khẩu</div>
            <% } %>
            <form action="<%= request.getContextPath() %>/member/doLogin8.jsp" method="post">
                <div class="form-group">
                    <label>Tên đăng nhập:</label>
                    <input type="text" name="userName" required>
                </div>
                <div class="form-group">
                    <label>Mật khẩu:</label>
                    <input type="password" name="password" required>
                </div>
                <div class="btn-row">
                    <button type="submit">Đăng nhập</button>
                </div>
            </form>
        </div>
    </body>
</html>
