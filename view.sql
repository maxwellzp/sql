USE BD_SQLGOFF;

# Представлением называется SQL-запрос на выборку, которому присвоили имя и который затем сохранили в базе данных.
# Представления используются по нескольким причинам:
# - они позволяют сделать так, что разные пользователи базы данных будут видеть ее по разному.
# - с их помощью можно ограничить доступ к данным, разрешая пользователям видеть только некоторые из строк и столбцов
# таблицы.
# - они упрощают доступ к базе данных, показывая каждому пользователю структуру хранимых данных в наиболее подходящем
# для него виде.

# Создание представлений (CREATE VIEW)
# CREATE VIEW имя_представления (имя_столбца) AS запрос WITH CASCADE|LOCAL

# Горизонтальные представления. Разрезает исходную таблицу по горизонтали.
# Представление, показывающее информацию о служащих восточного региона.
CREATE VIEW EASTREPS AS
SELECT *
FROM SALESREPS
WHERE REP_OFFICE IN (11, 12, 13);

# Представление, показывающее информацию о служащих западного региона.
CREATE VIEW WESTREPS AS
SELECT *
FROM SALESREPS
WHERE REP_OFFICE IN (21, 22);

# Теперь каждому менеджеру по продажам можно разрешить доступ либо к представлению EASTREPS либо к представлению
# WESTREPS и одновременно запретить доступ к другому представлению, а также к таблице SALESREPS.
# Горизонтальные представления удобно применять, когда исходная таблица содержит данные, которые относятся к различным
# организациям или пользователям. Они предоставляют каждому пользователю личную таблицу, содержащую только те строки,
# которые ему необходимы.

# Представление, содержащее офисы только восточного региона.
CREATE VIEW EASTOFFICES AS
SELECT *
FROM OFFICES
WHERE REGION = 'Eastern';

# Представление для Сью Смит (идентификатор служащего 102), показывающее заказы, сделанные только ее клиентами.
CREATE VIEW SUEORDERS AS
SELECT *
FROM ORDERS
WHERE CUST IN (SELECT CUST_NUM FROM CUSTOMERS WHERE CUST_REP = 102);

SELECT * FROM SUEORDERS;

# Представление, показывающее только тех клиентов, которые в настоящий момент сделали заказы на сумму более $30 000.
CREATE VIEW BIGCUSTOMERS AS
    SELECT *
FROM CUSTOMERS
WHERE 30000.00 < (SELECT SUM(AMOUNT) FROM ORDERS WHERE CUST = CUST_NUM);

SELECT * FROM BIGCUSTOMERS;

# Вертикальные представления. Разрезает исходную таблицу по вертикали.
# Еще одним распространенным применением представлений является ограничение доступа к столбцам таблицы. Например,
# отделу, обрабатывающему заказы к учебной базе данных, для выполнения своих функций может потребоваться следующая
# информация: имя, идентификатор, служащего и офис, в котором он работает. Но отделу вовсе не обязательно знать
# плановый и фактический объекмы продаж того или иного служащего.

# Представление, показывающее избранную информацию о служащих.
CREATE VIEW REPINFO AS
    SELECT EMPL_NUM, NAME, REP_OFFICE
FROM SALESREPS;
# Разрешив отделу обработки заказов доступ к этому представлению и одновременно запретив доступ к самой таблице
# SALESREPS, можно ограничить доступ к конфиденциальной информации.

SELECT * FROM REPINFO;

# Вертикальные представления часто применяются там, где данные используются различными пользователями или группами
# пользователей. Они предоставляют каждому пользователю личную виртуальную таблицу, содержащую только те столбцы,
# которые ему необходимы.

# Для отдела обработки заказов создать представление таблицы OFFICES, которое включает в себя идентификатор офиса,
# город и регион.
CREATE VIEW OFFICEINFO AS
    SELECT OFFICE, CITY, REGION
FROM OFFICES;

SELECT * FROM OFFICEINFO;

# Представление таблицы CUSTOMERS, включающее только имена клиентов и идентификаторы закрепленных за ними служащих.
CREATE VIEW CUSTINFO AS
    SELECT COMPANY, CUST_REP
FROM CUSTOMERS;

SELECT * FROM CUSTINFO;

# Смешанные представления
# Представление, включающее идентификатор клиента, имя компании и лимит кредита для всех клиентов Билла Адамса.
# (идентификатор слудащего 105)
CREATE VIEW BILLCUST AS
    SELECT CUST_NUM, COMPANY, CREDIT_LIMIT
FROM CUSTOMERS
WHERE CUST_REP = 105;

SELECT * FROM BILLCUST;

# Сгруппированные представления
# Представление, включающее суммарные данные о заказах по каждому служащему.
CREATE VIEW ORD_BY_REP(WHO, HOW_MANY, TOTAL, LOW, HIGH, AVERAGE)
AS
SELECT REP, COUNT(*), SUM(AMOUNT), MIN(AMOUNT), MAX(AMOUNT), AVG(AMOUNT)
FROM ORDERS
GROUP BY REP;

# Отобразить имя, число заказов, общую стоимость заказов и среднюю стоимость заказа по каждому служащему.
SELECT NAME, HOW_MANY, TOTAL, AVERAGE
FROM SALESREPS, ORD_BY_REP
WHERE WHO = EMPL_NUM
ORDER BY TOTAL DESC;

# Для каждого офиса вывести на экран диапазон средних значений заказов для всех служащих, работающих в офисе.
SELECT REP_OFFICE, MIN(AVERAGE), MAX(AVERAGE)
FROM SALESREPS,
     ORD_BY_REP
WHERE EMPL_NUM = WHO
  AND REP_OFFICE IS NOT NULL
GROUP BY REP_OFFICE;

# Представление таблицы ORDERS с именами вместо идентификаторов
CREATE VIEW ORDER_INFO(ORDER_NUM, COMPANY, REP_NAME, AMOUNT) AS
SELECT ORDER_NUM, COMPANY, NAME, AMOUNT
FROM ORDERS,
     CUSTOMERS,
     SALESREPS
WHERE CUST = CUST_NUM
  AND REP = EMPL_NUM;

# Для каждого служащего отобразить на экране общую стоимость заказов по каждой компании.
SELECT REP_NAME, COMPANY, SUM(AMOUNT)
FROM ORDER_INFO
GROUP BY REP_NAME, COMPANY;

# Вывести список крупных заказов, упорядоченных по стоимости
SELECT COMPANY, AMOUNT, REP_NAME
FROM ORDER_INFO
WHERE AMOUNT > 20000.00
ORDER BY AMOUNT DESC;

# Удаление представления
DROP VIEW ORDER_INFO;

