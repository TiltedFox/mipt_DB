-- 1 task
SELECT SUM(si.UnitPrice * si.Quantity) as TotalSales
FROM sales_items as si
JOIN sales as s ON si.SalesId = s.SalesId
WHERE s.ShipCountry = 'USA' AND strftime('%Y', s.SalesDate) = '2012' AND strftime('%m', s.SalesDate) BETWEEN '01' AND '03';

SELECT SUM(UnitPrice * Quantity) as TotalSales
FROM sales_items
WHERE SalesId IN (
    SELECT SalesId
    FROM sales
    WHERE ShipCountry = 'USA' AND strftime('%Y', SalesDate) = '2012' AND strftime('%m', SalesDate) BETWEEN '01' AND '03'
);


-- 2 task
SELECT c.FirstName
FROM customers as c
LEFT JOIN employees as e ON c.FirstName = e.FirstName
WHERE e.FirstName IS NULL
GROUP BY c.FirstName;

SELECT FirstName
FROM customers
WHERE (customers.FirstName not in (
    select employees.FirstName
    from employees))
GROUP BY customers.FirstName;

SELECT FirstName
FROM customers
GROUP BY FirstName
EXCEPT 
SELECT FirstName FROM employees;


-- 3 task

-- Нет, потому что в первом случае из получившейся с помощью LEFT JOIN таблицы уберутся строки, в которых t1.column = 0.
-- А во втором - LEFT JOIN применится для строк, у которых t1.column = 0.
-- Во втором случае будет больше строк


-- 4 task
SELECT albums.Title as "Album's name", COUNT(tracks.TrackId) as 'Tracks number'
FROM albums
JOIN tracks ON albums.AlbumId = tracks.AlbumId
GROUP BY albums.AlbumId
ORDER BY COUNT(tracks.TrackId) DESC;

SELECT albums.Title as "Album's name", 
(SELECT COUNT(tracks.TrackId) 
FROM tracks 
WHERE tracks.AlbumId = albums.AlbumId) as 'Tracks number'
FROM albums
ORDER BY 'Tracks number' DESC;


-- 5 task
SELECT customers.LastName as 'Lastname', customers.FirstName as 'Name'
FROM customers
JOIN sales ON customers.CustomerId = sales.CustomerId
WHERE sales.ShipCity = 'Berlin' AND strftime('%Y', SalesDate) == '2009' AND customers.Country = 'Germany'


-- 6 task
SELECT LastName 
FROM customers 
inner join sales 
inner join sales_items on customers.CustomerId = sales.CustomerId and sales.SalesId = sales_items.SalesId 
GROUP BY LastName 
HAVING SUM(sales_items.Quantity) > 30;

SELECT (
    SELECT 
        (SELECT LastName 
        FROM customers 
        WHERE customers.CustomerId = sales.CustomerId)
        FROM sales where sales.SalesId = sales_items.SalesId
        ) as LastName 
    FROM sales_items 
    GROUP BY LastName 
    HAVING SUM(Quantity) > 30;


-- 7 task
SELECT g.Name as 'Genre', AVG(t.UnitPrice) as 'Average price'
FROM genres as g
JOIN tracks as t ON g.GenreId = t.GenreId
GROUP BY g.GenreId, g.Name;


-- 8 task
SELECT g.Name as 'Genre', AVG(t.UnitPrice) as 'Average price'
FROM genres as g
JOIN tracks as t ON g.GenreId = t.GenreId
GROUP BY g.Name
HAVING AVG(t.UnitPrice) > 1;
