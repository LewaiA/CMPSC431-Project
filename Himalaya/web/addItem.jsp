<%@page import="javax.naming.Context"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<!DOCTYPE html>
<!--
      Document   : additem.html
      Created on : Apr 6, 2017, 10:10:10 PM
      Author     : lew-ayyy
-->

<html>
    <head>
        <title>Add an Item to sell</title>
        <meta charset="UTF-8" >
        <meta name="viewport" content="width=device-width, initial-scale=1.0" >
        <script src="https://code.jquery.com/jquery-2.1.3.min.js"></script>
        <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" href="css/bootstrap-theme.min.css">
        <link rel="stylesheet" href="css/main.css">
    </head>
    <body>
         <!-- Load navigation bar  -->
         <div id="navbar"></div>
         <script>
             $.get("navbar.jsp", function(data){
                 $("#navbar").replaceWith(data);
             });
         </script>
         <!--  End load navigation bar -->

        <div class="translucentDiv">
          <h1 align="center">Add an Item to sell</h1>
          <form name="addItem" method="POST" action="prepareAddItem.jsp" onsubmit="return validate_form();">
            <table align="center" border="0" width="300">
              <tr>
                  <td>Item Name</td>
                  <td><input required type="text" name="name"></td>
              </tr>
              <tr>
                  <td>&nbsp;</td>
              </tr>
              <tr>
                  <td>Item Description</td>
                  <td><textarea required rows="4" columns="8" name="description"></textarea></td>
              </tr>
              <tr>
                  <td>&nbsp;</td>
              </tr>
              <tr>
                <td>Your website</td>
                <td>
                  <input required type="url" name="seller_url"></td>
              </tr>
              <tr>
                  <td>image URL</td>
                  <td><input required type="url" name="img_url"></td>
              </tr>
              <tr>
                  <td>Quantity available</td>
                  <td><input required type="number" name="qty"></td>
              </tr>
              <tr>
                <td>Category</td>
                <td>
                <select name="cid">
                    <%
                    InitialContext initialContext = new InitialContext();
                    Context context = (Context) initialContext.lookup("java:comp/env");
                    //The JDBC Data source that we just created
                    DataSource ds = (DataSource) context.lookup("himalaya");
                    Connection connection = ds.getConnection();
                    PreparedStatement preparedStmt = connection.prepareStatement("SELECT * FROM Category");
                    ResultSet rs = preparedStmt.executeQuery();
                    while(rs.next()){
                        out.println("<option value=\""+ rs.getString("CID") + "\">" + rs.getString("CNAME") + "</option>");
                    }
                    connection.close();
                    %>
                </select>
                </td>
              </tr>
              <tr>
                  <td>&nbsp;</td>
              </tr>
              <tr>
                  <td><input type="checkbox" name="dsale" onclick="dsalechck()"/> Direct Sale</td>

              </tr>
              <script>
              function dsalechck(){
                    if(document.getElementsByName("dsale")[0].checked == true){
                        document.getElementsByName("price")[0].disabled=false;
                    }
                    else{
                        document.getElementsByName("price")[0].disabled=true;
                    }
               }
               function bsalechck(){
                   if(document.getElementsByName("bsale")[0].checked == true){
                        document.getElementsByName("min_bid")[0].disabled=false;
                        document.getElementsByName("end_date")[0].disabled=false;
                    }
                    else{
                        document.getElementsByName("min_bid")[0].disabled=true;
                        document.getElementsByName("end_date")[0].disabled=true;
                    }
                }
              </script>
              <tr>
                  <td>Direct Sale Price</td>
                  <td><input required type="number" name="price" disabled></td>
              </tr>
              <tr>
                  <td>&nbsp;</td>
              </tr>
              <tr>
                      <td><input type="checkbox" name="bsale" onclick="bsalechck()"/> Bid</td>
              </tr>
              <tr>
                  <td>Bid Start Price</td>
                  <td><input required type="number" name="min_bid" disabled></td>
              </tr>
              <tr>
                  <td>End bid date</td>
                  <td><input required type="date" id="end_date" name="end_date" disabled></td>
              </tr>

              <tr>
                  <td></td>
                <td align = "right">
                  <input class = "btn btn-default" type="submit" value= "Add Item to Sell" name="submit">
                </td>
              </tr>
              <!-- Add description section, price, purchase method, shipping methods-->
            </table>
          </form>
        </div>
        <script type="text/javascript">
            function validate_form(){
                if (document.addItem.name.value.length > 100){
                    alert("Item Name is Limited to 100 Characters");
                    return false;
                }
                else if(document.addItem.qty.value <= 0){
                    alert("Item Quantity cannot be 0 or less");
                    return false;
                }
                else if(document.addItem.cid.options[document.addItem.cid.selectedIndex].value == 0){
                    alert("Please select a category");
                    return false;
                }
                else if(document.addItem.dsale.checked == false && document.addItem.bsale.checked == false){
                    alert("Please select either the Direct or Bidding sale methods");
                    return false;
                }
                else if(document.addItem.price.disabled == false && document.addItem.price.value <= 0){
                    alert("Item Price must be for more then 0");
                    return false;
                }
                else if(document.addItem.min_bid.disabled == false && document.addItem.min_bid.value <= 0){
                    alert("Item minimum bid cannot be a price of 0 or less");
                    return false;
                }
                else{
                    document.addItem.submit();
                }
            }

        </script>

    </body>
</html>
