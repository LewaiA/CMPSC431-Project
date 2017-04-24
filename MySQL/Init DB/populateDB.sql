# ***NOTE: Change 'C:/Users/nscribano/Desktop/' to your local directory of the GitHub project

LOAD DATA LOCAL INFILE 'C:/Users/Lewai/Documents/CMPSC 431/CMPSC431-Project/MySQL/Init DB/populateData/users.txt' INTO TABLE Users COLUMNS TERMINATED BY ',';
LOAD DATA LOCAL INFILE 'C:/Users/Lewai/Documents/CMPSC 431/CMPSC431-Project/MySQL/Init DB/populateData/ccpayment.txt' INTO TABLE CCPayment COLUMNS TERMINATED BY ',';
LOAD DATA LOCAL INFILE 'C:/Users/Lewai/Documents/CMPSC 431/CMPSC431-Project/MySQL/Init DB/populateData/shippingaddress.txt' INTO TABLE ShippingAddress COLUMNS TERMINATED BY ',';
LOAD DATA LOCAL INFILE 'C:/Users/Lewai/Documents/CMPSC 431/CMPSC431-Project/MySQL/Init DB/populateData/socialaccnt.txt' INTO TABLE SocialAccnt COLUMNS TERMINATED BY ',';
LOAD DATA LOCAL INFILE 'C:/Users/Lewai/Documents/CMPSC 431/CMPSC431-Project/MySQL/Init DB/populateData/categories.txt' INTO TABLE Category COLUMNS TERMINATED BY ',';
#*******Doesn't load anything into items because items dataset not cleaned up yet

