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
                try {
                    // --- Check that user is logged in --- //
                    if (request.getSession().getAttribute("email") == null){
                        out.println("<h3 style=\"color:red;display:table;margin:0 auto;\">You must be logged in to buy an item</h3>");
                    }
                    else {
                        if (request.getParameter("submitBuy") != null){
                            out.print("<h1>Confirm your purchase</h1>");
                            out.print("<form name=\"confirmBuyItem\" method=\"POST\" action=\"confirmBuyItem.jsp?itemID="
                                    + request.getParameter("itemID")
                                    + "\" onsubmit=\"return validate_confirmBuy();\">");
                            out.print("<input type=\"hidden\" name=\"email\" value=\""
                                    + request.getSession().getAttribute("email")
                                    + "\">");
                            out.print("<input type=\"hidden\" name=\"quantity\" value=\""
                                    + request.getParameter("quantity")
                                    + "\">");
                            out.print("<input type=\"hidden\" name=\"price\" value=\""
                                    + request.getParameter("price")
                                    + "\">");

                            InitialContext initialContext = new InitialContext();
                            Context context = (Context) initialContext.lookup("java:comp/env");
                            DataSource ds = (DataSource) context.lookup("himalaya");
                            Connection connection = ds.getConnection();

                            if (connection == null)
                            {
                                throw new SQLException("Error establishing connection!");
                            }

                            // --- Credit Card --- //
                            PreparedStatement preparedStmt = connection.prepareStatement(
                                    "SELECT number FROM CCPayment WHERE email=?");
                            preparedStmt.setString(1, request.getParameter("email"));
                            ResultSet rs = preparedStmt.executeQuery();

                            out.print("<h5>Choose your payment card</h5>");
                            out.print("<select name=\"creditCard\">");
                            while (rs.next())
                            {
                                out.print("<option value=\""
                                        + rs.getString("number")
                                        + "\">"
                                        + rs.getString("number")
                                        + "</option>");
                            }
                            out.print("</select>");
                            
                            // --- Shipping Address --- //
                            preparedStmt = connection.prepareStatement(
                                    "SELECT * FROM ShippingAddress WHERE email=?");
                            preparedStmt.setString(1, request.getParameter("email"));
                            rs = preparedStmt.executeQuery();
                            
                            out.print("<h5>Choose your shipping address</h5>");
                            out.print("<select name=\"shippingAddress\">");
                            while (rs.next())
                            {
                                out.print("<option value=\""
                                        + rs.getString("street") + " " + rs.getString("city") + " " + rs.getString("state") + " " + rs.getString("ZIP")
                                        + "\">"
                                        + rs.getString("street") + " " + rs.getString("city") + " " + rs.getString("state") + " " + rs.getString("ZIP")
                                        + "</option>");
                            }
                            out.print("</select>");

                            out.print("<h6>&nbsp;</h6>");
                            int total = new Integer(request.getParameter("quantity")) * new Integer(request.getParameter("price"));
                            out.print("<input type=\"submit\" name=\"confirmBuyItem\" class=\"btn btn-default\" value=\"Confirm Purchase ($"
                                    + total
                                    + ")\">");
                            out.print("</form>");
                        }

                        if (request.getParameter("confirmBuyItem") != null){
                            InitialContext initialContext = new InitialContext();
                            Context context = (Context) initialContext.lookup("java:comp/env");
                            DataSource ds = (DataSource) context.lookup("himalaya");
                            Connection connection = ds.getConnection();

                            if (connection == null)
                            {
                                throw new SQLException("Error establishing connection!");
                            }

                            // --- Place buy --- //
                            PreparedStatement preparedStmt = connection.prepareStatement(
                                    "INSERT INTO PurchaseHistory VALUES(?, ?, ?, ?, ?, ?, ?)");
                            preparedStmt.setString(1, request.getParameter("email"));
                            preparedStmt.setString(2, request.getParameter("itemID"));
                            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            java.util.Date now = new java.util.Date();
                            String dateTime = format.format(now);
                            preparedStmt.setString(3, dateTime);
                            preparedStmt.setString(4, request.getParameter("quantity"));
                            Integer price = (new Integer(request.getParameter("quantity"))) * new Integer(request.getParameter("price"));
                            preparedStmt.setString(5, price.toString());
                            preparedStmt.setString(6, request.getParameter("creditCard"));
                            preparedStmt.setString(7, request.getParameter("shippingAddress"));
                            preparedStmt.executeUpdate();

                            out.println("<h3 style=\"color:green;display:table;margin:0 auto;\">You have successfully bought the item</h3>");

                            connection.close();
                        }
                    }
                }
                catch (Exception e){
                    out.println("<h1>An error occurred<h1>");
                    out.println("Error: " + e.getMessage());
                }


            %>
        </div>
    
        <script type="text/javascript">
            function validate_confirmBuy(){
                document.bidOnItem.submit();
            }
        </script> 
        
    </body>
</html>
