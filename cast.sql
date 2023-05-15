USE BD_SQLGOFF;

# Выражение CAST выполняет преобразование типов
# CAST (скалярное значение) AS тип данных

# Пример 1
SELECT NAME, CAST(REP_OFFICE AS CHAR), CAST(HIRE_DATE AS CHAR)
FROM SALESREPS;

# Пример 2
SELECT PRODUCT, QTY, AMOUNT
FROM ORDERS
WHERE CUST = CAST('2107' AS INTEGER);
