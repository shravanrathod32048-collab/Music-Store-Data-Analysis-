CREATE DATABASE music_store;
USE music_store;
--- 1. Genre
CREATE TABLE Genre (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(120)
);
select * from genre;
--- 2. MediaType
CREATE TABLE MediaType (
    media_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(120)
);
select * from  MediaType;
--- 3. Employee
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(120),
    first_name VARCHAR(120),
    title VARCHAR(120),
    reports_to INT,
    levels VARCHAR(255),
    birthdate DATE,
    hire_date DATE,
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    phone VARCHAR(50),
    fax VARCHAR(50),
    email VARCHAR(100)
);
INSERT INTO Employee (
    employee_id,
    last_name,
    first_name,
    title,
    reports_to,
    levels,
    birthdate,
    hire_date,
    address,
    city,
    state,
    country,
    postal_code,
    phone,
    fax,
    email
)
VALUES (
    9,
    'Madan',
    'Mohan',
    'Senior General Manager',
    NULL,
    'L7',
    '1961-01-26',
    '2016-01-14',
    '1008 Vrinda Ave MT',
    'Edmonton',
    'AB',
    'Canada',
    'T5K 2N1',
    '+1 (780) 428-9482',
    '+1 (780) 428-3457',
    'madan.mohan@chinookcorp.com'
);
SELECT
    CONSTRAINT_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'music_store'
  AND TABLE_NAME = 'Employee'
  AND REFERENCED_TABLE_NAME IS NOT NULL;
  select * from employee;
--- 4. Artist
CREATE TABLE Artist (
    artist_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(120)
);
select * from  Artist;
--- 5. Playlist
CREATE TABLE Playlist (
    playlist_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255)
);
select * from  Playlist;
--- 6. Album
CREATE TABLE Album (
    album_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(160),
    artist_id INT,
    FOREIGN KEY (artist_id)
        REFERENCES Artist(artist_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
select * from  Album;
--- 7. Track
CREATE TABLE Track (
    track_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200),
    album_id INT,
    media_type_id INT,
    genre_id INT,
    composer VARCHAR(220),
    milliseconds INT,
    bytes INT,
    unit_price DECIMAL(10,2),

    FOREIGN KEY (album_id)
        REFERENCES Album(album_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (media_type_id)
        REFERENCES MediaType(media_type_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (genre_id)
        REFERENCES Genre(genre_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

SHOW VARIABLES LIKE 'secure_file_priv';
desc track;

LOAD DATA INFILE  'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/track.csv'
INTO TABLE  track
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(track_id, name, album_id, media_type_id, genre_id, composer, milliseconds, bytes, unit_price);

select count(track_id) from track;

select * from Track;
--- 8. Customer
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(120),
    last_name VARCHAR(120),
    company VARCHAR(120),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    phone VARCHAR(50),
    fax VARCHAR(50),
    email VARCHAR(100),
    support_rep_id INT,

    FOREIGN KEY (support_rep_id)
        REFERENCES Employee(employee_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
select * from  Customer;
--- 9. Invoice
CREATE TABLE Invoice (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    invoice_date DATE,
    billing_address VARCHAR(255),
    billing_city VARCHAR(100),
    billing_state VARCHAR(100),
    billing_country VARCHAR(100),
    billing_postal_code VARCHAR(20),
    total DECIMAL(10,2),

    FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
select * from Invoice;
--- 10. InvoiceLine
CREATE TABLE InvoiceLine (
    invoice_line_id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_id INT,
    track_id INT,
    unit_price DECIMAL(10,2),
    quantity INT,

    FOREIGN KEY (invoice_id)
        REFERENCES Invoice(invoice_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (track_id)
        REFERENCES Track(track_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
select count(invoice_id) from InvoiceLine;
select * from InvoiceLine;
--- 11. PlaylistTrack
CREATE TABLE PlaylistTrack (
    playlist_id INT,
    track_id INT,

    PRIMARY KEY (playlist_id, track_id),

    FOREIGN KEY (playlist_id)
        REFERENCES Playlist(playlist_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (track_id)
        REFERENCES Track(track_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
select count(playlist_id) from PlaylistTrack;
select * from PlaylistTrack;
SELECT 'Genre' AS table_name, COUNT(*) AS total_rows FROM Genre
UNION ALL
SELECT 'MediaType', COUNT(*) FROM MediaType
UNION ALL
SELECT 'Employee', COUNT(*) FROM Employee
UNION ALL
SELECT 'Customer', COUNT(*) FROM Customer
UNION ALL
SELECT 'Artist', COUNT(*) FROM Artist
UNION ALL
SELECT 'Album', COUNT(*) FROM Album
UNION ALL
SELECT 'Track', COUNT(*) FROM Track
UNION ALL
SELECT 'Invoice', COUNT(*) FROM Invoice
UNION ALL
SELECT 'InvoiceLine', COUNT(*) FROM InvoiceLine
UNION ALL
SELECT 'Playlist', COUNT(*) FROM Playlist
UNION ALL
SELECT 'PlaylistTrack', COUNT(*) FROM PlaylistTrack;

-- 1. Who is the senior most employee based on job title? 
SELECT
    employee_id,
    first_name,
    last_name,
    title
FROM Employee
ORDER BY levels DESC
LIMIT 1;

-- Another Method
SELECT
    employee_id,
    first_name,
    last_name,
    title,
    levels
FROM Employee
WHERE levels =
(
    SELECT MAX(levels)
    FROM Employee
);


-- Q2. Find countries having the most invoices
SELECT
    billing_country,
    COUNT(invoice_id) AS total_invoices
FROM Invoice
GROUP BY billing_country
ORDER BY total_invoices DESC;

-- Another Method
SELECT
    billing_country,
    total_invoices
FROM
(
    SELECT
        billing_country,
        COUNT(invoice_id) AS total_invoices
    FROM Invoice
    GROUP BY billing_country
) AS country_counts
ORDER BY total_invoices DESC;


-- 3. What are the top 3 values of total invoice?
SELECT
    invoice_id,
    total
FROM Invoice
ORDER BY total DESC
LIMIT 3;

-- Another Method
SELECT
    invoice_id,
    total
FROM
(
    SELECT
        invoice_id,
        total,
        RANK() OVER (ORDER BY total DESC) AS rnk
    FROM Invoice
) AS x
WHERE rnk <= 3;


-- Q4. Find the city where the store made the most money
SELECT
    billing_city,
    SUM(total) AS total_sales
FROM Invoice
GROUP BY billing_city
ORDER BY total_sales DESC
LIMIT 1;

-- Another Method
SELECT
    billing_city,
    SUM(total) AS total_sales
FROM Invoice
GROUP BY billing_city
HAVING SUM(total) =
(
    SELECT MAX(total_sales)
    FROM
    (
        SELECT
            billing_city,
            SUM(total) AS total_sales
        FROM Invoice
        GROUP BY billing_city
    ) AS city_sales
);


-- Q5. Find the customer who spent the most money
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(i.total) AS total_spent
FROM Customer c
JOIN Invoice i
    ON c.customer_id = i.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC
LIMIT 1;

-- Another Method
SELECT
    customer_id,
    first_name,
    last_name,
    total_spent
FROM
(
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(i.total) AS total_spent,
        RANK() OVER (
            ORDER BY SUM(i.total) DESC
        ) AS rnk
    FROM Customer c
    JOIN Invoice i
        ON c.customer_id = i.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
) AS customer_sales
WHERE rnk = 1;


-- Q6. Find customers who purchased Rock music
SELECT DISTINCT
    c.email,
    c.first_name,
    c.last_name,
    g.name AS genre
FROM Customer c
JOIN Invoice i
    ON c.customer_id = i.customer_id
JOIN InvoiceLine il
    ON i.invoice_id = il.invoice_id
JOIN Track t
    ON il.track_id = t.track_id
JOIN Genre g
    ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email ASC;

-- Another Method
SELECT DISTINCT
    email,
    first_name,
    last_name,
    'Rock' AS genre
FROM Customer
WHERE customer_id IN
(
    SELECT customer_id
    FROM Invoice
    WHERE invoice_id IN
    (
        SELECT invoice_id
        FROM InvoiceLine
        WHERE track_id IN
        (
            SELECT track_id
            FROM Track
            WHERE genre_id =
            (
                SELECT genre_id
                FROM Genre
                WHERE name = 'Rock'
            )
        )
    )
)
ORDER BY email;


-- Q7. Find the top 10 artists who have written the most Rock tracks
SELECT
    ar.name AS artist_name,
    COUNT(t.track_id) AS total_track_count
FROM Artist ar
JOIN Album al
    ON ar.artist_id = al.artist_id
JOIN Track t
    ON al.album_id = t.album_id
JOIN Genre g
    ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY
    ar.artist_id,
    ar.name
ORDER BY total_track_count DESC
LIMIT 10;

-- Another Method
SELECT
    ar.name AS artist_name,
    (
        SELECT COUNT(*)
        FROM Track t
        WHERE t.genre_id = (
            SELECT genre_id
            FROM Genre
            WHERE name = 'Rock'
        )
        AND EXISTS (
            SELECT 1
            FROM Album al
            WHERE al.album_id = t.album_id
              AND al.artist_id = ar.artist_id
        )
    ) AS total_track_count
FROM Artist ar
ORDER BY total_track_count DESC
LIMIT 10;


-- Q8. Find tracks longer than the average song length
SELECT
    name,
    milliseconds
FROM Track
WHERE milliseconds >
(
    SELECT AVG(milliseconds)
    FROM Track
)
ORDER BY milliseconds DESC;

-- Another Method
WITH avg_length AS
(
    SELECT AVG(milliseconds) AS average_length
    FROM Track
)
SELECT
    t.name,
    t.milliseconds
FROM Track t
CROSS JOIN avg_length a
WHERE t.milliseconds > a.average_length
ORDER BY t.milliseconds DESC;


-- Q9. Find how much each customer spent on each artist
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ar.name AS artist_name,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM Customer c
JOIN Invoice i
    ON c.customer_id = i.customer_id
JOIN InvoiceLine il
    ON i.invoice_id = il.invoice_id
JOIN Track t
    ON il.track_id = t.track_id
JOIN Album al
    ON t.album_id = al.album_id
JOIN Artist ar
    ON al.artist_id = ar.artist_id
GROUP BY
    c.customer_id,
    c.first_name,
c.last_name,
    ar.artist_id,
    ar.name
ORDER BY total_spent DESC;

-- Another Method
WITH spending AS
(
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        ar.artist_id,
        ar.name AS artist_name,
        il.unit_price,
        il.quantity
    FROM Customer c
    JOIN Invoice i ON c.customer_id = i.customer_id
    JOIN InvoiceLine il ON i.invoice_id = il.invoice_id
    JOIN Track t ON il.track_id = t.track_id
    JOIN Album al ON t.album_id = al.album_id
    JOIN Artist ar ON al.artist_id = ar.artist_id
)
SELECT
    customer_name,
    artist_name,
    SUM(unit_price * quantity) AS total_spent
FROM spending
GROUP BY customer_id, artist_id, customer_name, artist_name
ORDER BY total_spent DESC;
    
    
-- Q10. Find the most popular genre for each country
-- Include all genres when there is a tie
WITH genre_sales AS
(
    SELECT
        i.billing_country AS country,
        g.name AS genre,
        SUM(il.quantity) AS total_purchases
    FROM Invoice i
    JOIN InvoiceLine il
        ON i.invoice_id = il.invoice_id
    JOIN Track t
        ON il.track_id = t.track_id
    JOIN Genre g
        ON t.genre_id = g.genre_id
    GROUP BY
        i.billing_country,
        g.name
),
ranked_genres AS
(
    SELECT
        country,
        genre,
        total_purchases,
        DENSE_RANK() OVER
        (
            PARTITION BY country
            ORDER BY total_purchases DESC
        ) AS genre_rank
    FROM genre_sales
)
SELECT
    country,
    genre,
    total_purchases
FROM ranked_genres
WHERE genre_rank = 1
ORDER BY country;

-- Another Method
SELECT
    country,
    genre,
    total_purchases
FROM
(
    SELECT
        i.billing_country AS country,
        g.name AS genre,
        SUM(il.quantity) AS total_purchases,
        RANK() OVER (
            PARTITION BY i.billing_country
            ORDER BY SUM(il.quantity) DESC
        ) AS rnk
    FROM Invoice i
    JOIN InvoiceLine il
        ON i.invoice_id = il.invoice_id
    JOIN Track t
        ON il.track_id = t.track_id
    JOIN Genre g
        ON t.genre_id = g.genre_id
    GROUP BY
        i.billing_country,
        g.name
) AS x
WHERE rnk = 1
ORDER BY country;


-- Q11. Find the highest-spending customer for each country
-- Include all customers when there is a tie
WITH customer_spending AS
(
    SELECT
        c.country,
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(il.unit_price * il.quantity) AS total_spent
    FROM Customer c
    JOIN Invoice i
        ON c.customer_id = i.customer_id
    JOIN InvoiceLine il
        ON i.invoice_id = il.invoice_id
    GROUP BY
        c.country,
        c.customer_id,
        c.first_name,
        c.last_name
),
ranked_customers AS
(
    SELECT
        country,
        customer_id,
        customer_name,
        total_spent,
        DENSE_RANK() OVER
        (
            PARTITION BY country
            ORDER BY total_spent DESC
        ) AS customer_rank
    FROM customer_spending
)
SELECT
    country,
    customer_name,
    total_spent
FROM ranked_customers
WHERE customer_rank = 1
ORDER BY country;

-- Another Method
SELECT
    country,
    customer_name,
    total_spent
FROM
(
    SELECT
        c.country,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(il.unit_price * il.quantity) AS total_spent,
        RANK() OVER (
            PARTITION BY c.country
            ORDER BY SUM(il.unit_price * il.quantity) DESC
        ) AS rnk
    FROM Customer c
    JOIN Invoice i
        ON c.customer_id = i.customer_id
    JOIN InvoiceLine il
        ON i.invoice_id = il.invoice_id
    GROUP BY
        c.country,
        c.customer_id,
        c.first_name,
        c.last_name
) AS x
WHERE rnk = 1
ORDER BY country;