<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Telemarketing Report</title>

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
        <h1 align="center">Telemarketing Report</h1>
        <table align="center" border="1px solid black" width="100%">
            <tr>
                <th>Name</th> 
                <th>Address</th> 
                <th>E-mail</th> <th>Phone</th> 
                <th>Age</th> 
                <th>Gender</th> 
                <th>Annual Income</th> 
                <th># of Bid Activities</th>
            </tr>
            <tr>
                
            </tr>
        </table>
    </div>
        
    </body>
</html>
