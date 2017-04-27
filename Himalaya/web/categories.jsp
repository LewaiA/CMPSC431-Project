<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
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


            <%
                try {
                    // --- Get item info --- //
                    if (request.getParameter("CID") != " "){
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
                                "SELECT * FROM category WHERE PCID=?");
                        preparedStmt.setString(1, request.getParameter("CID"));
                        ResultSet rs = preparedStmt.executeQuery();

                        while(rs.next()) {
                            out.println("<a href=\"categories.jsp?CID="+rs.getString("CID")+"\">"
                            + "<button type=\"button\" class=\"btn btn-primary\">"+ rs.getString("CNAME") + "</button></a>");
                        }


                        connection.close();
                    }
                }
                catch (Exception e){
                        out.println("<h1>An error occurred<h1>");
                        out.println("Error: " + e.getMessage());
                }
            %>

        <div class="translucentDiv">
            <%
            try{
            // --- Get item info --- //
                if (request.getParameter("CID") != null){
                    InitialContext initialContext = new InitialContext();
                    Context context = (Context) initialContext.lookup("java:comp/env");
                    //The JDBC Data source that we just created
                    DataSource ds = (DataSource) context.lookup("himalaya");
                    Connection connection = ds.getConnection();

                    if (connection == null)
                    {
                        throw new SQLException("Error establishing connection!");
                    }
                    //title the search results
                    PreparedStatement title = connection.prepareStatement("SELECT CNAME FROM category WHERE CID=?");
                    title.setString(1, request.getParameter("CID"));
                    ResultSet titlepg = title.executeQuery();
                    //better way of checking if there is any results returned from query without skipping any
                    if(titlepg.isBeforeFirst()){
                        while(titlepg.next()){
                            out.println("<h1 align = \"center\">" + titlepg.getString("CNAME") +"</h1>");
                        }
                    }
                    // --- Get item information --- //
                    String sql = "";
                    List<String> statements = new ArrayList<String>();
                    //find all child categories
                    PreparedStatement childCID = connection.prepareStatement("SELECT CID FROM category WHERE PCID=?");
                    childCID.setString(1, request.getParameter("CID"));
                    ResultSet child = childCID.executeQuery();
                    if(child.isBeforeFirst()){
                        while(child.next()){
                            statements.add("SELECT * FROM items WHERE CID="+ child.getString("CID"));
                        }
                    }
                    //create SQL statement
                    for(int i=0; i<statements.size(); i++){
                        sql+= statements.get(i)+" UNION ";
                    }
                    //combine all sql statements to get one major sql statement
                    sql+= "SELECT * FROM items WHERE CID="+ request.getParameter("CID");

                    PreparedStatement preparedStmt = connection.prepareStatement(sql);

                    ResultSet rs = preparedStmt.executeQuery();

                    if(!rs.isBeforeFirst()){
                        out.print("<h2>No Items are currently for sale in this category please come back later</h2>");
                    }
                    else{
                        while(rs.next()){
                            out.print("<a href=\"item.jsp?itemID="+ rs.getString("itemID") +"\">");
                            out.print(rs.getString("itemID")+" "+rs.getString("name")+"</br>");
                            out.println("</a>");
                        }

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
