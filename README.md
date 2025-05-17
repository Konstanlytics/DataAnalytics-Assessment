# Data Analytics Assessment

## Per-Question Explanations

### Question 1: High-Value Customers with Multiple Products
To identify customers with both a savings and an investment plan, I joined the `users_customuser`, `plans_plan`, and `savings_savingsaccount` tables. I filtered for only funded plans using `confirmed_amount > 0`, then used conditional aggregation to count the number of savings (`is_regular_savings = 1`) and investment (`is_a_fund = 1`) plans per customer. The results were grouped by customer and sorted by total deposits in descending order.

### Question 2: Transaction Frequency Analysis
I calculated the average number of transactions per customer per month by first counting all inflow transactions per customer from the `savings_savingsaccount` table. I used the difference in months between the first and last transaction (`transaction_date`) to compute account activity duration. Customers were then categorized as "High", "Medium", or "Low Frequency" based on defined thresholds.

### Question 3: Account Inactivity Alert  
This query identifies accounts that have not had any transactions in over one year. I joined `plans_plan` with `savings_savingsaccount`, grouped by plan, and checked the latest `transaction_date`. If that date was more than 365 days from the current date, the account was flagged as inactive.

### Question 4: Customer Lifetime Value (CLV) Estimation
To estimate CLV, I calculated the number of months between each customer’s signup date and their most recent transaction. I computed total transaction value and assumed a profit per transaction of 0.1%. The CLV formula was:  
`(total_transactions / tenure_months) * 12 * avg_profit_per_transaction`.  
Results were sorted by highest CLV.

## Challenges

- **Schema Familiarization**: Before writing any queries, I explored the actual database schema to understand available fields. Some date fields like `transaction_date` contained both date and time, so I applied appropriate date functions for clean comparisons.
- **Date-Time Handling**: Some columns included time along with the date. I used functions like `DATE()` and `PERIOD_DIFF()` to extract and compare dates accurately.
- **Null Name Columns**: The `name` field in `users_customuser` was always null. I resolved this by concatenating `first_name` and `last_name` to create a usable display name.
- **Syntax Errors**: Minor syntax issues (like using wrong column names) were resolved by checking the actual schema and testing queries in smaller parts first.

