# DataAnalytics-Assessment-
# Overview
This repository contains SQL queries designed to solve four assessment tasks related to High-Value Customers with Multiple Products, Transaction Frequency Analysis,  Account Inactivity Alert, Customer Lifetime Value (CLV) Estimation. Each query is optimized for performance and tailored to the given schema, ensuring accurate results. The repository also documents challenges encountered and their solutions.
# 1. High-Value Customers with Multiple Products
## Scenario: Identify customers who hold multiple products (savings + investment plans) and rank them by their total balance. 
## Approach:

Used JOIN on plans_plan and savings_savingsaccount to link customers with their product holdings.

Aggregated confirmed_amount for inflows and amount_withdrawn for outflows.

Segmented customers into high-value users based on combined savings + investment amounts.

Ordered results by highest total balance.

## Challenges & Solutions:

Handling customers with only one type of product (Savings OR Investment). 

Solution: Used LEFT JOIN instead of INNER JOIN to ensure all users are included, even those with only one product.

# 2. Transaction Frequency Analysis
## Scenario: Track how often customers transact and determine their engagement levels. 
## Approach:
Aggregating Monthly Transactions

 Used DATE_FORMAT(transaction_date, '%Y-%m') to group transactions by month.

Counted transactions per customer for each month (COUNT(transaction_id)).

 Calculating Average Transactions per Month

Averaged transactions per customer (AVG(transactions_per_month)).

Used a CASE statement to classify users into High Frequency (≥10), Medium Frequency (3-9), Low Frequency (≤2) categories.

 Joining with users_customuser 

Included inactive customers by performing a LEFT JOIN between users_customuser and savings_savingsaccount.

Used COALESCE(AVG(transactions_per_month), 0) to replace NULL transaction counts with zero.

Computing Category-wise Metrics

Counted customers per frequency category (COUNT(customer_id)).

Calculated the average number of transactions per category (ROUND(AVG(avg_transactions_per_month), 2)).

## Challenges & Solutions:
Challenge: Transaction frequency fluctuated across months.

Some customers had high transactions in some months but low transactions in others, skewing their categorization. 

Solution: Used AVG(transactions_per_month) instead of single-month counts to smooth out variations.

Challenge: Sorting categories logically in output.

MySQL’s default sorting didn’t ensure logical order (High → Medium → Low). 

Solution: Used ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency') to maintain proper order.

# 3️. Account Inactivity Alert
## Scenario: Flag accounts with no inflow transactions for over a year (365 days). 
## Approach:

Used LEFT JOIN to include all accounts, even those without transactions.

Leveraged MAX(transaction_date) to find the last transaction date per account.

Applied DATEDIFF() to calculate inactivity duration (days since last transaction).

Filtered results using HAVING last_transaction_date < CURDATE() - INTERVAL 365 DAY.
## Challenges & Solutions:

Some NULL values appeared for accounts with no transactions ever. 

Solution: Used COALESCE() to replace NULLs with "N/A" for better readability.

### Fixing Lost Connection Issues (Error Code 2013)
### Scenario: The query execution was too slow, causing MySQL to lose connection. 
### Approach:

Increased MySQL timeout settings using SET GLOBAL net_read_timeout = 600.

Indexed critical columns (owner_id, transaction_date) to improve query performance.

Broke down queries using LIMIT to process data in smaller chunks.

### Challenges & Solutions:

Query still timed out due to large dataset joins. 

Solution: Used WITH transaction_summary to pre-aggregate transaction data, reducing query complexity.

# 4️. Customer Lifetime Value (CLV) Estimation
## Scenario: Estimate CLV based on account tenure and transaction volume. 
## Approach:

Used TIMESTAMPDIFF(MONTH, created_on, CURDATE()) to calculate account tenure.

Counted total transactions per customer.

Applied CLV formula: CLV = (total_transactions/ tenure_months) * 12 * avg_profit_per_transaction.

Ordered customers by highest estimated CLV.

## Challenges & Solutions:

Missing transaction data for new customers resulted in incorrect CLV estimates. 

Solution: Used HAVING tenure_months > 0 to exclude accounts with no meaningful transaction history.
