<!-- Navigation bar-->
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse1" aria-expanded="false">
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
            <ul class="nav navbar-nav">
                <li class="active"><a href="allitems.jsp">All Items</a></li>
            </ul>
            <%-- Search Bar --%>
            <form class="navbar-form navbar-left" role="search" action="searchResults.jsp">
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
            
            <form class="navbar-form navbar-right" role="form">
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
        </div>
    </div>
</nav>
<!-- Navigation bar end-->