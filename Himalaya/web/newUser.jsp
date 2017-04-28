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
<%@page import="java.io.*,java.util.*,javax.mail.*"%>
<%@page import="javax.mail.internet.*,javax.activation.*"%>
<%@page import="javax.servlet.http.*,javax.servlet.*" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registration Successful</title>
        
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
        <div align="center" class="translucentDiv">
            <%
                try{
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

                        // --- Insert data into Users --- //
                        PreparedStatement preparedStmt = connection.prepareStatement("INSERT INTO Users (email, password, name, gender, phone, dob, reward_progress, income)"
                        + " VALUES(?, ?, ?, ?, ?, ?, ?, ?)");
                        preparedStmt.setString(1, request.getParameter("email"));
                        preparedStmt.setString(2, request.getParameter("password"));
                        preparedStmt.setString(3, request.getParameter("name"));
                        preparedStmt.setString(4, request.getParameter("gender"));
                        preparedStmt.setString(5, request.getParameter("phone"));

                        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                        java.util.Date dob = format.parse(request.getParameter("dob"));
                        preparedStmt.setDate(6, new java.sql.Date(dob.getTime()));

                        preparedStmt.setInt(7, 0);
                        preparedStmt.setInt(8, Integer.parseInt(request.getParameter("income")));

                        preparedStmt.execute();             // execute the preparedstatement
                        
                        // --- Insert data into ShippingAddress --- //
                        preparedStmt = connection.prepareStatement("INSERT INTO ShippingAddress (email, ZIP, street, city, state)"
                        + " VALUES(?, ?, ?, ?, ?)");
                        preparedStmt.setString(1, request.getParameter("email"));
                        preparedStmt.setString(2, request.getParameter("ZIP"));
                        preparedStmt.setString(3, request.getParameter("street"));
                        preparedStmt.setString(4, request.getParameter("city"));
                        preparedStmt.setString(5, request.getParameter("state"));
                        preparedStmt.execute();             // execute the preparedstatement
                        
                        // --- Insert data into CCPayment --- //
                        preparedStmt = connection.prepareStatement("INSERT INTO CCPayment (email, number, type, expiration)"
                        + " VALUES(?, ?, ?, ?)");
                        preparedStmt.setString(1, request.getParameter("email"));
                        preparedStmt.setString(2, request.getParameter("ccNumber"));
                        preparedStmt.setString(3, request.getParameter("ccType"));
                        format = new SimpleDateFormat("yyyy-MM");
                        java.util.Date ccExp = format.parse(request.getParameter("ccExpiration"));
                        preparedStmt.setDate(4, new java.sql.Date(ccExp.getTime()));
                        preparedStmt.execute();             // execute the preparedstatement

                        out.println("<h1>Registration Successful</h1>");
                      
//                        try{
//                            // Send email to user
//                            String to = request.getParameter("email");
//                            String from = "noreply@himalaya.com";
//                            String host = "localhost";
//                            Properties properties = System.getProperties();
//                            properties.setProperty("mail.smtp.host", host);
//                            Session mailSession = Session.getDefaultInstance(properties);
//
//                            MimeMessage message = new MimeMessage(mailSession);
//                            message.setFrom(new InternetAddress(from));
//                            message.addRecipient(Message.RecipientType.TO,
//                                                     new InternetAddress(to));
//                            message.setSubject("This is the Subject Line!");
//                            message.setText("This is actual message");
//                            Transport.send(message);
//                        }catch (MessagingException mex) {
//                            mex.printStackTrace();
//                        }
                        
                        
                        connection.close();
                    }
                }
                catch (Exception e){
                    out.println("<h1>Registration Unsuccessful! Please try again.</h1>");
                    out.println("<h1>Error: " + e.getMessage() +"</h1>");
                }
            %>
            <a class="btn btn-default" href="index.jsp">Return to Home Page</a>
        </div>
    </body>
</html>


