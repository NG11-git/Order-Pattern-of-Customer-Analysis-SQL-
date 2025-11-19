CREATE TABLE introtallent.swiggy (
    id INT,
    cust_id VARCHAR(20),
    order_id INT,
    partner_code INT,
    outlet VARCHAR(20),
    bill_amount FLOAT,
    order_date DATE,
    Comments VARCHAR(20)
);   
select * from introtallent.swiggy;
INSERT INTO introtallent.swiggy  VALUES
(1,'SW1005', 700, 50, 'KFC', 753, '2021-10-10', 'Door locked'),
(2,'SW1006', 710, 59, 'Pizza hut', 1496, '2021-09-01', 'In-time delivery'),
(3,'SW1005', 720, 59, 'Dominos', 990, '2021-12-10', ''),
(4,'SW1005', 707, 50, 'Pizza hut', 2475, '2021-12-11', ''),
(5,'SW1006', 770, 59, 'KFC', 1250, '2021-11-17', 'No response'),
(6,'SW1020', 1000, 119, 'Pizza hut', 1400, '2021-11-18', ''),
(7,'SW2035', 1079, 135, 'Dominos', 1750, '2021-11-19', ''),
(8,'SW1020', 1083, 59, 'KFC', 1250, '2021-12-10', ''),
(11,'SW1020', 1100, 150, 'Pizza hut', 1950, '2021-12-24', 'Late delivery'),
(9,'SW2035', 1095, 119, 'Pizza hut', 1270, '2021-11-21', 'Late delivery'),
(10,'SW1005', 729, 135, 'KFC', 1000, '2021-09-10', 'Delivered'),
(1,'SW1005', 700, 50, 'KFC', 753, '2021-10-10', 'Door locked'),
(2,'SW1006', 710, 59, 'Pizza hut', 1496, '2021-09-01', 'In-time delivery'),
(3,'SW1005', 720, 59, 'Dominos', 990, '2021-12-10', ''),
(4,'SW1005', 707, 50, 'Pizza hut', 2475, '2021-12-11', '');

# Q1: find the count of duplicate rows in the swiggy table
SELECT 
    COUNT(*) - COUNT(DISTINCT id,
        cust_id,
        order_id,
        partner_code,
        outlet,
        bill_amount,
        order_date,
        Comments) AS duplicat_rows
FROM
    introtallent.swiggy;
 # Q2: Remove Duplicate records from the table
 
CREATE TABLE introtallent.swiggy2 AS
SELECT DISTINCT *
FROM introtallent.swiggy ;
drop table introtallent.swiggy;
rename table introtallent.swiggy2 to introtallent.swiggy;

# Q3: print records from row number 4 to 9

SELECT * 
FROM (
    SELECT *, ROW_NUMBER() OVER (ORDER BY id) AS row_num
    FROM introtallent.swiggy
) AS RankedRows
WHERE row_num BETWEEN 4 AND 9;

# Q4: find latest order placed by customers.
SELECT 
    cust_id, outlet, MAX(order_date) AS latest_order
FROM
    introtallent.swiggy
GROUP BY 1 , 2;

# Q5: print order_id, partner_code, oder date,coments(No issues in place of null else comment.
 
 select order_id, partner_code, order_date, 
 (case
 when Comments ='' then 'No issues'
 else
 Comments
 end) as comments
 from introtallent.swiggy
 ;
 
# Q6: Print outlet wise order count, cumulative order count, total bill_amount, cumulative
# bill_amoun
   
   SELECT 
    a.outlet,
    a.order_cnt,
    @cum_cnt:=a.order_cnt + @cum_cnt AS cumulative_cnt,
    a.total_sale,
    @cum_sale:=a.total_sale + @cum_sale AS cummulative_sale
FROM
    (SELECT 
        outlet,
            COUNT(outlet) AS order_cnt,
            SUM(bill_amount) AS total_sale
    FROM
        introtallent.swiggy
    GROUP BY 1 ) AS a
        JOIN
    (SELECT @cum_cnt:=0, @cum_sale:=0) AS b
ORDER BY a.outlet ASC;

# Q7: Print cust_id wise, Outlet wise 'total number of orders

select cust_id ,
sum(if(outlet='kfc',1,0)) as KFC,
sum(if(outlet='Dominos',1,0)) as Dominos,
sum(if(outlet='Pizza hut',1,0)) as Pizza_Hut
from introtallent.swiggy
group by 1;

# Q8: Print cust_id wise, Outlet wise 'total sales
select cust_id ,
sum(if(outlet='kfc',bill_amount,0)) as KFC,
sum(if(outlet='Dominos',bill_amount,0)) as Dominos,
sum(if(outlet='Pizza hut',bill_amount,0)) as Pizza_Hut
from introtallent.swiggy
group by 1;