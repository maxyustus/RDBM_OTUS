CREATE TABLE IF NOT EXISTS Supplier(
	SupplierId INT PRIMARY KEY,
	SupplierName VARCHAR(50) NOT NULL,
	Email VARCHAR(50) NOT NULL,
	SupplierInfo VARCHAR(255) NOT NULL,
	Since DATE NOT NULL,
    ModifiedDate TIMESTAMP
);

CREATE TABLE IF NOT EXISTS SuppliedRelease (
    SuppliedReleaseId INT PRIMARY KEY,
    SupplierId INT NOT NULL,
    SerialId SERIAL NOT NULL,
    SupplierPrice NUMERIC(5 , 2 ) NOT NULL,
    RetailPrice NUMERIC(10 , 2 ) NOT NULL,
    TotalCopies INT NOT NULL,
    OrderedDate DATE NOT NULL,
    ArrivedDate DATE NOT NULL,
    ModifiedDate TIMESTAMP
);