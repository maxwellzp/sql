USE BD_SQLGOFF;
# Удаление существующих данных

DELETE FROM SALESREPS
WHERE NAME = 'Henry Jacobsen';

# Удалить все заказы компании InterCorp
DELETE FROM ORDERS
WHERE CUST = 2126;

# Удалить все заказы, сделанные до 15 ноября 2007 года
DELETE FROM ORDERS WHERE ORDER_DATE < '2007-11-15';

# Удалить данные о всех клиентах, обслуживаемых Биллом Адамсом, Мери Джонс и Дэном Робертсом. (идентификаторы служащих
# 105, 109 и 101).
DELETE FROM CUSTOMERS WHERE CUST_REP IN (105, 109, 101);

# Удалить данные о всех служащих, принятых на работу до июля 2006 года и еще не имеющих личного плана.
DELETE FROM SALESREPS WHERE HIRE_DATE < '2006-07-01' AND QUOTA IS NULL;

# Удаление всех строк
DELETE FROM ORDERS;
# Таблица становится пустой, но из БД она не удаляется

# Инструкция DELETE с подзапросом
# В инструкции DELETE запрещено использовать соединение таблиц. Только подзапросы.
# Удалить все заказы, принятые Сью Смит.
DELETE FROM ORDERS
WHERE REP = (SELECT EMPL_NUM FROM SALESREPS WHERE NAME = 'Sue Smith');
# Подзапросы в инструкции DELETE играют важную роль, поскольку они позволяют удалять строки, основываясь на информации,
# содержащейся в других таблицах.

# Удалить данные о всех клиентах, обслуживаемых служащими, у которых фактический объем продаж меньше 80 процентов
# их плана.
DELETE FROM CUSTOMERS WHERE CUST_REP IN (SELECT EMPL_NUM
                                         FROM SALESREPS
                                         WHERE SALES < (.8 * QUOTA));

# Удалить данные о всех служащих, у которых сумма текущих заказов меньше двух процентов из личного плана.
DELETE FROM SALESREPS
WHERE (0.02 * QUOTA) > (SELECT SUM(AMOUNT) FROM ORDERS WHERE REP = EMPL_NUM);
