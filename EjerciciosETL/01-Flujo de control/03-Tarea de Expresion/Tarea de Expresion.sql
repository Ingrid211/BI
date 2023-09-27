create database datamart1
go

use datamart1
go

use NORTHWND
go

select * from Customers

select top 0 *
into datamart1.dbo.dCustomers
from Customers

select top 0 *
into datamart1.dbo.dshippers
from Shippers

select top 0 *
into datamart1.dbo.dorders
from Orders

select * from datamart1.dbo.dCustomers

--Agregar la restrinccion de primary key a la tabla customers

alter table datamart1.dbo.dcustomers
add constraint PK_dcustomers
primary key (customerId)

--Agregar la restrinccion de primary key a la tabla shippers

alter table datamart1.dbo.dshippers
add constraint PK_dshippers
primary key (shipperId)

--Agregar la restrinccion de primary key a la tabla orders

alter table datamart1.dbo.dorders
add constraint PK_dorders
primary key (orderId)

--Agregar la restrinccion de foreing key a la tabla orders

alter table datamart1.dbo.dorders
add constraint fk_dorders
foreign key (ShipVia)
references datamart1.dbo.dshippers (shipperId)

--Agregar la restrinccion de foreing key a la tabla customers


alter table datamart1.dbo.dorders
add constraint fk_dorders_dcustomers
foreign key (customerId)
references datamart1.dbo.dcustomers (customerId)
go

create view ReporteVentas 
as
select o.OrderID, o.OrderDate,
o.EmployeeID, e.FullName, c.CompanyName,
c.City,c.Country, od.Quantity, od.UnitPrice,
od.Discount, od.Mount,p.ProductName
from Orders as o
inner join (
	select employeeid,
	CONCAT(FirstName,' ', LastName)
	as FullName 
	from Employees
)as e
on o.EmployeeID = e.EmployeeID
inner join(
select CompanyName , City, Country, CustomerID
from Customers
)as c
on o.CustomerID=c.CustomerID
inner join(
select UnitPrice, Quantity, Discount, (UnitPrice*Quantity) as
Mount, OrderID, ProductID
from [Order Details]
) as od
 on o.OrderID=od.OrderID
 inner join(
select  ProductID,ProductName from Products
) as p
on od.ProductID = p.ProductID

select * from ReporteVentas
where ProductName = 'Queso cabrales'