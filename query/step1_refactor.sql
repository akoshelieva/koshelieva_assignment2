USE salesHistoricalCar;

WITH
sales_2023 AS (
    SELECT region, SUM(value) AS total_sales_2023
    FROM iea_ev_dataev_saleshistoricalcars
    WHERE year = 2023
      AND parameter = 'EV sales'
      AND mode = 'Cars'
      AND unit = 'Vehicles'
    GROUP BY region
),


sales_2022 AS (
    SELECT region, SUM(value) AS total_sales_2022
    FROM iea_ev_dataev_saleshistoricalcars
    WHERE year = 2022
      AND parameter = 'EV sales'
      AND mode = 'Cars'
      AND unit = 'Vehicles'
    GROUP BY region
),


stock_share_2023 AS (
    SELECT region, SUM(value) AS stock_share_2023
    FROM iea_ev_dataev_saleshistoricalcars
    WHERE year = 2023
      AND parameter = 'EV stock share'
      AND mode = 'Cars'
      AND unit = 'percent'
    GROUP BY region
)


SELECT
    s23.region,
    s22.total_sales_2022,
    s23.total_sales_2023,
    ss23.stock_share_2023
FROM sales_2023 s23
JOIN sales_2022 s22 ON s23.region = s22.region
JOIN stock_share_2023 ss23 ON s23.region = ss23.region
WHERE s23.total_sales_2023 > s22.total_sales_2022
  AND ss23.stock_share_2023 > 5
ORDER BY s23.total_sales_2023 DESC;
