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

SELECT UPPER(CONCAT(first_name,' ', last_name)) AS 'Actor Name' FROM actor;
```

This query returns our actors' first and last names together as one column called `Actor Name` and makes them upper case.

- `CONCAT` takes in any number of columns or variables and joins them all together into one string.
- `UPPER` is a function that transforms strings passed to it into upper case letters.
- `AS` this tells SQL how to rename a selection when outputted, this is incredibly handy as by default SQL outputs a selection by whatever you declared in the SQL script. So the above would have outputed a column label: `UPPER(CONCAT(first_name,' ', last_name))` But with `AS` we can label our query outputs into something more concise and human readable.

Here's another common case where you'd want to format a query output

```sql
SELECT
    CONCAT('$',amount) AS 'Payment Amount',
    DATE_FORMAT(payment_date,"%d/%m/%Y") AS 'Payment Date'
FROM sakila.payment;
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
SELECT amount from payment WHERE amount >= 1
```

Additionally with string columns we can use the keyword `LIKE` and what is called a wildcard with `WHERE` to approximate the values we want returned. In SQL wildcards are indicated as '%'

```sql
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%GEN%';
```

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

This won't match last names starting with B it instead is matching the pattern `LIKE 'A%'` and is confused as to what to do with 'B%'

You may want to do something like the bellow:

```sql
SELECT country_id, country from country WHERE
country = 'Afghanistan' OR 'Bangladesh' OR 'China';
```

This will only output 'Afghanistan' instead to get the other two countries we should use `IN`

```sql
SELECT country_id, country from country WHERE
country IN('Afghanistan', 'Bangladesh','China');
```

## Joining Tables

Coming soon...

---

## Further notes

As a **declarative** programming language, we have to be very specific in what we tell SQL to do. Unlike Python or Javascript which are **imperative** languages and therefore are used to detail out to the computer what actions to perform. SQL being a **declarative** language means that you are really just asking SQL what to give you rather than what to do. The distinction may be odd to grasp but try to keep it in mind when SQL does something you didn't expect.
