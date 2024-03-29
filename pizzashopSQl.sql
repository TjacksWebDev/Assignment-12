create database Pizza_Shop;

-- drop tables if they exist to make script re-runnable.
drop table if exists OrderDetails;
drop table if exists Orders;
drop table if exists Customers;
drop table if exists Pizzas;

-- creation of Customers table.
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL
);
    
-- creation of Pizzas Table.
CREATE TABLE Pizzas (
    PizzaID INT AUTO_INCREMENT PRIMARY KEY,
    PizzaType VARCHAR(250) NOT NULL,
    Price DECIMAL(5 , 2 ) NOT NULL
);

-- creation of Orders Table.
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDateTime DATETIME NOT NULL,
    FOREIGN KEY (CustomerID)
        REFERENCES Customers (CustomerID)
);

-- creation of OrderDetails table.
CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    PizzaID INT,
    Quantity INT NOT NULL,
    FOREIGN KEY (OrderID)
        REFERENCES Orders (OrderID),
    FOREIGN KEY (PizzaID)
        REFERENCES Pizzas (PizzaID)
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
SELECT 
    c.Name, SUM(p.Price * od.Quantity) AS TotalSpent
FROM
    Customers c
        JOIN
    Orders o ON c.CustomerID = o.CustomerID
        JOIN
    OrderDetails od ON o.OrderID = od.OrderID
        JOIN
    Pizzas p ON od.PizzaID = p.PizzaID
GROUP BY c.Name;

-- total spending by each Customer on each date.
SELECT 
    c.Name,
    o.OrderDateTime,
    SUM(p.Price * od.Quantity) AS TotalSpent
FROM
    Customers c
        JOIN
    Orders o ON c.CustomerID = o.CustomerID
        JOIN
    OrderDetails od ON o.OrderID = od.OrderID
        JOIN
    Pizzas p ON od.PizzaID = p.PizzaID
GROUP BY c.Name , o.OrderDateTime;
