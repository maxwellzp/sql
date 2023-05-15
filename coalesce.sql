USE BD_SQLGOFF;

# COALESCE - нечто вроде выражения CASE специального вида
# Правила обработки:
# СУБД вычисляет первое выражение в списке. Если его значение не равно NULL, оно становится результатом всего оператора
# COALESCE. В противном случае СУБД переходит ко второму выражению и проверяет, равно ли оно NULL. Если нет, оно
# возвращается в качестве результата, иначе СУБД переходит к третьему выражению и т.д.
#

# запрос без использования выражения COALESCE
SELECT NAME,
       CASE
           WHEN (QUOTA IS NOT NULL) THEN QUOTA
           WHEN (SALES IS NOT NULL) THEN SALES
           ELSE 0.00
           END AS ADJUSTED_QUOTA
FROM SALESREPS;

# тот же запрос но с использованием выражения COALESCE
SELECT NAME, COALESCE(QUOTA, SALES, 0.00)
FROM SALESREPS;

