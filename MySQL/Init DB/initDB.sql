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
    age INTEGER,
    reward_progress INTEGER,
    income REAL,
    PRIMARY KEY (email)
);

CREATE TABLE SocialAccnt( 
	userID VARCHAR(20), 
	type VARCHAR(20), 
	email VARCHAR(100) NOT NULL,  
	PRIMARY KEY(userID, email), 
	FOREIGN KEY (email) REFERENCES Users (email)
		ON DELETE CASCADE 
);

CREATE TABLE CCPayment( 
	email VARCHAR(100) NOT NULL, 
	number CHAR(16), 
	type VARCHAR(20), 
	expiration DATE, 
	PRIMARY KEY(number, email), 
	FOREIGN KEY(email) REFERENCES Users (email)
		ON DELETE CASCADE 
);

CREATE TABLE ShippingAddress( 
	email VARCHAR(100) NOT NULL, 
	ZIP CHAR(5), 
	street VARCHAR(30), 
	city VARCHAR(30),  
	state CHAR(2), 
	PRIMARY KEY(street, email), 
	FOREIGN KEY(email) REFERENCES Users (email)
		ON DELETE CASCADE 
);

CREATE TABLE Category( 
	CID CHAR(4), 
	itemID CHAR(10), 
	PCID CHAR(4), 
	PRIMARY KEY(CID),
	FOREIGN KEY(PCID) REFERENCES Category (CID)
);

CREATE TABLE Items(
	url VARCHAR(255),  
	itemID CHAR(10), 
	qty INTEGER, 
	CID CHAR(4) NOT NULL, 
	PRIMARY KEY(itemID, CID), 
	FOREIGN KEY(CID) REFERENCES Category (CID)
		ON DELETE CASCADE 
);

CREATE TABLE Wishlist( 
	wlID  CHAR(10), 
	date_added  DATE, 
	privacy   BOOLEAN, 
	itemID  CHAR(10), 
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
	itemID CHAR(10) NOT NULL, 
	PRIMARY KEY(GID, itemID),  
	FOREIGN KEY(itemID) REFERENCES Wishlist (itemID) 
		ON DELETE CASCADE 
);

CREATE TABLE ShoppingCart( 
	email VARCHAR(100) NOT NULL,  
	total_price REAL,  
	shipping_method  VARCHAR(100), 
	itemID CHAR(10),  
	PRIMARY KEY (total_price, email, itemID), 
	FOREIGN KEY(email) REFERENCES Users (email) 
		ON DELETE CASCADE,
	FOREIGN KEY(itemID) REFERENCES Items (itemID)  
		ON DELETE NO ACTION
);

CREATE TABLE TreatYoSelf( 
	email VARCHAR(100) NOT NULL,  
	budget REAL,  
	CID CHAR(4), 
	PRIMARY KEY(email, budget), 
	FOREIGN KEY(email) REFERENCES Users (email) 
		ON DELETE CASCADE, 
	FOREIGN KEY(CID) REFERENCES Category (CID)
);

CREATE TABLE DsaleMethod( 
	itemID  CHAR(10) NOT NULL,  
	price REAL,  
	PRIMARY KEY(price, itemID), 
	FOREIGN KEY(itemID) REFERENCES Items (itemID) 
		ON DELETE CASCADE 
);

CREATE TABLE BiddingMethod( 
	itemID CHAR(10) NOT NULL, 
	min_bid REAL, 
	current_bid REAL, 
	PRIMARY KEY(itemID), 
	FOREIGN KEY(itemID) REFERENCES Items (itemID) 
		ON DELETE CASCADE 
);

CREATE TABLE Rating( 
	email VARCHAR(100),  
	itemID CHAR(10) NOT NULL,  
	stars INTEGER,  
	review VARCHAR(500),  
	PRIMARY KEY(stars, itemID, email), 
	FOREIGN KEY(itemID) REFERENCES Items (itemID)  
		ON DELETE CASCADE, 
	FOREIGN KEY(email) REFERENCES Users (email)
		ON DELETE NO ACTION 
);