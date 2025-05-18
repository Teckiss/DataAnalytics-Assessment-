WITH last_transaction AS (
    SELECT s.plan_id,
           s.owner_id,
           MAX(s.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount s
    WHERE s.confirmed_amount > 0  -- Only consider inflow transactions
    GROUP BY s.plan_id, s.owner_id
)
SELECT p.id AS plan_id,
       p.owner_id,
       CASE 
           WHEN p.is_a_fund = 1 THEN 'Investment' 
           ELSE 'Savings' 
       END AS type,
       COALESCE(t.last_transaction_date, 'N/A') AS last_transaction_date,
       COALESCE(DATEDIFF(CURDATE(), t.last_transaction_date), 'N/A') AS inactivity_days
FROM plans_plan p
LEFT JOIN last_transaction t ON p.id = t.plan_id AND p.owner_id = t.owner_id
WHERE t.last_transaction_date IS NULL 
   OR t.last_transaction_date < CURDATE() - INTERVAL 365 DAY;
