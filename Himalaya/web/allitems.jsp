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

        <%-- <a class="btn btn-primary btn default" href="index.jsp">himalaya.com</a> --%>
        <div class="translucentDiv">
            <h1>All Items</h1>
            <%
            InitialContext initialContext = new InitialContext();
            Context context = (Context) initialContext.lookup("java:comp/env");
            //The JDBC Data source that we just created
            DataSource ds = (DataSource) context.lookup("himalaya");
            Connection connection = ds.getConnection();
                try{

                    if (connection == null)
                    {
                        throw new SQLException("Error establishing connection!");
                    }
                    String query = "SELECT * FROM Items";

                    PreparedStatement statement = connection.prepareStatement(query);
                    ResultSet rs = statement.executeQuery();

                    PreparedStatement checkPurchase = null;
                    ResultSet purchaseCheck = null;

                    out.print("<table class=\"table table-striped table-responsive\">");
                          out.print("<tr>"+
                          "<td></td>"+
                          "<td>Item Name:</td>"+
                          "<td>Direct Price</td>"+
                          "<td>Current/Minimum Bid</td>"+
                          "<td>Go Buy!</td></tr>");

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
                    out.println("Error: " + e.getMessage());
                    out.println("<h1>An error occurred<h1>");
                    connection.close();
                }
            %>
        </div>
    </body>
</html>
