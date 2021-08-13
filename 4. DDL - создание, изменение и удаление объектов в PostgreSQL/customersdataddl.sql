CREATE TABLE IF NOT EXISTS customersdata.customer(
	customer_id bigint PRIMARY KEY,
	first_name varchar(50) NULL,
	last_name varchar(50) NULL,
	nickname varchar(20) NOT NULL,
	email varchar(50) NOT NULL UNIQUE,
	profile_pic varchar(255) NULL,
	registration_date timestamp,
	discount_pct int NULL
);

CREATE TABLE IF NOT EXISTS customersdata.order(
	order_id bigint PRIMARY KEY,
	created_at date NOT NULL,
	paid date NULL,
	total_price numeric(10, 2) NOT NULL CHECK(total_price > 0),
	total_discount numeric(10,2) NOT NULL CHECK (total_discount >=0),
	customer_id bigint NOT NULL,
	status_id int NOT NULL
);

CREATE TABLE IF NOT EXISTS customersdata.order_status(
	status_id int PRIMARY KEY,
	status_name varchar(50)
);

CREATE TABLE IF NOT EXISTS customersdata.order_delivery(
	order_delivery_id bigint PRIMARY KEY,
	order_id bigint NOT NULL,
	shipped boolean NOT NULL,
	shipped_date date NULL,
	delivery_info varchar(150) NOT NULL,
	delivery_type_id int NOT NULL
);

CREATE TABLE IF NOT EXISTS customersdata.delivery_type(
	delivery_type_id int PRIMARY KEY,
	delivery_type_name varchar(50)
);

CREATE TABLE IF NOT EXISTS customersdata.ordered_release(
	ordered_release_id bigint PRIMARY KEY,
	order_id bigint NOT NULL,
	supplied_release_id bigint NOT NULL,
	total_copies bigint NOT NULL CHECK (total_copies > 0)
);
