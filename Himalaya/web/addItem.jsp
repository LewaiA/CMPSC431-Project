<%--
    Document : addItem.jsp
    Create on : April 5, 2017
    Author    : Lew-ayy
--%>

<%@page import="java.sql.Statement"%>
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
        <title>Add Item</title>

        <script src="https://code.jquery.com/jquery-2.1.3.min.js"></script>
        <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" href="css/bootstrap-theme.min.css">
        <link rel="stylesheet" href="css/main.css">
    </head>
    <body>
    <!-- Load navigation bar -->
        <div id="navbar"></div>
        <script>
            $.get("navbar.jsp", function(data){
                $("#navbar").replaceWith(data);
            });
        </script>
        <!-- End load navigation bar -->
        <div align= "center" class="translucentDiv">
          <%
            int itemId=0;
            try{
              if(request.getParameter("submit") != null){
                InitialContext initialContext = new InitialContext();
                Context context = (Context) initialContext.lookup("java:comp/env");
                //The JDBC Data source that we just created
                DataSource ds = (DataSource) context.lookup("himalaya");
                Connection connection = ds.getConnection();
                //create query to pull itemID out from database
                Statement statement=null;

                ResultSet rs= null;
                statement = connection.createStatement();
                statement.executeUpdate("UPDATE item_list list SET list.id= list.id+1");

                rs = statement.executeQuery("SELECT list.id FROM item_list list");

                while(rs.next()){
                    itemId = rs.getInt("id");
                }

                if (connection == null){
                    throw new SQLException("Error establishing connection!");
                }

                PreparedStatement preparedStmt = connection.prepareStatement("INSERT INTO Items(itemID, name, description, url, qty, CID)"
                + "VALUES(?, ?, ?, ?, ?, ?)");
                //create the mysql insert PreparedStatement
                preparedStmt.setInt(1, itemId);
                preparedStmt.setString(2, request.getParameter("name"));
                preparedStmt.setString(3, request.getParameter("description"));
                preparedStmt.setString(4, request.getParameter("url"));
                preparedStmt.setInt(5, Integer.parseInt(request.getParameter("qty")));
                preparedStmt.setInt(6, Integer.parseInt(request.getParameter("CID")));

                //execute the preparedstatement
                preparedStmt.execute();

                out.println("<h1>Item successfully added for sale</h1>");
                connection.close();
              }
            }
            catch (Exception e){
                out.println("<h1>Adding Item Unsuccessful! Please re-check your entries and try again</h1>");
                out.println("<h1>Error: " + e.getMessage()+"</h1>");
            }
            %>
            <a class= "btn btn-default" href="index.jsp">Return to Home Page</a>
        </div>
    </body>
</html>
