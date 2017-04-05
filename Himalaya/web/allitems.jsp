<%--
    Document   : allitems
    Created on : Mar 25, 2017, 1:54:59 PM
    Author     : nscribano
--%>

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
        <title>All Items</title>
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/bootstrap-theme.min.css">
        <link rel="stylesheet" href="css/main.css">
        <link rel="stylesheet" href="design.css" >
    </head>
    <body>
      <!-- Navigation bar-->
      <nav class="navbar navbar-inverse navbar-fixed-top">
          <div class="container-fluid">
              <div class="navbar-header">
                  <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse1" aria-expanded="false">
                  <span class="sr-only">Toggle Naviagtion</span> --%>
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
          </div>
      </nav>
      <%-- <a class="btn btn-primary btn default" href="index.jsp">himalaya.com</a> --%>
      <h1>All Items</h1>
        <%
          InitialContext initialContext = new InitialContext();
          Context context = (Context) initialContext.lookup("java:comp/env");
          //The JDBC Data source that we just created
          DataSource ds = (DataSource) context.lookup("himalaya");
          Connection connection = ds.getConnection();

          if (connection == null)
          {
              throw new SQLException("Error establishing connection!");
          }
          String query = "SELECT * FROM Items";

          PreparedStatement statement = connection.prepareStatement(query);
          ResultSet rs = statement.executeQuery();

          while (rs.next())
          {
              out.println(rs.getString("itemID")+" "+rs.getString("name")+"</br>");
          }

          connection.close();
        %>
    </body>
</html>
