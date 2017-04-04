<%-- 
    Document   : newUser
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
    <title>Create your Himalaya.com Account</title>
</head>
<body>
    <h1>Create your Himalaya.com Account</h1>
    
    <form method="POST" action="newUser.jsp">
    <table align = "center" border="0" width="300">
     
    <tr>
        <td>Name</td>
        <td><input type="text" name="name" size="20"></td>
    </tr>    
    <tr>
        <td>Email</td>
        <td><input type="text" name="email" size="20"></td>
    </tr>
    <tr>
        <td>Password</td>
        <td><input type="password" name="password" size="20"></td>
    </tr>
    <tr>
        <td>Confirm Password</td>
        <td><input type="password" name="confirmPassword" size="20"></td>
    </tr>
    <tr>
        <td>Gender</td>
        <td><input type="text" name="gender" size="1"></td>
    </tr>
    <tr>
        <td>Phone number</td>
        <td><input type="text" name="phone" size="15"></td>
    </tr>
    <tr>
        <td>Birth Date</td>
        <td><input type="date" name="dob" size="20"></td>
    </tr>
    <tr>
        <td>Income</td>
        <td><input type="number" name="income" size="20"></td>
    </tr>
    <tr>
        <td align = "center">
            <input type="submit" value="Register" name="submit">
        </td>
    </tr>
    </table>
    </form>
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

            while(paramNames.hasMoreElements()) {
               String paramName = (String)paramNames.nextElement();
               out.print("<tr><td>" + paramName + "</td>\n");
               String paramValue = request.getParameter(paramName);
               out.println("<td> " + paramValue + "</td></tr>\n");
            }

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


    </body>
</html>
