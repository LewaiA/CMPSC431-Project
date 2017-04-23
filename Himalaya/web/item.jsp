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
        <title>Item</title>

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
            <%
                try {
                    
                    // --- Submit bid --- //
                    if (request.getParameter("submitBid") != null){
                        // --- Check that user is logged in --- //
                        if (request.getSession().getAttribute("email") == null){
                            out.println("<h3 style=\"color:red;display:table;margin:0 auto;\">You must be logged in to place a bid</h3>");
                        }
                        else {
                            InitialContext initialContext = new InitialContext();
                            Context context = (Context) initialContext.lookup("java:comp/env");
                            DataSource ds = (DataSource) context.lookup("himalaya");
                            Connection connection = ds.getConnection();

                            if (connection == null)
                            {
                                throw new SQLException("Error establishing connection!");
                            }

                            // --- Place bid --- //
                            PreparedStatement preparedStmt = connection.prepareStatement(
                                    "UPDATE BiddingMethod SET current_bid = ?, current_bidder = ? WHERE itemID = ?");
                            preparedStmt.setString(1, request.getParameter("newBid"));
                            preparedStmt.setString(2, request.getParameter("email"));
                            preparedStmt.setString(3, request.getParameter("itemID"));
                            preparedStmt.executeUpdate();

                            connection.close();
                        }
                    }
                    
                    // --- Submit rating --- //
                    if (request.getParameter("submitRating") != null){
                        // --- Check that user is logged in --- //
                        if (request.getSession().getAttribute("email") == null){
                            out.println("<h3 style=\"color:red;display:table;margin:0 auto;\">You must be logged in to leave a rating</h3>");
                        }
                        else {
                            InitialContext initialContext = new InitialContext();
                            Context context = (Context) initialContext.lookup("java:comp/env");
                            DataSource ds = (DataSource) context.lookup("himalaya");
                            Connection connection = ds.getConnection();
                            
                            PreparedStatement preparedStmt = connection.prepareStatement(
                                    "INSERT INTO Rating VALUES (?,?,?,?)");
                            preparedStmt.setString(1, request.getSession().getAttribute("email").toString());
                            preparedStmt.setString(2, request.getParameter("itemID"));
                            preparedStmt.setString(3, request.getParameter("stars"));
                            preparedStmt.setString(4, request.getParameter("review"));
                            preparedStmt.executeUpdate();
                            
                            connection.close();
                        }
                        
                    }

                    // --- Get item info --- //
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
                            out.println("<h1>");
                            out.println(rs.getString("name"));
                            out.println("</h1>");

                            out.println("<h4>Quantity available: "
                                    + rs.getString("qty")
                                    + "&nbsp;&nbsp;&nbsp;");
                            
                            out.println("Seller URL: ");
                            out.println("<a href=\"" + rs.getString("url") + "\">" + rs.getString("url") + "</a>");
                            out.println("</h4>");

                            out.println("<h4>Description: ");
                            out.println(rs.getString("description"));
                            out.println("</h4>");
                        }
                        else {
                           out.println("<h1>An error occurred</h1>");
                        }
                        
                        // --- Get average rating --- //
                        preparedStmt = connection.prepareStatement(
                                "SELECT AVG(stars) AS avgRating FROM Rating R WHERE R.itemID=? GROUP BY itemID");
                        preparedStmt.setString(1, request.getParameter("itemID"));
                        rs = preparedStmt.executeQuery();                        
                        if(rs.next()) {    
                            out.println("<h4>Average rating: ");
                            out.println(rs.getString("avgRating"));
                            out.println(" / 5 peaks</h4>");
                        }
                        else {
                           out.println("<h4>No ratings present</h4>");
                        }

                        // --- Get DsaleMethod information (if exists) --- //
                        preparedStmt = connection.prepareStatement(
                                "SELECT * FROM DsaleMethod WHERE itemID=?");
                        preparedStmt.setString(1, request.getParameter("itemID"));
                        rs = preparedStmt.executeQuery();                        
                        if(rs.next()) {       
                            out.println("<h4>Price per item: $" + rs.getString("price") + " ");
                            out.println("<form name=\"buyItem\" method=\"POST\" action=\"confirmBuyItem.jsp?itemID="
                                    + request.getParameter("itemID")
                                    + "\" onsubmit=\"return validate_buy();\">");
                            out.println("<input type=\"hidden\" name=\"email\" value=\""
                                    + request.getSession().getAttribute("email")
                                    + "\">");
                            out.println("<input type=\"hidden\" name=\"price\" value=\""
                                    + rs.getString("price")
                                    + "\">");
                            out.println("<input type=\"number\" name=\"quantity\" placeholder=\"Quantity\">");
                            out.println("<input type=\"submit\" name=\"submitBuy\" class=\"btn btn-default\" value=\"Buy Now\">");
                            out.println("</form>");
                            out.println("</h4>");
                        }

                        // --- Get BiddingMethod information (if exists) --- //
                        preparedStmt = connection.prepareStatement(
                                "SELECT * FROM BiddingMethod WHERE itemID=?");
                        preparedStmt.setString(1, request.getParameter("itemID"));
                        rs = preparedStmt.executeQuery();                        
                        if(rs.next()) {       
                            out.println("<h4>Current bid: $" + rs.getString("current_bid") + " ");
                            out.println("&nbsp;Current bidder: ");
                            out.println(rs.getString("current_bidder"));
                            
                            
                            out.println("<form name=\"bidOnItem\" method=\"POST\" action=\"item.jsp?itemID="
                                    + request.getParameter("itemID")
                                    + "\" onsubmit=\"return validate_bid();\">");
                            out.println("<input type=\"hidden\" name=\"email\" value=\""
                                    + request.getSession().getAttribute("email")
                                    + "\">");
                            out.println("<input type=\"hidden\" name=\"prevBid\" value=\""
                                    + rs.getString("current_bid")
                                    + "\">");
                            out.println("<input type=\"hidden\" name=\"minBid\" value=\""
                                    + rs.getString("min_bid")
                                    + "\">");
                            
                            if (rs.getBoolean("active")){
                                %>        
                                    <input type="number" name="newBid" placeholder="Enter new bid">
                                    <input type="submit" name="submitBid" class="btn btn-default" value="Place bid">
                                </form>
                                <%
                            }
                            else{
                                %>
                                    <input disabled type="number" name="newBid" placeholder="This auction isn't active">
                                    <input disabled type="submit" name="submitBid" class="btn btn-default" value="Place bid">
                                </form>
                                <%
                            }
                            out.println("</h4>");
                        }

                        // --- Leave item rating --- //
                        if (request.getSession().getAttribute("email") != null){
                            
                            // --- Leave rating on only items bought --- //
                            preparedStmt = connection.prepareStatement(
                                    "SELECT * FROM PurchaseHistory WHERE itemID=? AND email=?");
                            preparedStmt.setString(1, request.getParameter("itemID"));
                            preparedStmt.setString(2, request.getSession().getAttribute("email").toString());
                            rs = preparedStmt.executeQuery();

                            if (rs.next()) {
                                preparedStmt = connection.prepareStatement(
                                        "SELECT * FROM Rating WHERE itemID=? AND email=?");
                                preparedStmt.setString(1, request.getParameter("itemID"));
                                preparedStmt.setString(2, request.getSession().getAttribute("email").toString());
                                rs = preparedStmt.executeQuery();

                                if (rs.next() == false){
                                    out.println("<form name=\"leaveRating\" method=\"POST\" action=\"item.jsp?itemID="
                                            + request.getParameter("itemID")
                                            + "\" onsubmit=\"return validate_rating();\">"); 
                                    %>
                                    <h4>Rate number of peaks: </h4>
                                        <select class="form-control" name="stars" placeholder="Peaks (1-5)">
                                            <option value="1">^</option>
                                            <option value="2">^^</option>
                                            <option value="3">^^^</option>
                                            <option value="4">^^^^</option>
                                            <option value="5">^^^^^</option>
                                        </select>
                                        <textarea type="text" class="form-control" style="vertical-align:top;" name="review" placeholder="Review (optional)"></textarea>
                                        <input type="submit" name="submitRating" class="btn btn-default" value="Leave rating">
                                    </form>     
                                    <%
                                }
                            }
                        }

                        // --- Show item reviews --- //
                        preparedStmt = connection.prepareStatement(
                                "SELECT * FROM Rating WHERE itemID=?");
                        preparedStmt.setString(1, request.getParameter("itemID"));
                        rs = preparedStmt.executeQuery();

                        if (rs.next()){
                            rs.beforeFirst();
                            out.println("<h4>Reviews</h4>");
                            %>
                            <table class="sortable table" align="center" border="0">
                                <tr style="font-weight:bold">
                                    <td>Email</td>
                                    <td>Rating</td>
                                    <td>Review</td>
                                </tr>
                            <%
                            while(rs.next()){
                                out.println("<tr>");
                                out.println("<td>" + rs.getString("email") + "</td>");
                                out.println("<td>" + rs.getString("stars") + "</td>");
                                out.println("<td>" + rs.getString("review") + "</td>");
                                out.println("</tr>");
                            }
                            out.println("</table>");
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
            function validate_buy(){
                var qty = document.buyItem.quantity.value;
                
                if (parseInt(qty) < 0){
                    alert("Quantity cannot be negative");
                    return false;
                }
                else if (parseInt(qty) < 1) {
                    alert("Quantity cannot be 0");
                    return false;
                }
                else if (qty == "") {
                    alert("No quantity entered");
                    return false;
                }
                else {
                    document.bidOnItem.submit();
                }
            }
            
            function validate_bid(){
                var newBid = document.bidOnItem.newBid.value;
                var prevBid = document.bidOnItem.prevBid.value;
                var minBid = document.bidOnItem.minBid.value;
                
                if (parseInt(newBid) < parseInt(prevBid) + 2){
                    alert("New bid must be at least $2 greater");
                    return false;
                }
                else if (parseInt(newBid) < parseInt(minBid)){
                    alert("The reserve price has not been reached. Please increase your bid.");
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
            
            function validate_rating(){
                var rating = document.leaveRating.stars.value;
                var review = document.leaveRating.review.value;
                
                if (parseInt(rating) > 5 || parseInt(rating) < 1){
                    alert("Rating must be between 1 and 5");
                    return false;
                }
                else if (review.length > 500){
                    alert("Review is limited to 500 characters");
                    return false;
                }
                else {
                    document.bidOnItem.submit();
                }
            }
        </script>
    
    </body>
</html>
