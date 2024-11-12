/*=========================================================================================================================
We will develop a project for a "fictional Online Retail company",
This project will cover creating database,tables and indexes,inserting data and writing queries for reporting and analysis.
===========================================================================================================================

Project Overview: Fictional Online Retail Company.
-------------------------------------------------------------------------------------------------------------------------
A. Database design
    ----database name:OnlineretailDB
B. Tables:
    ---Customers: Stores customer details.
	---Product: Stores product details.
	---Orders: Stores order details.
	---OrderItems: Stores details of each items in an order
	---Categories: Stores product categories.

C. Insert Sample data
   ---Populate each table with sample data.

D.  Write quries
    ----Retrive data(e.g. customer order,popular product)
	----Perform aggregations(e.g.total sales avg order)
	----Join tables for comprehensive reports.
	----Use subqueries and common table exepression(CTEs)
	*/
	/* Lets get started*/
----Create database
create database OnlineRetailDB;
GO
----Use database
use OnlineRetailDB;
GO
----Create the Customer table
create table Customers
(
 CustomerId int primary key identity(1,1),
 FirstName nvarchar(50),
 LastName nvarchar(50),
 Email nvarchar(100),
 PhoneNO nvarchar(50),
 Address nvarchar(100),
 City nvarchar(50),
 State nvarchar(50),
 ZipCode nvarchar(50),
 Country nvarchar(50),
 Atdate datetime default getdate()
);
GO
-----Create Product table;
create table Products(
  ProductId int primary key identity(1,1),
  ProductName nvarchar(100),
  CategoryId int,
  Price decimal(10,2),
  Stock int,
  CreatedAt datetime default getdate()
);
GO
------Create the category table
create table Categories(
  CategoryId int primary key identity(1,1),
  CategoryName nvarchar(100),
  Description nvarchar(250)
);
GO
----Create the Orders  table
create table Orders(
 OrderId int primary key identity(1,1),
 CustomerId int,
 Orderdate datetime default getdate(),
 Totalamount decimal(10,2),
 foreign key (CustomerId) references Customers(CustomerId)
);
GO
----Create tablel OrderItems
create table OrderItems(
 OrderItemId int primary key identity(1,1),
 OrderId int,
 ProductId int,
 Quantity int,
 Price decimal(10,2),
 foreign key (Productid) references Products(ProductId),
 foreign key (OrderId) references Orders(OrderId)
);
GO
---Insert sample data into category table
insert into Categories(CategoryName,Description) 
values
('Electronics','Devices and Gadgets'),
('Clothings','Apparel and Accessories'),
('Books','Printed and Electronic books');
GO
---Insert sample data into Product table
insert into Products(ProductName,CategoryId,Price,Stock)
values
('Smartphone',1,699,50),
('Laptop',1,999.99,30),
('T-Shirt',2,19.99,100),
('Jeans',2, 49.99,60),
('Fiction Novels',3,14.99,200),
('Science Journal',3,29.99,150);
GO
---Insert sample data into Customers table
insert into Customers(FirstName,LastName,Email,PhoneNO,Address,City,State,ZipCode,Country)
values
('Ishwar','Panchariya','ishwarpanchariya160@gmail.com','123-456-7890','123 Els St.','Springfield','IL','62701','USA'),
('Sameer','Khanna','khannasameer160@gmail.com','123-456-7890','123 Els St.','Springfield','IL','62701','USA'),
('Jane','Smith','janesmith@gmail.com','234-567-8990','456 Oak St.','Madison','WI','53703','USA'),
('Harshad','Patel','harshadpatel@gmail.com','345-678-9012','789 Dala St.','Mumbai','aharshtra','41550','Indai');
GO
----insert sample data into Orders table
insert into  Orders(CustomerID,Orderdate,Totalamount) values
(1,getdate(),719.98), 
(2,getdate(),49.99),
(3,getdate(),719.98);
GO
----Insert sample data into OrderItems
insert into OrderItems(OrderId,ProductId,Quantity,Price) values
(1,1,1,699.99),(1,3,1,19.99),(2,4,1,49.99),(3,5,1,14.99),(3,6,1,29.99);
GO
--Query 1: retrive all orders for a specific customer
select o.OrderId,o.OrderDate,o.Totalamount,oi.ProductId,p.ProductName,oi.Quantity,oi.Price
from Orders o join OrderItems oi on o.OrderId=oi.OrderId join Products p on oi.Productid=p.ProductId where o.CustomerId=1;
GO
--Query 2: find the total sales for each product
select p.ProductId,p.ProductName,sum(oi.Quantity*oi.Price) as totalSales
from OrderItems oi
join Products p
on oi.ProductId = p.ProductId
group by p.ProductId,p.ProductName
order by TotalSales desc;
GO
--Query 3: Calculate the average order value
select avg(Totalamount) as AverageOrderValue from Orders;
GO
--Query 4: List the top 5 customer by total spending
select CustomerId,FirstName,LastName,TotalSpending,rn
from
 (select c.CustomerId,c.FirstName,c.LastName,sum(o.totalamount) as TotalSpending,row_number() over(order by sum(o.totalamount) desc) as rn
 from Customers c join Orders o on c.CustomerId= o.CustomerId 
 group by c.CustomerId,c.FirstName,c.LastName)
 sub where rn<=5;
 GO
--Query 5: Retrive most popular Product category
select CategoryId,CategoryName,TotalQuantitySold,rn
from
(select c.CategoryId,c.CategoryName,sum(oi.quantity) as TotalQuantitySold,
 row_number() over(order by sum(oi.quantity) desc) as rn
 from OrderItems oi
 join Products p
 on oi.ProductId = p.productId
 join  Categories c
 on p.CategoryId= c.categoryId
 group by c.CategoryId,c.CategoryName) sub where rn =1 ;
 Go
--inserting a product with zero stock
insert into Products(ProductName,CategoryId,Price,Stock)
values('Keyboard',1,39.99,0);
go
--Query 6: List all the products that are out of stock
select* from Products where Stock=0;
----with category name
select p.ProductId,p.ProductName,c.CategoryName,Stock
from Products p join Categories c
on p.CategoryId= c.CategoryId
where stock=0;
Go
--Query 7: Find the customers who placed order in last 30 days
select c.customerId,c.firstName,c.LastName,c.Email,c.PhoneNo from Customers c join Orders o
on c.customerId=o.customerId
where o.Orderdate>= Dateadd(Day,-30,getdate());
GO
--Query 8: Calculate total numbers of orders placed each year
select Year(OrderDate) as OrderYear,Month(OrderDate) as OrderMonth,Count(OrderId) as TotalOrders from Orders
Group by Year(OrderDate),Month(OrderDate)
Order by OrderYear,OrderMonth;
GO
--Query 9: Retrive the details of most recent order
select top 1 o.OrderId,o.OrderDate,o.Totalamount,c.FirstName,c.LastName
from Orders o join Customers c
on o.CustomerId = c.CustomerId
order by o.OrderDate desc;
GO
--Query 10: Fing average price of products in each category
--FYR: Query 6
--select p.ProductId,p.ProductName,c.CategoryName,p.Stock from Products p join Categories c
--On p.ProductId = c.CategoryId
--where p.Stock=0;
select c.categoryId,c.CategoryName,avg(p.Price) as AveragePrice
from Categories c join Products p
on c.CategoryId = p.ProductId
group by c.CategoryId,c.CategoryName;
GO
--Query 11: List customers who have never placed an Order
select c.CustomerId,c.FirstName,c.LastName,c.Email,c.PhoneNo,o.Totalamount,o.OrderId
from Customers c full join Orders o
On c.CustomerId = o.CustomerId
where o.OrderId is NULL;
Go
--Query 12: Retrive the total quantity sold for each product
select p.ProductId,p.ProductName,sum(oi.Quantity) as TotalQuantity
from OrderItems oi join Products p
on oi.ProductId = p.ProductId
group by p.ProductId,p.ProductName
order by ProductName;
Go
--Query 13: calculate total revnue generated by  each category
select c.CategoryId,c.CategoryName,sum(oi.Quantity*oi.Price) as TotalRevenue
from OrderItems oi join Products p
on oi.ProductId=p.ProductId
join Categories c
on c.CategoryId = p.CategoryId
group by  c.CategoryId,c.CategoryName
order by TotalRevenue desc;
Go
--Query 14: find highest Priced product in each category
select c.CategoryId,c.CategoryName,p1.ProductId,p1.ProductName,p1.Price
from Categories c join Products p1
on c.CategoryId= p1.CategoryId
where p1.Price= (select max(Price) from Products p2 where p2.CategoryId = p1.CategoryId)
order by p1.Price desc;
GO
--Query 15: Retrive Orders with a total amount greater than a specific value(e.g.$500)
select o.OrderId, o.CustomerId,c.FirstName,c.LastName,o.Totalamount
from Orders o join Customers c
on o.CustomerId = c.CustomerId
where o.Totalamount>=49.9
order by o.Totalamount desc;
Go
--Query 16: List the Products along with the number of orders they appear in
select p.ProductId,p.ProductName,count(oi.OrderId) as Ordercount
from Products p join OrderItems oi 
on p.ProductId = oi.ProductId
group by p.ProductId,p.ProductName
order by Ordercount desc;
GO
--query 17: find out top 3 frequently ordered products
select top 3 p.productId,p.ProductName,count(oi.OrderId) as Ordercount
from Products p join OrderItems oi 
on oi.productId = p.productId
group by p.productId,p.ProductName
order by Ordercount desc;
GO
--Query 18: Calculate total numbers of customers from each country
select Country,count(CustomerId) as totalcustomers
from Customers group by country  order by totalcustomers desc;
GO
--Query 19: Retrive the list of customers along with their total spending
select c.CustomerId,c.FirstName,c.LastName,sum(o.Totalamount) as Totalspending
from Customers c join Orders o
on c.customerId = o.customerId
group by c.CustomerId,c.FirstName,c.LastName;
Go
--Query 20:List the orders more than specified numbers of items(e.g. 1)
select o.OrderId,c.CustomerId,c.firstName,c.LastName,count(oi.OrderItemId) as NumbersofItems
from Orders o join OrderItems oi
on o.OrderId= oi.OrderId
join Customers c
on o.customerId= c.CustomerId
group by o.OrderId,c.CustomerId,c.firstName,c.LastName
having count(oi.OrderId)>2
order by NumbersofItems;
GO
