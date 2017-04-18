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

    <div class="translucentDiv">
      <%
        try{
          if(request.getParameter("submit") != null){
            InitialContext initialContext = new InitialContext();
            Context context = (Context) initialContext.lookup("java:comp/env");
            //The JDBC Data source that we just created
            DataSource ds = (DataSource) context.lookup("himalaya");
            Connection connection = ds.getConnection();

            if (connection == null){
                throw new SQLException("Error establishing connection!");
            }

            Enumeration paramNames = request.getParameterNames();

            String ins = "INSERT INTO Items(itemID, name, description, url, qty, CID)"
            + "VALUES(?, ?, ?, ?, ?, ?)";

            //create the mysql insert PreparedStatement
            PreparedStatement preparedStmt = connection.prepareStatement(ins);
            prepareStatement.setString(1, request.getParameter("itemID"));
            preparedstatement.setString(2, request.getParameter("name"));
            preparedstatement.setString(3, request.getParameter("description"));
            preparedstatement.setString(4, request.getParameter("url"));
            PreparedStatement.setString(5, request.getParameter("qty"));
            PreparedStatement.setString(6, request.getParameter("CID"));

            //execute the preparedstatement
            preparedStmt.execute();

            out.println("<h1>Item successfully added for sale</h1>")
          }
        }

    </div>

    </body>
</html>
