SELECT u.id AS owner_id, 
       CONCAT(u.first_name, ' ', u.last_name) AS name, 
       COUNT(DISTINCT s.plan_id) AS savings_count, 
       COUNT(DISTINCT p.id) AS investment_count,
       SUM(s.confirmed_amount) / 100 AS total_deposits  -- Convert from kobo to Naira
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id
JOIN plans_plan p ON u.id = p.owner_id
WHERE s.plan_id IS NOT NULL AND p.is_a_fund = 1
GROUP BY u.id, u.first_name, u.last_name
HAVING savings_count > 0 AND investment_count > 0
ORDER BY total_deposits DESC;
