-- create database Tys_Pizza_Shop;

-- Drop tables if they exist to make the script re-runnable
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Pizzas;

-- Creation of Customers Table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL
);

-- Creation of Pizzas Table
CREATE TABLE Pizzas (
    PizzaID INT AUTO_INCREMENT PRIMARY KEY,
    PizzaType VARCHAR(255) NOT NULL,
    Price DECIMAL(5,2) NOT NULL
);

-- Creation of Orders Table
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDateTime DATETIME NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Creation of OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    PizzaID INT,
    Quantity INT NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (PizzaID) REFERENCES Pizzas(PizzaID)
);

-- Insert Pizzas
INSERT INTO Pizzas (PizzaType, Price) VALUES 
('Pepperoni & Cheese', 7.99),
('Vegetarian', 9.99),
('Meat Lovers', 14.99),
('Hawaiian', 12.99);

-- Insert Customers
INSERT INTO Customers (Name, PhoneNumber) VALUES 
('Trevor Page', '226-555-4982'),
('John Doe', '555-555-9498');

-- Insert Orders
-- Note: Adjusted the date/time format for MySQL and corrected the second order time
INSERT INTO Orders (CustomerID, OrderDateTime) VALUES 
((SELECT CustomerID FROM Customers WHERE Name = 'Trevor Page'), '2014-09-10 09:47:00'),
((SELECT CustomerID FROM Customers WHERE Name = 'John Doe'), '2014-09-10 13:20:00'),
((SELECT CustomerID FROM Customers WHERE Name = 'Trevor Page'), '2014-09-10 09:47:00');

-- Insert OrderDetails
-- The PizzaID will be selected based on the PizzaType inserted earlier.
INSERT INTO OrderDetails (OrderID, PizzaID, Quantity) VALUES 
(1, (SELECT PizzaID FROM Pizzas WHERE PizzaType = 'Pepperoni & Cheese'), 1),
(1, (SELECT PizzaID FROM Pizzas WHERE PizzaType = 'Meat Lovers'), 1),
(2, (SELECT PizzaID FROM Pizzas WHERE PizzaType = 'Vegetarian'), 1),
(2, (SELECT PizzaID FROM Pizzas WHERE PizzaType = 'Meat Lovers'), 2),
(3, (SELECT PizzaID FROM Pizzas WHERE PizzaType = 'Meat Lovers'), 1),
(3, (SELECT PizzaID FROM Pizzas WHERE PizzaType = 'Hawaiian'), 1);

select * from orderdetails;
select * from customers;
select * from orders;

-- Q4: Total spending by each customer
SELECT c.Name, SUM(p.Price * od.Quantity) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Pizzas p ON od.PizzaID = p.PizzaID
GROUP BY c.Name;

-- Q5: Total spending by each customer on each date
SELECT c.Name, o.OrderDateTime, SUM(p.Price * od.Quantity) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Pizzas p ON od.PizzaID = p.PizzaID
GROUP BY c.Name, o.OrderDateTime;

