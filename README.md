# DataAnalytics-Assessment

My answers to the Cowrywise Data Analyst SQL assessment are included in this project.  The dataset mirrors the behavior of users and transactions on a platform for financial services.  Both exploratory and analytical SQL queries were needed for the tasks.

# 📁 Files Included

- `Assessment_Q1`: A query that returns high-Value Customers with Multiple Products
- `Assessment_Q2`: A query that classifies customers based on average monthly transactions.
- `Assessment_Q3`: A query that flags accounts with no activity in the last 365 days.
- `Assessment_Q4`: A query that calculates customer lifetime value based on tenure and transaction behavior.

# Assessment_Q1

METHOD OF APPROACH:

I began by analyzing the scenario, which required identifying users who have both savings and investment accounts. From the structure of the *savings_savingsaccount* and *plans_plan* tables, I observed that savings plans are identified by *is_regular_savings = 1*, while investment plans are flagged using *is_a_fund = 1*. Since we needed to aggregate counts and amounts from multiple sources, I opted to use Common Table Expressions (CTEs) to make the query more modular and readable.

The first CTE joins the *savings_savingsaccount* and *plans_plan* tables to isolate savings accounts and calculate both the number of savings accounts per user and their total confirmed deposits. The second CTE similarly filters for investment accounts and computes the count per user.

In the final query, I joined both CTEs with the *users_customuser* table to retrieve each customer’s full name using *CONCAT(first_name, last_name)*. I then computed the total deposit by summing savings and investment confirmed deposits. Finally, I ordered the result by total deposit in descending order, as required in the problem.

# Assessment_Q2

METHOD OF APPROACH:

The goal of this task was to help the finance team classify users based on how frequently they performed transactions. To achieve this, I needed to calculate the average number of transactions each user made per active month and then categorize them based on their transaction frequency.

I completed this task by creating three Common Table Expressions (CTEs) to structure the logic. The first CTE calculated the total number of transactions each user made per month by using the *EXTRACT()* function to isolate the year and month from each transaction's date. The second CTE computed the average number of transactions per user across all their active months, based on the monthly counts obtained from the first CTE. This separation helped keep each CTE focused and the overall query efficient.

The third CTE, named categorized_users, used a CASE statement to classify users into 'High Frequency', 'Medium Frequency', or 'Low Frequency' categories depending on their average monthly transaction count. Finally, the main query grouped the users by category, calculated the total number of users in each group, and displayed the average monthly transaction per category. The result was ordered by average transaction count in descending order to highlight the most active user categories

CHALLENGE:

One major challenge I encountered carrying out this task was counting the number of transactions per "active" month acroos the years instead of just counting the entire number of transactions and dividing by the total number of months. This approach which I have taken will make the result of more quality, showing average transactions per month where account was active.

# Assessment_Q3

METHOD OF APPROACH:

it has been detected that some accounts have remained inactive over a perios of time and now, the Ops team wants to flag them out based on a range of inactivity. From this understanding, I knew I had to calculate the number of days between the current date and the last transaction date using *DATEDIFF ()* function, and filter the result WHERE the number of inactive days is more than 365 days.

In solving this problem, I created 2 CTEs, to calculate the last time a transaction was carried out on a user's account, either on the savings plan or on the investment plan. 

# ASSESSMENT_Q4

METHOD OF APPROACH:

For this task, I estimated customer lifetime value (CLV) by calculating each user's account tenure and total transaction volume, assuming a 0.1% profit margin per transaction. I completed this task by applying core SQL concepts such as CTEs, aggregate functions, date calculations, and CASE statements for classification. I created two CTEs, the first one to count the total transactions carried out by a user and to calculate the total sum of the transaction using the *SUM* function. The second CTE calculated the number of months the user has had the account for using the *DATEDIFF* function. I estimated the clv by dividing the total transactions by the tenure months, (using a *NULLIF ()* function to return a 0 value for a null entry so as not to get an error value), divided the total traansaction value by 0.01% value of the total transaction, multiplying the entire result by 12 (following the formula given in the task), and rounding off the answer to 2 decimal places, sorting the final result based on estimated clv descending.
