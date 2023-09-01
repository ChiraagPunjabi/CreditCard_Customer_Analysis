-- Show the first few rows of the dataset
SELECT * FROM customer_data LIMIT 5;

-- Count missing values for each column
SELECT
    column_name,
    COUNT(*) AS missing_count
FROM
    information_schema.columns
WHERE
    table_name = 'customer_data'
    AND column_name NOT IN ('column_with_no_missing_values') -- Exclude columns without missing values
    AND column_name NOT IN ('another_excluded_column')
GROUP BY
    column_name
ORDER BY
    missing_count DESC;

-- Summary statistics
SELECT
    AVG(balance) AS avg_balance,
    MAX(purchases) AS max_purchases,
    MIN(credit_limit) AS min_credit_limit
FROM
    customer_data;

-- Distribution of purchases
SELECT
    purchases,
    COUNT(*) AS frequency
FROM
    customer_data
GROUP BY
    purchases
ORDER BY
    purchases;

-- Credit limit utilization
SELECT
    cust_id,
    purchases / credit_limit AS utilization_ratio
FROM
    customer_data;

-- Customer segmentation based on purchase behavior and credit limit utilization
SELECT
    cust_id,
    CASE
        WHEN purchases > 1000 AND (purchases / credit_limit) > 0.5 THEN 'High Usage'
        WHEN purchases <= 1000 AND (purchases / credit_limit) <= 0.5 THEN 'Low Usage'
        ELSE 'Medium Usage'
    END AS segment
FROM
    customer_data;

-- Average balance, purchases, and credit limit utilization for each segment
SELECT
    segment,
    AVG(balance) AS avg_balance,
    AVG(purchases) AS avg_purchases,
    AVG(utilization_ratio) AS avg_utilization_ratio
FROM
    ( -- Subquery to calculate utilization ratio and define segments
        SELECT
			balance,
            purchases,
            cust_id,
            purchases / credit_limit AS utilization_ratio,
            CASE
                WHEN purchases > 1000 AND (purchases / credit_limit) > 0.5 THEN 'High Usage'
                WHEN purchases <= 1000 AND (purchases / credit_limit) <= 0.5 THEN 'Low Usage'
                ELSE 'Medium Usage'
            END AS segment
        FROM
            customer_data
    ) AS subquery
GROUP BY
    segment;

