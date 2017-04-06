<%--
    Document   : index
    Created on : Mar 22, 2017, 4:52:26 PM
    Author     : nscribano
--%>
<%-- <%@page import="javax.naming.Context"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%> --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Himalaya.com</title>

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
        
    
    <h1 align="center">Welcome to Himalaya.com</h1>
    <%-- Search Bar --%>
    <%-- <div class="navbar-form navbar-left">
        <div class="col-xs-12 col-sm-6 col-sm-push-3 col-md-6 col-md-push-3">
           <div class="input-group">
             <input type="text" class="form-control" placeholder="Search for...">
             <span class="input-group-btn">
               <button class="btn btn-default" type="button">Go!</button>
             </span>
           </div><!-- /input-group -->
        </div><!-- /.col-lg-6 -->
    </div><!-- /.row --> --%>
    <%-- Search Bar end --%>



    <%-- <a class="btn btn-primary btn-default" href="allitems.jsp">All Items</a>
    <a class="btn btn-primary btn-default" href="newUser.html" role="button">New User</a> --%>


    <%-- <%
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
            out.println(rs.getString("itemID"));
        }

        connection.close();
    %> --%>
    </body>
</html>
