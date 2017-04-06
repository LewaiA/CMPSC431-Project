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
        <title>Log In</title>
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/bootstrap-theme.min.css">
        <link rel="stylesheet" href="css/main.css">
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

                        // create the mysql insert preparedstatement
                        PreparedStatement preparedStmt = connection.prepareStatement(""
                                + "SELECT email,password FROM Users WHERE email=? AND password=?");
                        preparedStmt.setString(1, request.getParameter("email"));
                        preparedStmt.setString(2, request.getParameter("password"));

                        // execute the preparedstatement
                        ResultSet rs = preparedStmt.executeQuery();                        
                        if(rs.next())           
                           out.println("<h1>Valid login credentials</h1>");        
                        else
                           out.println("<h1>Invalid login credentials</h1>");

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