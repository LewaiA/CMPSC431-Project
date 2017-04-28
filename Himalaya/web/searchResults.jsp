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
        InitialContext initialContext = new InitialContext();
        Context context = (Context) initialContext.lookup("java:comp/env");
        //The JDBC Data source that we just created
        DataSource ds = (DataSource) context.lookup("himalaya");
        Connection connection = ds.getConnection();

        try{
          ResultSet rs = null;

          if(connection == null){
            throw new SQLException("Error establishing connection!");
          }

          if(request.getParameter("search") !="" || request.getParameter("minimum_price") !="" || request.getParameter("maximum_price")!=""){
              //create a prepare statement to search for keywords
              String sql = "SELECT * FROM Items i";
              String searches="";
              String range="";
              String Min = "";
              String Max = "";
              int c = 0;
             // check if there was anything in the search box
              if(request.getParameter("search")!= ""){
                  searches=" WHERE (i.name LIKE \'%"+request.getParameter("search")+"%\' OR i.description LIKE \'%"+request.getParameter("search")+"%\')";
                  c++;
              }
              //check if user entered numbers in both minimum and maximum price sections
              if(request.getParameter("minimum_price") != "" && request.getParameter("maximum_price") != ""){
                  range="SELECT itemID FROM dsalemethod WHERE price BETWEEN "+ request.getParameter("minimum_price") +
                  " AND " + request.getParameter("maximum_price");
              }
              //check if user entered numbers in just the minimum price
              if(request.getParameter("minimum_price") != ""){
                  Min="SELECT itemID FROM dsalemethod WHERE price >= " + request.getParameter("minimum_price");
              }
              //check if user entered numbers in just the maximum price section
              if(request.getParameter("maximum_price") != ""){
                  Max="SELECT itemID FROM dsalemethod WHERE price <= " + request.getParameter("maximum_price");
              }

              if(request.getParameter("minimum_price") != "" || request.getParameter("maximum_price") != ""){
                  //THIIIIIIIIICCCCCCCCCCCCCCCCCCCC
                  if(range != ""){
                      sql+= ", ("+range+") as R";
                      if(searches != ""){
                          sql+=searches;
                          sql+=" AND i.itemID = R.itemID";
                      }
                      else{
                          sql+= " WHERE i.itemID = R.itemID";
                      }
                  }
                  else if(Max !=""){
                      sql+=", ("+Max+") as M";
                      if(searches != ""){
                          sql+=searches;
                          sql+=" AND i.itemID = M.itemID";
                      }
                      else{
                          sql+= " WHERE i.itemID = M.itemID";
                      }
                  }
                  else if(Min != ""){
                      sql+=", ("+Min+") as M";
                      if(searches != ""){
                          sql+=searches;
                          sql+=" AND i.itemID = M.itemID";
                      }
                      else{
                          sql+=" WHERE i.itemID = M.itemID";
                      }
                  }
              }
              else{
                  sql+= searches;
              }

              PreparedStatement searchResults = connection.prepareStatement(sql);
              rs = searchResults.executeQuery();
          }
          else{
              PreparedStatement statmnt = connection.prepareStatement("SELECT * FROM items");
              rs = statmnt.executeQuery();
          }

          PreparedStatement checkPurchase = null;
          ResultSet purchaseCheck = null;

          out.print("<table class=\"table table-striped table-responsive\">");
                out.print("<tr>"+
                "<td></td>"+
                "<td>Item Name:</td>"+
                "<td>Direct Price</td>"+
                "<td>Current/Minimum Bid</td>"+
                "<td>Go Buy!</td></tr>");

          if(!rs.isBeforeFirst()){
            out.print("<h1>No Items Found with your search. Try a different Search For better Luck! </h1>");
          }
          while (rs.next())
          {
              out.print("<tr><td><img style=\"max-width:60%;\" src=\""+ rs.getString("img_url") + "\"></td><td>"+rs.getString("name")+"</td>");
              checkPurchase = connection.prepareStatement("SELECT * FROM dsalemethod WHERE itemID =?");
              checkPurchase.setString(1, rs.getString("itemID"));
              purchaseCheck = checkPurchase.executeQuery();

              if(purchaseCheck.isBeforeFirst()){
                  while(purchaseCheck.next()){
                      out.println("<td>"+purchaseCheck.getString("price")+"</td>");
                  }
              }
              else{
                  out.println("<td>N/A</td>");
              }

              checkPurchase = connection.prepareStatement("SELECT * FROM biddingmethod WHERE itemID=?");
              checkPurchase.setString(1, rs.getString("itemID"));
              purchaseCheck = checkPurchase.executeQuery();

              if(purchaseCheck.isBeforeFirst()){
                  while(purchaseCheck.next()){
                      if(purchaseCheck.getString("current_bid")!= null){
                          out.println("<td>"+purchaseCheck.getString("current_bid")+"</td>");
                      }
                      else{
                          out.println("<td>"+purchaseCheck.getString("min_bid")+"</td>");
                      }
                  }
              }
              else{
                  out.println("<td>N/A</td>");
              }


              out.println("<td><a href=\"item.jsp?itemID="+rs.getString("itemID")+"\" class=\"btn btn-success\"> Check it out!</a></td></tr>");
          }
          out.print("</table>");
          connection.close();

        }
        catch (Exception e){
            out.println("<h1>An error occurred</h1>");
            out.println("<h1>Please try search again with valid input</h1>");
            out.println("<h1>Error: " + e.getMessage()+"</h1>");
            connection.close();
        }
        %>

    </div>
    </body>
</html>
