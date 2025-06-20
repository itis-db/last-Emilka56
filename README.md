[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/wnaZok1C)
# Контрольная работа (Оконные функции , Group By)

Тема: Анализ продаж интернет-магазина

Схема БД:

```sql
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10, 2)
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    order_date DATE,
    customer_id INT
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id),
    product_id INT REFERENCES products(id),
    quantity INT,
    amount NUMERIC(10, 2)
);

-- Очистка таблиц
TRUNCATE TABLE order_items, orders, products RESTART IDENTITY;
-- Товары
INSERT INTO products (name, category, price) VALUES
('Ноутбук Lenovo', 'Электроника', 45000.00),
('Смартфон Xiaomi', 'Электроника', 22000.50),
('Кофеварка Bosch', 'Бытовая техника', 15000.00),
('Футболка мужская', 'Одежда', 1500.00),
('Джинсы женские', 'Одежда', 3500.99),
('Шампунь Head&Shoulders', 'Косметика', 450.50),
('Книга "SQL для всех"', 'Книги', 1200.00),
('Монитор Samsung', 'Электроника', 18000.00),
('Чайник электрический', 'Бытовая техника', 2500.00),
('Кроссовки Nike', 'Одежда', 7500.00),
('Планшет Huawei', 'Электроника', 32000.00),
('Блендер Philips', 'Бытовая техника', 6500.00);
-- Заказы (за последние 2 года)
INSERT INTO orders (order_date, customer_id) VALUES
('2025-05-01', 101),
('2025-05-03', 102),
('2025-05-05', 103),
('2025-05-10', 104),
('2025-05-15', 101),
('2025-05-20', 105),
('2025-06-01', 102),
('2025-06-02', 103),
('2024-05-01', 104),
('2024-05-15', 105),
('2024-06-01', 101);
-- Позиции заказов
INSERT INTO order_items (order_id, product_id, quantity, amount) VALUES
(1, 1, 1, 45000.00),
(1, 8, 1, 18000.00),
(2, 2, 1, 22000.50),
(2, 4, 2, 3000.00),
(3, 5, 1, 3500.99),
(3, 10, 1, 7500.00),
(3, 6, 3, 1351.50),
(4, 3, 1, 15000.00),
(4, 9, 1, 2500.00),
(5, 11, 1, 32000.00),
(5, 12, 1, 6500.00),
(6, 7, 5, 6000.00),
(7, 1, 1, 45000.00),
(7, 2, 1, 22000.50),
(8, 5, 2, 7001.98),
(9, 3, 1, 15000.00),
(9, 6, 2, 901.00),
(10, 4, 3, 4500.00),
(10, 10, 1, 7500.00),
(11, 7, 2, 2400.00),
(11, 11, 1, 32000.00);
```

## Задания

**Продажи по категориям**

Для каждой категории товаров выведите:
·	category (категория)
·	total_sales (общая сумма продаж)
·	avg_per_order (средняя сумма продаж на заказ)
·	category_share (доля категории в общих продажах, %)

**Анализ покупателей**

Для каждого заказа выведите:
·	customer_id, order_id, order_date, order_total (сумма заказа)
·	total_spent (общая сумма покупок покупателя)
·	avg_order_amount (средний чек покупателя)
·	difference_from_avg (разница между суммой заказа и средним чеком)

**Сравнение продаж по месяцам**

Для каждого месяца выведите:
·	year_month (год и месяц в формате YYYY-MM)
·	total_sales (сумма продаж за месяц)
·	prev_month_diff (% изменения от предыдущего месяца)
·	prev_year_diff (% изменения от того же месяца год назад)


