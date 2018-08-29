# Sakila-practice: An Introduction to SQL
SQL which stands for **S**tructured **Q**uery **L**anguage and a way to query a database, in a structured manner.
SQL Databases are **tabular** in nature meaning that they are represented as collections of spreadsheets where each row represents one record with each column recording an attribute of that record. The most straight forward and common way of interfacing with a SQL database is to use a program like [MySQL Workbench](https://dev.mysql.com/doc/workbench/en/) which is available for mac and windows. While there are a variety of SQL dialects (MySQL, MS Access, etc) the variations are slight and most operations work in a nearly identical manner. For the purposes of this demonstration we'll be working with MySQL. 

MySQL Workbench comes with the Sakila database, which is a sample database purpose built to demonstrate how to use SQL. 
[information on the sakila database here](https://dev.mysql.com/doc/sakila/en/)
[Sakila installation](https://dev.mysql.com/doc/sakila/en/sakila-installation.html)

If you’re on a PC and used MySQL Installer to install MySQL, you may already have the Sakila database loaded. Before you do anything else, open MySQL workbench and examine the list of databases loaded on your computer:

![list of databases](Images/list_of_databases.png)

## SELECT * FROM 

``
USE Sakila;
SELECT first_name, last_name FROM actor;
``
Nearly every SQL query begins with a SELECT ... FROM statement.
* everything after the SELECT statement and before the FROM statement are columns that you want to get **from** the table **actor** in this case we are getting the *columns first_name* and *last_name*
* ``USE sakila;`` simply tells the SQL server that you are working with tables from sakila

Instead of using ``USE sakila;`` we could have used the query 
``SELECT first_name, last_name FROM sakila.actor`` 

