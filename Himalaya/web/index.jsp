<%-- 
    Document   : index
    Created on : Mar 22, 2017, 4:52:26 PM
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
        <title>Himalaya.com</title>
    </head>
    <body>
        <h1>Welcome to Himalaya.com</h1>
        <a href="allitems.jsp">All Items</a>
        <a href="newUser.jsp">New User</a>
        <h1>ItemIDs from Items table in Himalaya DB</h1>
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
                out.println(rs.getString("itemID"));
            }
            
            connection.close();
        %>
    </body>
</html>
