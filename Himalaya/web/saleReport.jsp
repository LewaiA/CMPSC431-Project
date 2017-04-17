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
        <title>Sale Report</title>

        <script src="https://www.kryogenix.org/code/browser/sorttable/sorttable.js"></script>
        <script src="https://code.jquery.com/jquery-2.1.3.min.js"></script>
        <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" href="css/bootstrap-theme.min.css">
        <link rel="stylesheet" href="css/main.css">
        
        <style type="text/css">
            td
            {
                padding:0 15px 0 15px;
            }
        </style>
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
            <h1 align="center">Today's Current Transactions</h1>
            
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
                            "SELECT * FROM PurchaseHistory WHERE date >= ? AND date <= ?");
                    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                    java.util.Date now = new java.util.Date();
                    String dateBegin = format.format(now) + " 00:00:00";
                    String dateEnd = format.format(now) + " 23:59:59";
                    preparedStmt.setString(1, dateBegin);
                    preparedStmt.setString(2, dateEnd);
                    ResultSet rs = preparedStmt.executeQuery();

                    %>
                    <table class="sortable table" align="center" border="0">
                        <tr style="font-weight:bold">
                            <td>Email</td>
                            <td>itemId</td>
                            <td>Timestamp</td>
                            <td>Quantity</td>
                            <td>Price Paid</td>
                        </tr>
                    <%
                    
                    while (rs.next())
                    {
                        out.print("<tr>");
                        
                            out.print("<td>" + rs.getString("email") + "</td>");
                            out.print("<td>" + rs.getString("itemId") + "</td>");
                            out.print("<td>" + rs.getString("date") + "</td>");
                            out.print("<td>" + rs.getString("quantity") + "</td>");
                            out.print("<td>$" + rs.getString("pricePaid") + "</td>");
                        
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
