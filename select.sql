USE BD_SQLGOFF;

# Проверка на принадлежность
SELECT ORDER_NUM, ORDER_DATE, MFR, PRODUCT, AMOUNT
FROM ORDERS
WHERE ORDER_DATE BETWEEN '2007-10-01' AND '2007-12-31';

# Инвертированная версия проверки на принадлежность диапазону
SELECT * FROM SALESREPS WHERE SALES NOT BETWEEN (.8 * QUOTA) AND (1.2 * QUOTA);

# A BETWEEN  B AND C
# может быть выражено через
# (A >= B) AND (A <= C)

# Проверка наличия во множестве
SELECT NAME, QUOTA, SALES FROM SALESREPS WHERE REP_OFFICE IN (11, 13, 22);

# Инвертированная версия проверки наличия во множестве
SELECT ORDER_NUM, REP, AMOUNT FROM ORDERS WHERE REP NOT IN(107, 109, 101, 103);

# X IN (A, B, C)
# может быть выражено через
# (X = A) OR (X = B) OR (X = C)

# Проверка на соответствие шаблону (LIKE)
SELECT COMPANY, CREDIT_LIMIT FROM CUSTOMERS WHERE COMPANY LIKE 'Smith% Corp';
SELECT COMPANY, CREDIT_LIMIT FROM CUSTOMERS WHERE COMPANY LIKE 'Smiths_n Corp';
SELECT COMPANY, CREDIT_LIMIT FROM CUSTOMERS WHERE COMPANY LIKE 'Smiths_n %';


# Инвертированная версия проверки на соответствие шаблону
SELECT COMPANY, CREDIT_LIMIT FROM CUSTOMERS WHERE COMPANY NOT LIKE 'Smiths_n %';

# Проверка на равенство NULL (IS NULL)
SELECT * FROM SALESREPS WHERE REP_OFFICE IS NULL;

# Инвертированная версия проверки на равенство NULL
SELECT * FROM SALESREPS WHERE REP_OFFICE IS NOT NULL;

# Сортировка результатов запроса (ORDER BY)
SELECT CITY, REGION, SALES FROM OFFICES ORDER BY REGION, CITY;
# - REGION - старший ключ, потому что идет первым
# - CITY - младший ключ, потому что идет вторым
# По умолчанию данные сортируются в порядке возрастания ASC. Чтобы сортировать их по убыванию, следует использовать DESC.
SELECT CITY, REGION, SALES FROM OFFICES ORDER BY REGION ASC, CITY DESC;
# ASC можно не указывать.

# Пример с вычисляемым столбцом. Если нет имени, то можно указать порядковый номер столбца. Использование номера столбца
# это старый способ.
SELECT CITY, REGION, (SALES - TARGET) FROM OFFICES ORDER BY 3 DESC;

# Объединение результатов нескольких запросов (UNION)
SELECT MFR_ID, PRODUCT_ID FROM PRODUCTS WHERE PRICE > 2000
UNION
SELECT DISTINCT MFR, PRODUCT FROM ORDERS WHERE AMOUNT > 30000;

# На таблицы для объединения накладываются следующие ограничения:
# - эти таблицы должны содержать одинаковое число столбцов;
# - тип данных каждого столбца первой таблицы должен совпадать с типом данных соответсвующего столбца во второй таблице.
# - ни одна из двух таблиц не может быть отсортирована с помощью ORDER BY, однако объединенные результаты запроса можно
# остортировать как обычно.

# В случае если нужно сохранить повторяющиеся строки из двух таблиц (повтор при слиянии верхнего запроса и нижнего
# запроса), то следует использовать предикат ALL
SELECT MFR_ID, PRODUCT_ID FROM PRODUCTS WHERE PRICE > 2000
UNION ALL
SELECT DISTINCT MFR, PRODUCT FROM ORDERS WHERE AMOUNT > 30000;

# UNION и сортировка
SELECT MFR_ID, PRODUCT_ID FROM PRODUCTS WHERE PRICE > 2000
UNION
SELECT DISTINCT MFR, PRODUCT FROM ORDERS WHERE AMOUNT > 30000
ORDER BY 1, 2 DESC;
# Поскольку столбцы таблицы результатов запроса на объединение не имеют имен, в этом предложении следует указывать
# номера столбцов

