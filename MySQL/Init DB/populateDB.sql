# ***NOTE: Change 'C:/Users/nscribano/Desktop/' to your local directory of the GitHub project

LOAD DATA LOCAL INFILE 'C:/Users/Lewai/Documents/CMPSC 431/CMPSC431-Project/MySQL/Init DB/populateData/users.txt' INTO TABLE Users COLUMNS TERMINATED BY ',';
LOAD DATA LOCAL INFILE 'C:/Users/Lewai/Documents/CMPSC 431/CMPSC431-Project/MySQL/Init DB/populateData/ccpayment.txt' INTO TABLE CCPayment COLUMNS TERMINATED BY ',';
LOAD DATA LOCAL INFILE 'C:/Users/Lewai/Documents/CMPSC 431/CMPSC431-Project/MySQL/Init DB/populateData/shippingaddress.txt' INTO TABLE ShippingAddress COLUMNS TERMINATED BY ',';
LOAD DATA LOCAL INFILE 'C:/Users/Lewai/Documents/CMPSC 431/CMPSC431-Project/MySQL/Init DB/populateData/socialaccnt.txt' INTO TABLE SocialAccnt COLUMNS TERMINATED BY ',';
LOAD DATA LOCAL INFILE 'C:/Users/Lewai/Documents/CMPSC 431/CMPSC431-Project/MySQL/Init DB/populateData/category.txt' INTO TABLE Category COLUMNS TERMINATED BY ',';
LOAD DATA LOCAL INFILE 'C:/Users/Lewai/Documents/CMPSC 431/CMPSC431-Project/MySQL/Init DB/populateData/items.txt' INTO TABLE Items COLUMNS TERMINATED BY ',';
LOAD DATA LOCAL INFILE 'C:/Users/Lewai/Documents/CMPSC 431/CMPSC431-Project/MySQL/Init DB/populateData/DsaleMethod.txt' INTO TABLE dsalemethod COLUMNS TERMINATED BY ',';
LOAD DATA LOCAL INFILE 'C:/Users/Lewai/Documents/CMPSC 431/CMPSC431-Project/MySQL/Init DB/populateData/BiddingMethod.txt' INTO TABLE biddingmethod COLUMNS TERMINATED BY ',';
