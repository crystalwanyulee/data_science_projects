-- Preliminaries
DROP   DATABASE IF EXISTS db_sales;
CREATE DATABASE db_sales;
USE    db_sales;

-- Create tables
CREATE TABLE providers(
  ID_provider              INT unsigned NOT NULL AUTO_INCREMENT,
  provider_name            VARCHAR(50) NOT NULL,
  ID_phone                 INT unsigned NOT NULL,
  ID_address               INT unsigned NOT NULL,
  website                  VARCHAR(200),
  update_date              DATE,
  PRIMARY KEY              (ID_provider)
  );
  
CREATE TABLE customers(
  ID_customer              INT unsigned NOT NULL AUTO_INCREMENT,
  username                 VARCHAR(50) NOT NULL,
  password                 VARCHAR(50) NOT NULL,
  description              TEXT,
  update_date              TIMESTAMP,
  PRIMARY KEY              (ID_customer)
  );
  
CREATE TABLE products(
  ID_product               INT unsigned NOT NULL AUTO_INCREMENT,
  product_name             VARCHAR(50) NOT NULL,
  current_price            INT,
  stock                    INT,
  ID_provider              INT unsigned NOT NULL,
  ID_category              INT unsigned NOT NULL,
  update_date              DATE,
  PRIMARY KEY              (ID_product)
  );
  
CREATE TABLE transactions(
  ID_transaction           INT unsigned NOT NULL AUTO_INCREMENT,
  transaction_date         DATETIME,
  ID_customer              INT unsigned NOT NULL,
  shipping_address         INT unsigned NOT NULL,
  discount                 FLOAT,
  paid_amount              FLOAT,
  PRIMARY KEY              (ID_transaction)
  );
  
CREATE TABLE addresses(
  ID_address               INT unsigned NOT NULL AUTO_INCREMENT,
  address_line             VARCHAR(50),
  city                     VARCHAR(50),
  state                    VARCHAR(50),
  country                  VARCHAR(50),
  zipcode                  VARCHAR(10),
  update_date              DATE,
  PRIMARY KEY              (ID_address)
  );
  
CREATE TABLE phones(
  ID_phone                 INT unsigned NOT NULL AUTO_INCREMENT,
  phone_number             VARCHAR(20),
  update_date              TIMESTAMP,
  PRIMARY KEY              (ID_phone)
  );
  
CREATE TABLE categories(
  ID_category              INT unsigned NOT NULL AUTO_INCREMENT,
  category_name            VARCHAR(50),
  update_date              DATE,
  PRIMARY KEY              (ID_category)
  );
  
-- Create Tables to deal with many to many relationships
CREATE TABLE customers_phones(
  ID_customer              INT unsigned NOT NULL,
  ID_phone                 INT unsigned NOT NULL
  );
  
CREATE TABLE customers_addresses(
  ID_customer              INT unsigned NOT NULL,
  ID_address               INT unsigned NOT NULL
  );
  
CREATE TABLE categories_providers(
ID_category                INT unsigned NOT NULL,
ID_provider                INT unsigned NOT NULL
);

CREATE TABLE transactions_details(
ID_transaction            INT unsigned NOT NULL,
ID_product                INT unsigned NOT NULL,
price                     FLOAT,
quantity                  INT
);

-- Insert Foreign Keys
ALTER TABLE providers     ADD CONSTRAINT FK_Providers_Addresses     FOREIGN KEY (ID_address)        REFERENCES addresses(ID_address);
ALTER TABLE providers     ADD CONSTRAINT FK_Providers_Phones        FOREIGN KEY (ID_phone)          REFERENCES phones(ID_phone);
ALTER TABLE products      ADD CONSTRAINT FK_Products_Providers      FOREIGN KEY (ID_provider)       REFERENCES providers(ID_provider);
ALTER TABLE products      ADD CONSTRAINT FK_Products_Categories     FOREIGN KEY (ID_category)       REFERENCES categories(ID_category);
ALTER TABLE transactions  ADD CONSTRAINT FK_Transactions_Customers  FOREIGN KEY (ID_customer)       REFERENCES customers(ID_customer);
ALTER TABLE transactions  ADD CONSTRAINT FK_Transactions_Addresses  FOREIGN KEY (shipping_address)  REFERENCES addresses(ID_address);


-- Insert Foreign Keys for many to many relationships
ALTER TABLE customers_phones      ADD CONSTRAINT FK_CP_Customers    FOREIGN KEY (ID_customer)     REFERENCES customers(ID_customer);
ALTER TABLE customers_phones      ADD CONSTRAINT FK_CP_Phones       FOREIGN KEY (ID_phone)        REFERENCES phones(ID_phone);
ALTER TABLE customers_addresses   ADD CONSTRAINT FK_CA_Customers    FOREIGN KEY (ID_customer)     REFERENCES customers(ID_customer);
ALTER TABLE customers_addresses   ADD CONSTRAINT FK_CA_Addresses    FOREIGN KEY (ID_address)      REFERENCES addresses(ID_address);
ALTER TABLE categories_providers  ADD CONSTRAINT FK_CP_Categories   FOREIGN KEY (ID_category)     REFERENCES categories(ID_category);
ALTER TABLE categories_providers  ADD CONSTRAINT FK_CP_Providers    FOREIGN KEY (ID_provider)     REFERENCES providers(ID_provider);
ALTER TABLE transactions_details  ADD CONSTRAINT FK_TD_Transactions FOREIGN KEY (ID_transaction)  REFERENCES transactions(ID_transaction);
ALTER TABLE transactions_details  ADD CONSTRAINT FK_TD_Details      FOREIGN KEY (ID_product)      REFERENCES products(ID_product);   