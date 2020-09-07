-- Preliminaries
DROP   DATABASE IF EXISTS db_consumer_panel;
CREATE DATABASE db_consumer_panel;
USE    db_consumer_panel;

-- Create tables
CREATE TABLE households(
  hh_id                    INT unsigned NOT NULL AUTO_INCREMENT,
  hh_race                  INT unsigned,
  is_latinx                INT unsigned,
  hh_income                INT unsigned,
  hh_size                  INT unsigned,
  hh_zip_code              INT unsigned,
  hh_state                 VARCHAR(2),
  hh_residence_type        INT unsigned,
  PRIMARY KEY              (hh_id)
  );

CREATE TABLE products(
  prod_id                  VARCHAR(50) NOT NULL,
  brand_at_prod_id         VARCHAR(50),
  department_at_prod_id    VARCHAR(25),
  group_at_prod_id         VARCHAR(25),
  module_at_prod_id        VARCHAR(50),
  amount_at_prod_id        FLOAT,
  units_at_prod_id         VARCHAR(10),
  PRIMARY KEY              (prod_id)
  );

CREATE TABLE trips(
  TC_id                         INT unsigned NOT NULL,
  TC_date                       DATE,
  TC_retailer_code              INT,
  TC_retailer_code_store_code   INT unsigned,
  TC_retailer_code_store_zip3   FLOAT,
  TC_total_spent                FLOAT,
  hh_id                         INT unsigned NOT NULL,
  PRIMARY KEY                   (TC_id)
  );

CREATE TABLE purchases(
  TC_id                          INT unsigned NOT NULL,
  prod_id                        VARCHAR(50) NOT NULL,
  quantity_at_TC_prod_id         INT,
  total_price_paid_at_TC_prod_id FLOAT,
  coupon_value_at_TC_prod_id     FLOAT,
  deal_flag_at_TC_prod_id        INT
  );


-- Insert Foreign Keys
ALTER TABLE trips        ADD CONSTRAINT FK_trips_household     FOREIGN KEY (hh_id)     REFERENCES households(hh_id);
ALTER TABLE purchases   ADD CONSTRAINT FK_purchases_trips     FOREIGN KEY (TC_id)     REFERENCES trips(TC_id);
ALTER TABLE purchases   ADD CONSTRAINT FK_purchases_products  FOREIGN KEY (prod_id)   REFERENCES products(prod_id); 