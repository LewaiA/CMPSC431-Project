<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
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
        <title>Confirm Buy Item</title>

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
        <%

          InitialContext initialContext = new InitialContext();
          Context context = (Context) initialContext.lookup("java:comp/env");
          //The JDBC Data source that we just created
          DataSource ds = (DataSource) context.lookup("himalaya");
          Connection connection = ds.getConnection();
          try{
              String user_name = "";

              PreparedStatement info = connection.prepareStatement("SELECT name FROM users WHERE email=?");
              info.setString(1, (String)request.getSession().getAttribute("email"));
              ResultSet getNames = info.executeQuery();

              //get user name first
              if(getNames.isBeforeFirst()){
                  while(getNames.next()){
                      user_name = getNames.getString("name");
                  }
              }

              //print out the User's Wishlist
              out.println("<h1 align=\"center\">"+ user_name+"'s Wishlist</h1>");
              PreparedStatement checkPurchase;
              int count = 0;
              PreparedStatement Wishlist = connection.prepareStatement("SELECT * FROM Wishlist WHERE email=?");
              ResultSet purchaseCheck=null;
              Wishlist.setString(1, (String) request.getSession().getAttribute("email"));

              ResultSet wishList = Wishlist.executeQuery();

              if(!wishList.isBeforeFirst()){
                  out.print("<h1 align=\"center\"> There are currently no Items in your Wishlist!</h1>");
              }
              else{
                  out.print("<table class=\"table table-striped table-responsive\">");
                  out.print("<tr>"+
                  "<td>Item Name:</td>"+
                  "<td>Date Added:</td>"+
                  "<td>Direct Price</td>"+
                  "<td>Current/Minimum Bid</td>"+
                  "<td>Go Buy!</td>"+
                  "<td>Delete :(</td></tr>");

                  while(wishList.next()){

                      out.print("<tr><td>"+wishList.getString("name")+"</td><td>"+wishList.getDate("date_added")+"</td>");
                      checkPurchase = connection.prepareStatement("SELECT * FROM dsalemethod WHERE itemID =?");
                      checkPurchase.setString(1, wishList.getString("itemID"));
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
                      checkPurchase.setString(1, wishList.getString("itemID"));
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


                      out.println("<td><a href=\"item.jsp?itemID="+wishList.getString("itemID")+"\" class=\"btn btn-success\"> Check it out!</a></td>");
                      out.println("<td><a href=\"deleteWish.jsp?itemID="+wishList.getString("itemID")+"\" class=\"btn btn-danger\"> Delete</a></td></tr>");
                  }
                  out.print("</table>");
              }
              connection.close();
          }
          catch(Exception e){
              out.println("<h1>An error occurred<h1>");
              out.println("Error: " + e.getMessage());
              connection.close();
          }
        %>
      </div>
    </body>
</html>
