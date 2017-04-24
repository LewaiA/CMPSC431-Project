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
        <title>Search Results</title>

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

    <div class="translucentDiv">
        <h1 align="center">Search results</h1>
        <%
        try{
          InitialContext initialContext = new InitialContext();
          Context context = (Context) initialContext.lookup("java:comp/env");
          //The JDBC Data source that we just created
          DataSource ds = (DataSource) context.lookup("himalaya");
          Connection connection = ds.getConnection();

          if(connection == null){
            throw new SQLException("Error establishing connection!");
          }

          PreparedStatement searchResults = connection.prepareStatement("SELECT * FROM Items WHERE name = ?");
          searchResults.setString(1, request.getParameter("search"));

          ResultSet rs = searchResults.executeQuery();

          while (rs.next())
          {
              out.print("<a href=\"item.jsp?itemID="+
                      rs.getString("itemID")
                      +"\">");
              out.print(rs.getString("itemID")+" "+rs.getString("name")+"</br>");
              out.println("</a>");
          }

          connection.close();
        }

        catch (Exception e){
            out.println("<h1>An error occurred<h1>");
            out.println("Error: " + e.getMessage());
        }
        %>
    </div>

    </body>
</html>
