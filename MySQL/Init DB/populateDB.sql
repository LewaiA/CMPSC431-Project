# ***NOTE: Change 'C:/Users/nscribano/Dropbox/School/16th Grade/CMPSC 431/Project/' to your local directory of the GitHub project

LOAD DATA LOCAL INFILE 'C:/Users/nscribano/Dropbox/School/16th Grade/CMPSC 431/Project/CMPSC431-Project/MySQL/Init DB/populateData/users.txt' INTO TABLE Users COLUMNS TERMINATED BY ',';
LOAD DATA LOCAL INFILE 'C:/Users/nscribano/Dropbox/School/16th Grade/CMPSC 431/Project/CMPSC431-Project/MySQL/Init DB/populateData/ccpayment.txt' INTO TABLE CCPayment COLUMNS TERMINATED BY ',';
LOAD DATA LOCAL INFILE 'C:/Users/nscribano/Dropbox/School/16th Grade/CMPSC 431/Project/CMPSC431-Project/MySQL/Init DB/populateData/shippingaddress.txt' INTO TABLE ShippingAddress COLUMNS TERMINATED BY ',';
LOAD DATA LOCAL INFILE 'C:/Users/nscribano/Dropbox/School/16th Grade/CMPSC 431/Project/CMPSC431-Project/MySQL/Init DB/populateData/socialaccnt.txt' INTO TABLE SocialAccnt COLUMNS TERMINATED BY ',';
LOAD DATA LOCAL INFILE 'C:/Users/nscribano/Dropbox/School/16th Grade/CMPSC 431/Project/CMPSC431-Project/MySQL/Init DB/populateData/category.txt' INTO TABLE Category COLUMNS TERMINATED BY ',';
LOAD DATA LOCAL INFILE 'C:/Users/nscribano/Dropbox/School/16th Grade/CMPSC 431/Project/CMPSC431-Project/MySQL/Init DB/populateData/items.txt' INTO TABLE Items COLUMNS TERMINATED BY ',';