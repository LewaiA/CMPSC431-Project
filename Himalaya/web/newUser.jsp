<%-- 
    Document   : newUser.jsp
    Created on : Apr 3, 2017, 10:39:14 PM
    Author     : nscribano
--%>

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
    </head>
    <body>
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

        String ins = "INSERT INTO Users (email, password, name, gender, phone, age, income)"
        + " VALUES(?, ?, ?, ?, ?, ?, ?)";

        // create the mysql insert preparedstatement
        PreparedStatement preparedStmt = connection.prepareStatement(ins);
        preparedStmt.setString (1, request.getParameter("email"));
        preparedStmt.setString (2, request.getParameter("password"));
        preparedStmt.setString (3, request.getParameter("name"));
        preparedStmt.setString (4, request.getParameter("gender"));
        preparedStmt.setString (5, request.getParameter("phone"));
        preparedStmt.setInt (6, 0);
        preparedStmt.setInt (7, Integer.parseInt(request.getParameter("income")));


        // execute the preparedstatement
        preparedStmt.execute();

        connection.close();
    }
%>    
