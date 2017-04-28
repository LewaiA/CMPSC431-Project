<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import = "java.sql.DriverManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Account</title>

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
            <a href="treatYoSelf.jsp" class="btn btn-success">Treat Yo' Self Settings</a>
            <a href="wishList.jsp" class="btn btn-success">Your Wishlist</a>
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
                    PreparedStatement preparedStmt = connection.prepareStatement("UPDATE Users SET "
                            + "email=?, password=?, name=?, gender=?, phone=?, dob=?, reward_progress=?, income=?"
                            + " WHERE email=?");
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
                    preparedStmt.setString(9, request.getParameter("email"));

                    preparedStmt.execute();             // execute the preparedstatement

                    // --- Insert data into ShippingAddress --- //
                    preparedStmt = connection.prepareStatement("UPDATE ShippingAddress SET "
                            + "email=?, ZIP=?, street=?, city=?, state=? "
                            + "WHERE email=?");
                    preparedStmt.setString(1, request.getParameter("email"));
                    preparedStmt.setString(2, request.getParameter("ZIP"));
                    preparedStmt.setString(3, request.getParameter("street"));
                    preparedStmt.setString(4, request.getParameter("city"));
                    preparedStmt.setString(5, request.getParameter("state"));
                    preparedStmt.setString(6, request.getParameter("email"));
                    preparedStmt.execute();             // execute the preparedstatement

                    // --- Insert data into CCPayment --- //
                    preparedStmt = connection.prepareStatement("UPDATE CCPayment SET "
                            + "email=?, number=?, type=?, expiration=? "
                            + "WHERE email=?");
                    preparedStmt.setString(1, request.getParameter("email"));
                    preparedStmt.setString(2, request.getParameter("ccNumber"));
                    preparedStmt.setString(3, request.getParameter("ccType"));
                    format = new SimpleDateFormat("yyyy-MM");
                    java.util.Date ccExp = format.parse(request.getParameter("ccExpiration"));
                    preparedStmt.setDate(4, new java.sql.Date(ccExp.getTime()));
                    preparedStmt.setString(5, request.getParameter("email"));
                    preparedStmt.execute();             // execute the preparedstatement

                    out.println("<h3 style=\"color:green;display:table;margin:0 auto;\">You info has been successfully updated</h3>");

                    connection.close();
                }

                // --- Check that user is logged in --- //
                if (request.getSession().getAttribute("email") == null){
                    out.println("<h3 style=\"color:red;display:table;margin:0 auto;\">You must be logged in view account info</h3>");
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

                    PreparedStatement preparedStmt = connection.prepareStatement(
                            "SELECT * FROM Users U, CCPayment C, ShippingAddress S WHERE U.email=? AND "
                                    + "U.email=C.email AND C.email=S.email");
                    preparedStmt.setString(1, request.getSession().getAttribute("email").toString());
                    ResultSet rs = preparedStmt.executeQuery();

                    rs.next();
                %>

        <h1 align="center">Update your information here</h1>
        <form name="updateUser" method="POST" action="manageAccount.jsp" onsubmit="return validate_form();">
                <table align = "center" border="0">
                    <tr>
                        <td>Name</td>
                        <td>
                            <%out.println("<input required class=\"form-control\" type=\"text\" name=\"name\" value=\""
                                + rs.getString("name")
                                + "\">");%>
                        </td>
                    </tr>
                    <tr>
                        <td>Email</td>
                        <td>
                            <%out.println("<input disabled class=\"form-control\" type=\"email\" name=\"dummyEmail\" value=\""
                                + rs.getString("email")
                                + "\">");%>
                            <%out.println("<input class=\"form-control\" type=\"hidden\" name=\"email\" value=\""
                                + rs.getString("email")
                                + "\">");%>
                        </td>
                    </tr>
                    <tr>
                        <td>Password</td>
                        <td>
                            <%out.println("<input required class=\"form-control\" type=\"password\" name=\"password\" value=\""
                                    + rs.getString("password")
                                    + "\">");%>
                        </td>
                    </tr>
                    <tr>
                        <td>Confirm password</td>
                        <td>
                            <%out.println("<input required class=\"form-control\" type=\"password\" name=\"confirmPassword\" value=\""
                                    + rs.getString("password")
                                    + "\">");%>
                        </td>
                    </tr>
                    <tr>
                        <td>Gender</td>
                        <td>
                            <select class="form-control" name="gender">
                                <%
                                if (rs.getString("gender").equals("M")){
                                    out.println("<option selected value=\"M\">Male</option><option value=\"F\">Female</option>");
                                }
                                else {
                                    out.println("<option value=\"M\">Male</option><option selected value=\"F\">Female</option>");
                                }
                                %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>Phone number</td>
                        <td>
                            <%out.println("<input required class=\"form-control\" type=\"tel\" name=\"phone\" value=\""
                                    + rs.getString("phone")
                                    + "\">");
                            %>
                        </td>
                    </tr>
                    <tr>
                        <td>Birth date</td>
                        <td>
                            <%out.println("<input required class=\"form-control\" type=\"date\" name=\"dob\" value=\""
                                    + rs.getString("dob")
                                    + "\">");%>
                        </td>
                    </tr>
                    <tr>
                        <td>Income ($)</td>
                        <td><%out.println("<input required class=\"form-control\" type=\"number\" name=\"income\" value=\""
                                + rs.getString("income")
                                + "\">");%>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>Address</td>
                        <td><%out.println("<input required class=\"form-control\" placeholder=\"Street\" type=\"text\" name=\"street\" value=\""
                                + rs.getString("street")
                                + "\">");%>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><%out.println("<input required class=\"form-control\" placeholder=\"City\" type=\"text\" name=\"city\" value=\""
                                + rs.getString("city")
                                + "\">");%>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><%out.println("<input required class=\"form-control\" placeholder=\"State\" type=\"text\" name=\"state\" value=\""
                                + rs.getString("state")
                                + "\">");%>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><%out.println("<input required class=\"form-control\" placeholder=\"ZIP\" type=\"text\" name=\"ZIP\" value=\""
                                + rs.getString("ZIP")
                                + "\">");%></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>Credit card</td>
                        <td><%out.println("<input required class=\"form-control\" placeholder=\"Number\" type=\"text\" name=\"ccNumber\" value=\""
                                + rs.getString("number")
                                + "\">");%>
                        </td>
                    </tr>
                    <tr>
                        <td>Type</td>
                        <td><%out.println("<input required class=\"form-control\" placeholder=\"Ex. Visa\" type=\"text\" name=\"ccType\" value=\""
                                + rs.getString("type")
                                + "\">");%>
                        </td>
                    </tr>
                    <tr>
                        <td>Expiration date</td>
                        <td><%out.println("<input required class=\"form-control\" type=\"date\" name=\"ccExpiration\" value=\""
                                    + rs.getString("expiration")
                                    + "\">");%>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td></td>
                        <td align = "right">
                            <input class="btn btn-default" type="submit" value="Update information" name="submit">
                        </td>
                    </tr>
                </table>
            </form>
        </div>

        <%

                    connection.close();
                }
            }
            catch (Exception e){
                out.println("<h1>An error occurred<h1>");
                out.println("Error: " + e.getMessage());
            }
        %>
        %>
        <script type="text/javascript">
            function validate_form(){
                if (document.updateUser.name.value.length > 20){
                    alert("Name is limited to 20 characters");
                    return false;
                }
                else if (document.updateUser.email.value.length > 100){
                    alert("Email is limited to 100 characters");
                    return false;
                }
                else if (document.updateUser.password.value.length > 30){
                    alert("Password is limited to 30 characters");
                    return false;
                }
                else if (document.updateUser.phone.value.length > 15){
                    alert("Phone number is limited to 15 characters");
                    return false;
                }
                else if (document.updateUser.dob.value.length > 10){
                    alert("Date of birth is invalid");
                    return false;
                }
                else if (document.updateUser.income.value.length > 10){
                    alert("Income is limited to 10 digits");
                    return false;
                }
                else if (!(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/).test(document.updateUser.email.value)) {
                    alert("Please enter a valid email address");
                    return false;
                }
                else if (document.updateUser.password.value.length < 6){
                    alert("Password must be at least 6 characters long");
                    return false;
                }
                else if (document.updateUser.password.value !== document.updateUser.confirmPassword.value){
                    alert("The passwords do not match");
                    return false;
                }
                else if (document.updateUser.gender.value !== "M" && document.updateUser.gender.value !== "F"){
                    alert("Please enter either 'M' or 'F' for gender");
                }
                else if (document.updateUser.street.value.length > 50){
                    alert("Street address is limited to 50 characters");
                    return false;
                }
                else if (document.updateUser.city.value.length > 50){
                    alert("City is limited to 50 characters");
                    return false;
                }
                else if (document.updateUser.state.value.length > 2){
                    alert("State is limited to 2 characters");
                    return false;
                }
                else if (document.updateUser.ZIP.value.length > 5){
                    alert("ZIP code is limited to 5 characters");
                    return false;
                }
                else if (document.updateUser.ccNumber.value.length > 19){
                    alert("Credit card number is limited to 19 characters");
                    return false;
                }
                else if (document.updateUser.ccType.value.length > 20){
                    alert("Credit card type is limited to 20 characters");
                    return false;
                }
                else if (document.updateUser.ccExpiration.value.length > 10){
                    alert("Credit card expiration date is invalid");
                    return false;
                }
                else {
                    document.updateUser.submit();
                }

            }
        </script>
    </body>
</html>
