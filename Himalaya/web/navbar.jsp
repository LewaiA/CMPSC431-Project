<%@page import="javax.naming.Context"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<!-- Navigation bar-->
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar">
            <span class="sr-only">Toggle Navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            </button>
            <!--<a class="navbar-brand" href="index.jsp">Himalaya.com</a>-->
            <a href="index.jsp">
                <img id="logo" src="img/logo.png" style="width:125px;padding-right:10px;"/>
            </a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
            <ul class="nav navbar-nav navbar-left">
                <li class=""><a href="allitems.jsp">All Items</a></li>
                <li class=""><a href="addItem.jsp">Sell</a></li>

                  <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Browse Categories<span class="caret"></span></a>
                    <ul class="dropdown-menu">
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

                          PreparedStatement preparedStmt = connection.prepareStatement("SELECT * FROM category WHERE pcid=0");
                          ResultSet rs = preparedStmt.executeQuery();
                          while(rs.next()){
                              out.println("<li>" + "<a href=\"categories.jsp?CID="+rs.getString("CID")+"\"> "  + rs.getString("CNAME") + "</a></li>");
                          }

                          connection.close();
                      %>
                    </ul>
                  </li>
                  <li>
            </ul>
            <%-- Search Bar --%>
            <ul class="nav navbar-nav navbar-left hidden-xs collapse navbar-collapse" id="removeOnCollapse">
                <form class="navbar-form" role="search" method="POST" action="searchResults.jsp">
                    <div class="input-group">
                        <input type="text" class="form-control" name="search" placeholder="Search for Items...">
                        <div class="input-group-btn">
                            <button class="btn btn-default" type="submit">
                                <i class="glyphicon glyphicon-search"></i>
                            </button>
                        </div>
                    </div>
                <%-- Search Bar end --%>
                <%-- <form class="navbar-form navbar-left" role="price_search" method="POST" action="searchResults.jsp"> --%>
                  <label class="sr-only" for="exampleInputAmount">Amount (in dollars)</label>
                    <div class="input-group col-xs-1">
                      <input type="text" class="form-control" name="minimum_price" placeholder="Min $">
                    </div>
                    <div class="input-group col-xs-1">
                        <input type="text" class="form-control" name="maximum_price" placeholder="Max $" >
                    </div>
                  <button type="submit" class="btn btn-primary">Find Price Range</button>
                </form>
            </ul>

            <ul class= "nav navbar-nav navbar-right">
            <form class="navbar-form" role="form">
                <%
                    if(request.getSession().getAttribute("email") != null){
                        out.println("<span style=\"color:white;\">Hello, " +
                            request.getSession().getAttribute("name") +
                            "</span>"); %>
                        <a class="btn btn-default glyphicon glyphicon-cog" href="manageAccount.jsp"></a>
                        <a class="btn btn-default" href="logout.jsp">Log Out</a>
                    <% }
                    else { %>
                        <a class="btn btn-success" href="login.html">Sign In</a>
                        <a class="btn btn-default" href="newUser.html">Register</a>
                    <% }
                %>
            </form>
            </ul>
        </div>
    </div>
</nav>
<!-- Navigation bar end-->
