USE BD_SQLGOFF;

# Понятие триггер является относительно простым. С любым событием, вызывающим изменение содержимого таблицы,
# пользователь может связать сопутствующее действие (триггер), которое СУБД должна выполнять при каждом возникновении
# события. Тремя такими событиями, запускающими триггеры, являются попытки изменить содержимое таблицы инструкциями
# INSERT, DELETE и UPDATE.

# Example:
SET @sum = 0;
CREATE TRIGGER ins_sum BEFORE INSERT ON ORDERS
    FOR EACH ROW SET @sum = @sum + NEW.amount;
