--Q1. Load the given dataset into snowflake with a primary key to Order Date column.
CREATE OR REPLACE TABLE SJ_SALES_DATA (
  order_id VARCHAR NOT NULL,
  order_date DATE PRIMARY KEY NOT NULL,
  ship_date DATE NOT NULL,
  ship_mode VARCHAR NOT NULL,
  consumer_name VARCHAR NOT NULL,
  segment VARCHAR NOT NULL,
  state VARCHAR NOT NULL,
  country VARCHAR NOT NULL,
  market VARCHAR NOT NULL,
  region VARCHAR NOT NULL,
  product_id VARCHAR NOT NULL,
  category VARCHAR NOT NULL,
  sub_category VARCHAR NOT NULL,
  product_name VARCHAR NOT NULL,
  sales INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  discount NUMBER(5,2) NOT NULL,
  profit NUMBER(10,4) NOT NULL,
  shipping_cost NUMBER(10,2) NOT NULL,
  order_priority VARCHAR NOT NULL,
  year INTEGER NOT NULL
);

CREATE OR REPLACE TABLE SJ_SALES_DATA_copy AS SELECT * FROM SJ_SALES_DATA;  --created replica of original table to keep backup

--Q2. Change the Primary key to Order Id Column.
ALTER TABLE SJ_SALES_DATA_copy DROP PRIMARY KEY;     --dropping the primary key

ALTER TABLE SJ_SALES_DATA_copy
ADD PRIMARY KEY(order_id);      --adding new primary key

--Q3. Check the data type for Order date and Ship date and mention in what data type it should be?
DESC TABLE SJ_SALES_DATA_copy;
--The data type of order_date and ship_date in DATE and these two column should be in DATE type.

-- Q4.  Create a new column called order_extract and extract the number after the last ‘–‘from Order ID column.
ALTER TABLE SJ_SALES_DATA_copy
ADD COLUMN order_num NUMBER DEFAULT 0;   --adding new column named "order_num" with default value zero

UPDATE SJ_SALES_DATA_copy
SET order_num = SPLIT_PART(order_id, '-', 3);   --assigning new value to "oder_num" column

--Q5.  FLAG ,IF DISCOUNT IS GREATER THEN 0 THEN  YES ELSE FALSE AND PUT IT IN NEW COLUMN FROM EVERY ORDER ID.
ALTER TABLE SJ_SALES_DATA_copy
ADD COLUMN discount_flag BOOLEAN DEFAULT FALSE;

UPDATE SJ_SALES_DATA_copy
SET discount_flag = 
    CASE 
        WHEN discount > 0 THEN 'Yes'
        ELSE 'No'
    END;

-- Q6. FIND OUT HOW MUCH DAYS TAKEN FOR EACH ORDER TO PROCESS FOR THE SHIPMENT FOR EVERY ORDER ID.
ALTER TABLE SJ_SALES_DATA_copy
ADD COLUMN process_days NUMBER DEFAULT NULL;

UPDATE SJ_SALES_DATA_COPY
SET process_days = DATEDIFF('DAYS', order_date, ship_date);

--7. FLAG THE PROCESS DAY AS BY RATING IF IT TAKES LESS OR EQUAL 3  DAYS MAKE 5,LESS OR EQUAL THAN 6 DAYS BUT MORE THAN 3 MAKE 4,LESS THAN 10 BUT MORE THAN 6 MAKE 3,MORE THAN 10 MAKE IT 2 FOR EVERY ORDER ID.
ALTER TABLE SJ_SALES_DATA_copy
ADD COLUMN rating NUMBER DEFAULT NULL;

UPDATE SJ_SALES_DATA_COPY
SET rating = 
    CASE 
        WHEN DATEDIFF('DAYS', order_date, ship_date) <= 3 THEN 5
        WHEN DATEDIFF('DAYS', order_date, ship_date) <= 6 THEN 4
        WHEN DATEDIFF('DAYS', order_date, ship_date) <=10 THEN 3
        ELSE 2
    END;
