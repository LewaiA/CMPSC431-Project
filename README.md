# CMPSC431-Project (Himalaya.com)
## Two directories are present:
### 1. Himalaya

Is a NetBeans Java EE project used for running the project's code and deploying the website. The Java EE version of Netbeans, [available here](https://netbeans.org/downloads/), must be installed to run the project. Be sure to choose Tomcat as your desired deployment server during installation.

### 2. MySQL

A running instance of MySQL is also needed for the website's backend. If not already installed, download the proper version of MySQL Community Server for you machine [here](https://dev.mysql.com/downloads/mysql/). Files within this directory include initDB.sql, populateDB.sql, and various text files within PopulateData.

initDB.sql must be run __first__ to create the database schemas for Himalaya.com. populateDB.sql must be run __second__ to populate the database with dummy data stored the text files in ./MySQL/Init_DB/populateData/.


After the database is initialized, the NetBeans project can be opened and run. The project is configured to run off the Tomcat server built into NetBeans and shouldn't need any further configuration before running.
