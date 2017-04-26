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
          ResultSet rs = null;
          if(connection == null){
            throw new SQLException("Error establishing connection!");
          }
          if(request.getParameter("search") !="" || request.getParameter("minimum_price") !="" || request.getParameter("maximum_price")!=""){
              //create a prepare statement to search for keywords
              String sql = "SELECT * FROM Items WHERE ";
              String find_items="";
              int c = 0;
              //check if there was anything in the search box
              if(request.getParameter("search")!= ""){
                  sql+="name LIKE \'%"+request.getParameter("search")+"%\' OR description LIKE \'%"+request.getParameter("search")+"%\'";
                  c++;
              }
              //check if user entered numbers in both minimum and maximum price sections
              if(request.getParameter("minimum_price") != "" && request.getParameter("maximum_price") != ""){
                  find_items="SELECT itemID FROM dsalemethod WHERE price BETWEEN "+ request.getParameter("minimum_price") +
                  " AND " + request.getParameter("maximum_price");
              }
              //check if user entered numbers in just the minimum price
              if(request.getParameter("minimum_price") != ""){
                  find_items="SELECT itemID FROM dsalemethod WHERE price >= " + request.getParameter("minimum_price");
              }
              //check if user entered numbers in just the maximum price section
              if(request.getParameter("maximum_price") != ""){
                  find_items="SELECT itemID FROM dsalemethod WHERE price <= " + request.getParameter("maximum_price");
              }

              if(request.getParameter("minimum_price") != "" || request.getParameter("maximum_price") != ""){
                  PreparedStatement items = connection.prepareStatement(find_items);
                  //THIIIIIIIIICCCCCCCCCCCCCCCCCCCC
                  ResultSet thic = items.executeQuery();

                  while(thic.next()){
                      if(c==0){
                          sql+= "itemID= " + thic.getString("itemID");
                          c++;
                      }
                      sql+=" UNION SELECT * FROM items WHERE itemID = " + thic.getString("itemID");
                  }
              }
              PreparedStatement searchResults = connection.prepareStatement(sql);
              rs = searchResults.executeQuery();
          }
          else{
              PreparedStatement statmnt = connection.prepareStatement("SELECT * FROM items");
              rs = statmnt.executeQuery();
          }

          if(!rs.isBeforeFirst()){
            out.print("<h1>No Items Found with your search. Try a different Search For better Luck! </h1>");
          }
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
            out.println("<h1>An error occurred</h1>");
            out.println("<h1>Please try search again with valid input</h1>");
            out.println("<h1>Error: " + e.getMessage()+"</h1>");
        }
        %>

    </div>
    <div align="center">
        <a class= "btn btn-default" href="index.jsp">Return to Home Page</a>
    </div>
    </body>
</html>
