<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.time.LocalDateTime"%>
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

    Order8 order = (Order8) session.getAttribute("order");
    if (order == null) {
        order = new Order8();
        order.setCustomer(customer);
        session.setAttribute("order", order);
    }

    Product8[] listProduct = (Product8[]) session.getAttribute("listProduct");
    String keyword = (String) session.getAttribute("searchKeyword");
    if (keyword == null) {
        keyword = "";
    }

    String noticeMessage = null;
    String action = request.getParameter("action");

    if ("search".equals(action)) {
        String inProductName = request.getParameter("inProductName");
        if (inProductName == null || inProductName.trim().isEmpty()) {
            // Ngoại lệ 3.2: không nhập mặt hàng và ấn tìm
            noticeMessage = "Vui lòng nhập mặt hàng";
        } else {
            keyword = inProductName.trim();
            session.setAttribute("searchKeyword", keyword);
            // Bước 5 - 10: Gọi ProductDAO8.searchProduct()
            ProductDAO8 productDAO = new ProductDAO8();
            Product8[] found = productDAO.searchProduct(keyword);
            if (found == null || found.length == 0) {
                // Ngoại lệ 3.1: nhập mặt hàng không tồn tại
                noticeMessage = "Không tìm thấy mặt hàng";
                listProduct = null;
                session.removeAttribute("listProduct");
            } else {
                listProduct = found;
                session.setAttribute("listProduct", listProduct);
            }
        }
    } else if ("add".equals(action)) {
        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");
        if (quantityStr == null || quantityStr.trim().isEmpty()) {
            // Ngoại lệ 5.3: không nhập số lượng và ấn thêm
            noticeMessage = "Vui lòng nhập số lượng";
        } else {
            int qty = -1;
            boolean validNumber = true;
            try {
                qty = Integer.parseInt(quantityStr.trim());
            } catch (NumberFormatException e) {
                validNumber = false;
            }

            Product8 selectedProduct = null;
            if (listProduct != null && productIdStr != null) {
                try {
                    int pid = Integer.parseInt(productIdStr.trim());
                    for (Product8 p : listProduct) {
                        if (p.getId() == pid) {
                            selectedProduct = p;
                            break;
                        }
                    }
                } catch (Exception e) {
                }
            }

            int existingCartQty = 0;
            if (selectedProduct != null && order.getOrderDetail() != null) {
                for (OrderDetail8 d : order.getOrderDetail()) {
                    if (d.getProduct().getId() == selectedProduct.getId()) {
                        existingCartQty = d.getQuantity();
                        break;
                    }
                }
            }

            // Ngoại lệ 5.1: nhập số lượng không hợp lệ (số âm, 0, chứa chữ cái, lớn hơn tồn kho)
            if (!validNumber || qty <= 0 || selectedProduct == null || (qty + existingCartQty) > selectedProduct.getInventory()) {
                noticeMessage = "Số lượng không hợp lệ";
            } else {
                // Bước 13 - 18: Gọi Order8.addToCart()
                order.addToCart(selectedProduct, qty);
                session.setAttribute("order", order);
            }
        }
    } else if ("remove".equals(action)) {
        String productIdStr = request.getParameter("productId");
        if (productIdStr != null && order.getOrderDetail() != null) {
            try {
                int pid = Integer.parseInt(productIdStr.trim());
                Product8 target = null;
                for (OrderDetail8 d : order.getOrderDetail()) {
                    if (d.getProduct().getId() == pid) {
                        target = d.getProduct();
                        break;
                    }
                }
                if (target != null) {
                    order.removeFromCart(target);
                    session.setAttribute("order", order);
                }
            } catch (Exception e) {
            }
        }
    } else if ("confirm".equals(action)) {
        if (order.getOrderDetail() == null || order.getOrderDetail().length == 0) {
            // Ngoại lệ 5.2: không thêm mặt hàng nào vào giỏ và ấn Xác nhận
            noticeMessage = "Vui lòng chọn mặt hàng";
        } else {
            // Bước 21 - 24: Gọi Order8 đóng gói thông tin đơn hàng và gọi doOrder8.jsp
            Order8 confirmedOrder = new Order8(
                    "DH" + System.currentTimeMillis(),
                    LocalDateTime.now(),
                    order.getTotal(),
                    "PENDING",
                    order.getOrderDetail(),
                    customer
            );
            session.setAttribute("order", confirmedOrder);
            response.sendRedirect(request.getContextPath() + "/customer/doOrder8.jsp");
            return;
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Tìm kiếm và đặt hàng</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                margin: 0;
                padding: 30px;
            }
            .container {
                width: 900px;
                margin: 0 auto;
                background: #ffffff;
                border: 1px solid #cccccc;
                padding: 20px;
            }
            h2 {
                text-align: center;
                margin-top: 0;
                margin-bottom: 8px;
                font-size: 20px;
            }
            .customer-info {
                text-align: center;
                font-size: 14px;
                margin-bottom: 18px;
                color: #333333;
            }
            h3 {
                font-size: 16px;
                margin-top: 20px;
                margin-bottom: 10px;
            }
            .search-bar {
                display: flex;
                gap: 10px;
                justify-content: center;
                margin-bottom: 20px;
            }
            .search-bar input[type="text"] {
                width: 300px;
                padding: 6px;
                border: 1px solid #999999;
                font-size: 14px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 15px;
            }
            th, td {
                border: 1px solid #cccccc;
                padding: 6px 8px;
                font-size: 13px;
                text-align: left;
                vertical-align: middle;
            }
            th {
                background-color: #eeeeee;
                text-align: center;
            }
            .qty-input {
                width: 65px;
                padding: 4px;
                border: 1px solid #999999;
                text-align: center;
            }
            .prod-img {
                max-width: 60px;
                max-height: 60px;
                display: block;
                margin: 0 auto 3px auto;
            }
            button, .btn-link {
                padding: 6px 16px;
                border: 1px solid #666666;
                background-color: #e0e0e0;
                color: #000000;
                text-decoration: none;
                font-size: 13px;
                cursor: pointer;
            }
            button:hover, .btn-link:hover {
                background-color: #d0d0d0;
            }
            .bottom-actions {
                display: flex;
                justify-content: center;
                gap: 15px;
                margin-top: 20px;
            }
            .notice-box {
                border: 1px solid #999999;
                background-color: #fff8e7;
                padding: 12px;
                margin-bottom: 15px;
                text-align: center;
            }
            .notice-box p {
                margin: 0 0 10px 0;
                font-size: 14px;
            }
            .stock-warn {
                color: #cc0000;
                font-size: 12px;
                font-weight: bold;
                display: block;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Tìm kiếm và đặt hàng</h2>
            <div class="customer-info">Khách hàng: <strong><%= customer.getFullName() %></strong></div>

            <form action="<%= request.getContextPath() %>/customer/SearchOrderView8.jsp" method="post" class="search-bar">
                <input type="hidden" name="action" value="search">
                <input type="text" id="inProductName" name="inProductName" value="<%= keyword %>" placeholder="Nhập tên mặt hàng">
                <button type="submit" id="btnSearch">Tìm</button>
            </form>

            <% if (listProduct != null && listProduct.length > 0) { %>
                <h3>Danh sách kết quả tìm kiếm</h3>
                <table id="tblProduct">
                    <thead>
                        <tr>
                            <th>Tên MH</th>
                            <th>Loại</th>
                            <th>Giá bán</th>
                            <th>Mô tả</th>
                            <th>Hình ảnh</th>
                            <th>Tồn Kho</th>
                            <th>Nhập SL</th>
                            <th>Thêm</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Product8 p : listProduct) {
                               String imgName = p.getImage() != null ? p.getImage() : "";
                        %>
                        <tr>
                            <td><%= p.getProductName() %></td>
                            <td><%= (p.getType() != null) ? p.getType().getTypeName() : "" %></td>
                            <td><%= p.getPrice() %>/<%= p.getUnit() %></td>
                            <td><%= (p.getDescription() != null) ? p.getDescription() : "" %></td>
                            <td style="text-align: center;">
                                <% if (!imgName.isEmpty()) { %>
                                    <img class="prod-img" src="<%= request.getContextPath() %>/<%= imgName %>" alt="Ảnh">
                                <% } %>
                            </td>
                            <td style="text-align: center;"><%= p.getInventory() %></td>
                            <td style="text-align: center;">
                                <form action="<%= request.getContextPath() %>/customer/SearchOrderView8.jsp" method="post" style="margin:0; display:inline;" id="addForm_<%= p.getId() %>">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="<%= p.getId() %>">
                                    <input type="text" name="quantity" class="qty-input">
                                </form>
                            </td>
                            <td style="text-align: center;">
                                <button type="submit" form="addForm_<%= p.getId() %>">Thêm</button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>

            <% if (noticeMessage != null) { %>
                <div class="notice-box" id="noticeBox">
                    <p><%= noticeMessage %></p>
                    <button type="button" onclick="document.getElementById('noticeBox').style.display='none'">Ok</button>
                </div>
            <% } %>

            <h3>Giỏ hàng</h3>
            <table id="tblCart">
                <thead>
                    <tr>
                        <th>Tên MH</th>
                        <th>Giá bán</th>
                        <th>Số lượng</th>
                        <th>Thành tiền</th>
                        <th>Xoá</th>
                    </tr>
                </thead>
                <tbody>
                    <% OrderDetail8[] details = order.getOrderDetail();
                       if (details != null && details.length > 0) {
                           for (OrderDetail8 d : details) {
                               Product8 cp = d.getProduct();
                               long subTotal = d.getPrice() * d.getQuantity();
                               boolean notEnoughStock = d.getQuantity() > cp.getInventory();
                    %>
                    <tr>
                        <td>
                            <%= cp.getProductName() %>
                            <% if (notEnoughStock) { %>
                                <span class="stock-warn">(Không đủ số lượng, tồn kho hiện tại: <%= cp.getInventory() %>)</span>
                            <% } %>
                        </td>
                        <td><%= d.getPrice() %>/<%= cp.getUnit() %></td>
                        <td style="text-align: center;"><%= d.getQuantity() %></td>
                        <td style="text-align: right;"><%= subTotal %></td>
                        <td style="text-align: center;">
                            <form action="<%= request.getContextPath() %>/customer/SearchOrderView8.jsp" method="post" style="margin: 0;">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="productId" value="<%= cp.getId() %>">
                                <button type="submit">Xoá</button>
                            </form>
                        </td>
                    </tr>
                    <%     }
                       } else { %>
                    <tr>
                        <td colspan="5" style="text-align: center;">Giỏ hàng trống</td>
                    </tr>
                    <% } %>
                    <tr>
                        <td colspan="3" style="font-weight: bold;">Tổng tiền</td>
                        <td colspan="2" style="font-weight: bold; text-align: right;"><%= order.getTotal() %></td>
                    </tr>
                </tbody>
            </table>

            <div class="bottom-actions">
                <form action="<%= request.getContextPath() %>/customer/SearchOrderView8.jsp" method="post" style="margin: 0;">
                    <input type="hidden" name="action" value="confirm">
                    <button type="submit" id="btnConfirm">Xác nhận</button>
                </form>
                <a id="btnBack" class="btn-link" href="<%= request.getContextPath() %>/customer/CustomerHomeView8.jsp">Quay lại</a>
            </div>
        </div>
    </body>
</html>
