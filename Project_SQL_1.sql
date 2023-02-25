create database foodapp;
create table foodapp.swiggy
(
id int,
cust_id varchar(10),
order_id int,
partner_code int,
outlet varchar(20),
bill_amount int,
order_date date,
comments varchar(50)
);

insert into foodapp.swiggy
values
(1,"SW1005",700,50,"KFC",753,"2021-10-10","Door locked"),
(2,"SW1006",710,59,"Pizza Hut",1496,"2021-09-01","In-time delivery"),
(3,"SW1005",720,59,"Dominos",990,"2021-12-10",null),
(4,"SW1005",707,50,"Pizza Hut",2475,"2021-12-11",null),
(5,"SW1006",770,59,"KFC",1250,"2021-11-17","No Response"),
(6,"SW1020",1000,119,"Pizza Hut",1400,"2021-11-18","In-time delivery"),
(7,"SW2035",1079,135,"Dominos",1750,"2021-12-19",null),
(8,"SW1020",1083,59,"KFC",1250,"2021-11-20",null),
(11,"SW1020",1100,150,"Pizza Hut",1950,"2021-12-24","Late delivery"),
(9,"SW2035",1095,119,"Pizza Hut",1270,"2021-11-21","Late delivery"),
(10,"SW1005",729,135,"KFC",1000,"2021-10-09","Delivered"),
(1,"SW1005",700,50,"KFC",753,"2021-10-10","Door locked"),
(2,"SW1006",710,59,"Pizza Hut",1496,"2021-09-01","In-time delivery"),
(3,"SW1005",720,59,"Dominos",990,"2021-12-10",null),
(4,"SW1005",707,50,"Pizza Hut",2475,"2021-12-11",null);

# 1) Find the count of duplicate rows in the swiggy table
	
select id, cust_id, order_id, partner_code, outlet, bill_amount, order_date, comments, count(*) from foodapp.swiggy
group by id, cust_id, order_id, partner_code, outlet, bill_amount, order_date, comments 
having count(*)>1;

# 2) Remove Duplicate records from the table
alter table foodapp.swiggy
add column temp varchar(5) after comments;
alter table foodapp.swiggy
drop column temp;
 
delete t1 from foodapp.swiggy t1
inner join foodapp.swiggy t2 
where t1.order_id>t2.order_id;

create temporary table foodapp.swiggynew as 
select max(id) as id, cust_id, order_id, partner_code, outlet, bill_amount, order_date, comments
from foodapp.swiggy
group by cust_id, order_id, partner_code, outlet, bill_amount, order_date, comments;

alter table foodapp.swiggynew 
rename column id to id;

create table foodapp.swiggynew  as
select * from foodapp.swiggynew;
select * from foodapp.swiggynew;

/*drop table foodapp.swiggynew;
select * from foodapp.swiggy;

select * from foodapp.swiggynew;
drop table foodapp.swiggynew;*/


# 3) Print records from row number 4 to 9
select id, cust_id, order_id, partner_code, outlet, bill_amount, order_date, comments from foodapp.swiggy
where id between 4 and 9
group by id, cust_id, order_id, partner_code, outlet, bill_amount, order_date, comments ;

# 4) Find the latest order placed by customers.
select distinct(cust_id) as cust_id, outlet, order_date,
rank() over(partition by cust_id order by order_date desc) as rnk
from foodapp.swiggynew;
#where clause
#use cte rank 

# 5)Print order_id, partner_code, order_date, comment (No issues in place of null else comment).
select order_id, partner_code, order_date, 
if(comments is null,"no issues",comments) as comment
from foodapp.swiggynew;

# 6) Print outlet wise order count, cumulative order count, total bill_amount, cumulative bill_amount.
select a.outlet, a.outlet_cnt, a.total_sale,
@cumulative_cnt:=@cumulative_cnt+a.outlet_cnt as cumulative_cnt,
@cumulative_sale:=@cumulative_sale+a.total_sale as cumulative_sale
from
(select outlet, 
count(outlet) as outlet_cnt, 
sum(bill_amount) as total_sale 
from foodapp.swiggynew
group by outlet) a
join 
(select @cumulative_cnt:=0, @cumulative_sale:=0) b
order by outlet asc;

select outlet, count(outlet), sum(bill_amount) from foodapp.swiggynew
group by outlet;

# 7) Print cust_id wise, Outlet wise 'total number of orders'
select cust_id, 
sum(if(outlet="KFC",1,0)) as KFC,
sum(if(outlet="Dominos",1,0)) as Dominos,
sum(if(outlet="Pizza Hut",1,0)) as Pizz_Hut
from foodapp.swiggynew group by cust_id;

# 8) Print cust_id wise, Outlet wise 'total sales.
select cust_id, 
sum(if(outlet="KFC",bill_amount,0)) as KFC,
sum(if(outlet="Dominos",bill_amount,0)) as Dominos,
sum(if(outlet="Pizza Hut",bill_amount,0)) as Pizz_Hut
from foodapp.swiggynew group by cust_id;






