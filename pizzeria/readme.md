### Описание  

Это учебный проект в рамках SQL Bootcamp от School21 (Школа программирования Сбербанка).

SQL Bootcamp в School21 представляет собой введение в язык SQL и базы данных в интенсивном формате: чтобы успешно завершить Буткемп,
необходимо выполнять проекты (на 1 проект выделяется 2 дня) и защищать свои решения перед другими студентам (по 2 проверки на каждый проект). Каждый проект содержит задания, посвященные реализации SQL-запросов для получения необходимых данных из заданной базы данных.

Система управления базами данных, используемая во время Bootcamp - PostgreSQL.

IDE, которую я использовала: DBeaver. 
В проекте DAY08 используется командная строка. 


![](https://github.com/habbena/SQL/blob/main/images/pizzeria.png)


**DAY00-DAY03**

Basic SQL syntax: use of SELECT, JOIN, UNION etc.

**DAY04**

View, Materialized View: создание, обновление, удаление    
Вывод всех представлений в схеме, процедура по удалению всех представлений в схеме


**DAY05 - DAY07**

Data Governance Policies, Database indexes, Database Sequences.

**DAY08**

Transactions and isolation levels.

**DAY09**

The task of the day is to create PostgreSQL functions to process the data.

**TEAM01**

DWH, ETL process, data with anomalies.

ex00

The task is to write a SQL statement that returns 
the total volume (sum of all money) of transactions 
from user balance aggregated by user and balance type.

ex01

The task is to write a SQL statement that returns
all Users, all Balance transactions (not including currencies that do not have a key in the Currency table) 
with currency name and calculated value of currency in USD for the nearest day.
