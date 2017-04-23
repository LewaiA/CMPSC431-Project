<%@page import="java.text.SimpleDateFormat"%>
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
        <title>Terminate Auction</title>

        <script src="https://www.kryogenix.org/code/browser/sorttable/sorttable.js"></script>
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
            <h1 align="center">Terminate Auction</h1>
            
            <%
                try{
                    InitialContext initialContext = new InitialContext();
                    Context context = (Context) initialContext.lookup("java:comp/env");
                    //The JDBC Data source that we just created
                    DataSource ds = (DataSource) context.lookup("himalaya");
                    Connection connection = ds.getConnection();

                    if (connection == null)
                    {
                        throw new SQLException("Error establishing connection!");
                    }
                    
                    PreparedStatement preparedStmt = connection.prepareStatement(
                            "SELECT * FROM BiddingMethod WHERE end_date >= ? AND end_date <= ?");
                    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                    java.util.Date now = new java.util.Date();
                    String dateBegin = format.format(now) + " 00:00:00";
                    String dateEnd = format.format(now) + " 23:59:59";
                    preparedStmt.setString(1, dateBegin);
                    preparedStmt.setString(2, dateEnd);
                    ResultSet rs = preparedStmt.executeQuery();

                    out.print("<h3>Auctions ending today</h3>");
                    %>
                    <table class="sortable table" align="center" border="0">
                        <tr style="font-weight:bold">
                            <td>Email</td>
                            <td>itemId</td>
                            <td>Sold?</td>
                            <td>Price Paid</td>
                        </tr>
                    <%
                    while (rs.next())
                    {
                        out.print("<tr>");

                        out.print("<td>"
                            + rs.getString("current_bidder")
                            + "</td>");
                        out.print("<td>"
                            + rs.getString("itemID")
                            + "</td>");
                        
                        if (rs.getString("min_bid") != null && rs.getString("current_bid") != null
                                && Integer.parseInt(rs.getString("min_bid")) <= Integer.parseInt(rs.getString("current_bid"))){
                            
                            // item sold
                            out.print("<td>Yes</td>");
                            preparedStmt = connection.prepareStatement(
                                    "INSERT INTO PurchaseHistory VALUES(?, ?, ?, ?, ?, ?, ?)");
                            preparedStmt.setString(1, rs.getString("current_bidder"));
                            preparedStmt.setString(2, rs.getString("itemID"));
                            format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            now = new java.util.Date();
                            String dateTime = format.format(now);
                            preparedStmt.setString(3, dateTime);
                            preparedStmt.setString(4, "1");
                            preparedStmt.setString(5, rs.getString("current_bid"));
                            
                            // find user card/shipping address
                            PreparedStatement preparedStmt2 = connection.prepareStatement(
                                    "SELECT number FROM CCPayment WHERE email=?");
                            preparedStmt2.setString(1, rs.getString("current_bidder"));
                            ResultSet rs2 = preparedStmt2.executeQuery();
                            if (rs2.next()){
                                preparedStmt.setString(6, rs2.getString("number"));
                            } else {
                                preparedStmt.setString(6, null);
                            }
                            preparedStmt2 = connection.prepareStatement(
                                    "SELECT * FROM ShippingAddress WHERE email=?");
                            preparedStmt2.setString(1, rs.getString("current_bidder"));
                            rs2 = preparedStmt2.executeQuery();
                            if (rs2.next()){
                                preparedStmt.setString(7, rs2.getString("street") + " " + rs2.getString("city") + " " + rs2.getString("state") + " " + rs2.getString("ZIP"));
                            } else {
                                preparedStmt.setString(7, null);
                            }
                            
                            // deactivate auction
                            preparedStmt = connection.prepareStatement(
                                    "UPDATE BiddingMethod SET active=false WHERE itemID=?");
                            preparedStmt.setString(1, rs.getString("itemID"));
                            
                            
                            preparedStmt.executeUpdate();
                            
                        }
                        else {  // item not sold
                            out.print("<td>No</td>");
                            preparedStmt = connection.prepareStatement(
                                    "DELETE FROM BiddingMethod WHERE itemID=?");
                            preparedStmt.setString(1, rs.getString("itemID"));
                            preparedStmt.executeUpdate();
                            
                            preparedStmt = connection.prepareStatement(
                                    "DELETE FROM Items WHERE itemID=?");
                            preparedStmt.setString(1, rs.getString("itemID"));
                            preparedStmt.executeUpdate();
                            
                        }
                        
                        out.print("<td>"
                            + rs.getString("current_bid")
                            + "</td>");
                        
                        
                        out.print("</tr>");
                    }
                    
                    out.print("</table>");
                    
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
