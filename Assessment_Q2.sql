WITH monthly_transactions AS (
    SELECT s.owner_id, 
           DATE_FORMAT(s.transaction_date, '%Y-%m') AS transaction_month, 
           COUNT(s.id) AS transactions_per_month
    FROM savings_savingsaccount s
    GROUP BY s.owner_id, transaction_month
),
customer_transaction_frequency AS (
    SELECT u.id AS customer_id,
           CONCAT(u.first_name, ' ', u.last_name) AS name,
           COALESCE(AVG(mt.transactions_per_month), 0) AS avg_transactions_per_month,
           CASE 
               WHEN COALESCE(AVG(mt.transactions_per_month), 0) >= 10 THEN 'High Frequency'
               WHEN COALESCE(AVG(mt.transactions_per_month), 0) BETWEEN 3 AND 9 THEN 'Medium Frequency'
               ELSE 'Low Frequency'
           END AS frequency_category
    FROM users_customuser u
    LEFT JOIN monthly_transactions mt ON u.id = mt.owner_id  -- Ensure all users are included
    GROUP BY u.id, u.first_name, u.last_name
)
SELECT frequency_category, 
       COUNT(customer_id) AS customer_count,
       ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM customer_transaction_frequency
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
