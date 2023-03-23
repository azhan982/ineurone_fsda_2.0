create or replace table aa_sales_data
(order_id varchar(25),
order_date date,
ship_date date,
ship_mode varchar(25),
customer_name varchar(25),
segment varchar(20),
state varchar(50),
country varchar(50),
market varchar(25),
region varchar(30),
product_id varchar(35),
category varchar(25),
sub_category varchar(25),
product_name varchar,
sales number,
quantity number(10,3),
discount number(10,3),
profit number(10,3),
shipping_cost number(10,3),
order_priority varchar(10),
year varchar(4));

describe table aa_sales_data;
select * from aa_sales_data;

--1 .SET PRIMARY KEY.

alter table aa_sales_data
add primary key(customer_name);

--2. CHECK THE ORDER DATE AND SHIP DATE TYPE AND THINK IN WHICH DATA TYPE YOU HAVE TO CHANGE.

-- I already changed date type in Excel.Now Changing the date type to the one I prefer.
select to_char(ORDER_DATE, 'dd-mm-yyyy') as my_order_date,to_char(ship_date, 'dd-mm-yyyy') as my_ship_date from aa_sales_data;

--3. EXTACT THE LAST NUMBER AFTER THE - AND CREATE OTHER COLUMN AND UPDATE IT.

create or replace table up_sales_data as
select substr(order_id,9) as id_number,* from aa_sales_data;

select * from up_sales_data;


--4.FLAG ,IF DISCOUNT IS GREATER THEN 0 THEN  YES ELSE FALSE AND PUT IT IN NEW COLUMN FRO EVERY ORDER ID.
select *,
         case when discount>0 then 'Yes'
         else 'False'
         end as discounted
from aa_sales_data;

--5.FIND OUT THE FINAL PROFIT AND PUT IT IN COLUMN FOR EVERY ORDER ID.

-- Ans= Already Profit column is their in data.
select sum(profit) as overall_profit from aa_sales_data;

--6.  FIND OUT HOW MUCH DAYS TAKEN FOR EACH ORDER TO PROCESS FOR THE SHIPMENT FOR EVERY ORDER ID.

create or replace view sale_data_pros as
select datediff('day',order_date,ship_date) as process_date,* from aa_sales_data;

select * from sale_data_pros;

/*7.FLAG THE PROCESS DAY AS BY RATING IF IT TAKES LESS OR EQUAL 3  DAYS MAKE 5,LESS OR EQUAL THAN 6 DAYS BUT MORE THAN 3 MAKE 4,
LESS THAN 10 BUT MORE THAN 6 MAKE 3,MORE THAN 10 MAKE IT 2 FOR EVERY ORDER ID.*/

create or replace view final_quest as
select 
      case when process_date<=3 then 5
           when process_date<=6 and process_date>3 then 4
           when process_date<=10 and process_date>6 then 3
           else 2
           end as shipment_rating,*
from sale_data_pros;
                   
select * from final_quest where shipment_rating like 3; 
