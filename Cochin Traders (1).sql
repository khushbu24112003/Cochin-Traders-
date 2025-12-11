#Ques1. Fetch the full name and hiring date of all Employees who work as Sales Representatives

select concat(firstname,' ',lastname) as full_name,hiredate 
 from `cochin_Traders.employees`
 where title = 'Sales Representative';

#*Ques2. Which of the products in our inventory need to be reordered?

select
productid,productname,unitsinstock,reorderlevel 
 from `cochin_Traders.products`
 where unitsinstock <= reorderlevel
 order by productid;

#*Ques3. Find and display the details of customers who have placed more than 5 orders.

select customerid,contactname,city,address from `cochin_Traders.customer`
 where customerid IN(
select customerid 
 from `cochin_Traders.orders`
 group by customerid
 HAVING COUNT(*)> 5 
);

#JOIN 
 select o.customerid,c.contactname
  from `cochin_Traders.customer` c 
  JOIN  `cochin_Traders.orders` o 
  using(customerid) 
  group by o.customerid,c.contactname 
  having count(*) > 5; 

 #cte 

 WITH orders AS (
    SELECT customerid
    FROM `cochin_Traders.orders`
    GROUP BY customerid
    HAVING COUNT(*) > 5
   ),
   cust AS (
    SELECT customerid,contactname
    FROM `cochin_Traders.customer`
    )
   SELECT c.customerid,c.contactname
   FROM cust c
   JOIN orders o
   ON c.customerid = o.customerid;

  #with single cte 
 
  WITH CustomerOrders AS(
  SELECT CustomerID    
    FROM `cochin_Traders.orders`   
    GROUP BY CustomerID   
    HAVING COUNT(*) > 5
  )
  select c.customerid, c.contactname
    FROM `cochin_Traders.customer` AS c 
    JOIN CustomerOrders AS o
    ON c.CustomerID = o.CustomerID; 

  #Question 4: An employee of ours (Margaret Peacock, EmployeeID 4) has the record of completing most orders. However, there are some customers who've never placed an order with her. Show me all such customers.


  select customerid,contactname from `cochin_Traders.customer`
    where customerid not in (
    select customerid from `cochin_Traders.orders`
    where employeeid = 4
  );

  #join 
  
  SELECT 
    c.CustomerID,
    c.ContactName
    FROM `cochin_Traders.customer` AS c
    LEFT JOIN `cochin_Traders.orders` AS o
    ON c.CustomerID = o.CustomerID
    AND o.EmployeeID = 4
    WHERE o.CustomerID IS NULL;

    
    #Question 5: The developers at Cochin Traders are testing an app that the customers will use to show orders. #In order to make sure that even the largest orders will show up correctly on the app, they'd like some samples of orders that have lots of individual line items. Display the top 10 orders with the most line items. 
    
    
    select orderid,
    count(*) as line_items
    from `cochin_Traders.orders_details`
    group by  orderid 
    order by 2 desc
    limit 10;

#Question 6: Retrieve the top 5 best-selling products on the basis of the quantity ordered. 

    
 SELECT p.ProductID,p.Productname,
    SUM(od.Quantity) AS TotalQuantitySold
 FROM `cochin_Traders.orders_details` od
 JOIN `cochin_Traders.products` p 
    ON od.ProductID = p.ProductID
  GROUP BY 
    p.ProductID, 
    p.ProductName
  ORDER BY 
    TotalQuantitySold DESC
  LIMIT 5;

#Question 7: Analyze the monthly order count for the year 1997.

 select  extract(month from orderdate) as month,
 count(*) as ordersCount 
 from `cochin_Traders.orders`
 where extract(year from orderdate) = 1997
 group by month 
 order by 2 desc; 





 