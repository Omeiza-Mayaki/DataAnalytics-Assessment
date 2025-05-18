# DataAnalytics-Assessment

My answers to the Cowrywise Data Analyst SQL assessment are included in this project.  The dataset mirrors the behavior of users and transactions on a platform for financial services.  Both exploratory and analytical SQL queries were needed for the tasks.

# 📁 Files Included

- `Assessment_Q1`: A query that returns high-Value Customers with Multiple Products
- `Assessment_Q2`: A query that classifies customers based on average monthly transactions.
- `Assessment_Q3`: A query that flags accounts with no activity in the last 365 days.
- `Assessment_Q4`: A query that calculates customer lifetime value based on tenure and transaction behavior.

# Assessment_Q1

METHOD OF APPROACH:

I first of all had to understand the scenario where the company wanted to see customers who had both a savings and an investment account with the company. And from the hints given, we see that the savings and investment plans had different ways of selecting them from the savings_saving table, referencing the *is_a_regular_savings* and *is_a_fund* fields in the table. Also, having to provide more than one count result (for savings and investment count) accross three tables, I decided to implement Common Table Expressions (CTE) to make my query easier to read and more efficient. I created two CTEs, one for the savings account, and the other for the investment account.

I created the first CTE by joining the savings and the plans tables with *p.is_regular_savings = 1* to get the savings count and the total savings deposit which was later added to the total investment deposit to get the finanl value for the total deposit (taking the confirmed amount as the amount remaining after a withdrwal, and every necessary deduction have been made) as required in the question. The secons CTE was created also by joining the savings and the plans table with *p.is_a_fund = 1* to get the count of invesment accounts belonging to a single owner.

Lastly, I wrote the query that retunrs the expected result by qeurrying the 2 CTEs and joining it with the owners table which contained the names of each user. I also had to use *CONCAT()* to combine the first and last names of each user to get their full names. The query was sorted by total deposit as instructed.

# Assessment_Q2

METHOD OF APPROACH:

I understood from the scenario that the finance team wanted to know how often each user carried out a transaction so as to classify them under different categories. With this understanding, I knew that I had to count the number of transactions each customer carried out on average over a period of one active month, and thus, create a *CASE STATEMENT* that will categorize them dependent on the number of their average monthly transactions.

I created three CTEs, the first one to calculate the number of monthly transactions for each month over the number of years in the dataset (2016 - 2018) using *EXTRACT()* Function. I then went on to create the second CTE which calculated the average number of transaction based on the number of transaction returned from the first CTE. I did this to avoid clustering the first CTE with both the count and average calculations to help the query be more efficient. Lastly, I created another CTE known as 'categorized user' where I created a csee that classifies users based on their average monthly transactions. Tthe final query was sorted by the average transactions per month.

CHALLENGE:

One major challenge I encountered carrying out this task was counting the number of transactions per "active" month acroos the years instead of just counting the entire number of transactions and dividing by the total number of months. This approach which I have taken will make the result of more quality, showing average transactions per month where account was active.

# Assessment_Q3

METHOD OF APPROACH:

it has been detected that some accounts have remained inactive over a perios of time and now, the Ops team wants to flag them out based on a range of inactivity. From this understanding, I knew I had to calculate the number of days between the current date and the last transaction date using *DATEDIFF ()* function, and filter the result WHERE the number of inactive days is more than 365 days.

In solving this problem, I created 2 CTEs, to calculate the last time a transaction was carried out on a user's account, either on the savings plan or on the investment plan. 

# ASSESSMENT_Q4

METHOD OF APPROACH:

For this task, I estimated customer lifetime value (CLV) by calculating each user's account tenure and total transaction volume, assuming a 0.1% profit margin per transaction. I completed this task by applying core SQL concepts such as CTEs, aggregate functions, date calculations, and CASE statements for classification. I created two CTEs, the first one to count the total transactions carried out by a user and to calculate the total sum of the transaction using the *SUM* function. The second CTE calculated the number of months the user has had the account for using the *DATEDIFF* function. I estimated the clv by dividing the total transactions by the tenure months, (using a *NULLIF ()* function to return a 0 value for a null entry so as not to get an error value), divided the total traansaction value by 0.01% value of the total transaction, multiplying the entire result by 12 (following the formula given in the task), and rounding off the answer to 2 decimal places, sorting the final result based on estimated clv descending.
