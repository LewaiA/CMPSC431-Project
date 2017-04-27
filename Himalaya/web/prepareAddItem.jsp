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
                // Statement statement=null;

                // ResultSet rs= null;
                // statement = connection.createStatement();
                // statement.executeUpdate("UPDATE item_list list SET list.id= list.id+1");

                // rs = statement.executeQuery("SELECT list.id FROM item_list list");

                // while(rs.next()){
                    // itemId = rs.getInt("id");
                // }
                int itemID=0;
                if (connection == null){
                    throw new SQLException("Error establishing connection!");
                }

                PreparedStatement preparedStmt = connection.prepareStatement("INSERT INTO Items(name, description, seller_url, img_url, qty, CID)"
                + "VALUES(?, ?, ?, ?, ?, ?)", new String[]{"itemID"});
                //create the mysql insert PreparedStatement
                // preparedStmt.setInt(1, itemId);
                preparedStmt.setString(1, request.getParameter("name"));
                preparedStmt.setString(2, request.getParameter("description"));
                preparedStmt.setString(3, request.getParameter("seller_url"));
                preparedStmt.setString(4, request.getParameter("img_url"));
                preparedStmt.setInt(5, Integer.parseInt(request.getParameter("qty")));
                preparedStmt.setInt(6, Integer.parseInt(request.getParameter("cid")));

                //execute the preparedstatement
                preparedStmt.execute();
                //get generated itemID
                try (ResultSet generatedKeys = preparedStmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        itemID = generatedKeys.getInt(1);
                    }
                    else {
                        throw new SQLException("<h1>Creating user failed, no ID obtained.</h1>");
                    }
                }

                String DirectSale = request.getParameter("dsale");
                if(DirectSale !=null){
                    //prepare statement to input into Direct Sale
                    PreparedStatement dSaleStmt = connection.prepareStatement("INSERT INTO DsaleMethod(itemID, price) VALUES(?,?)");
                    dSaleStmt.setInt(1, itemID);
                    dSaleStmt.setInt(2, Integer.parseInt(request.getParameter("price")));

                    dSaleStmt.execute();
                    //End Direct Sale
                }
                String BiddingSale= request.getParameter("bsale");
                if(BiddingSale !=null){
                    //prepare statement to input into Bidding Sale
                    PreparedStatement bSaleStmt = connection.prepareStatement("INSERT INTO BiddingMethod(itemID, min_bid, current_bid, current_bidder, end_date, active)"
                    + "VALUES(?,?, NULL, NULL, ?, true)");
                    bSaleStmt.setInt(1, itemID);
                    bSaleStmt.setInt(2, Integer.parseInt(request.getParameter("min_bid")));

                    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                    java.util.Date end_date = format.parse(request.getParameter("end_date"));
                    bSaleStmt.setDate(3, new java.sql.Date(end_date.getTime()));

                    bSaleStmt.execute();

                    //end Bidding Sale
                }
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
