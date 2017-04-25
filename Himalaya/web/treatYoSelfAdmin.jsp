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
        <title>Execute Treat Yo' Self</title>

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
            <h1 align="center">Execute Treat Yo' Self</h1>
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
                            "SELECT * FROM TreatYoSelf T, Category C WHERE T.CID=C.CID");
                    ResultSet rs = preparedStmt.executeQuery();

                    %>
                    <table class="sortable table" align="center" border="0">
                        <tr style="font-weight:bold">
                            <td>Email</td>
                            <td>Budget</td>
                            <td>Category Preference</td>
                            <td>Chosen Item ID</td>
                            <td>Chosen Item Name</td>
                            <td>Price</td>
                        </tr>
                    <%
                    while (rs.next())
                    {
                        out.print("<tr>");

                        out.print("<td>"
                            + rs.getString("email")
                            + "</td>");
                        
                        out.print("<td>$"
                            + rs.getString("budget")
                            + "</td>");
                        
                        out.print("<td>"
                            + rs.getString("CNAME")
                            + "</td>");
                        
                        out.print(chooseItem(Integer.valueOf(rs.getString("CID")), 
                                Integer.valueOf(rs.getString("budget")), rs.getString("email")));

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

<%!
    public String chooseItem(Integer CID, Integer budget, String email) throws Exception
    {
        Connection connection = null;
        try {
            InitialContext initialContext = new InitialContext();
            Context context = (Context) initialContext.lookup("java:comp/env");
            //The JDBC Data source that we just created
            DataSource ds = (DataSource) context.lookup("himalaya");
            connection = ds.getConnection();

            if (connection == null)
            {
                throw new SQLException("Error establishing connection!");
            }

            String output = "";
            String chosenItemID = "-";
            String chosenItemName = "No item found in budget";
            String chosenItemPrice = " -";
            
            PreparedStatement preparedStmt = connection.prepareStatement(
                    " SELECT * FROM Items I, DsaleMethod D WHERE I.itemID=D.itemID AND D.price<=? AND I.itemID NOT IN "
                    + "(SELECT P.itemID FROM PurchaseHistory P WHERE P.email=?);");
            preparedStmt.setInt(1, budget);
            preparedStmt.setString(2, email);
            ResultSet rs = preparedStmt.executeQuery();

            if(rs.next()){
                chosenItemID = rs.getString("itemID");
                chosenItemName = rs.getString("name");
                chosenItemPrice = rs.getString("price");

                // --- Place buy --- //
                preparedStmt = connection.prepareStatement(
                        "INSERT INTO PurchaseHistory VALUES(?, ?, ?, ?, ?, ?, ?)");
                preparedStmt.setString(1, email);
                preparedStmt.setString(2, rs.getString("itemID"));
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                java.util.Date now = new java.util.Date();
                String dateTime = format.format(now);
                preparedStmt.setString(3, dateTime);
                preparedStmt.setInt(4, 1);
                preparedStmt.setString(5, rs.getString("price"));

                PreparedStatement cardAndAddr = connection.prepareStatement(
                            "SELECT * FROM CCPayment C, ShippingAddress S WHERE C.email=? AND C.email=S.email");
                cardAndAddr.setString(1, email);
                ResultSet cardAndAddrRs = cardAndAddr.executeQuery();
                if (cardAndAddrRs.next()){
                    preparedStmt.setString(6, cardAndAddrRs.getString("number"));
                    preparedStmt.setString(7, cardAndAddrRs.getString("street") + " " + cardAndAddrRs.getString("city") 
                            + " " + cardAndAddrRs.getString("state") + " " + cardAndAddrRs.getString("ZIP"));
                }

                preparedStmt.executeUpdate();
                
            } 
            
            output += "<td>" + chosenItemID + "</td>";
            output += "<td>" + chosenItemName + "</td>";
            output += "<td>$" + chosenItemPrice + "</td>";

            connection.close();
            return output;
        }
        catch(Exception e){

            if (connection != null)
                connection.close();

            return e.toString();
        }
    }
%>
