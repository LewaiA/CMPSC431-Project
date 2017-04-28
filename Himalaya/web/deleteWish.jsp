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
            InitialContext initialContext = new InitialContext();
            Context context = (Context) initialContext.lookup("java:comp/env");
            //The JDBC Data source that we just created
            DataSource ds = (DataSource) context.lookup("himalaya");
            Connection connection = ds.getConnection();
                try {
                        // --- Check that user is logged in --- //
                        if (request.getSession().getAttribute("email") == null){
                            out.println("<h3 style=\"color:red;display:table;margin:0 auto;\">You must be logged in to delete an item to a WishList!</h3>");
                        }
                        //otherwise if logged in start the process
                        else{
                            if (connection == null)
                            {
                                throw new SQLException("Error establishing connection!");
                            }

                            String user_name = "";
                            String item_name = "";

                            PreparedStatement info = connection.prepareStatement("SELECT * FROM users WHERE email=?");
                            info.setString(1, (String)request.getSession().getAttribute("email"));
                            ResultSet getNames = info.executeQuery();

                            //get user name first
                            if(getNames.isBeforeFirst()){
                                while(getNames.next()){
                                    user_name = getNames.getString("name");
                                }
                            }
                            //get item name
                            info = connection.prepareStatement("SELECT name FROM Items WHERE itemID=" + request.getParameter("itemID"));
                            getNames = info.executeQuery();
                            if(getNames.isBeforeFirst()){
                                while(getNames.next()){
                                    item_name = getNames.getString("name");
                                }
                            }

                             info = connection.prepareStatement("DELETE FROM wishlist WHERE itemID=? AND email=?");
                            info.setString(1, request.getParameter("itemID"));
                            info.setString(2, (String)request.getSession().getAttribute("email"));
                            info.execute();

                            out.print("<h1 align=\"center\">"+item_name+" has been deleted from "+user_name+"'s Wishlist!</h1>");

                            connection.close();
                        }
                    }
                catch(Exception e){
                    out.println("<h1>An error occurred<h1>");
                    out.println("Error: " + e.getMessage());
                    connection.close();
                }
            %>

        </div>
    </body>
</html>
