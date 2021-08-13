CREATE TABLE IF NOT EXISTS suppliersdata.supplier(
	supplier_id bigint PRIMARY KEY,
	supplier_name varchar(50) NOT NULL,
	email varchar(50) NOT NULL,
	supplier_info varchar(255) NOT NULL,
	since date NOT NULL
);

CREATE TABLE IF NOT EXISTS suppliersdata.suplied_release(
	supplied_release_id bigint PRIMARY KEY,
	supplier_id bigint NOT NULL,
	serial_id bigserial NOT NULL,
	supplier_price numeric(5, 2) NOT NULL,
	retail_price numeric(10, 2) NOT NULL,
	total_copies int NOT NULL,
	ordered_date date NOT NULL,
	arrived_date date NOT NULL
);