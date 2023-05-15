USE BD_SQLGOFF;

# Увеличить предельный кредит для компании Acme Manufacturing до $60 000 и закрепить ее за Мери Джонс (идентификатор 109)
UPDATE CUSTOMERS
SET CREDIT_LIMIT = 60000, CUST_REP = 109
WHERE COMPANY = 'Acme Mfg.';

# Перевести всех служащих из чикагского офиса (идентификатор 12) в нью-йорский офис (идентификатор 11) и понизить их
# личные планы на десять процентов
UPDATE SALESREPS
SET REP_OFFICE = 11, QUOTA = .9 * QUOTA
WHERE REP_OFFICE = 12;

# Перевести всех клиентов, обслуживаемых служащими с идентификаторами 105, 106 и 107, к служащему с идентификатором 102
UPDATE CUSTOMERS
SET CUST_REP = 102
WHERE CUST_REP IN (105, 106, 107);

# Установить личный план продаж в $100 000 всем служащим, не имеющим в настоящий момент плана.
UPDATE SALESREPS
SET QUOTA = 100000
WHERE QUOTA IS NULL;

# Обновление всех строк
UPDATE SALESREPS SET QUOTA = 1.05 * QUOTA;

# Инструкция UPDATE с подзапросом
# Увеличить на $5000 лимит кредита для тех клиентов, которые сделали заказ на сумму более $25 000.
UPDATE CUSTOMERS
SET CREDIT_LIMIT = CREDIT_LIMIT + 5000.00
WHERE CUST_NUM IN (SELECT DISTINCT CUST
                   FROM ORDERS
                   WHERE AMOUNT > 25000.00);

# Переназначить клиентов, обслуживаемых служащими, чей объем продаж меньше 80 процентов из личного плана, служащему
# с идентификатором 105.
UPDATE CUSTOMERS
SET CUST_REP = 105
WHERE CUST_REP IN (SELECT EMPL_NUM
                   FROM SALESREPS
                   WHERE SALES < (.8 * QUOTA));

# Всех служащих, обслуживающих более трех клиентов, подчинить непосредственно Сэму Кларку (идентификатор 106)
UPDATE SALESREPS
SET MANAGER = 106
WHERE 3 < (SELECT COUNT(*) FROM CUSTOMERS WHERE CUST_REP = EMPL_NUM);

# Внешние ссылки часто встречаются в подзапросах инструкции UPDATE, поскольку они реализуют соединение таблицы
# (или таблиц) подзапроса и целевой таблицы инструкции UPDATE. Стандарт SQL указывает, что ссылка на целевую таблицу в
# подзапросе вычисляется с использованием данных, имевшихся в целевой таблице до обновления.

# Инструкции INSERT, DELETE и UPDATE обращаются только к одной таблице
