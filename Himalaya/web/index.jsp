<%--
    Document   : index
    Created on : Mar 22, 2017, 4:52:26 PM
    Author     : nscribano
--%>
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
        <title>Himalaya.com</title>

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

        <h1 align="center" style="color:white">Welcome to Himalaya.com</h1>
        <br/>
        <br/>

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
                            "SELECT * FROM Items ORDER BY rand() LIMIT 1");
                    ResultSet rs = preparedStmt.executeQuery();
                    if (rs.next()){

                    %>
                    <div align="center">
                        <div style="max-width:500px;" align="center" class="translucentDiv">
                            <h1 align="center">Suggested Item</h1>

                            <table>
                                <td style="padding:5px;">
                                    <tr rowspan="4">
                                        <%
                                            out.println("<img style=\"max-width:60%;\" src=\""
                                            + rs.getString("img_url")
                                            + "\">");
                                        %>
                                    </tr>
                                </td>
                                <td align="left" style="padding:5px;">
                                    <tr>
                                            <%out.println("<h3>Item:&nbsp;" + rs.getString("name") + "</h3>");%>
                                    </tr>
                                    <tr>
                                            <%out.println("Quantity:&nbsp;" + rs.getString("qty") + "&nbsp;");%>
                                    </tr>
                                    <tr>
                                            <%
                                                out.println("<a class=\"btn btn-primary\" href=\"item.jsp?itemID="
                                                        + rs.getString("itemID")
                                                        + "\">View item</a>");
                                            %>
                                    </tr>
                                </td>
                            </table>
                        </div>
                    </div>
                    <%

                    }

                    connection.close();
                }
                catch(Exception e){
                    out.println("<h1>An error occurred<h1>");
                    out.println("Error: " + e.getMessage());
                }
                %>
                <br/>
    </body>
</html>
