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

                    // create the mysql insert preparedstatement
                    PreparedStatement preparedStmt = connection.prepareStatement(""
                            + "SELECT * FROM Items WHERE itemID=?");
                    preparedStmt.setString(1, request.getParameter("itemID"));

                    // execute the preparedstatement
                    ResultSet rs = preparedStmt.executeQuery();                        
                    if(rs.next()) {       
                        out.print("<h1>");
                        out.print(rs.getString("name"));
                        out.print("</h1>");
                        
                        out.print("<h3>");
                        out.print(rs.getString("description"));
                        out.print("</h3>");
                        
                    }
                    else {
                       out.println("<h1>An error occurred</h1>");
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
        
    </body>
</html>
