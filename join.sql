USE BD_SQLGOFF;

# Простое соединение таблиц
SELECT ORDER_NUM, AMOUNT, COMPANY, CREDIT_LIMIT FROM ORDERS, CUSTOMERS WHERE CUST = CUST_NUM;

# Отношение "предок-потомок"
# Таблица, содержащая внешний ключ, является потомком, а таблица с первичным ключом - предком. Чтобы использовать в
# запросе отношение "предок-потомок", необходимо задать условие отбора, в котором первичный ключ сравнивается с внешним
# ключом. Пример:
SELECT NAME, CITY, REGION FROM SALESREPS, OFFICES WHERE REP_OFFICE = OFFICE;
# SELECT NAME, CITY, REGION FROM SALESREPS (потомок), OFFICES (предок) WHERE REP_OFFICE = OFFICE;

SELECT CITY, NAME, TITLE FROM OFFICES, SALESREPS WHERE MGR = EMPL_NUM;
# SELECT CITY, NAME, TITLE FROM OFFICES (потомок), SALESREPS (предок) WHERE MGR = EMPL_NUM;

# Еще один способ определения соединений
SELECT NAME, CITY, REGION FROM SALESREPS JOIN OFFICES ON REP_OFFICE = OFFICE;
SELECT CITY, NAME, TITLE FROM OFFICES JOIN SALESREPS ON MGR = EMPL_NUM;

# Соединение с условием отбора строк
SELECT CITY, NAME, TITLE FROM OFFICES, SALESREPS WHERE MGR = EMPL_NUM AND TARGET > 600000;
# тоже самое, но с новейшим синтаксисом
SELECT CITY, NAME, TITLE FROM OFFICES JOIN SALESREPS ON MGR = EMPL_NUM WHERE TARGET > 600000;

# Связывание составных ключей
SELECT ORDER_NUM, AMOUNT, DESCRIPTION FROM ORDERS, PRODUCTS WHERE MFR = MFR_ID AND PRODUCT = PRODUCT_ID;
# тоже самое, но с новейшим синтаксисом
SELECT ORDER_NUM, AMOUNT, DESCRIPTION FROM ORDERS JOIN PRODUCTS ON MFR = MFR_ID AND PRODUCT = PRODUCT_ID;

# Естественные соединения
# Зачастую связанные столбцы, используемые при соединении двух таблиц, имеют одну одно и то же имя в обоих таблицах.
SELECT ORDER_NUM, AMOUNT, DESCRIPTION FROM ORDERS NATURAL JOIN PRODUCTS;
# Эта инструкция указывает СУБД на необходимость соединения таблиц ORDERS и PRODUCTS по всем столбцам, имеющим
# в этих таблицах одинаковые имена.

# тоже самое, но с новейшим синтаксисом
SELECT ORDER_NUM, AMOUNT, DESCRIPTION FROM ORDERS JOIN PRODUCTS USING(MFR, PRODUCT);
# В предложении USING в скобках перечисляются связанные столбцы (Имеющие одинаковые имена в обеих таблицах).
# USING представляет собой более компактную альтернативу предложению ON.
# Предыдущий запрос полностью эквивалентин следующему:
SELECT ORDER_NUM, AMOUNT, DESCRIPTION
FROM ORDERS JOIN PRODUCTS ON ORDERS.MFR = PRODUCTS.MFR and ORDERS.PRODUCT = PRODUCTS.PRODUCT;

# Зачастую соединения с помощью предложения USING оказывается предпочтительней явного указания NATURAL JOIN.

# Запросы к трем и более таблицам
SELECT ORDER_NUM, AMOUNT, COMPANY, NAME
FROM ORDERS, CUSTOMERS, SALESREPS
WHERE CUST = CUST_NUM AND REP = EMPL_NUM AND AMOUNT > 25000;
# тоже самое, но с новейшим синтаксисом
SELECT ORDER_NUM, AMOUNT, COMPANY, NAME
FROM ORDERS
         JOIN CUSTOMERS ON ORDERS.CUST = CUSTOMERS.CUST_NUM
         JOIN SALESREPS ON CUSTOMERS.CUST_REP = SALESREPS.EMPL_NUM
WHERE AMOUNT > 25000;


SELECT ORDER_NUM, AMOUNT, COMPANY, NAME
FROM ORDERS, CUSTOMERS, SALESREPS
WHERE ORDERS.CUST = CUSTOMERS.CUST_NUM
  AND CUSTOMERS.CUST_REP = SALESREPS.EMPL_NUM
  AND AMOUNT > 25000;
# Порядок соединений в этих многотабличных запросах значения не имеет.

# Пример запроса к четырем таблицам
SELECT ORDER_NUM, AMOUNT, COMPANY, NAME, CITY
FROM ORDERS, CUSTOMERS, SALESREPS, OFFICES
WHERE ORDERS.CUST = CUSTOMERS.CUST_NUM
AND CUSTOMERS.CUST_REP = SALESREPS.EMPL_NUM
AND SALESREPS.REP_OFFICE = OFFICES.OFFICE
AND AMOUNT > 25000;

# Прочие соединения по равенству
# В SQL не требуется, чтобы связанные столбцы представляли собой пару "внешний ключ-первисный ключ". Любые два столбца
# из двух таблиц могут быть связанными, если только они имеют сравнимые типы данных.
# Пример:
SELECT ORDER_NUM, AMOUNT, ORDER_DATE, NAME
FROM ORDERS, SALESREPS
WHERE ORDER_DATE = HIRE_DATE;
# ORDER_DATE и HIRE_DATE не являются ни внешним, ни первичным ключом. Связанные столбцы, подобные приведенным, создают
# между двумя таблицами отношение "многие-ко-многим". Может поступить много заказов в день приема на работу
# какого-нибудь служащего, а также в день получения какого-нибудь заказа, на работу может быть принято несколько
# служащих.

# Отношение "многие-ко-многим" отличается от отношения "один-ко-многим", создаваемого, когда в качестве связанных
# столбцов используются первичный и внешний ключи.
# Итого:
# - Соединение, созданное путем связи первичного ключа с внешним, всегда создает отношение предок-потомок "один-ко-многим".
# - В прочих соединениях также могут существовать отношения "один-ко-многим", если по крайней мере в одной таблице
# связанный столбец содержит уникальные значения во всех строках.
# - В общем случае в соединениях, созданных на основе произвольных связанных столбцов, существуют отношения
# "многие-ко-многим"

# Соединение по неравенству
SELECT NAME, QUOTA, CITY, TARGET
FROM SALESREPS, OFFICES
WHERE SALESREPS.QUOTA > OFFICES.TARGET;

# Список имен всех столбцов определенной таблицы (*)
SELECT SALESREPS.*, CITY, REGION
FROM SALESREPS, OFFICES
WHERE REP_OFFICE = OFFICE;

# Самосоединение
# Некоторые многотабличные запросы используют отношения, существующие внутри одной таблицы.
# Вывести список всех служащих и их руководителей
# Для соединения таблицы с самой собой в SQL применяется метод "воображаемой копии". Вместо того чтобы на самом деле
# создавать копию таблицы, СУБД просто позволяет вам сослаться на ее, используя другое имя, псевдоним таблицы.

SELECT EMPS.NAME, MGRS.NAME
FROM SALESREPS EMPS, SALESREPS MGRS
WHERE EMPS.MANAGER = MGRS.EMPL_NUM;

SELECT SALESREPS.NAME, SALESREPS.QUOTA, MGRS.QUOTA
FROM SALESREPS, SALESREPS MGRS
WHERE SALESREPS.MANAGER = MGRS.EMPL_NUM
AND SALESREPS.QUOTA > MGRS.QUOTA;

# Псевдонимы таблиц (Alias)
SELECT S.NAME NEW_NAME
FROM SALESREPS S;
# Стандарт SQL допускает необязательную вставку ключевого слова AS между именем и псевдонимом таблицы.
SELECT S.NAME AS NEW_NAME
FROM SALESREPS AS S;

# Умножение таблиц
# Соединение - это частный случай более общей комбинации данных из двух таблиц, известной под названием "декартово
# произведение" (или просто произведение) двух таблиц. Произведение двух таблиц представляет собой таблицу (называемую
# таблицей произведения), состояющую из всех возможных пар строк обеих таблиц.
# Если создать запрос к двум таблицам без предложения WHERE, то таблица результатов запроса окажется произведением
# двух таблиц.
# Показать все возможные комбинации служащих и городов.
SELECT NAME, CITY
FROM SALESREPS, OFFICES;
# Таблица результатов запроса будет иметь 50 строк (5 офисов * 10 служащих = 50 комбинаций)
# Для соединения используется точно такой же запрос SELECT, но с предложением WHERE
SELECT NAME, CITY
FROM SALESREPS, OFFICES
WHERE REP_OFFICE = OFFICE;
# Два приведенных выше запроса указывают на важную связь между соединениями и произведением:
# соединение двух таблиц является произведением этих таблиц, из которого удалены некоторые строки.Удаляются те строки,
# которые не удовлетворяют условию, налагаемому на связанные столбцы для данного соединения.

# Внешние соединения
# Вывести список служащих и офисов, где они работают
SELECT NAME, REP_OFFICE
FROM SALESREPS;

# Вывести список служащих и городов, где они работают.
SELECT NAME, CITY
FROM SALESREPS JOIN OFFICES
ON REP_OFFICE = OFFICE;
# Этот запрос возвращает 9 строк, вместо 10, потому что значение NULL не совпадает ни с одним идентификатором офиса.

# Корректный запрос при помощи внешнего соединения таблиц.
SELECT NAME, CITY
FROM SALESREPS LEFT OUTER JOIN OFFICES
ON REP_OFFICE = OFFICE;

# Полное внешнее соединение
# SELECT *
# FROM GIRLS FULL OUTER JOIN BOYS
# ON GIRLS.CITY = BOYS.CITY;


# Последовательность построения внешнего соединения
# 1. Начать со внутреннего соединения двух таблиц обычным способом.
# 2. Для каждой строки первой таблицы, которая не имеет связи ни с одной строкой второй таблицы, добавить в результаты
# запроса строку со значениями столбцов из первой таблицы, а вместо значений столбцов второй таблицы использовать
# значения NULL.
# 3. Для каждой строки второй таблицы, которая не имеет связи ни с одной строкой первой таблицы, добавить в результаты
# запроса строку со значениями столбцов из второй таблицы, а вместо значений столбцов первой таблицы использовать
# значения NULL.
# 4. Результирующая таблица является внешним соединением двух таблиц.


# Левое внешнее соединение двух таблиц получается, если выполнить шаги 1 и 2 из предыдущего описания, а шаг 3 пропустить.
# SELECT *
# FROM GIRLS LEFT OUTER JOIN BOYS
# ON GIRLS.CITY = BOYS.CITY;

# Правое внешнее соединение двух таблиц получается, если выполнить шаги 1 и 3, а шаг 2 пропустить.
# SELECT *
# FROM GIRLS RIGHT OUTER JOIN BOYS
# ON GIRLS.CITY = BOYS.CITY;

# Зачастую полезно рассматривать одну из таблиц как "старшую" или "ведущую" (все строки которой оказываются в результате
# запроса), а другую - как "младшую" или "ведомую" (столбцы которой в результате запроса содержат значения NULL).
# В левом внешнем соединении левая (первая) таблица является старшей, а правая (вторая) - младшей. В случае правого
# внешнего соединения роли меняются (правая таблица становится старшей, левая младшей).

SELECT NAME, CITY
FROM SALESREPS LEFT OUTER JOIN OFFICES
ON REP_OFFICE = OFFICE;

SELECT NAME, CITY
FROM OFFICES RIGHT OUTER JOIN SALESREPS
 ON OFFICE = REP_OFFICE;

# Ключевое слово INNER не обязательно, так как соединения являются внутренними по умолчанию.

# Внешние соединения в стандарте SQL
# FULL OUTER JOIN
SELECT *
FROM GIRLS FULL OUTER JOIN BOYS
ON GIRLS.CITY = BOYS.CITY;

# LEFT OUTER JOIN
SELECT *
FROM GIRLS LEFT OUTER JOIN BOYS
ON GIRLS.CITY = BOYS.CITY;

# RIGHT OUTER JOIN
SELECT *
FROM GIRLS RIGHT OUTER JOIN BOYS
ON GIRLS.CITY = BOYS.CITY;

# Применение ключевого слова OUTER не обязательно; СУБД в состоянии понять по наличию ключевых слов FULL, LEFT
# или RIGHT, что следует выполнить внешее соединение.

# Перекрестные соединения в стандарте SQL
# Перекрестное соединение (CROSS JOIN) представляет собой другое название декартова произведения двух таблиц.
SELECT * FROM GIRLS CROSS JOIN BOYS;
# По определению декартово произведение содержит все возможные пары строк из двух таблиц. Оно является результатом
# "умножения" двух таблиц, превращая таблицы трех девочек и двух мальчиков в таблицу шести пар "девочка/мальчик"
# (3 * 2 = 6). Перекрестным соединениям не сопутствуют никакие "связанные столбцы" или "условия отбора",
# поэтому предложения ON или USING в них не допускаются.
# Те же результаты можно получить с помощью внутреннего соединения, если не задать в нем условия отбора.
SELECT * FROM GIRLS, BOYS;

