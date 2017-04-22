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
        <title>Treat Yo' Self</title>

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
            <h1 align="center">Treat Yo' Self</h1>
            <%
                try {

                    // --- Submit TYS form --- //
                    if (request.getParameter("submitTYS") != null){
                        InitialContext initialContext = new InitialContext();
                        Context context = (Context) initialContext.lookup("java:comp/env");
                        //The JDBC Data source that we just created
                        DataSource ds = (DataSource) context.lookup("himalaya");
                        Connection connection = ds.getConnection();

                        if (connection == null)
                        {
                            throw new SQLException("Error establishing connection!");
                        }

                        // --- Check that user is enrolled in TYS --- //
                        PreparedStatement preparedStmt = connection.prepareStatement(
                                "INSERT INTO TreatYoSelf (email, budget, CID) VALUES (?,?,?)");
                        preparedStmt.setString(1, request.getSession().getAttribute("email").toString());
                        preparedStmt.setString(2, request.getParameter("budget"));
                        preparedStmt.setString(3, request.getParameter("CID"));
                        
                        preparedStmt.executeUpdate();
                        
                        connection.close();
                    }
                    
                    // --- Unsubscribe from TYS --- //
                    if (request.getParameter("unsubscribeTYS") != null){
                        InitialContext initialContext = new InitialContext();
                        Context context = (Context) initialContext.lookup("java:comp/env");
                        //The JDBC Data source that we just created
                        DataSource ds = (DataSource) context.lookup("himalaya");
                        Connection connection = ds.getConnection();

                        if (connection == null)
                        {
                            throw new SQLException("Error establishing connection!");
                        }

                        // --- Check that user is enrolled in TYS --- //
                        PreparedStatement preparedStmt = connection.prepareStatement(
                                "DELETE FROM TreatYoSelf WHERE email=?");
                        preparedStmt.setString(1, request.getSession().getAttribute("email").toString());
                        
                        preparedStmt.executeUpdate();
                        
                        connection.close();
                    }

                    // --- Check that user's logged in --- //
                    if (request.getSession().getAttribute("email") == null){
                            out.println("<h3 style=\"color:red;display:table;margin:0 auto;\">You must be logged in to use Treat Yo' Self</h3>");
                    }
                    else {
                        InitialContext initialContext = new InitialContext();
                        Context context = (Context) initialContext.lookup("java:comp/env");
                        //The JDBC Data source that we just created
                        DataSource ds = (DataSource) context.lookup("himalaya");
                        Connection connection = ds.getConnection();

                        if (connection == null)
                        {
                            throw new SQLException("Error establishing connection!");
                        }

                        // --- Check that user is enrolled in TYS --- //
                        PreparedStatement preparedStmt = connection.prepareStatement(
                                "SELECT * FROM TreatYoSelf WHERE email=?");
                        preparedStmt.setString(1, request.getSession().getAttribute("email").toString());
                        ResultSet rs = preparedStmt.executeQuery();

                        if (rs.next()){     // user has signed up
                            rs.beforeFirst();
                            %>
                            <h4 style="padding-left:50px;padding-right:50px" align="center">
                                You're signed up to Treat Yo' Self. Click below to unsubscribe.
                            </h4>
                            <form align="center" name="unsubscribeTYS" method="POST" action="treatYoSelf.jsp">
                                <input class="btn btn-danger" type="submit" value="Unsubscribe" name="unsubscribeTYS">
                            </form>
                            <%
                            
                                
                        }
                        else {      // user hasn't signed up
                            %>
                            <h4 style="padding-left:50px;padding-right:50px" align="center">
                                Treat Yo' Self is an opt-in feature of Himalaya.com that buys gifts on your behalf.
                                If opted in, once a month Himalaya.com chooses an item it thinks you'll like,
                                charges your primary credit card for the item, and secretly sends the item to you.</br>
                                <br/>
                                It feels like it's your birthday every month!<br/>
                                <br/>
                                If interested, sign up below...<br/>
                                <br/>
                            </h4>
                            <form name="treatYoSelf" method="POST" action="treatYoSelf.jsp" onsubmit="return validate_TYS();">
                                <table align = "center" border="0">
                                    <tr>
                                        <td>Budget (per month)</td>
                                        <td align="center">
                                            <input required class="form-control" type="range" name="budget" id="budgetInputId" value="50" min="5" max="100" oninput="budgetOutputId.value = budgetInputId.value">
                                            $<output style="display:inline;" name="budgetOutput" id="budgetOutputId">50</output>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Preferred item category</td>
                                        <td>
                                            <select class="form-control" name="CID">
                                                <%
                                                preparedStmt = connection.prepareStatement(
                                                        "SELECT * FROM Category");
                                                rs = preparedStmt.executeQuery();
                                                
                                                while(rs.next()){
                                                    out.println("<option value=\""
                                                            + rs.getString("CID")
                                                            + "\">"
                                                            + rs.getString("CNAME")
                                                            + "</option>"
                                                    );
                                                }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align = "right">
                                            <input class="btn btn-default" type="submit" value="Opt In" name="submitTYS">
                                        </td>
                                    </tr>
                                </table>
                            </form>
                            <%
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
            
        <script type="text/javascript">
            function validate_TYS(){
                document.treatYoSelf.submit();
            }
        </script>
    </body>
</html>
