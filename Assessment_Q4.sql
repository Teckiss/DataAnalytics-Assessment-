WITH transaction_summary AS (
    SELECT s.owner_id,
           COUNT(s.id) AS total_transactions,
           SUM(s.confirmed_amount) / 100 AS total_inflow_naira,  -- this ensure Conversion from kobo to naira
           (SUM(s.confirmed_amount) / 100) * 0.001 AS avg_profit_per_transaction -- 0.1% profit
    FROM savings_savingsaccount s
    WHERE s.plan_id IS NOT NULL  -- this Ensures valid plan association
    GROUP BY s.owner_id
),
customer_tenure AS (
    SELECT u.id AS customer_id,
           CONCAT(u.first_name, ' ', u.last_name) AS name,
           TIMESTAMPDIFF(MONTH, u.created_on, CURDATE()) AS tenure_months
    FROM users_customuser u
)
SELECT c.customer_id,
       c.name,
       c.tenure_months,
       t.total_transactions,
       ROUND((t.total_transactions / c.tenure_months) * 12 * t.avg_profit_per_transaction, 2) AS estimated_clv
FROM customer_tenure c
JOIN transaction_summary t ON c.customer_id = t.owner_id
ORDER BY estimated_clv DESC;
