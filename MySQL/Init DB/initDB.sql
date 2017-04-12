/* Create new database */
DROP DATABASE IF EXISTS himalaya;
CREATE DATABASE IF NOT EXISTS himalaya;
USE himalaya;

/* Add tables */
CREATE TABLE Users(
	email VARCHAR(100),
    password VARCHAR(30),
    name VARCHAR(20),
	gender CHAR(1),
    phone VARCHAR(15),
    dob DATE,
    reward_progress INTEGER,
    income REAL,
    PRIMARY KEY (email)
);

CREATE TABLE SocialAccnt( 
	email VARCHAR(100) NOT NULL,
    username VARCHAR(20), 
	type VARCHAR(20), 
	PRIMARY KEY(username, email), 
	FOREIGN KEY (email) REFERENCES Users (email)
		ON DELETE CASCADE 
);

CREATE TABLE CCPayment( 
	email VARCHAR(100) NOT NULL, 
	number CHAR(19), 
	type VARCHAR(20), 
	expiration DATE, 
	PRIMARY KEY(number, email), 
	FOREIGN KEY(email) REFERENCES Users (email)
		ON DELETE CASCADE 
);

CREATE TABLE ShippingAddress( 
	email VARCHAR(100) NOT NULL, 
	ZIP VARCHAR(5), 
	street VARCHAR(50), 
	city VARCHAR(50),  
	state CHAR(2), 
	PRIMARY KEY(email, ZIP, street, city, state), 
	FOREIGN KEY(email) REFERENCES Users (email)
		ON DELETE CASCADE 
);

CREATE TABLE Category( 
	CID INTEGER, 
	PCID INTEGER,
    CNAME VARCHAR(30),
	PRIMARY KEY(CID),
	FOREIGN KEY(PCID) REFERENCES Category (CID)
);

CREATE TABLE Items(
	itemID INTEGER, 
    name VARCHAR(100),
    description VARCHAR(500),
    url VARCHAR(255),
	qty INTEGER, 
	CID INTEGER NOT NULL, 
	PRIMARY KEY(itemID), 
	FOREIGN KEY(CID) REFERENCES Category (CID)
		ON DELETE CASCADE
);

CREATE TABLE Wishlist( 
	wlID  CHAR(10), 
	date_added  DATE, 
	privacy   BOOLEAN, 
	itemID INTEGER, 
	email  VARCHAR(100) NOT NULL, 
	PRIMARY KEY(wlID, itemID, email), 
	FOREIGN KEY(itemID) REFERENCES Items (itemID)
	ON DELETE NO ACTION, 
	FOREIGN KEY (email) REFERENCES Users (email)
	ON DELETE CASCADE 
);

CREATE TABLE PriceWatcher( 
	GID CHAR(4),
	cur_date DATE,
	itemID INTEGER NOT NULL, 
	PRIMARY KEY(GID, itemID),  
	FOREIGN KEY(itemID) REFERENCES Wishlist (itemID) 
		ON DELETE CASCADE 
);

CREATE TABLE ShoppingCart( 
	email VARCHAR(100) NOT NULL,  
	total_price REAL,  
	shipping_method  VARCHAR(100), 
	itemID INTEGER,  
	PRIMARY KEY (total_price, email, itemID), 
	FOREIGN KEY(email) REFERENCES Users (email) 
		ON DELETE CASCADE,
	FOREIGN KEY(itemID) REFERENCES Items (itemID)  
		ON DELETE NO ACTION
);

CREATE TABLE TreatYoSelf( 
	email VARCHAR(100) NOT NULL,  
	budget REAL,  
	CID INTEGER, 
	PRIMARY KEY(email, budget), 
	FOREIGN KEY(email) REFERENCES Users (email) 
		ON DELETE CASCADE, 
	FOREIGN KEY(CID) REFERENCES Category (CID)
);

CREATE TABLE DsaleMethod( 
	itemID INTEGER NOT NULL,  
	price REAL,  
	PRIMARY KEY(price, itemID), 
	FOREIGN KEY(itemID) REFERENCES Items (itemID) 
		ON DELETE CASCADE 
);

CREATE TABLE BiddingMethod( 
	itemID INTEGER NOT NULL, 
	min_bid REAL, 
	current_bid REAL, 
    current_bidder VARCHAR(100),
	PRIMARY KEY(itemID), 
	FOREIGN KEY(itemID) REFERENCES Items (itemID) 
		ON DELETE CASCADE ,
	FOREIGN KEY(current_bidder) REFERENCES Users (email)
);

CREATE TABLE Rating( 
	email VARCHAR(100),  
	itemID INTEGER NOT NULL,  
	stars INTEGER,  
	review VARCHAR(500),  
	PRIMARY KEY(stars, itemID, email), 
	FOREIGN KEY(itemID) REFERENCES Items (itemID)  
		ON DELETE CASCADE, 
	FOREIGN KEY(email) REFERENCES Users (email)
		ON DELETE NO ACTION 
);