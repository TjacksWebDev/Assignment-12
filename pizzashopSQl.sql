create database Pizza_Shop;

-- drop tables if they exist to make script re-runnable.
drop table if exists OrderDetails;
drop table if exists Orders;
drop table if exists Customers;
drop table if exists Pizzas;

-- creation of Customers table.
create table Customers(
	CustomerID INT AUTO_INCREMENT primary key,
    Name varchar(255) not null,
    PhoneNumber varchar(20) NOT NULL
);
    
-- creation of Pizzas Table.
create table Pizzas (
	PizzaID int auto_increment Primary Key,
    PizzaType varchar(250) not null,
    Price Decimal(5,2) not null
);

-- creation of Orders Table.
create table Orders(
	OrderID int auto_increment Primary Key,
    CustomerID int,
    OrderDateTime DateTime not null,
	Foreign Key (CustomerID) References Customers(CustomerID)
);

-- creation of OrderDetails table.
create table OrderDetails(
	OrderDetailID int auto_increment Primary Key,
    OrderID int,
    PizzaID int,
    Quantity int not null,
    Foreign Key (OrderID) References Orders(OrderID),
    Foreign Key (PizzaID) References Pizzas (PizzaID)
);

-- insert Pizzas.
insert into Pizzas(PizzaType, Price) Values
('Pepperoni & Cheese', 7.99),
('Vegetarian', 9.99),
('Meat Lovers', 14.99),
('Hawaiian', 12.99);

-- insert Customers.
insert into Customers(Name, PhoneNumber) Values
('Trevor Page', '226-555-4982'),
('John Doe', '555-555-9498');

-- insert Orders.
insert into Orders(CustomerID, OrderDateTime) Values
((Select CustomerID from Customers where Name = 'Trevor Page'),'2014-09-10 09:47:00'),
((Select CustomerID from Customers where Name = 'John Doe'), '2014-09-10 13:20:00'),
((Select CustomerID from Customers where Name = 'Trevor Page'),'2014-09-10 09:47:00'); 

-- insert OrderDetails.
insert into OrderDetails(OrderID, PizzaID, Quantity) values
(1,(Select PizzaID from Pizzas where PizzaType= 'Pepperoni & Cheese'),1),
(1,(Select PizzaID from Pizzas where PizzaType= 'Meat Lovers'),1),
(2,(Select PizzaID from Pizzas where PizzaType= 'Vegetarian'),1),
(2,(Select PizzaID from Pizzas where PizzaType= 'Meat Lovers'),2),
(3,(Select PizzaID from Pizzas where PizzaType= 'Meat Lovers'),1),
(3,(Select PizzaID from Pizzas where PizzaType= 'Hawaiian'),1);

-- total spending by each Customer.
select c.Name, SUM(p.Price * od.Quantity) AS TotalSpent
from Customers c
join Orders o on c.CustomerID = o.CustomerID
join OrderDetails od on o.OrderID = od.OrderID
join Pizzas p on od.PizzaID = p.PizzaID
group by c.Name;

-- total spending by each Customer on each date.
select c.Name, o.OrderDateTime, SUM(p.Price * od.Quantity) AS TotalSpent
from Customers c
join Orders o on c.CustomerID = o.CustomerID
join OrderDetails od on o.OrderID = od.OrderID
join Pizzas p on od.PizzaID = p.PizzaID
group by c.Name, o.OrderDateTime;
