USE BD_SQLGOFF;

# Оператор CASE обеспечивает ограниченные возможности принятия решения в SQL-выражениях. Его базовая стрктура, подобна
# структуре конструкции IF...THEN...ELSE.
# Когда СУБД встречает выражение CASE, она вычисляет первое условие, и если оно истинно, выполняется первое
# результирующее выражение. Если же первое условие ложно, проверяется второе условие, и если оно истинно, выполняется
# второе результирующее выражение, и т.д.

# Предположим, что мы хотим разделить клиентов на три категории в соответсвии с суммами их кредитного лимита.
SELECT COMPANY,
       CASE
           WHEN CREDIT_LIMIT > 60000 THEN 'A'
           WHEN CREDIT_LIMIT > 30000 THEN 'B'
           ELSE 'C'
           END AS CREDIT_RATING
FROM CUSTOMERS;
# Для каждой строки результатов запроса СУБД вычисляет выражение CASE. Сначала она сравнивает лимит кредита со значением
# $60 000. Если результатом оказывается TRUE, она возвращает во втором столбце значение A. В противном случае лимит
# кредита сравнивается со значением $30 000. Если результатом оказывается TRUE, второй столбец получает значение B,
# иначе - C.

# Стандарт SQL предоставляет сокращенную версию выражения CASE, более удобную для тех распространенных случаев, когда нужно сравнить проверяемое значение некоторого типа с последовательностью значений данных
SELECT NAME,
       CITY,
       CASE OFFICE
           WHEN 11 THEN 'New York'
           WHEN 12 THEN 'Illinois'
           WHEN 13 THEN 'Georgia'
           WHEN 21 THEN 'California'
           END AS STATE
FROM OFFICES,
     SALESREPS
WHERE MGR = EMPL_NUM;

