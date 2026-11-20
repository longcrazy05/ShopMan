<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.nio.file.Paths"%>
<%@page import="java.nio.file.StandardCopyOption"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="javax.servlet.http.Part"%>
<%@page import="dao.ProductTypeDAO8"%>
<%@page import="model.Manager8"%>
<%@page import="model.ProductType8"%>
<%@page import="model.Product8"%>
<%
    request.setCharacterEncoding("UTF-8");

    Manager8 manager = (Manager8) session.getAttribute("manager");
    if (manager == null) {
        response.sendRedirect(request.getContextPath() + "/member/LoginView8.jsp");
        return;
    }

    // Bước 6 - 11: Gọi ProductTypeDAO8.getProductType() lấy danh sách loại mặt hàng
    ProductTypeDAO8 productTypeDAO = new ProductTypeDAO8();
    ProductType8[] listType = productTypeDAO.getProductType();

    // Mỗi dòng lưu String[7]: [0]=code, [1]=name, [2]=typeId, [3]=desc, [4]=unit, [5]=price, [6]=imagePath
    List<String[]> rows = new ArrayList<>();
    String errorMessage = null;

    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        if ("1".equals(request.getParameter("retry")) && session.getAttribute("draftRows") != null) {
            rows = (List<String[]>) session.getAttribute("draftRows");
            errorMessage = (String) session.getAttribute("existError");
            session.removeAttribute("existError");
        } else {
            session.removeAttribute("draftRows");
            session.removeAttribute("existError");
            rows.add(new String[]{"", "", "", "", "", "", ""});
        }
    } else {
        String[] codes = request.getParameterValues("productCode");
        String[] names = request.getParameterValues("productName");
        String[] typeIds = request.getParameterValues("typeId");
        String[] descs = request.getParameterValues("description");
        String[] units = request.getParameterValues("unit");
        String[] prices = request.getParameterValues("price");
        String[] savedImgs = request.getParameterValues("savedImage");

        int rowCount = (codes != null) ? codes.length : 0;
        String realImgDir = application.getRealPath("/images");
        File deployImgFolder = new File(realImgDir);
        if (!deployImgFolder.exists()) {
            deployImgFolder.mkdirs();
        }
        File srcImgFolder = null;
        if (realImgDir != null && (realImgDir.contains("build\\web") || realImgDir.contains("build/web"))) {
            srcImgFolder = new File(realImgDir.replace("build\\web", "web").replace("build/web", "web"));
            if (!srcImgFolder.exists()) {
                srcImgFolder.mkdirs();
            }
        }

        for (int i = 0; i < rowCount; i++) {
            String imgPath = (savedImgs != null && i < savedImgs.length && savedImgs[i] != null) ? savedImgs[i].trim() : "";
            Part filePart = request.getPart("image_" + i);
            if (filePart != null && filePart.getSize() > 0) {
                String submittedName = filePart.getSubmittedFileName();
                if (submittedName != null && !submittedName.trim().isEmpty()) {
                    String fileName = Paths.get(submittedName).getFileName().toString();
                    File destFile = new File(deployImgFolder, fileName);
                    try (InputStream is = filePart.getInputStream()) {
                        Files.copy(is, destFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    }
                    if (srcImgFolder != null) {
                        try {
                            Files.copy(destFile.toPath(), new File(srcImgFolder, fileName).toPath(), StandardCopyOption.REPLACE_EXISTING);
                        } catch (Exception ignore) {
                        }
                    }
                    imgPath = "images/" + fileName;
                }
            }
            rows.add(new String[]{
                codes[i] != null ? codes[i].trim() : "",
                (names != null && i < names.length && names[i] != null) ? names[i].trim() : "",
                (typeIds != null && i < typeIds.length && typeIds[i] != null) ? typeIds[i].trim() : "",
                (descs != null && i < descs.length && descs[i] != null) ? descs[i].trim() : "",
                (units != null && i < units.length && units[i] != null) ? units[i].trim() : "",
                (prices != null && i < prices.length && prices[i] != null) ? prices[i].trim() : "",
                imgPath
            });
        }

        if (rows.isEmpty()) {
            rows.add(new String[]{"", "", "", "", "", "", ""});
        }

        // Ngoại lệ 5.1: kiểm tra nhập thiếu thông tin (trừ mô tả)
        for (String[] r : rows) {
            if (r[0].isEmpty() || r[1].isEmpty() || r[2].isEmpty() || r[4].isEmpty() || r[5].isEmpty() || r[6].isEmpty()) {
                errorMessage = "Vui lòng nhập đủ thông tin";
                break;
            }
        }

        // Ngoại lệ 5.4: kiểm tra giá bán hợp lệ
        long[] parsedPrices = new long[rows.size()];
        if (errorMessage == null) {
            for (int i = 0; i < rows.size(); i++) {
                try {
                    long pVal = Long.parseLong(rows.get(i)[5]);
                    if (pVal <= 0) {
                        errorMessage = "Giá bán không hợp lệ";
                        break;
                    }
                    parsedPrices[i] = pVal;
                } catch (NumberFormatException e) {
                    errorMessage = "Giá bán không hợp lệ";
                    break;
                }
            }
        }

        // Ngoại lệ 5.3: kiểm tra nhập nhiều mặt hàng bị trùng mã
        if (errorMessage == null) {
            for (int i = 0; i < rows.size(); i++) {
                for (int j = i + 1; j < rows.size(); j++) {
                    if (rows.get(i)[0].equalsIgnoreCase(rows.get(j)[0])) {
                        errorMessage = "Mã mặt hàng " + rows.get(i)[0] + " bị nhập trùng";
                        break;
                    }
                }
                if (errorMessage != null) {
                    break;
                }
            }
        }

        // Bước 14 - 17: Đóng gói Product8 và chuyển sang doSaveProduct8.jsp
        if (errorMessage == null) {
            Product8[] listProduct = new Product8[rows.size()];
            for (int i = 0; i < rows.size(); i++) {
                String[] r = rows.get(i);
                int tId = Integer.parseInt(r[2]);
                ProductType8 selectedType = null;
                for (ProductType8 pt : listType) {
                    if (pt.getId() == tId) {
                        selectedType = pt;
                        break;
                    }
                }
                if (selectedType == null) {
                    selectedType = new ProductType8(tId, "");
                }
                listProduct[i] = new Product8(r[0], r[1], r[3], r[4], parsedPrices[i], r[6], 0, selectedType);
            }
            session.setAttribute("draftRows", rows);
            session.setAttribute("listProduct", listProduct);
            response.sendRedirect(request.getContextPath() + "/manager/doSaveProduct8.jsp");
            return;
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thêm thông tin mặt hàng</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                margin: 0;
                padding: 30px;
            }
            .container {
                width: 960px;
                margin: 0 auto;
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
            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 16px;
            }
            th, td {
                border: 1px solid #cccccc;
                padding: 6px;
                text-align: left;
                font-size: 13px;
                vertical-align: middle;
            }
            th {
                background-color: #eeeeee;
                text-align: center;
            }
            input[type="text"], select {
                width: 100%;
                padding: 4px;
                box-sizing: border-box;
                border: 1px solid #999999;
                font-size: 13px;
            }
            .img-cell {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }
            .prod-img {
                width: 48px;
                height: 48px;
                object-fit: cover;
                border: 1px solid #dddddd;
            }
            .btn-group {
                display: flex;
                justify-content: center;
                gap: 12px;
                margin-top: 15px;
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
            .notice-box {
                border: 1px solid #999999;
                background-color: #fff8e7;
                padding: 12px;
                margin-top: 15px;
                text-align: center;
            }
            .notice-box p {
                margin: 0 0 10px 0;
                font-size: 14px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Thêm thông tin mặt hàng</h2>

            <form id="addProductForm" action="<%= request.getContextPath() %>/manager/AddProductView8.jsp" method="post" enctype="multipart/form-data" onsubmit="reindexFiles()">
                <table id="tblProduct">
                    <thead>
                        <tr>
                            <th style="width: 90px;">Mã MH</th>
                            <th style="width: 150px;">Tên MH</th>
                            <th style="width: 120px;">Loại</th>
                            <th style="width: 150px;">Mô tả</th>
                            <th style="width: 80px;">ĐV tính</th>
                            <th style="width: 100px;">Giá bán</th>
                            <th style="width: 140px;">Hình ảnh</th>
                            <th style="width: 60px;">Xoá</th>
                        </tr>
                    </thead>
                    <tbody id="productBody">
                        <% for (int i = 0; i < rows.size(); i++) {
                               String[] r = rows.get(i);
                        %>
                        <tr>
                            <td><input type="text" name="productCode" value="<%= r[0] %>"></td>
                            <td><input type="text" name="productName" value="<%= r[1] %>"></td>
                            <td>
                                <select name="typeId">
                                    <option value="">-- Chọn --</option>
                                    <% for (ProductType8 pt : listType) {
                                           String selected = String.valueOf(pt.getId()).equals(r[2]) ? "selected" : "";
                                    %>
                                        <option value="<%= pt.getId() %>" <%= selected %>><%= pt.getTypeName() %></option>
                                    <% } %>
                                </select>
                            </td>
                            <td><input type="text" name="description" value="<%= r[3] %>"></td>
                            <td><input type="text" name="unit" value="<%= r[4] %>"></td>
                            <td><input type="text" name="price" value="<%= r[5] %>"></td>
                            <td>
                                <div class="img-cell">
                                    <img class="prod-img" src="<%= r[6].isEmpty() ? "" : (request.getContextPath() + "/" + r[6]) %>" style="<%= r[6].isEmpty() ? "display:none;" : "" %>" alt="Ảnh">
                                    <input type="file" class="img-input" name="image_<%= i %>" accept="image/*" style="display:none;" onchange="previewImg(this)">
                                    <input type="hidden" name="savedImage" value="<%= r[6] %>">
                                    <button type="button" onclick="this.parentElement.querySelector('.img-input').click()">Chọn</button>
                                </div>
                            </td>
                            <td style="text-align: center;">
                                <button type="button" onclick="deleteRow(this)">Xoá</button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <div class="btn-group">
                    <button type="button" id="btnAddNewRow" onclick="addRow()">Thêm dòng mới</button>
                    <button type="submit" id="btnSave">Lưu</button>
                    <a id="btnCancel" class="btn-link" href="<%= request.getContextPath() %>/manager/ManageProductView8.jsp">Huỷ</a>
                </div>
            </form>

            <% if (errorMessage != null) { %>
                <div class="notice-box" id="errorBox">
                    <p><%= errorMessage %></p>
                    <button type="button" onclick="document.getElementById('errorBox').style.display='none'">Ok</button>
                </div>
            <% } %>
        </div>

        <script>
            function addRow() {
                var tbody = document.getElementById("productBody");
                var newRow = tbody.rows[0].cloneNode(true);
                var inputs = newRow.querySelectorAll("input, select");
                for (var i = 0; i < inputs.length; i++) {
                    inputs[i].value = "";
                }
                var img = newRow.querySelector(".prod-img");
                img.src = "";
                img.style.display = "none";
                tbody.appendChild(newRow);
                reindexFiles();
            }

            function deleteRow(btn) {
                var tbody = document.getElementById("productBody");
                if (tbody.rows.length > 1) {
                    btn.closest("tr").remove();
                } else {
                    var inputs = tbody.rows[0].querySelectorAll("input, select");
                    for (var i = 0; i < inputs.length; i++) {
                        inputs[i].value = "";
                    }
                    var img = tbody.rows[0].querySelector(".prod-img");
                    img.src = "";
                    img.style.display = "none";
                }
                reindexFiles();
            }

            function previewImg(input) {
                var img = input.parentElement.querySelector(".prod-img");
                if (input.files && input.files[0]) {
                    img.src = URL.createObjectURL(input.files[0]);
                    img.style.display = "block";
                }
            }

            function reindexFiles() {
                var fileInputs = document.querySelectorAll("#productBody .img-input");
                for (var i = 0; i < fileInputs.length; i++) {
                    fileInputs[i].name = "image_" + i;
                }
            }
        </script>
    </body>
</html>
