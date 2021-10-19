USE vinyldb;

CREATE TABLE IF NOT EXISTS Customer(
	CustomerId INT PRIMARY KEY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	NickName VARCHAR(20) NOT NULL,
	Email VARCHAR(50) NOT NULL UNIQUE,
	ProfilePic VARCHAR(255) NOT NULL,
	RegistrationDate TIMESTAMP,
	DiscountPct INT NOT NULL,
    ModifiedDate TIMESTAMP
);

CREATE TABLE IF NOT EXISTS CustomerOrder(
	OrderId INT PRIMARY KEY,
	CreatedAt DATE NOT NULL,
	Paid DATE NOT NULL,
	TotalPrice NUMERIC(10, 2) NOT NULL CHECK(TotalPrice > 0),
	TotalDiscount NUMERIC(10,2) NOT NULL CHECK (TotalDiscount >=0),
	CustomerId INT NOT NULL,
	StatusId INT NOT NULL,
    ModifiedDate TIMESTAMP
);

CREATE TABLE IF NOT EXISTS OrderStatus(
	StatusId INT PRIMARY KEY,
	StatusName VARCHAR(50),
    ModifiedDate TIMESTAMP
);

CREATE TABLE IF NOT EXISTS OrderDelivery(
	OrderDeliveryId INT PRIMARY KEY,
	OrderId INT NOT NULL,
	Shipped BOOLEAN NOT NULL,
	ShippedDate DATE NOT NULL,
	DeliveryInfo VARCHAR(150) NOT NULL,
	DeliveryTypeId INT NOT NULL,
    ModifiedDate TIMESTAMP
);

CREATE TABLE IF NOT EXISTS DeliveryType(
	DeliveryTypeId INT PRIMARY KEY,
	DeliveryTypeName VARCHAR(50),
    ModifiedDate TIMESTAMP
);

CREATE TABLE IF NOT EXISTS OrderedRelease(
	OrderedReleaseId INT PRIMARY KEY,
	OrderId INT NOT NULL,
	SuppliedReleaseId INT NOT NULL,
	TotalCopies INT NOT NULL CHECK (TotalCopies > 0),
    ModifiedDate TIMESTAMP
);
