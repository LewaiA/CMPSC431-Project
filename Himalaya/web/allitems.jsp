<%--
    Document   : allitems
    Created on : Mar 25, 2017, 1:54:59 PM
    Author     : nscribano
--%>

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
        <title>All Items</title>
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/bootstrap-theme.min.css">
        <link rel="stylesheet" href="css/main.css">
    </head>
    <body>
        <!-- Load navigation bar -->
        <div id="navbar"></div>
        <script src="//code.jquery.com/jquery.min.js"></script>
        <script>
            $.get("navbar.jsp", function(data){
                $("#navbar").replaceWith(data);
            });
        </script> 
        <!-- End load navigation bar -->
        
        <%-- <a class="btn btn-primary btn default" href="index.jsp">himalaya.com</a> --%>
        <div class="translucentDiv">
            <h1>All Items</h1>
            <%
                InitialContext initialContext = new InitialContext();
                Context context = (Context) initialContext.lookup("java:comp/env");
                //The JDBC Data source that we just created
                DataSource ds = (DataSource) context.lookup("himalaya");
                Connection connection = ds.getConnection();

                if (connection == null)
                {
                    throw new SQLException("Error establishing connection!");
                }
                String query = "SELECT * FROM Items";

                PreparedStatement statement = connection.prepareStatement(query);
                ResultSet rs = statement.executeQuery();

                while (rs.next())
                {
                    out.println(rs.getString("itemID")+" "+rs.getString("name")+"</br>");
                }

                connection.close();
            %>
        </div>
    </body>
</html>
