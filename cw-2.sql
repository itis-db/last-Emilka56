---------Продажи по категориям-----------

WITH category_sales AS (
    SELECT
        p.category,
        SUM(oi.amount) AS total_sales,
        COUNT(DISTINCT o.id) AS orders_count
    FROM order_items oi
             JOIN products p ON oi.product_id = p.id
             JOIN orders o ON oi.order_id = o.id
    GROUP BY p.category
),
     total_sales AS (
         SELECT SUM(amount) AS grand_total FROM order_items
     )
SELECT
    cs.category,
    cs.total_sales,
    ROUND(cs.total_sales / NULLIF(cs.orders_count, 0), 2) AS avg_per_order,
    ROUND((cs.total_sales / ts.grand_total * 100)::NUMERIC, 2) AS category_share
FROM category_sales cs
         CROSS JOIN total_sales ts
ORDER BY total_sales DESC;

---------Анализ покупателей-----------

WITH order_totals AS (
    SELECT
        o.id AS order_id,
        o.customer_id,
        o.order_date,
        SUM(oi.amount) AS order_total
    FROM orders o
             JOIN order_items oi ON o.id = oi.order_id
    GROUP BY o.id, o.customer_id, o.order_date
),
     customer_stats AS (
         SELECT
             customer_id,
             SUM(order_total) AS total_spent,
             COUNT(*) AS order_count,
             ROUND(AVG(order_total), 2) AS avg_order_amount
         FROM order_totals
         GROUP BY customer_id
     )
SELECT
    ot.customer_id,
    ot.order_id,
    ot.order_date,
    ot.order_total,
    cs.total_spent,
    cs.avg_order_amount,
    ROUND((ot.order_total - cs.avg_order_amount)::NUMERIC, 2) AS difference_from_avg
FROM order_totals ot
         JOIN customer_stats cs ON ot.customer_id = cs.customer_id
ORDER BY ot.customer_id, ot.order_date;

----------Сравнение продаж по месяцам-----------

WITH monthly_sales AS (
    SELECT
        TO_CHAR(o.order_date, 'YYYY-MM') AS year_month,
        SUM(oi.amount) AS total_sales
    FROM orders o
             JOIN order_items oi ON o.id = oi.order_id
    GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
    ORDER BY year_month
)
SELECT
    year_month,
    total_sales,
    ROUND(
            COALESCE(
                    (total_sales / LAG(total_sales, 1) OVER (ORDER BY year_month) * 100 - 100),
                    0
            )::NUMERIC,
            2
    ) AS prev_month_diff,
    ROUND(
            COALESCE(
                    (total_sales / (
                        SELECT ms_prev.total_sales
                        FROM monthly_sales ms_prev
                        WHERE ms_prev.year_month = TO_CHAR(
                                TO_DATE(ms.year_month, 'YYYY-MM') - INTERVAL '1 year',
                                'YYYY-MM'
                                                   )
                    ) * 100 - 100),
                    0
            )::NUMERIC,
            2
    ) AS prev_year_diff
FROM monthly_sales ms;