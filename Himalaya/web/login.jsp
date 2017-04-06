<%-- 
    Document   : login
    Created on : Apr 6, 2017, 4:39:53 PM
    Author     : nscribano
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Enumeration"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <!-- Load navigation bar -->
        <div id="navbar"></div>
        <script src="//code.jquery.com/jquery.min.js"></script>
        <script>
            $.get("navbar.html", function(data){
                $("#navbar").replaceWith(data);
            });
        </script> 
        <!-- End load navigation bar -->
        
        <div class="translucentDiv">
            <%
                try{
                    if (request.getParameter("submit") != null) {
                        InitialContext initialContext = new InitialContext();
                        Context context = (Context) initialContext.lookup("java:comp/env");
                        //The JDBC Data source that we just created
                        DataSource ds = (DataSource) context.lookup("himalaya");
                        Connection connection = ds.getConnection();

                        if (connection == null)
                        {
                            throw new SQLException("Error establishing connection!");
                        }

                        Enumeration paramNames = request.getParameterNames();

//                        String ins = "INSERT INTO Users (email, password, name, gender, phone, dob, reward_progress, income)"
//                        + " VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
//
//                        // create the mysql insert preparedstatement
//                        PreparedStatement preparedStmt = connection.prepareStatement(ins);
//                        preparedStmt.setString(1, request.getParameter("email"));
//                        preparedStmt.setString(2, request.getParameter("password"));
//                        preparedStmt.setString(3, request.getParameter("name"));
//                        preparedStmt.setString(4, request.getParameter("gender"));
//                        preparedStmt.setString(5, request.getParameter("phone"));
//
//                        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
//                        java.util.Date dob = format.parse(request.getParameter("dob"));
//                        //java.sql.Date sqlDob = new java.sql.Date(dob.getTime());
//                        preparedStmt.setDate(6, new java.sql.Date(dob.getTime()));
//
//                        preparedStmt.setInt(7, 0);
//                        preparedStmt.setInt(8, Integer.parseInt(request.getParameter("income")));
//
//
//                        // execute the preparedstatement
//                        preparedStmt.execute();

                        out.println("<h1>Login Successful</h1>");
                        connection.close();
                    }
                } catch (Exception e){
                    out.println("<h1>An error occurred, please try again<h1>");
                    out.println("Error: " + e.getMessage());
                }
                
               %>
            <a class="btn btn-default" href="index.jsp">Return to Home Page</a>
        </div>
    </body>
</html>