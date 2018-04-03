USE sakila;

-- 1a.
SELECT first_name, last_name FROM actor;

-- 1b.
SELECT UPPER(CONCAT(first_name,' ', last_name)) AS 'Actor Name' FROM actor;

-- 2a. 
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'Joe';

-- 2b. 
SELECT * FROM actor WHERE last_name LIKE '%GEN%';

-- 2c.
SELECT first_name, last_name FROM actor WHERE last_name LIKE '%LI%';

-- 2d. 
SELECT country_id, country from country WHERE
country IN('Afghanistan', 'Bangladesh','China');

-- 3a. 
ALTER TABLE actor
  ADD middle_name VARCHAR(50);
ALTER TABLE actor MODIFY
COLUMN middle_name VARCHAR(50) AFTER first_name;

-- 3b. 
UPDATE actor SET middle_name = 'blobs';

-- 3c. delete column middle_name
ALTER TABLE actor DROP COLUMN middle_name; 

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) FROM actor group by last_name

-- 4b. List last names of actors and the number of actors who 
-- have that last name, but only for names that are shared
-- by at least two actors

SELECT last_name, COUNT(last_name) FROM actor group by last_name
HAVING COUNT(last_name) > 2;

-- 4c. update GROUCHO WILLIAMS to HARPO WILLIAMS
UPDATE actor SET first_name = 'HARPO' WHERE first_name = 'GROUCHO'
AND last_name = 'WILLIAMS';

-- 4d. 
UPDATE actor SET first_name = 'GROUCHO' WHERE first_name = 'HARPO'
UPDATE actor SET first_name = 'MUCHO GROUCHO' WHERE first_name = 'GROUCHO';


-- 5a. 
CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;


-- 6a. 
SELECT s.first_name, s.last_name, a.address
FROM staff s 
JOIN address a ON 
s.address_id = a.address_id;

-- 6b. 
SELECT s.first_name, s.last_name, COUNT(p.staff_id) AS sales
FROM staff s 
JOIN payment p ON 
s.staff_id = p.staff_id
Group by  s.last_name;

-- 6c. List each film and the number of actors who are listed for that film. 
SELECT f.title,  COUNT(a.actor_id) AS 'number of actors'
FROM film f 
JOIN film_actor a ON 
f.film_id = a.film_id
Group by (f.title);

-- 6d. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT COUNT(f.title) AS 'inventory stock for Hunchback' 
FROM inventory i 
JOIN film f on 
f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible';

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name
SELECT CONCAT(c.first_name,' ', c.last_name) as customer,
SUM(p.amount) as payment
FROM customer c 
JOIN payment p ON
c.customer_id = p.customer_id
Group by customer 
ORDER BY customer;

-- 7a. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title FROM film WHERE language_id IN 
  (SELECT language_id FROM language WHERE name = 'English')
  AND title like "Q%" OR title like "K%"; 

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT Count(actor_id) as 'number of actors' WHERE film_id IN   
    (SELECT film_id FROM film WHERE title = 'Alone Trip')

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT CONCAT(first_name,' ', last_name) as name, email
from customer where address_id in  
  (SELECT address_id from address where city_id IN  
    (SELECT city_id from city where country_id IN
        (SELECT country_id FROM country WHERE country = 'Canada'
          ) 
        )
    );

--  7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
SELECT title FROM film WHERE film_id IN(
	SELECT film_id from film_category WHERE category_id IN(
		(SELECT category_id FROM category WHERE name = 'family')
	)
)

-- 7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(film_id) as 'rentals' FROM film WHERE film_id IN(
	SELECT film_id from inventory WHERE inventory_id IN (
		(SELECT inventory_id FROM rental)
    )
)    
GROUP BY film_id
ORDER BY COUNT(film_id) DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

