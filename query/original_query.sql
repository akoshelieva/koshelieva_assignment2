use salesHistoricalCar;
explain analyze

SELECT
    s2023.region,
    s2022.total_sales_2022,
    s2023.total_sales_2023,
    ss2023.stock_share_2023
FROM (
    SELECT region, SUM(value) as total_sales_2023
    FROM iea_ev_dataev_saleshistoricalcars
    WHERE year = 2023
      AND parameter = 'EV sales'
      AND mode = 'Cars'
      AND unit = 'Vehicles'
    GROUP BY region
) s2023
JOIN (
	SELECT region, SUM(value) as total_sales_2022
    FROM iea_ev_dataev_saleshistoricalcars
    WHERE year = 2022
      AND parameter = 'EV sales'
      AND mode = 'Cars'
      AND unit = 'Vehicles'
    GROUP BY region
) s2022 ON s2023.region = s2022.region
JOIN (
    SELECT region, SUM(value) as stock_share_2023
    FROM iea_ev_dataev_saleshistoricalcars
    WHERE year = 2023
      AND parameter = 'EV stock share'
      AND mode = 'Cars'
      AND unit = 'percent'
    GROUP BY region
) ss2023 ON s2023.region = ss2023.region
WHERE s2023.total_sales_2023 > s2022.total_sales_2022 
  AND ss2023.stock_share_2023 > 5 
ORDER BY s2023.total_sales_2023 DESC;