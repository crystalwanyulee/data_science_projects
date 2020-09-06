-- a. 
use db_consumer;
rename table dta_at_hh to households;
rename table dta_at_tc to trips;
rename table dta_at_tc_upc to purchases;
rename table dta_at_prod_id to products;

-- How many:
-- Store shopping trips are recorded in your database?

select count(*) from trips;
-- Part A
select count(distinct(tc_id)) from trips;
# 7596145

-- Households appear in your database?
select count(distinct(hh_id)) from households;
# 39577

-- Stores of different retailers appear in our database?

select count(distinct(tc_retailer_code)) from trips;
# 863

-- different products are recorded?
-- Products per category and products per module

-- product per category
select count(distinct(department_at_prod_id)) from products;
# 11

-- product per module
select count(distinct(module_at_prod_id)) from products;
# 1224

-- Transactions?
-- Total transactions and transactions realized under some kind of promotion

-- total transactions
select count(distinct(tc_id)) from purchases;
# 5651255

-- under promotion 
select count(coupon_value_at_tc_prod_id) from purchases
where coupon_value_at_tc_prod_id != 0 ;
# 2603946

-- table generated for making plots
drop table module; 
create temporary table module
select count(distinct(prod_id)) as number_of_module, module_at_prod_id from products
group by module_at_prod_id;
select * from module
order by number_of_module DESC;

create table department
select count(distinct(prod_id))as number_of_products, department_at_prod_id from products
group by department_at_prod_id
order by number_of_products DESC;
SELECT * FROM department;

# module per department
select count(distinct(module_at_prod_id)) as number_of_module, department_at_prod_id
from products
group by department_at_prod_id
order by number_of_module DESC;

# product per department 12 rows returned
select count(distinct(prod_id)) as number_of_product, department_at_prod_id
from products
group by department_at_prod_id
order by number_of_product DESC;

# DRY GROCERY
select * from products;

select count(group_at_prod_id), group_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "DRY GROCERY"
group by group_at_prod_id;

#GM
select count(group_at_prod_id), group_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "GENERAL MERCHANDISE"
group by group_at_prod_id;

#H&B CARE
select count(group_at_prod_id), group_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "HEALTH & BEAUTY CARE"
group by group_at_prod_id;

#NON-FOOD
select count(group_at_prod_id), group_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "NON-FOOD GROCERY"
group by group_at_prod_id;

#FROZEN FOOD
select count(group_at_prod_id), group_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "FROZEN FOODS"
group by group_at_prod_id;

#DAIRY
select count(group_at_prod_id), group_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "DAIRY"
group by group_at_prod_id;

#ALOHOLIC BEVERAGES
select count(group_at_prod_id), group_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "ALCOHOLIC BEVERAGES"
group by group_at_prod_id;


#FRESH PRODUCE
select count(group_at_prod_id), group_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "FRESH PRODUCE"
group by group_at_prod_id;

#DELI
select count(group_at_prod_id), group_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "DELI"
group by group_at_prod_id;


#PACKAGED MEAT
select count(group_at_prod_id), group_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "PACKAGED MEAT"
group by group_at_prod_id;

#module
#DRY GROCERY
select count(module_at_prod_id), module_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "DRY GROCERY"
group by module_at_prod_id;

#GM
select count(module_at_prod_id), module_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "GENERAL MERCHANDISE"
group by module_at_prod_id;

#H&B CARE
select count(module_at_prod_id), module_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "HEALTH & BEAUTY CARE"
group by module_at_prod_id;

#NON-FOOD
select count(module_at_prod_id), module_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "NON-FOOD GROCERY"
group by module_at_prod_id;

#FROZEN FOOD
select count(module_at_prod_id), module_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "FROZEN FOODS"
group by module_at_prod_id;


#DAIRY
select count(module_at_prod_id), module_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "DAIRY"
group by module_at_prod_id;

#ALOHOLIC BEVERAGES
select count(module_at_prod_id), module_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "ALCOHOLIC BEVERAGES"
group by module_at_prod_id;

#Fresh Produce
select count(module_at_prod_id), module_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "FRESH PRODUCE"
group by module_at_prod_id;

#DELI
select count(module_at_prod_id), module_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "DELI"
group by module_at_prod_id;

#PACKAGED MEAT
select count(module_at_prod_id), module_at_prod_id, department_at_prod_id
from products
where department_at_prod_id = "PACKAGED MEAT"
group by module_at_prod_id;



-- b. Aggregate the data at the household‐monthly level to answer the -- following questions:  How many households do not shop at least 
-- once on a 3 month periods. 
-- i. Is it reasonable?  
-- ii. Why do you think this is occurring?

drop table IF exists B0;
CREATE TABLE B0
SELECT *, STR_TO_DATE(TC_date,'%Y-%m-%d') AS TC_date_1 FROM trips;

DROP TABLE IF EXISTS B1;
create table B1
select distinct(concat(hh_id,TC_date_1)) hh_id_date, hh_id,TC_date_1 from B0;
create index B1_TC_date_1_index on B1 (TC_date_1);
create index B1_hh_id_index on B1 (hh_id);

DROP TABLE IF EXISTS B2;
CREATE TABLE B2
SELECT * FROM B1;
create index B2_TC_date_1_index on B2 (TC_date_1);
create index B2_hh_id_index on B2 (hh_id);

DROP TABLE IF EXISTS B3;
create table B3
SELECT *, (
    SELECT count(*) from B2 as b where a.TC_date_1 < b.TC_date_1 AND a.hh_id = b.hh_id
) AS row_num FROM B1 as a;

drop table if exists B4;
CREATE TABLE B4
select hh_id, TC_date_1, row_num, concat(hh_id, row_num) as hh_id_num from B3;
create index B4_hh_id_num_index on B4 (hh_id_num);

DROP TABLE IF EXISTS B5;
create table B5
SELECT hh_id as hh_id_1, TC_date_1 as TC_date_2, row_num+1, CONCAT(hh_id,(row_num+1)) as hh_id_num_1 from B3;
create index B5_hh_id_num_index on B5 (hh_id_num_1);

DROP TABLE IF EXISTS B6;
create table B6
select hh_id, datediff(TC_date_2,TC_date_1) as diff_day from (select * from B5 as a Left join B4 as b on a.hh_id_num_1=b.hh_id_num) as c;
# count the number of households that do not go shopping in three months
select count(distinct(hh_id)) from B6 WHERE diff_day >=91;
.
# Analyse the reason why those households do not go shopping in ai least three month;
create table B_2
select * from B5 AS b INNER JOIN (select distinct(hh_id) as h_id from (select hh_id, diff_day from B6 where diff_day>=90) as a ) AS c on b.hh_id_1=c.h_id;

create table B_2_1
select *, b.TC_date_2 as date_1 from B4 as a inner join B_2 as b on a.hh_id_num=b.hh_id_num_1  ;

select hh_id, TC_date_1, TC_date_2, datediff(TC_date_2, TC_date_1) from B_2_1 where datediff(TC_date_2, TC_date_1) >= 90;
.
 
-- Loyalism: Among the households who shop at least once a month, which -- % of them
-- concentrate at least 80% of their grocery expenditure (on average) on --single retailer? Andamong 2 retailers?  
create table B7_1
select *  from trips as a inner join (select distinct(c.hh_id) as h_id from (select hh_id, max(d.diff_day) from B6 as d group by d.hh_id having max(d.diff_day) <= 30) as c) as b on a.hh_id = b.h_id;

DROP TABLE IF EXISTS B8;
create table B8
select hh_id, TC_retailer_code, round(sum(TC_total_spent),2) AS S1 from B7_1 group by hh_id, TC_retailer_code;
SELECT * FROM B8;

DROP TABLE IF EXISTS B9;
create temporary table B9
select hh_id, round(sum(TC_total_spent),2) S2 from B7 group by hh_id;

drop table IF exists B10;
create table B10
SELECT B8.hh_id, TC_retailer_code, S1/S2 AS PERC_PURCHASE_RETAILER FROM B8 LEFT JOIN B9 ON B8.hh_id=B9.hh_id ORDER BY B8.hh_id, PERC_PURCHASE_RETAILER DESC;
SELECT * FROM B10;
create index B10_hh_id_index on B10 (hh_id);
create index B10_perc_index on B10 (PERC_PURCHASE_RETAILER);

DROP TABLE IF EXISTS B11;
CREATE TABLE B11
SELECT * FROM B10;
create index B11_hh_id_index on B11 (hh_id);
create index B11_perc_index on B11 (PERC_PURCHASE_RETAILER);


DROP TABLE IF EXISTS B12;
create table B12
SELECT *, (
    SELECT count(*) from B11 as b where a.PERC_PURCHASE_RETAILER <= b.PERC_PURCHASE_RETAILER AND a.hh_id = b.hh_id
) AS row_num FROM B10 as a;
SELECT * FROM B12;

DROP TABLE IF EXISTS B13;
CREATE TABLE B13
SELECT * FROM B12 WHERE PERC_PURCHASE_RETAILER >= 0.8 and row_num = 1;

## always shopping in a single market.
SELECT count(a.hh_id)/(select count(distinct(b.hh_id)) from B12 AS b) from B13 AS a;

DROP TABLE IF EXISTS B14;
CREATE TABLE B14
SELECT * FROM B12 WHERE row_num <= 2;
select * from B14;

select hh_id, sum(PERC_PURCHASE_RETAILER) as sum_perc from B14 GROUP BY hh_id having sum_perc >= 0.8;

drop table IF exists B15;
create table B15
select count(distinct(hh_id)) as c_hh_id from (select hh_id, sum(PERC_PURCHASE_RETAILER) as sum_perc from B14 GROUP BY hh_id having sum_perc >= 0.8) as a;
select * from B15;
## always shopping in two market.
SELECT c_hh_id/(select count(distinct(b.hh_id)) from b12 AS b) from B15 AS a;

drop table if exists B16;
create table B16
select hh_id as h_id from B13; # always shopping in a single market;

drop table IF exists B17;
create table B17
select * from households as a inner join B16 as b on a.hh_id = b.h_id;

-- i. Are their demographics remarkably different? Are these people richer? Poorer?
select avg(hh_income) from households;

create table B17_1
SELECT hh_income, a.hh_id from households as a inner join (select distinct(hh_id) from B7_1) as b ON a.hh_id= b.hh_id;
select avg(hh_income) from B17_1;
 
-- ii. What is the retailer that has more loyalists?
select TC_retailer_code, avg(PERC_PURCHASE_RETAILER) avg_perc_retailer, count(TC_retailer_code) from B11 group by TC_retailer_code order by avg(PERC_PURCHASE_RETAILER) DESC;
 
-- iii. Where do they live? Plot the distribution by state
# The distribution of the people that shopping ar least once a month by state
select hh_state, count(b.hh_id) as num_state from households as c inner join (select distinct(a.hh_id) from B7_1 AS a) as b on c.hh_id= b.hh_id group by hh_state order by count(b.hh_id);

# Compare that distribution to all the households’ distribution by state
# Plot these two distributions together in one graph
select a.hh_state, a.num_hh_all, b.num_hh from (select hh_state, count(hh_id) as num_hh_all from households group by hh_state) as a
inner join (select count(b.hh_id) as num_hh, hh_state from households as c inner join (select distinct(a.hh_id) from B7_1 AS a) as b on c.hh_id= b.hh_id group by hh_state order by count(b.hh_id)
) as b on a.hh_state = b.hh_state order by b.num_hh;
 
-- Plot with the distribution:
-- i. Average number of items purchased on a given month.use db_final;
 
create index trips_TC_id_index on trips (TC_id);
create index purchases_TC_id_index on purchases (TC_id);
 
create table B18
select hh_id, a.TC_id, substr(TC_date,3,5) as year_mon, quantity_at_TC_prod_id from purchases as a left join trips as b on a.TC_id = b.TC_id;
 
drop table if exists B19_1;
create table B19_1
select year_mon, hh_id, sum(quantity_at_TC_prod_id) as sum_purchase_quant_per_month from B18 group by TC_id, hh_id;
select * from B19_1 order by hh_id, year_mon;
 
drop table if exists B20_0;
create table B20_0
SELECT year_mon, avg(sum_purchase_quant_per_month) as avg_purchase_quant_per_month from B19_1 group by year_mon;
 
SELECT * FROM B20_0 where year_mon != "03-12" ORDER BY year_mon;
 
-- ii. Average number of shopping trips per month.
create table B21
select hh_id, substr(TC_date,3,5) as year_mon, count(TC_id) as num_trips from trips group by hh_id, substr(TC_date,3,5);
 
create table B22
select year_mon, avg(num_trips) as avg_num_trips from B21 group by year_mon;
select * from B22 ORDER BY year_mon;
 
select * from B22 where year_mon != "03-12";

  -- iii. Average number of days between 2 consecutive shopping trips.
drop table if exists B23;
create table B23
select hh_id, avg(diff_day) as avg_diff_day from B6 group by hh_id;
SELECT * FROM B23;

DROP TABLE IF EXISTS B24;
create table B24
select round(avg_diff_day,0) as diff_day, count(hh_id) as num_people_same_avg from B23 group by round(avg_diff_day,0);
SELECT * FROM B24 where num_people_same_avg != 0 ORDER BY diff_day ;
 

-- c-1

DROP TABLE IF EXISTS tb1;
CREATE TABLE tb1
   SELECT *, SUBSTR(T1.TC_date,3,5) as month
   FROM (SELECT hh_id, 
                              TC_id as TC_id_1, 
                              TC_date 
                FROM trips) AS T1
   LEFT JOIN (SELECT TC_id as TC_id_2, 
                                       SUM(quantity_at_TC_prod_id) as num_item 
                        FROM purchases GROUP BY TC_Id) AS T2
   ON T1.TC_id_1 = T2.TC_id_2;

DROP TABLE IF EXISTS tb2;
CREATE TEMPORARY TABLE tb2
   SELECT hh_id, 
                  month, 
                  COUNT(TC_id_1) as num_trips 
   FROM tb1 
   GROUP BY hh_id, month;

DROP TABLE IF EXISTS tb3;
CREATE TEMPORARY TABLE tb3
   SELECT month, 
                  round(AVG(num_trips),2) as avg_trips 
   FROM tb2 
   GROUP BY month ORDER BY month;

DROP TABLE IF EXISTS tb4;
CREATE TEMPORARY TABLE tb4
   SELECT month, 
              round(AVG(num_item),2) as avg_items 
   FROM tb1 
   GROUP BY month 
   ORDER BY month;

DROP TABLE IF EXISTS tb5;
CREATE TEMPORARY TABLE tb5
   SELECT T1.month, avg_trips, avg_items
   FROM tb3 as T1
       INNER JOIN tb4 as T2
       ON T1.month = T2.month;

SELECT * FROM tb5;


-- c-2. Is the average price paid per item correlated with the number of items purchased? 
SELECT (total_price_paid_at_TC_prod_id/quantity_at_TC_prod_id) as avg_price,
                quantity_at_TC_prod_id as num_items
FROM purchases;

# 3. Private Labeled products are the products with the same brand as the supermarket. In the data set they appear labeled as ‘CTL BR’ 
# i.  What are the product categories that have proven to be more “Private labelled” 

SELECT group_at_prod_id as category,
      COUNT(prod_id)/(SELECT count(prod_id) FROM products WHERE brand_at_prod_id = "CTL BR") as private_labeled
FROM products
WHERE brand_at_prod_id = "CTL BR"
GROUP BY group_at_prod_id
ORDER BY private_labeled DESC;


Note: The following is Python’s code. Because the dataset is too large and our computers cannot run the queries in 3-3-ii and 3-3-iii, we import data into python to analyze data, but we also provide SQL code at the same time, which we have used less rows to run SQL queries and make sure if it can work.

-- 3-3-ii.  Is the expenditure share in Private Labeled products constant across months? 
[Python code]
# preliminaries
# load dataset and merge table 
households = pd.read_csv("dta_at_hh.csv")
products   = pd.read_csv("dta_at_prod_id.csv")
trips      = pd.read_csv("dta_at_TC.csv")
purchases  = pd.read_csv("dta_at_TC_upc.csv")

# change date to year&month
trips['month'] = trips.TC_date.str[2:7]

# remove useless columns
households = households.drop(columns = households.columns.values[[0,2,3,4,5,7,8]])
products = products.drop(columns = products.columns.values[[0,2,4,5,6,7]])
trips = trips.drop(columns = trips.columns.values[[0,2,3,4,5]])
purchases = purchases.drop(columns = purchases.columns.values[[0,2,4,5]])

# create private label prod_id
private_label_id = products.loc[products["brand_at_prod_id"] == "CTL BR"]
private_label_id = private_label_id["prod_id"]

# merge households and trips table
merge_1 = pd.merge(trips, households, how="left", on="hh_id")

# merge households, trips and purchases table
merge_2 = pd.merge(purchases, merge_1, how="left", on="TC_id")

# create private label only table
merge_PL_only = pd.merge(merge_2, private_label_id, how="inner", on="prod_id")

# In[] final result for c-3-ii

PL_cost_by_month = merge_PL_only.groupby('month')['total_price_paid_at_TC_prod_id'].sum()
total_cost_by_month = merge_2.groupby('month')['total_price_paid_at_TC_prod_id'].sum()
PL_cost_share_by_month = PL_cost_by_month/total_cost_by_month

# remove 2003-12 and reset index
PL_cost_share_by_month = PL_cost_share_by_month[1:].reset_index()

# create month column
PL_cost_share_by_month['month'] = range(1,13)

# set month as index
PL_cost_share_by_month = PL_cost_share_by_month.set_index('month')

print(PL_cost_share_by_month)

# In[]
PL_cost_share_by_month.to_csv("PL_cost_share.csv", sep='\t')

[SQL code]
DROP TABLE IF EXISTS tb6;
CREATE TEMPORARY TABLE tb6
    SELECT T1.TC_id_1, T1.total_price_paid_at_TC_prod_id as PL_cost_by_trip
    FROM (SELECT TC_id as TC_id_1, total_price_paid_at_TC_prod_id, prod_id FROM purchases) AS T1
        INNER JOIN (SELECT prod_id FROM products WHERE brand_at_prod_id = "CTL BR") AS T2
        ON T1.prod_id = T2.prod_id
    GROUP BY T1.TC_id_1;

select * from tb6;

DROP TABLE IF EXISTS tb7
CREATE TEMPORARY TABLE tb7
    SELECT month, SUM(PL_cost_by_trip) as PL_monthly_cost
    FROM tb6 AS T1
        INNER JOIN (SELECT TC_id, SUBSTR(TC_date, 3, 5) as month FROM trips) AS T2
        ON T1.TC_id = T2.TC_id
    GROUP BY T2.month
    ORDER BY T2.month;

DROP TABLE IF EXISTS tb8
CREATE TEMPORARY TABLE tb8;
    SELECT SUBSTR(TC_date, 3, 5) as month,
           SUM(TC_total_spent) as total_monthly_cost 
    FROM trips
    GROUP BY month
    ORDER BY month;

DROP TABLE IF EXISTS tb9
CREATE TEMPORARY TABLE tb9;
    SELECT T1.month,
           round(T1.PL_monthly_share/T2.total_monthly_cost,2) as PL_monthly_ratio
    FROM tb7 as T1
    INNER JOIN tb8 as T2
    ON T1.month = T2.month;


-- 3-3-iii. Cluster households in three income groups, Low, Medium and High. Report the average monthly expenditure on grocery. Study the % of private label share in their  monthly  expenditures.  Use  visuals  to  represent  the  intuition  you  are suggesting. 
[Python Code]
# In[] final result for c-3-iii
# define income level for total expenditure
low_income    =  merge_1.hh_income < 20
medium_income = (merge_1.hh_income > 20) & (merge_1.hh_income < 27)
high_income   =  merge_1.hh_income == 27

# define income level for Private Label expenditure
low_income_PL    =  merge_PL_only.hh_income < 20
medium_income_PL = (merge_PL_only.hh_income > 20) & (merge_1.hh_income < 27)
high_income_PL   =  merge_PL_only.hh_income == 27

# In[] total monthly expenditure BY INCOME LEVEL

# low income
low_sumcost_by_hh_month = merge_1.loc[low_income].groupby(['hh_id','month'])['TC_total_spent'].sum()
low_avgcost_by_month = low_sumcost_by_hh_month.groupby('month').mean()
low_avgcost_by_month = low_avgcost_by_month.reset_index().rename(columns={"month":"month","TC_total_spent":"low_income"}).set_index("month")
print(low_avgcost_by_month)

# medium income
medium_sumcost_by_hh_month = merge_1.loc[medium_income].groupby(['hh_id','month'])['TC_total_spent'].sum()
medium_avgcost_by_month = medium_sumcost_by_hh_month.groupby('month').mean()
medium_avgcost_by_month = medium_avgcost_by_month.reset_index().rename(columns={"month":"month","TC_total_spent":"medium_income"}).set_index("month")
print(medium_avgcost_by_month)

# high income
high_sumcost_by_hh_month = merge_1.loc[high_income].groupby(['hh_id','month'])['TC_total_spent'].sum()
high_avgcost_by_month = high_sumcost_by_hh_month.groupby('month').mean()
high_avgcost_by_month = high_avgcost_by_month.reset_index().rename(columns={"month":"month","TC_total_spent":"high_income"}).set_index("month")
print(high_avgcost_by_month)

# merge tables
total_monthly_expenditure = pd.merge(low_avgcost_by_month, medium_avgcost_by_month, how="inner", on="month")
total_monthly_expenditure = pd.merge(total_monthly_expenditure, high_avgcost_by_month, how="inner", on="month")
total_monthly_expenditure = total_monthly_expenditure.drop("03-12")

# adust final table
total_monthly_expenditure = total_monthly_expenditure.reset_index().drop(columns="month")
total_monthly_expenditure['month'] = range(1,13)
total_monthly_expenditure          = total_monthly_expenditure.set_index("month")
print(total_monthly_expenditure)

# In[] save file
total_monthly_expenditure.to_csv("total_monthly_expenditure.csv", sep="\t")

# In[] PL monthly expenditure BY INCOME LEVEL
# low income
low_PL_sumcost_by_trip     = merge_PL_only.loc[low_income_PL].groupby(['hh_id','month','TC_id'])['total_price_paid_at_TC_prod_id'].sum()
low_PL_sumcost_by_hh_month = low_PL_sumcost_by_trip.groupby(['hh_id','month']).sum()
low_PL_avgcost_by_month = low_PL_sumcost_by_hh_month.groupby('month').mean()
low_PL_avgcost_by_month = low_PL_avgcost_by_month.reset_index().rename(columns={"month":"month","total_price_paid_at_TC_prod_id":"low_income"}).set_index("month")
print(low_PL_avgcost_by_month)

# medium income
medium_PL_sumcost_by_trip     = merge_PL_only.loc[medium_income_PL].groupby(['hh_id','month','TC_id'])['total_price_paid_at_TC_prod_id'].sum()
medium_PL_sumcost_by_hh_month = medium_PL_sumcost_by_trip.groupby(['hh_id','month']).sum()
medium_PL_avgcost_by_month = medium_PL_sumcost_by_hh_month.groupby('month').mean()
medium_PL_avgcost_by_month = medium_PL_avgcost_by_month.reset_index().rename(columns={"month":"month",'total_price_paid_at_TC_prod_id':"medium_income"}).set_index("month")
print(medium_PL_avgcost_by_month)

# high income
high_PL_sumcost_by_trip     = merge_PL_only.loc[high_income_PL].groupby(['hh_id','month','TC_id'])['total_price_paid_at_TC_prod_id'].sum()
high_PL_sumcost_by_hh_month = high_PL_sumcost_by_trip.groupby(['hh_id','month']).sum()
high_PL_avgcost_by_month    = high_PL_sumcost_by_hh_month.groupby('month').mean()
high_PL_avgcost_by_month    = high_PL_avgcost_by_month.reset_index().rename(columns={"month":"month",'total_price_paid_at_TC_prod_id':"high_income"}).set_index("month")
print(high_PL_avgcost_by_month)

# merge tables
PL_monthly_expenditure = pd.merge(low_PL_avgcost_by_month, medium_PL_avgcost_by_month, how="inner", on="month")
PL_monthly_expenditure = pd.merge(PL_monthly_expenditure, high_PL_avgcost_by_month, how="inner", on="month")
PL_monthly_expenditure = PL_monthly_expenditure.drop("03-12")

# In[]
# adust final table
PL_monthly_expenditure          = PL_monthly_expenditure.reset_index().drop(columns="month")
PL_monthly_expenditure['month'] = range(1,13)
PL_monthly_expenditure          = PL_monthly_expenditure.set_index("month")
print(PL_monthly_expenditure)

# In[] save file
PL_monthly_expenditure.to_csv("PL_monthly_expenditure.csv", sep="\t")
# In[]
PL_monthly_ratio                = PL_monthly_expenditure/total_monthly_expenditure
print(PL_monthly_ratio)

# In[] save file
PL_monthly_ratio.to_csv("PL_monthly_ratio.csv", sep="\t")

[SQL code]
DROP TABLE IF EXISTS tb10;
# total cost
CREATE TEMPORARY TABLE tb10
    SELECT T1.hh_id, T1.income_level, T2.TC_id_2, month, TC_total_spent
    FROM (SELECT hh_id,
                 1 * (hh_income < 20) +
                 2 * (hh_income > 20 and hh_income < 27) +
                 3 * (hh_income > 26)
                 AS income_level
         FROM households) AS T1
    LEFT JOIN
        (SELECT hh_id, TC_id as TC_id_2, SUBSTR(TC_date,3,5) as month, TC_total_spent FROM trips) AS T2
    ON T1.hh_id = T2.hh_id;

# PL cost by income level
DROP TABLE IF EXISTS tb11;
CREATE TEMPORARY TABLE tb11
    SELECT hh_id,
           income_leveL,
           month,
           TC_id_2 as TC_id, SUM(TC_total_spent) as sum_total,
           SUM(PL_cost_by_trip) as sum_PL
    FROM tb10 as T1
    LEFT JOIN tb6 as T2
    ON T1.TC_id_2 = T2.TC_id_1
    GROUP BY income_level, hh_id, month;

DROP TABLE IF EXISTS tb12;
CREATE TEMPORARY TABLE tb12
    SELECT *, sum_PL/sum_total as PL_share FROM tb11;



DROP TABLE IF EXISTS tb13;
CREATE TEMPORARY TABLE tb13
    SELECT income_level,
           month,
           AVG(sum_total) as avg_total,
           AVG(sum_PL) as avg_PL,
           AVG(PL_share) as avg_PL_share
    FROM tb12
    GROUP BY income_level, month
    ORDER BY income_level, month;


DROP TABLE IF EXISTS tb14;
    CREATE TEMPORARY TABLE tb14
        SELECT month as month_1,
               avg_total as low_total,
               avg_PL as low_PL,
               avg_PL_share as low_PL_share from tb13 WHERE income_level=1;

DROP TABLE IF EXISTS tb15;
    CREATE TEMPORARY TABLE tb15
        SELECT month as month_2,
               avg_total as medium_total,
               avg_PL as medium_PL,
               avg_PL_share as medium_PL_share from tb13 WHERE income_level=2;

DROP TABLE IF EXISTS tb16;
    CREATE TEMPORARY TABLE tb16
        SELECT month as month_3,
               avg_total as high_total,
               avg_PL as high_PL,
               avg_PL_share as high_PL_share from tb13 WHERE income_level=3;

DROP TABLE IF EXISTS tb17;
    CREATE TEMPORARY TABLE tb17
        SELECT T1.month_1 as month,
               low_total,
               medium_total,
               high_total,
               low_PL,
               medium_PL,
               high_PL,
               low_PL_share,
               medium_PL_share,
               high_PL_share
        FROM tb14 AS T1
        INNER JOIN tb15 AS T2 ON T1.month_1 = T2.month_2
        INNER JOIN tb16 AS T3 ON T2.month_2 = T3.month_3
        ORDER BY T1.month_1 LIMIT 12 OFFSET 1;


SELECT * FROM tb17;

