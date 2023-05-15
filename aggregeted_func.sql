USE BD_SQLGOFF;
# Функция SUM() вычисляет сумму всех значений столбца
SELECT SUM(QUOTA), SUM(SALES)
FROM SALESREPS;

# Функция AVG() вычисляет среднее всех значений столбца
SELECT AVG(PRICE)
FROM PRODUCTS
WHERE MFR_ID = 'ACI';

# Вычисление предельных значений
# Функция MIN() находит наименьшее среди всех значений столбца
# Функция MAX() находит наибольшее среди всех значений столбца
SELECT MIN(QUOTA), MAX(QUOTA)
FROM SALESREPS;

SELECT MIN(ORDER_DATE)
FROM ORDERS;

# Функция COUNT() подсчитывает количество значений, содержащихся в столбце
# Функция COUNT(*) подсчитывает количество строк в таблице результатов запроса
SELECT COUNT(CUST_NUM)
FROM CUSTOMERS;
# Функция COUNT() с переданным именем столбца не учитывает значения NULL в этом столбце.
SELECT COUNT(*)
FROM ORDERS
WHERE AMOUNT > 25000;
# На практике для подсчета строк всегда используется функция COUNT(*), а не COUNT().


# В списке возвращаемых столбцов нельзя одновременно использовать статистические функции и обычные имена столбцов (за
# исключением запросов с группировкой и подзапросов), поскольку в этом нет смысла.
SELECT NAME, SUM(SALES)
FROM SALESREPS;

# В стандарте ANSI/ISO сказано, что значения NULL статистическими функциями игнорируются.
SELECT COUNT(*), COUNT(SALES), COUNT(QUOTA)
FROM SALESREPS;

# DISTINCT с статистическими функциями
# DISTINCT удаляет повторяющиеся строки
SELECT COUNT(DISTINCT TITLE)
FROM SALESREPS;
# Ключевое слово DISTINCT в одном запросе можно употребить только один раз.
