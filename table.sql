USE BD_SQLGOFF;

# Создание таблицы
# CREATE TABLE TABLE_NAME

# Определение столбца
# _имя_столбца_ _тип_данных_ [DEFAULT значение] [NOT NULL]

# Ограничение первичного ключа
# PRIMARY KEY (имя_столбца)

# Ограничение внешнего ключа
# FOREIGN KEY (имя_столбца) REFERENCES имя_таблицы (имя_столбца)
# ON DELETE CASCADE
#           SET NULL
#           SET DEFAULT
#           NO ACTION
# ON UPDATE CASCADE
#           SET NULL
#           SET DEFAULT
#           NO ACTION
# Если правила явно не указаны, СУБД использует правила по умолчанию NO ACTION.

# Для некоторых типов, например VARCHAR и DECIMAL, требуется дополнительная информация, такая как длина или число
# десятичных разрядов. Эта дополнительная информация заключается в скобки за ключевым словом, определяющим тип данных.

# Пример создания таблицы
CREATE TABLE OFFICES_1
(
    OFFICE INTEGER       NOT NULL,
    CITY   VARCHAR(15)   NOT NULL,
    REGION VARCHAR(10)   NOT NULL DEFAULT 'Eastern',
    MGR    INTEGER                DEFAULT 106,
    TARGET DECIMAL(9, 2)          DEFAULT NULL,
    SALES  DECIMAL(9, 2) NOT NULL DEFAULT 0.00
);
# При таком определении таблицы в процессе ввода в нее сведений о новом офисе необходимо задать только идентификатор
# офиса и города, в котором он расположен.

# В определении столбцов первичного ключа должно быть указано, что они не могут содержать значения NULL (имеют
# ограничение NOT NULL)

# Пример таблицы с первичным и внешними ключами.
CREATE TABLE IF NOT EXISTS ORDERS_1
(
    ORDER_NUM  INTEGER       NOT NULL,
    ORDER_DATE DATE          NOT NULL,
    CUST       INTEGER       NOT NULL,
    REP        INTEGER,
    MFR        CHAR(3)       NOT NULL,
    PRODUCT    CHAR(5)       NOT NULL,
    QTY        INTEGER       NOT NULL,
    AMOUNT     DECIMAL(9, 2) NOT NULL,
    PRIMARY KEY (ORDER_NUM),
    CONSTRAINT PLACEDBY FOREIGN KEY (CUST) REFERENCES CUSTOMERS (CUST_NUM) ON DELETE CASCADE,
    CONSTRAINT TAKENBY FOREIGN KEY (REP) REFERENCES SALESREPS (EMPL_NUM) ON DELETE SET NULL,
    CONSTRAINT ISFOR FOREIGN KEY (MFR, PRODUCT) REFERENCES PRODUCTS (MFR_ID, PRODUCT_ID) ON DELETE RESTRICT
);

# Если две или более таблиц образуют ссылочный цикл (как таблицы OFFICES и SALESREPS), о для первой создаваемой таблицы
# невозможно определить внешний ключ, так как связанная с нею таблица еще не существует. СУБД откажется выполнять
# инструкцию CREATE TABLE, выдав ошибку. В этом случае необходимо создать таблицу без определения внешнего ключа и
# добавить данное определение позже с помощью инструкции ALTER TABLE.

# Условия уникальности
# Определение таблицы с условием уникальности
CREATE TABLE IF NOT EXISTS OFFICES_1
(
    OFFICE INTEGER       NOT NULL,
    CITY   VARCHAR(15)   NOT NULL,
    REGION VARCHAR(10)   NOT NULL,
    MGR    INTEGER,
    TARGET DECIMAL(9, 2),
    SALES  DECIMAL(9, 2) NOT NULL,
    PRIMARY KEY (OFFICE),
    CONSTRAINT HASMGR FOREIGN KEY (MGR) REFERENCES SALESREPS (EMPL_NUM) ON DELETE SET NULL,
    UNIQUE (CITY)
);

# Таблица с сокращенной формой ограничений
CREATE TABLE IF NOT EXISTS OFFICES_2
(
    OFFICE INTEGER       NOT NULL PRIMARY KEY,
    CITY   VARCHAR(15)   NOT NULL UNIQUE,
    REGION VARCHAR(10)   NOT NULL,
    MGR    INTEGER REFERENCES SALESREPS (EMPL_NUM),
    TARGET DECIMAL(9, 2),
    SALES  DECIMAL(9, 2) NOT NULL
);

# Удалить таблицу
DROP TABLE OFFICES_2;

# Изменение определения таблицы (ALTER TABLE)

# Добавить в таблицу определение столбца
# ALTER TABLE имя_таблицы ADD определение_столбца
ALTER TABLE CUSTOMERS ADD CONTACT_NAME VARCHAR(30);
ALTER TABLE CUSTOMERS ADD CONTACT_PHONE CHAR(10);
# Если столбец объявлен как NOT NULL и со значением по умолчанию,то СУБД считает, что всего его значения - значения
# по умолчанию.
ALTER TABLE PRODUCTS ADD MIN_QTY INTEGER NOT NULL DEFAULT 0;

# Удалить столбец из таблицы
# ALTER TABLE имя_таблицы DROP имя_столбца [CASCADE | RESTRICT]
# CASCADE - Любой объект базы данных (внешний ключ, ограничение, и т.п.), связанный с удаляемым столбцом, также
# будет удален.
# RESTRICT - Если с удаляемым столбцом связан какой-либо объект в базе данных (внешний ключ, ограничение, и т.п.),
# инструкция ALTER TABLE завершится ошибкой.
ALTER TABLE SALESREPS DROP HIRE_DATE;

# Изменить значение по умолчанию для какого-либо столбца
# ALTER TABLE имя_таблицы ALTER имя_столбца SET DEFAULT значение
# ALTER TABLE имя_таблицы ALTER имя_столбца DROP DEFAULT

# Добавить первичный ключ
# ALTER TABLE имя_таблицы ADD определение первичного ключа

# Добавить внешний ключ
# ALTER TABLE имя_таблицы ADD определение внешнего ключа
# ALTER TABLE OFFICES ADD CONSTRAINT INREGION FOREIGN KEY (REGION) REFERENCES REGIONS(REGION_ID);

# Добавить ограничение уникальности
# ALTER TABLE имя_таблицы ADD ограничение уникальности

# Удалить ограничение
# ALTER TABLE имя_таблицы DROP CONSTRAINT имя ограничения
# ALTER TABLE SALESREPS DROP CONSTRAINT WORKSIN;

