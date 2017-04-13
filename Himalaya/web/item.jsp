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
        <title>Item</title>

        <script src="https://code.jquery.com/jquery-2.1.3.min.js"></script>
        <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" href="css/bootstrap-theme.min.css">
        <link rel="stylesheet" href="css/main.css">
    </head>
    <body>
        <!-- Load navigation bar -->
        <div id="navbar"></div>
        <script src="//code.jquery.com/jquery.min.js"></script>
        <script>
            $.get("navbar.jsp", function(data){
                $("#navbar").replaceWith(data);
            });
        </script> 
        <!-- End load navigation bar -->

        <div class="translucentDiv">
            <%
                try {
                    if (request.getParameter("submitBid") != null){
                        InitialContext initialContext = new InitialContext();
                        Context context = (Context) initialContext.lookup("java:comp/env");
                        DataSource ds = (DataSource) context.lookup("himalaya");
                        Connection connection = ds.getConnection();

                        if (connection == null)
                        {
                            throw new SQLException("Error establishing connection!");
                        }

                        // --- Get item information --- //
                        PreparedStatement preparedStmt = connection.prepareStatement(
                                "UPDATE BiddingMethod SET current_bid = ?, current_bidder = ? WHERE itemID = ?");
                        preparedStmt.setString(1, request.getParameter("newBid"));
                        preparedStmt.setString(2, request.getParameter("email"));
                        preparedStmt.setString(3, request.getParameter("itemID"));
                        preparedStmt.executeUpdate();

                        connection.close();
                    }

                    if (request.getParameter("itemID") != null){
                        InitialContext initialContext = new InitialContext();
                        Context context = (Context) initialContext.lookup("java:comp/env");
                        //The JDBC Data source that we just created
                        DataSource ds = (DataSource) context.lookup("himalaya");
                        Connection connection = ds.getConnection();

                        if (connection == null)
                        {
                            throw new SQLException("Error establishing connection!");
                        }

                        // --- Get item information --- //
                        PreparedStatement preparedStmt = connection.prepareStatement(
                                "SELECT * FROM Items I WHERE I.itemID=?");
                        preparedStmt.setString(1, request.getParameter("itemID"));
                        ResultSet rs = preparedStmt.executeQuery();                        
                        if(rs.next()) {       
                            out.print("<h1>");
                            out.print(rs.getString("name"));
                            out.print("</h1>");

                            out.print("<h4>Quantity available: ");
                            out.print(rs.getString("qty"));
                            out.print("</h4>");

                            out.print("<h4>Description: ");
                            out.print(rs.getString("description"));
                            out.print("</h4>");

                            out.print("<h4>Seller URL: ");
                            out.print(rs.getString("url"));
                            out.print("</h4>");

                        }
                        else {
                           out.println("<h1>An error occurred</h1>");
                        }

                        // --- Get DsaleMethod information (if exists) --- //
                        preparedStmt = connection.prepareStatement(
                                "SELECT * FROM DsaleMethod WHERE itemID=?");
                        preparedStmt.setString(1, request.getParameter("itemID"));
                        rs = preparedStmt.executeQuery();                        
                        if(rs.next()) {       
                            out.print("<h4>Price: $");
                            out.print(rs.getString("price") + " ");
                            out.print("<a class=\"btn btn-default\">Buy Now</a>");
                            out.print("</h4>");
                        }

                        // --- Get BiddingMethod information (if exists) --- //
                        preparedStmt = connection.prepareStatement(
                                "SELECT * FROM BiddingMethod WHERE itemID=?");
                        preparedStmt.setString(1, request.getParameter("itemID"));
                        rs = preparedStmt.executeQuery();                        
                        if(rs.next()) {       
                            out.print("<h4>Current bid: $");
                            out.print(rs.getString("current_bid") + " ");
                            out.print("&nbsp;Current bidder: ");
                            out.print(rs.getString("current_bidder"));
                            
                            
                            out.print("<form name=\"bidOnItem\" method=\"POST\" action=\"item.jsp?itemID="
                                    + request.getParameter("itemID")
                                    + "\" onsubmit=\"return validate_bid();\">");
                            out.print("<input type=\"hidden\" name=\"email\" value=\""
                                    + request.getSession().getAttribute("email")
                                    + "\">");
                            out.print("<input type=\"hidden\" name=\"prevBid\" value=\""
                                    + rs.getString("current_bid")
                                    + "\">");
                            %>        
                                <input type="number" name="newBid">
                                <input type="submit" name="submitBid" class="btn btn-default" value="Place bid">
                            </form>
                            <%
                            out.print("</h4>");
                        }

                        connection.close();
                    }
                }
                catch (Exception e){
                        out.println("<h1>An error occurred<h1>");
                        out.println("Error: " + e.getMessage());
                }
            %>
        </div>
            
        <script type="text/javascript">
            function validate_bid(){
                var newBid = document.bidOnItem.newBid.value;
                var prevBid = document.bidOnItem.prevBid.value;
                
                if (parseInt(newBid) < parseInt(prevBid) + 2){
                    alert("New bid must be at least $2 greater");
                    return false;
                }
                else if(newBid === ""){
                    alert("No bid entered");
                    return false;
                }
                else {
                    document.bidOnItem.submit();
                }

            }
        </script>
    
    </body>
</html>
