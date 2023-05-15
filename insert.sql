USE BD_SQLGOFF;

# В общем случае,в реляционной СУБД существует три способа добавления новых строк в базу данных.
# - Однострочная инструкция INSERT
# - Многострочная инструкция INSERT
# - Пакетная загрузка


# - Однострочная инструкция INSERT
INSERT INTO SALESREPS(NAME, AGE, EMPL_NUM, SALES, TITLE, HIRE_DATE, REP_OFFICE)
VALUES ('Henry Jacobson', 36, 111, 0.00, 'Sales Mgr', '2008-07-25', 13);


INSERT INTO CUSTOMERS(COMPANY, CUST_NUM, CREDIT_LIMIT, CUST_REP)
VALUES ('InterCorp', 2126, 15000, 111);

INSERT INTO ORDERS(AMOUNT, MFR, PRODUCT, QTY, ORDER_DATE, ORDER_NUM, CUST, REP)
VALUES (2340, 'ACI', '41004', 20, CURRENT_DATE, 113070, 2126, 111);

SELECT CURRENT_DATE;

# Явная вставка значений NULL
INSERT INTO SALESREPS(NAME, AGE, EMPL_NUM, SALES, QUOTA, TITLE, MANAGER, HIRE_DATE, REP_OFFICE)
VALUES ('Henry Jacobsen', 36, 111, 0.00, NULL, 'Sales Mgr', NULL, '2008-07-25', 13);

# Вставка всех столбцов
# Для удобства в SQL разрешается не включать список столбцов в инструкцию INSERT. Если список столбцов опущен, он
# генерируется автоматически и в нем слева направо перечисляются все столбцы таблицы.
INSERT INTO SALESREPS VALUES (111, 'Henry Jacobsen', 36, 13, 'Sales Mgr', '2008-07-25', NULL, NULL, 0.00);
# Очевидно, что если список столбцов опущен, то в списке значений необходимо явно указывать значения NULL. Кроме того,
# последовательность значений данных должна в точности соответствовать порядку столбцов в таблице.

# Многострочная инструкция INSERT
# Скопировать старые заказы в таблицу OLDORDERS
CREATE TABLE IF NOT EXISTS OLDORDERS
(
    ORDER_NUM INTEGER NOT NULL,
    ORDER_DATE DATE NOT NULL,
    AMOUNT DECIMAL(9,2) NOT NULL,
    PRIMARY KEY (ORDER_NUM)
);

INSERT INTO OLDORDERS(ORDER_NUM, ORDER_DATE, AMOUNT)
SELECT ORDER_NUM, ORDER_DATE, AMOUNT
FROM ORDERS
WHERE ORDER_DATE < '2008-01-01';
# 9 rows affected in 11 ms

SELECT * FROM OLDORDERS;

CREATE TABLE IF NOT EXISTS BIGORDERS
(
    AMOUNT DECIMAL(9,2) NOT NULL,
    COMPANY VARCHAR(20) NOT NULL,
    NAME VARCHAR(15)NOT NULL,
    PERF DECIMAL(9,2),
    MFR CHAR(3) NOT NULL,
    PRODUCT CHAR(5) NOT NULL,
    QTY INTEGER NOT NULL
);

INSERT INTO BIGORDERS(AMOUNT, COMPANY, NAME, PERF, PRODUCT, MFR, QTY)
SELECT AMOUNT, COMPANY, NAME, (SALES - QUOTA), PRODUCT, MFR, QTY
FROM ORDERS,
     CUSTOMERS,
     SALESREPS
WHERE CUST = CUST_NUM
  AND REP = EMPL_NUM
  AND AMOUNT > 15000;