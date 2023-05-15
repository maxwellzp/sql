USE BD_SQLGOFF;

# Подзапросом называется запрос внутри другого запроса SQL. Результаты подзапроса используются СУБД для определения
# результатов запроса более высокогоуровня, содержащего данный подзапрос.

# Вывести список офисов, в которых плановый объем продаж превышает сумму плановых объемов продаж всех служащих
SELECT CITY
FROM OFFICES
WHERE TARGET > (SELECT SUM(QUOTA) FROM SALESREPS WHERE REP_OFFICE = OFFICE);
# Внутренний запрос (подзапрос) вычисляет для каждого офиса сумму плановых объемов продаж для всех служащих, работающих
# в данном офисе.
# Главный (внешний) запрос сравнивает план продаж офиса с полученной с полученной суммой и, в зависимости от результата
# сравнения, либо добавляет данный оффис в таблицу результатов запроса, либо нет.

# Подзапрос всегда заключается в круглые скобки.

# Отличия:
# - В большинстве случаев результаты подзапроса всегда состоят из одного столбца
# - Хотя в подзапросе может находится предложение ORDER BY, на самом деле оно используется крайне редко. Результаты
# подзапроса используются внутри главного запроса и для пользователя остаются невидимыми, поэтому нет смысла
# их сортировать.
# - Имена столбцов в позапросе могут ссылаться на столбцы таблиц главного запроса.

# Вывести список служащих, чей плановый объем продаж составляет менее 10% от планового объема продаж всей компании.
SELECT NAME
FROM SALESREPS
WHERE QUOTA < (.1 * (SELECT SUM(TARGET) FROM OFFICES));
# или
SELECT NAME
FROM SALESREPS
WHERE QUOTA < (SELECT (SUM(TARGET) * .1) FROM OFFICES);

# Внешняя ссылка представляет собой имя столбца, не входящего ни в одну из таблиц, перечисленных в предложении
# FROM подзапроса, и принадлежащего таблице, указанной в предложении FROM главного запроса.
SELECT CITY
FROM OFFICES
WHERE TARGET > (SELECT SUM(QUOTA) FROM SALESREPS WHERE REP_OFFICE = OFFICE);
# Столбец OFFICE в подзапросе является примером внешней ссылки.


# Сравнение с результатом подзапроса
# Вывести список служащих, у которых плановый объем продаж не меньше планового объема продаж офиса в Атланте.
SELECT NAME
FROM SALESREPS
WHERE QUOTA >= (SELECT TARGET FROM OFFICES WHERE CITY = 'Atlanta');

# Вывести список клиентов, которых обслуживает Билл Адамс
SELECT COMPANY
FROM CUSTOMERS
WHERE CUST_REP = (SELECT EMPL_NUM FROM SALESREPS WHERE NAME = 'Bill Adams');

# Вывести список имеющихся в наличии товаров от компании ACI, количество которых превышает количество товара ACI-41004.
SELECT DESCRIPTION, QTY_ON_HAND
FROM PRODUCTS
WHERE MFR_ID = 'ACI'
  AND QTY_ON_HAND > (SELECT QTY_ON_HAND FROM PRODUCTS WHERE MFR_ID = 'ACI' AND PRODUCT_ID = '41004');

# Проверка на принадлежность результатам подзапроса (IN).
# Вывести список служащих тех офисов, где фактический объем продаж превышает плановый.
SELECT NAME
FROM SALESREPS
WHERE REP_OFFICE IN (SELECT OFFICE FROM OFFICES WHERE SALES > TARGET);

# Вывести список служащих, не работающих в офисах, которыми руководит Ларри Фитч
SELECT NAME
FROM SALESREPS
WHERE REP_OFFICE NOT IN (SELECT OFFICE FROM OFFICES WHERE MGR = 108);

# Проверка существования (EXIST)
# Предикат EXISTS не использует результаты подзапроса, а проверяется только наличие результатов.

# Вывести список товаров, на которые получен заказ стоимостью не менее $25 000.
# Этот запрос можно перефразировать следующим образом.
# Вывести список товаров, для которых в таблице ORDERS существует по крайней мере один заказ, который
# а) является заказом на данный товар;
# б) имеет стоимость не менее $25 000.
SELECT DISTINCT DESCRIPTION
FROM PRODUCTS
WHERE EXISTS (SELECT ORDER_NUM
              FROM ORDERS
              WHERE PRODUCT = PRODUCT_ID
                AND MFR = MFR_ID
                AND AMOUNT >= 25000);

# существует NOT EXISTS

# Запрос выше можно переписать так:
SELECT DESCRIPTION
FROM PRODUCTS
WHERE EXISTS (SELECT *
              FROM ORDERS
              WHERE PRODUCT = PRODUCT_ID
                AND MFR = MFR_ID
                AND AMOUNT >= 25000);
# На практике при использовании подзапроса в проверке EXISTS обычно применяется именно эта форма - SELECT *

# Вывести список клиентов, закрепленных за Сью Смит, которые не разместили заказы на сумму на сумму свыше $3 000.
SELECT COMPANY
FROM CUSTOMERS
WHERE CUST_REP = (SELECT EMPL_NUM
                  FROM SALESREPS
                  WHERE NAME = 'Sue Smith')
  AND NOT EXISTS(SELECT *
                 FROM ORDERS
                 WHERE CUST = CUST_NUM AND AMOUNT > 3000);

# Вывести список офисов, где имеется служащий, чей план превышает 55 процентов от плана офиса.
SELECT CITY
FROM OFFICES
WHERE EXISTS(SELECT *
             FROM SALESREPS
             WHERE REP_OFFICE = OFFICE
               AND QUOTA > (0.55 * TARGET));


# Многократное сравнение (предикаты ANY и ALL).

# Предикат ANY
# Ключевое слово ANY используется совместно с одним из шести операторов сравнения SQL (=, <>, <, <=, >, >=) и
# сравнивает проверяемое значение со столбцом данных, отобранных подзапросом. Проверяемое значение поочередно
# сравнивается с каждым элементом, содержащимся в столбце. Если некоторое из этих сравнений дает результат TRUE,
# то проверка ANY возвращает значение TRUE.

# Пример запроса
# Вывести список служащих, принявших заказ на сумму, превышающую 10% плана.
# Можно перефразировать:
# Вывести список служащих
SELECT NAME
FROM SALESREPS
WHERE (0.1 * QUOTA) < ANY (SELECT AMOUNT
                           FROM ORDERS
                           WHERE REP = EMPL_NUM);

# для понимания смысла
# WHERE X < ANY (SELECT Y ...)
# нужно читать так
# где X меньше некоторого из Y...

# Вывести имена и возраст всех служащих, которые не руководят офисами.
SELECT NAME, AGE
FROM SALESREPS
WHERE NOT (EMPL_NUM = ANY(SELECT MGR FROM OFFICES));

# Запрос с предикатом ANY всегда можно преобразовать в запрос с предикатом EXISTS, перенося операцию сравнения внутрь
# условия отбора подзапроса.
SELECT NAME, AGE
FROM SALESREPS
WHERE NOT EXISTS (SELECT * FROM OFFICES WHERE EMPL_NUM = MGR);

# Предикат ALL
# Ключевое слово ALL используется совместно с одним из шести операторов сравнения SQL (=, <>, <, <=, >, >=) и
# сравнивает проверяемое значение со столбцом данных, отобранных подзапросом. Проверяемое значение поочередно
# сравнивается с каждым элементом, содержащимся в столбце. Если ВСЕ сравнения дают результат TRUE,
# то проверка ALL возвращает значение TRUE.

# Пример
# Вывести список офисов с плановыми объемами продаж, у всех служащих которых фактический объем продаж превышает
# 50 процентов от плана офиса.

SELECT CITY, TARGET
FROM OFFICES
WHERE (.50 * TARGET) < ALL (SELECT SALES
                            FROM SALESREPS
                            WHERE REP_OFFICE = OFFICE);

# для понимания смысла
# WHERE X < ALL (SELECT Y...)
# следует читать как
# где для всех Y, X меньше Y...

# Запросы, записанные с применением подзапросов, можно представить в виде многотабличных запросов.

# Вывести имена и возраст служащих, работающих в офисах западного региона.
# с использованием подзапросов
SELECT NAME, AGE
FROM SALESREPS
WHERE REP_OFFICE IN (SELECT OFFICE FROM OFFICES WHERE REGION = 'Western');

# то же самое но с соединением двух таблиц
SELECT NAME, AGE
FROM SALESREPS, OFFICES
WHERE REP_OFFICE = OFFICE AND REGION = 'Western';

# Вложенные подзапросы
# Вывести список клиентов, закрепленных за служащими, работающими в офисах восточного региона.
SELECT COMPANY
FROM CUSTOMERS
WHERE CUST_REP IN
      (SELECT EMPL_NUM
       FROM SALESREPS
       WHERE REP_OFFICE IN (SELECT OFFICE
                            FROM OFFICES
                            WHERE REGION = 'Eastern'));

# Коррелированные подзапросы
SELECT CITY
FROM OFFICES
WHERE TARGET > (SELECT SUM(QUOTA) FROM SALESREPS WHERE REP_OFFICE = OFFICE);
# Подзапрос, содержащий внешнюю ссылку, называется коррелированым, так как его результаты оказываются коррелированными
# с каждой строкой таблицы в главном запросе. По той же причине внешняя ссылка называется иногда коррелированой.


# Подзапросы в предложении HAVING
SELECT NAME, AVG(AMOUNT)
FROM SALESREPS, ORDERS
WHERE EMPL_NUM = REP AND MFR = 'ACI'
GROUP BY NAME
HAVING AVG(AMOUNT) > (SELECT AVG(AMOUNT) FROM ORDERS);

