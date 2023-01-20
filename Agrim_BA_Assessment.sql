create DATABASE  agrim;
create TABLE assessment(Transaction_ID varchar(30), Transaction_Date date, Product_ID int,Qty int,MRP int,Sale_Price int,Store_Number varchar(30),Customer_ID varchar(30))
select * from assessment
########################################
alter table assessment modify column Transaction_Date varchar(30);
alter table assessment modify column Sale_Price varchar(30)
alter table assessment modify column MRP varchar(30);
####################################
set SESSION sql_mode = ''
#################################
load data infile
"E:/AGRIM_Business_Analyst_Assessment.csv"
into table assessment
fields terminated by ','
enclosed by '"'
ignore 1 rows;
####################################
TRUNCATE TABLE assessment
alter table assessment add column MRP_New int after MRP;
alter table assessment add column Sale_Price_New int after Sale_Price;
#####################
update assessment set MRP_New = replace(MRP,',','')
update assessment set Sale_Price_New = replace(Sale_Price,',','')
###########################
create table agrim.assessment as select * from sales.assessment
use agrim
select * from assessment

###########################
alter table assessment drop column MRP
alter table assessment drop column Sale_Price
alter table assessment add column MRP int after MRP_New
alter table assessment add column Sale_Price int after Sale_Price_New
#########################################
update assessment set MRP = CONVERT(MRP_New, DECIMAL)
update assessment set Sale_Price = Convert(Sale_Price_New, DECIMAL)
alter table assessment drop column MRP_NEW
alter table assessment drop column Sale_Price_New

#############
select * from assessment
delete from assessment where MRP = 0
#######################
/**(1) write a query to identify how much contribution does each transaction has on overall customer spends.
Example: Transaction A contributes 5% of total spend of customer A **/

select customer_id, transaction_id, (sale_price/sum(sale_price))*100 as percentage_contribution from assessment group by customer_id;
alter TABLE assessment add column total_spend int;
select * from assessment

update assessment set total_spend = Qty*Sale_Price

create table assessment2 as select customer_id,sum(total_spend) as customer_total_spend from assessment group by customer_id;

create table assessment3 as (select assessment.* , assessment2.customer_total_spend from assessment inner join assessment2 on assessment.Customer_ID = assessment2.customer_id);

select Customer_ID, Transaction_ID, ((Qty*Sale_Price)/customer_total_spend)*100 from assessment3

select customer_id, sum(sale_price) as total_spend from assessment group by customer_id;
####################################
/*(2) write a query to identify the Total Discount given by company to each customer*/
select customer_id, sum(MRP- sale_price) as total_discount from assessment group by customer_id;

select customer_id, sum(Qty*(MRP- sale_price)) as total_discount from assessment group by customer_id;
##############################
/*(3) write a query to identify Average Daily Revenue of each store */
select Store_Number, Transaction_Date,avg(Sale_Price) as Average_Daily_Revenue from assessment group by Store_Number, Transaction_Date;

select Store_Number, Transaction_Date,avg(Qty*Sale_Price) as Average_Daily_Revenue from assessment group by Store_Number, Transaction_Date;

INSERT into assessment values('AX123256','2/2/2023',123456789,2,1500,1450,'A35','RX2222',0)

###########################################
/* (4) write a query to identify Average Daily Spend of a customer*/
select * from assessment where Store_Number = 'A35';
select customer_id from assessment where Store_Number = 'A35' and Transaction_Date = '1/1/2023';
select * from assessment where customer_id = 'RX2222'

select customer_id,avg(sale_price) from assessment group by customer_id
select customer_id, transaction_date,avg(sale_price) from assessment group by customer_id, transaction_date;
-- delete from assessment where Transaction_Date = '2/2/2023';
select customer_id, transaction_date,avg(Qty*sale_price) from assessment group by customer_id, transaction_date;








