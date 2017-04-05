<%--
    Document   : newUser.jsp
    Created on : Apr 3, 2017, 10:39:14 PM
    Author     : nscribano
--%>

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
        <title>Registration Successful</title>
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/bootstrap-theme.min.css">
        <link rel="stylesheet" href="css/main.css">
        <link rel="stylesheet" href="css/design.css" >
    </head>
    <body>
        <nav class="navbar navbar-inverse navbar-fixed-top">
            <div class="container-fluid">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse1" aria-expanded="false">
                    <span class="sr-only">Toggle Naviagtion</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="index.jsp">Himalaya.com</a>
                </div>

                <ul class="nav navbar-nav">
                    <li class="active"><a href="allitems.jsp">All Items</a></li>
                </ul>
                <%-- Search Bar --%>
                <form class="navbar-form navbar-left" role="search">
                    <div class="form-group">
                       <div class="input-group">
                            <input type="text" class="form-control" placeholder="Search for...">
                            <span class="input-group-btn">
                                <button class="btn btn-green" type="button">Go!</button>
                            </span>
                       </div><!-- /input-group -->
                    </div><!-- /.col-lg-6 -->
                </form><!-- /.row -->
                <%-- Search Bar end --%>

                <ul class= "nav navbar-nav navbar-right">
                    <li><a href="newUser.html">Register</a></li>
                </ul>
            </div>
        </nav>
        <h1>Registration Successful</h1>
        <a href="index.jsp">Return to Home Page</a>
    </body>
</html>

<%
    if (request.getParameter("submit") != null) {
        InitialContext initialContext = new InitialContext();
        Context context = (Context) initialContext.lookup("java:comp/env");
        //The JDBC Data source that we just created
        DataSource ds = (DataSource) context.lookup("himalaya");
        Connection connection = ds.getConnection();

        if (connection == null)
        {
            throw new SQLException("Error establishing connection!");
        }

        Enumeration paramNames = request.getParameterNames();

//            while(paramNames.hasMoreElements()) {
//               String paramName = (String)paramNames.nextElement();
//               out.print("<tr><td>" + paramName + "</td>\n");
//               String paramValue = request.getParameter(paramName);
//               out.println("<td> " + paramValue + "</td></tr>\n");
//            }

        String ins = "INSERT INTO Users (email, password, name, gender, phone, dob, reward_progress, income)"
        + " VALUES(?, ?, ?, ?, ?, ?, ?, ?)";

        // create the mysql insert preparedstatement
        PreparedStatement preparedStmt = connection.prepareStatement(ins);
        preparedStmt.setString(1, request.getParameter("email"));
        preparedStmt.setString(2, request.getParameter("password"));
        preparedStmt.setString(3, request.getParameter("name"));
        preparedStmt.setString(4, request.getParameter("gender"));
        preparedStmt.setString(5, request.getParameter("phone"));
        
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date dob = format.parse(request.getParameter("dob"));
        //java.sql.Date sqlDob = new java.sql.Date(dob.getTime());
        preparedStmt.setDate(6, new java.sql.Date(dob.getTime()));
        
        preparedStmt.setInt(7, 0);
        preparedStmt.setInt(8, Integer.parseInt(request.getParameter("income")));


        // execute the preparedstatement
        preparedStmt.execute();

        connection.close();
    }
%>
