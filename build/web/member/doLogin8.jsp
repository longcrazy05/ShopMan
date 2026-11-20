<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Member8"%>
<%@page import="model.Manager8"%>
<%@page import="model.Customer8"%>
<%@page import="dao.MemberDAO8"%>
<%
    request.setCharacterEncoding("UTF-8");
    String userName = request.getParameter("userName");
    String password = request.getParameter("password");

    Member8 member = new Member8();
    member.setUserName(userName != null ? userName.trim() : "");
    member.setPassword(password != null ? password.trim() : "");

    MemberDAO8 memberDAO = new MemberDAO8();
    Member8 loggedIn = memberDAO.checkLogin(member);

    if (loggedIn instanceof Manager8) {
        session.setAttribute("manager", (Manager8) loggedIn);
        response.sendRedirect(request.getContextPath() + "/manager/ManagerHomeView8.jsp");
    } else if (loggedIn instanceof Customer8) {
        session.setAttribute("customer", (Customer8) loggedIn);
        response.sendRedirect(request.getContextPath() + "/customer/CustomerHomeView8.jsp");
    } else {
        response.sendRedirect(request.getContextPath() + "/member/LoginView8.jsp?err=1");
    }
%>
