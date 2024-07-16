-- 1. List the book title and retail price for all books with a retail price
-- lower than the average retail price of all books sold by JustLee Books.
SELECT
    Title,
    Retail
FROM
    Books
WHERE
    Retail < (SELECT AVG(Retail) FROM Books);

-- 2. Determine which books cost less than the average cost of other books in 
-- the same category.
SELECT
    A.Title,
    B.Category,
    A.Cost
FROM
    Books AS A,
    (
        SELECT
            Category,
            AVG(Cost) AS Averagecost
        FROM
            Books
        GROUP BY
            Category
    ) AS B
WHERE
    A.Category = B.Category
    AND A.Cost < B.Averagecost;

-- 3. Determine which orders were shipped to the same state as order 1014.
SELECT Order#
FROM Orders
WHERE
    Shipstate = (
        SELECT Shipstate
        FROM Orders
        WHERE Order# = 1014
    )
    AND Order# != 1014;

-- 4. Determine which orders had a higher total amount due than order 1008.
SELECT
    Order#,
    SUM(Quantity * Paideach) AS Totalamountdue
FROM
    Orderitems
GROUP BY
    Order#
HAVING
    SUM(Quantity * Paideach) > (
        SELECT SUM(Quantity * Paideach)
        FROM
            Orderitems
        WHERE
            Order# = 1008
    );

-- 5. Determine which author or authors wrote the books most frequently 
-- purchased by customers of JustLee Books.
SELECT
    Author.Authorid,
    Author.Lname,
    Author.Fname,
    (
        SELECT COUNT(*)
        FROM
            Orderitems
        WHERE
            Orderitems.Isbn IN (
                SELECT Bookauthor.Isbn
                FROM
                    Bookauthor
                WHERE
                    Bookauthor.Authorid = Author.Authorid
            )
    ) AS Purchasecount
FROM
    Author
ORDER BY
    Purchasecount DESC
FETCH FIRST 1 ROW ONLY;

-- 6. List the title of all books in the same category as books previously 
-- purchased by customer 1007. Don’t include books this customer has already 
-- purchased.
SELECT DISTINCT Books.Title
FROM
    Orders,
    Orderitems,
    Books
WHERE
    Orders.Order# = Orderitems.Order#
    AND Orderitems.Isbn = Books.Isbn
    AND Books.Category IN (
        SELECT DISTINCT Books.Category
        FROM
            Orders,
            Orderitems,
            Books
        WHERE
            Orders.Order# = Orderitems.Order#
            AND Orderitems.Isbn = Books.Isbn
            AND Orders.Customer# = 1007
    )
    AND Books.Isbn NOT IN (
        SELECT Isbn
        FROM
            Orderitems
        WHERE
            Order# IN (
                SELECT Order#
                FROM
                    Orders
                WHERE
                    Customer# = 1007
            )
    );

-- 7. List the shipping city and state for the order that had the longest 
-- shipping delay.
SELECT
    Order#,
    Shipcity,
    Shipstate,
    Shipdate - Orderdate AS Shippingdelay
FROM
    Orders
WHERE
    Shipdate IS NOT NULL
ORDER BY
    Shippingdelay DESC
FETCH FIRST 1 ROWS ONLY;

-- 8. Determine which customers placed orders for the least expensive book (in 
-- terms of regular retail price) carried by JustLee Books.
SELECT
    C.Customer#,
    C.LastName,
    C.FirstName
FROM
    Customers AS C
INNER JOIN
    Orders AS O
    ON C.Customer# = O.Customer#
INNER JOIN
    OrderItems AS OI
    ON O.Order# = OI.Order#
WHERE
    OI.ISBN = (
        SELECT B.ISBN
        FROM
            Books AS B
        WHERE
            B.Retail = (
                SELECT MIN(B.Retail)
                FROM
                    Books AS B
            )
    );

-- 9. Determine the number of different customers who have placed an order for 
-- books written or cowritten by James Austin.
SELECT COUNT(DISTINCT Customers.Customer#) AS Numcustomers
FROM Customers
INNER JOIN Orders ON Customers.Customer# = Orders.Customer#
INNER JOIN OrderItems ON Orders.Order# = OrderItems.Order#
WHERE OrderItems.Isbn IN (
    SELECT BookAuthor.Isbn
    FROM BookAuthor
    WHERE
        BookAuthor.AuthorID IN (
            SELECT Author.AuthorID
            FROM Author
            WHERE Author.Lname = 'AUSTIN' AND Author.Fname = 'JAMES'
        )
);

-- 10. Determine which books were published by the publisher of The Wok Way to 
-- Cook.
SELECT Title
FROM
    Books
WHERE
    Pubid = (
        SELECT Pubid
        FROM
            Books
        WHERE
            Title = 'THE WOK WAY TO COOK'
    );
