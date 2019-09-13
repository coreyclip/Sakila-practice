# Sakila-practice: An Introduction to SQL

SQL which stands for **S**tructured **Q**uery **L**anguage and a way to query a database, in a structured manner.
SQL Databases are **tabular** in nature meaning that they are represented as collections of spreadsheets where each row represents one record with each column recording an attribute of that record. The most straight forward and common way of interfacing with a SQL database is to use a program like [MySQL Workbench](https://dev.mysql.com/doc/workbench/en/) which is available for mac and windows. While there are a variety of SQL dialects (MySQL, MS Access, etc) the variations are slight and most operations work in a nearly identical manner. For the purposes of this demonstration we'll be working with MySQL.

MySQL Workbench comes with the Sakila database, which is a sample database purpose built to demonstrate how to use SQL.
[information on the sakila database here](https://dev.mysql.com/doc/sakila/en/)

[Sakila installation](https://dev.mysql.com/doc/sakila/en/sakila-installation.html)

If you’re on a PC and used MySQL Installer to install MySQL, you may already have the Sakila database loaded. Before you do anything else, open MySQL workbench and examine the list of databases loaded on your computer:

![list of databases](Images/list_of_databases.png)

## SELECT \* FROM

```sql
USE Sakila;

SELECT first_name, last_name FROM actor;
```

Nearly every SQL query begins with a SELECT ... FROM statement.

- everything after the SELECT statement and before the FROM statement are columns that you want to get **from** the table **actor** in this case we are getting the _columns first_name_ and _last_name_

Typically when constructing a query you start with this frame work in mind

```sql

USE <database>;

SELECT <column>, <column>,.. FROM <table within database>

```

- `USE sakila;` simply tells the SQL server that you are working with tables from sakila. The semi-colon: `;` tells sql that a given command is complete. For right now you'll just be placing one after `USE sakila;` but it's good practice to get into the habit of ending any complete sql execution with a semi-colon.

Instead of using `USE sakila;` we could have used the query

```sql
SELECT first_name, last_name FROM sakila.actor
```

which specifies to SQL within the query which database to draw from. Without it our sql query will return an error because it doesn't know where actor is coming from.

## Formatting our results

Adding formatting to SQL query results happens within the `SELECT` Statement

```sql
USE sakila;

SELECT UPPER(CONCAT(first_name,' ', last_name)) AS 'Actor Name' FROM actor LIMIT 10;
```
Note: LIMIT simply restricts the number of results a query returns, in this case only the first 10 records
+---------------------+
| Actor Name          |
+---------------------+
| PENELOPE GUINESS    |
| NICK WAHLBERG       |
| ED CHASE            |
| JENNIFER DAVIS      |
| JOHNNY LOLLOBRIGIDA |
| BETTE NICHOLSON     |
| GRACE MOSTEL        |
| MATTHEW JOHANSSON   |
| JOE SWANK           |
| CHRISTIAN GABLE     |
+---------------------+
This query returns our actors' first and last names together as one column called `Actor Name` and makes them upper case.

- `CONCAT` takes in any number of columns or variables and joins them all together into one string.
- `UPPER` is a function that transforms strings passed to it into upper case letters.
- `AS` this tells SQL how to rename a selection when outputted, this is incredibly handy as by default SQL outputs a selection by whatever you declared in the SQL script. So the above would have outputed a column label: `UPPER(CONCAT(first_name,' ', last_name))` But with `AS` we can label our query outputs into something more concise and human readable.

Here's another common case where you'd want to format a query output

```sql
SELECT
    CONCAT('$',amount) AS 'Payment Amount',
    DATE_FORMAT(payment_date,"%d/%m/%Y") AS 'Payment Date'
FROM sakila.payment LIMIT 10;
```

Typically we store monetary values in SQL databases as floating point numbers and don't keep '$' symbols in our database, as doing so would convert our numbers into strings and then we wouldn't be able to do numerical operations on them! But for situations like financial reporting those '$' are commonly requested. So it's best practice to just bring them in with a `CONCAT` function.

`Concat` is used to connect two items together
`DATE_FORMAT` alters how dates are ouputted in SQL. They function like this:
`DATE_FORMAT(<date column>, <format mask>)` the format mask is usually composed of % followed by some abbreviation of a time value. Most are intutive, `%d/%m/%Y` transforms a date to the format DD/MM/YYYY. You can get a comprehensive break down of different format masks [here](https://www.w3schools.com/sql/func_mysql_date_format.asp)

## Filtering Query Results

Working with a SQL database it's not going to be long before you get a request for only a subset of a table rather than whole columns. The most straight forward way of doing this is with `WHERE` statements that come after the `FROM` Statements of our queries

```Sql
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';
```
+----------|------------|-----------+
| actor_id | first_name | last_name |
+----------|------------|-----------+
|        9 | JOE        | SWANK     |
+----------|------------|-----------+

This will return rows **if and only if** the column value first_name holds the value 'Joe'

This will return every row, _except_ rows that have a first_name column value 'Joe'

```Sql
SELECT actor_id, first_name, last_name FROM actor WHERE first_name != 'Joe';
```

With numerical values you can additionally use the operators

- less than '<'
- greater than '>'
- lesser or equal to '>='
- greater or equal to '<='

That would look something like this

```sql
SELECT * FROM payment WHERE amount >= 11;
```
Additionally with string columns we can use the keyword `LIKE` and what is called a wildcard with `WHERE` to approximate the values we want returned. In SQL wildcards are indicated as '%'

```sql
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%GEN%';
```
+----------|------------|----------------+
| actor_id | first_name | last_name |
+----------|------------|----------------+
|       14 | VIVIEN     | BERGEN    |
|       41 | JODIE      | DEGENERES |
|      107 | GINA       | DEGENERES |
|      166 | NICK       | DEGENERES |
+----------|------------|-----------------+
The above query returns rows in the actor table where the last_name column values have _GEN_ somewhere in the last_name value. We would get values like this:

```table
VIVIEN	BERGEN
JODIE	DEGENERES
GINA	DEGENERES
NICK	DEGENERES
```

The wildcard %GEN% matches any character beginning or ending around the values GEN. The existance of a % tells SQL to match any character in that location

Try out the following patterns to get a feel for what wildcards do.

Only last names starting with 'A'

```sql
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE 'A%';
```

Only last names ending with 'T'

```sql
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%T';
```

Say you want to filter by more than one condition, that where you could start using the `AND` keyword

```sql
SELECT first_name, last_name FROM actor WHERE last_name LIKE '%GEN%'
AND first_name LIKE 'J%';
```

This will only return rows where the last name matches the pattern %GEN% **and** the first name matches 'J%' (starts with 'J')

The keyword `OR` behaves exactly as you may expect. bellow we get last names starting with 'A' and 'B'

```sql
SELECT first_name, last_name FROM actor WHERE last_name LIKE 'A%'
OR last_name LIKE 'B%';
```

Note the bellow query may seem correct but is likely not doing what you actually want it to do

```sql
SELECT first_name, last_name FROM actor WHERE last_name LIKE 'A%' OR 'B%';
```
+------------|-----------+
| first_name | last_name |
+------------|-----------+
| CHRISTIAN  | AKROYD    |
| KIRSTEN    | AKROYD    |
| DEBBIE     | AKROYD    |
| CUBA       | ALLEN     |
| KIM        | ALLEN     |
| MERYL      | ALLEN     |
| ANGELINA   | ASTAIRE   |
+------------|-----------+

This won't match last names starting with B it instead is matching the pattern `LIKE 'A%'` and is confused as to what to do with 'B%'

You may want to do something like the bellow:

```sql
SELECT country_id, country from country WHERE
country = 'Afghanistan' OR 'Bangladesh' OR 'China';
```
+------------|-------------+
| country_id | country     |
+------------|-------------+
|          1 | Afghanistan |
+------------|-------------+

This will only output 'Afghanistan' instead to get the other two countries we should use `IN`

```sql
SELECT country_id, country from country WHERE
country IN('Afghanistan', 'Bangladesh','China');
```
+------------|-------------+
| country_id | country     |
+------------|-------------+
|          1 | Afghanistan |
|         12 | Bangladesh  |
|         23 | China       |
+------------|-------------+


## Joining Tables
 The concept of joining a table is what makes a MySQL and other SQL variants what we term a *relational database*. When we join two tables we are telling MySQL to link up two tables. This allows us to cross reference information across different tables which in turn lets us modularize our tables. 
 
 So instead of keeping all the addresses of our staff in a staff table and all the addresses of our stores in another we can keep on strictly staff related columns in one table and store related in another. With both of these tables containing a *foreign key* to reference a table strictly related to addresses 
 
 foreign key relationships in well designed databases can be spotted when you notice two tables with the same columns which usually have the phrase 'id' in them. 
 
 The basic anatomy of a table join will look like this 
 
 ```sql
 SELECT * FROM [table] 
 [kind of join] JOIN [other table] 
 ON [table].[foreign key column] = [other table].[foreign key column]
 ```
 
 In our Sakila database we can run the follow query as an example of a simple table join 
 ```sql
SELECT s.first_name, s.last_name, a.address
FROM staff s 
JOIN address a ON 
s.address_id = a.address_id;
```

 output: 
+------------|-----------|----------------------+
| first_name | last_name | address              |
+------------|-----------|----------------------+
| Mike       | Hillyer   | 23 Workhaven Lane    |
| Jon        | Stephens  |1411 Lillydale Drive  |
+------------|-----------|----------------------+

Joins come in three main varieties, and basically differ on how they handle missing data. 
Say for example from the above query there were staff records that don't have a corresponding
address record (missing an address_id record or the record isn't in the other table). Should SQL return the staff first_name and last_name and leave the address line blank or should it leave the address line blank?

* LEFT JOIN: retains the table to the left of the join. In the above example it would retain the staff records 
* RIGHT JOIN: retains the table to the right of the join. In the above example it would retain the address records
* INNER JOIN: retains only records shared by both tables. So in the above example only records with an address_id in both tables would be included in the final result set. 

In most cases, if the database has complete records the kind of join you use won't make much of a difference. But designing your queries to start with the table you want to retain all the records from and join tables of lesser importance later on with LEFT JOINS 

## Aggregation Functions and Group By 
SQL has a wide variety of functions for aggregating data like excel. SUM, AVG, MAX, MIN, COUNT all operate as expected. 
```sql
SELECT SUM(payment.amount) AS 'Total Payments After 2006' FROM payment
WHERE payment_date >= '2006-01-01';
```
+-------------------------------+
| Total Payments After 2006 |
+-------------------------------+
|                    514.18 |
+-------------------------------+

Say you wanted to summarize the average sale amount by store. Joining and including the store table the ordinary way will yield an error if left unmodified. What you need to do is specify GROUP BY constraints within your query. See the following: 
```sql
SELECT address.address, AVG(payment.amount) AS 'Average Payments' FROM payment
LEFT JOIN customer on customer.customer_id = payment.customer_id
LEFT JOIN store on store.store_id = customer.store_id
LEFT JOIN address on address.address_id = store.address_id
GROUP BY address.address;
```
+--------------------|----------------------------------+
| address            |          Average Payments  |
+--------------------|----------------------------------+
| 28 MySQL Boulevard |                  4.165866 |
| 47 MySakila Drive  |                  4.229712 |
+--------------------|----------------------------------+

The above query returns the Average payment amount *by store address*, MySQL knew to break it down in this manner because the address column in the address table has been fed into the GROUP BY statement. also note above how we Join multiple tables above, there really isn't any limit to the number of joins you can make in a single query, though things can get confusing if you take it to far. 

You can GROUP BY multiple columns like in the following:

```sql
SELECT address.address, address.district, AVG(payment.amount) AS 'Average Payments' FROM payment
LEFT JOIN customer on customer.customer_id = payment.customer_id
LEFT JOIN store on store.store_id = customer.store_id
LEFT JOIN address on address.address_id = store.address_id
GROUP BY address.address, address.district;
```
+--------------------|----------|--------------------------+
| address            | district | Average Payments |
+--------------------|----------|--------------------------+
| 28 MySQL Boulevard | QLD      |         4.165866 |
| 47 MySakila Drive  | Alberta  |         4.229712 |
+--------------------|----------|--------------------------+
## Subqueries 

Subqueries refer to queries that get their results from other queries. In other words queries that query query results. One way to think of them, is a means breaking up queries into logical steps by creating on the fly tables you want to query without actually setting them up in the database. Typically one resorts to using subqueries when a succession of WHERE statements start to contridict each other or you simply can't figure out why a specific query isn't giving you the results you want

Here's a basic simplified example.
Say you wanted to grab all of the movies from the film table that are in english yet have titles that start with the letter K 
you could acheive this with a sub query like this: 
```sql
SELECT title FROM film WHERE language_id IN 
  (SELECT language_id FROM language WHERE name = 'English')
  AND title like "K%"; 
```

A subquery is defined by ( ) with the query being placed between the paranthesis. To get an idea of what's going on here execute that inner subquery. 

```sql
  SELECT language_id FROM language WHERE name = 'English';
```
+-------------+
| language_id |
+-------------+
|           1 |
+-------------+

Basically the results of the above query acts as fill in for the IN statement in the outer query. Basically it results in a final query that's the equivalent of this:
```sql
SELECT title FROM film WHERE language_id IN 
  (1)
  AND title like "K%"; 
```

This is a very simply case of a subquery and could have been acheived via joining the language table to the film table on language_id but the basic idea carries over into real cases when you should use a subquery. 

When tackling a very complex and intricate query problem, you can start by building a simple query that fills one of your requirements and then build up from there by querying this initial query as a subquery. 

---

## Further notes

As a **declarative** programming language, we have to be very specific in what we tell SQL to do. Unlike Python or Javascript which are **imperative** languages and therefore are used to detail out to the computer what actions to perform. SQL being a **declarative** language means that you are really just asking SQL what to give you rather than what to do. The distinction may be odd to grasp but try to keep it in mind when SQL does something you didn't expect.
