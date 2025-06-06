# README: Аналіз SQL-запитів для бази даних `salesHistoricalCar`


## Опис бази даних
База даних `salesHistoricalCar` містить таблицю `iea_ev_dataev_saleshistoricalcars`, яка зберігає історичні дані про продажі електромобілів та їхню частку в автопарку. Структура таблиці включає наступні ключові стовпці:
- `region`: Регіон (наприклад, "USA", "China").
- `year`: Рік даних (наприклад, 2022, 2023).
- `parameter`: Тип даних (наприклад, "EV sales", "EV stock share").
- `mode`: Тип транспортного засобу (наприклад, "Cars").
- `unit`: Одиниця виміру (наприклад, "Vehicles" для продажів, "percent" для частки).
- `value`: Значення (кількість проданих автомобілів або відсоток частки).

## Опис запитів
Усі три запити виконують однакову задачу: знаходять регіони, де продажі електромобілів у 2023 році перевищили продажі 2022 року, а частка електромобілів у автопарку в 2023 році становить більше 5%. Результати сортуються за продажами 2023 року в порядку спадання.
### Оригінальний запит: Використання підзапитів
**Мета**: Виконує ту саму задачу, але використовує підзапити в секції `FROM` замість CTE.  
**Опис**:
- Замість CTE використовує підзапити для обчислення `total_sales_2023`, `total_sales_2022` та `stock_share_2023`.
- Об’єднує підзапити за допомогою `JOIN` за полем `region`.


**Переваги**:
- Логіка обчислень зосереджена в одному блоці.

**Недоліки**:
- Менш читабельний через вкладені підзапити.
- Продуктивність гірша ніж без оптимізації
- 
### Запит 1: Використання CTE
**Мета**: Common Table Expressions (CTE) для структуризації обчислень продажів 2022 та 2023 років, а також частки автопарку 2023 року.  
**Опис**:
- Створюється три CTE: `sales_2023`, `sales_2022`, `stock_share_2023`, які групують дані за регіонами з відповідними фільтрами.
- Об’єднує CTE за допомогою `JOIN` за полем `region`.
- Фільтрує регіони, де продажі 2023 року більші за 2022 рік, а частка автопарку > 5%.
- Сортує результати за `total_sales_2023` у порядку спадання.

**Переваги**:
- Читабельність завдяки модульній структурі CTE.
- Зручність для розширення додатковими обчисленнями.


### Запит 3: Використання індексу з CTE
**Мета**: Оптимізує перший запит шляхом створення та використання індексу для зменшення часу виконання.  
**Опис**:
- Створює композитний індекс `idx_ev_sales_filtered` на полях `(year, parameter, mode, unit, region)` для прискорення фільтрації та групування.
- Використовує CTE, як у першому запиті, але з явним вказанням індексу через `USE INDEX (idx_ev_sales_filtered)`.
- Виконує ті самі обчислення, фільтрацію та сортування.

**Переваги**:
- Значно покращує продуктивність за рахунок індексу, особливо для великих таблиць.
- Зберігає читабельність структури CTE.

**Недоліки**:
- Створення індексу потребує додаткового місця на диску.

## Аналіз продуктивності (`EXPLAIN ANALYZE`)
Нижче наведено аналіз продуктивності кожного запиту за допомогою `EXPLAIN ANALYZE`. 
Аналіз продуктивності для неоптимізованого запиту:
<img width="675" alt="execution_plan_query1" src="https://github.com/user-attachments/assets/65fbaa1e-dd94-45e2-8a4a-44a129f78add" />
Аналіз продуктивності для оптимізованого запиту з використанням CTE:
<img width="657" alt="execution_plan_query2" src="https://github.com/user-attachments/assets/8d8e3601-3078-431b-a5a9-f6211cf54827" />
Аналіз продуктивності для оптимізованого запиту з використанням CTE та індексу:
<img width="641" alt="execution_plan_query3" src="https://github.com/user-attachments/assets/a5083e05-b55c-4d23-b1e4-01f393aa7c59" />


