WITH monthly_transactions AS (
    SELECT owner_id, 
           DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month, 
           COUNT(id) AS transactions_per_month
    FROM savings_savingsaccount
    GROUP BY owner_id, transaction_month
)
SELECT frequency_category, 
       COUNT(owner_id) AS customer_count,
       ROUND(AVG(transactions_per_month), 2) AS avg_transactions_per_month
FROM (
    SELECT owner_id,
           CASE 
               WHEN AVG(transactions_per_month) >= 10 THEN 'High Frequency'
               WHEN AVG(transactions_per_month) BETWEEN 3 AND 9 THEN 'Medium Frequency'
               ELSE 'Low Frequency'
           END AS frequency_category,
           AVG(transactions_per_month) AS transactions_per_month
    FROM monthly_transactions
    GROUP BY owner_id
) AS categorized_data
GROUP BY frequency_category;
