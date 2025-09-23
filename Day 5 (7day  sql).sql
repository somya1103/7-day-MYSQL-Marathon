-- q1 Assign a row number to employees ordered by salary descending.
select emp_name,salary,
row_number() over ( order by salary desc) as row_num
from employees;
-- q2 List employees with their rank in salary within the whole company.
select emp_name
, rank() over (order by salary desc) as rank_
from employees;

-- q3 Show employees with their dense rank of salary within each department.
select dept_id,emp_name,salary,
dense_rank() over(partition by dept_id order by salary desc) as salary_rank
from employees;

-- q4 Find the highest paid employee(s) in each department (using RANK = 1).
with rank_table as 
(select dept_id,emp_name,salary,
rank() over (partition by dept_id order by salary desc) as salary_rank
from employees)
select * from rank_table
where salary_rank =1;

-- q5 Identify employees with the second highest salary in each department (trap: ties).
with rank_table as 
(select dept_id,emp_name,salary,
dense_rank() over (partition by dept_id order by salary desc) as salary_rank
from employees)
select * from rank_table
where salary_rank =2;

-- q6 Show employees and their row number within each department, ordered by salary (ROW_NUMBER() + partition).
select dept_id,emp_name,salary,
row_number() over (partition by dept_id order by salary desc) as salary_rank
from employees;

-- q7 (Trap) Find employees who share the same rank within their department (salary ties).
with rank_table as 
(
select emp_id,dept_id,emp_name,salary
,dense_rank() over (partition by dept_id order by salary desc) as rank_
from employees	
)
select r1.dept_id,r1.emp_name,r1.salary,r1.rank_
from rank_table as r1
join rank_table as r2
where r1.rank_=r2.rank_
and r1.dept_id = r2.dept_id
and r1.emp_id <> r2.emp_id;

-- q8 Show each employee’s salary along with the average salary of their department.
select emp_name, salary,
avg(salary) over (partition by dept_id ) as avg_salary
from employees;

-- q9 Find employees whose salary is above the department average (using AVG() OVER).
with avg_table as
(
select emp_name, salary,
avg(salary) over (partition by dept_id ) as avg_salary
from employees
)
select emp_name
from avg_table
where salary > avg_salary;

-- q10 Show each employee’s salary and highest salary in their department (MAX()).
select emp_name, salary,
max(salary) over (partition by dept_id ) as max_salary
from employees;

-- q11 Show each employee’s salary and lowest salary in their department (MIN()).
select emp_name, salary,
min(salary) over (partition by dept_id ) as min_salary
from employees;

-- q12 Display each employee with the difference between their salary and department average.

select emp_name, 
abs(salary-(avg(salary) over (partition by dept_id ))) as salary_diff
from employees;

-- q13 (Trap) Show employees whose salary is equal to department max salary but don’t use GROUP BY.
with rank_table as
(select emp_name,
rank() over (partition by dept_id order by salary desc) as salary_rank
from employees)
select * from rank_table
where salary_rank =1;

with table2 as 
(
select emp_name, salary,
max(salary) over (partition by dept_id ) as max_salary
from employees
)
select emp_name
from table2
where salary= max_salary;

-- q14 Show a cumulative sum of salaries across the company (ordered by salary).
select salary,
sum(salary) over (order by salary ) as cummulative_sum
from employees;

-- q15 Show a cumulative salary within each department.
select dept_id,salary,
sum(salary) over (partition by dept_id order by salary ) as cummulative_sum
from employees;

-- q16 Show each employee’s salary and the moving average of last 2 salaries (ordered by salary).
select emp_name, salary,
avg(salary) over ( order by salary
                   rows between 1 preceding and current row) as moving_last2_avg
from employees;                   
                           
-- q17 Show the percentile rank of each employee based on salary (PERCENT_RANK()).
select emp_name, salary,
percent_rank() OVER( order by salary desc) as percent_contribution
from employees
;
-- q18 Show the cumulative distribution of employee salaries (CUME_DIST()).
select emp_name, salary,
cume_dist() OVER( order by salary desc)as percent_contribution
from employees
;
-- q19 (Trap) Show top 10% earners in the company (using window percentile logic).
with table1 as 
(select emp_name, salary,
cume_dist()  OVER( order by salary desc) as contribution
from employees
)
select * from table1
where contribution <=0.1;

 select sum(salary) from employees;
 
-- q21 Show each employee’s salary and the previous employee’s salary (LAG()).
select emp_name,salary,
lag(salary) over (order by salary) as prev_Salary
from employees;

-- q22 Show each employee’s salary and the next employee’s salary (LEAD()).
select emp_name,salary,
lead(salary) over (order by salary) as next_Salary
from employees;

-- q23 Show each employee with the difference from previous salary.
select emp_name,salary,
lag(salary) over (order by salary) as prev_Salary,
abs(salary- (lag(salary) over (order by salary))) as salary_diff
from employees;

-- q24 Show each employee with the difference from next salary.
select emp_name,salary,
lead(salary) over (order by salary) as next_Salary,
abs(salary- (lead(salary) over (order by salary))) as salary_diff
from employees;

-- q25 (Trap) Find employees whose salary is the same as the previous employee’s salary.
with table_1 as
(
select emp_name,salary,
lag(salary) over (order by salary) as prev_Salary
from employees
)
select emp_name 
from table_1
where salary = prev_Salary;

-- q26 For each department, show employees with salary rank and total employees in that department (COUNT() OVER).
select dept_id,emp_name,salary,
count(*) over(partition by dept_id) as count
from employees;

-- q27 Show each employee’s salary rank in their department and also their global company rank.
select emp_name,
salary,
dense_rank() over (partition by dept_id order by salary desc) as dept_rank,
dense_rank() over ( order by salary desc) as company_rank
from employees;

-- q28 Show the average salary of all employees working on projects (using window, not subquery).

select project_name,emp_name,salary,
avg(salary) over (partition by project_name) as avg_salary
from employees as e
right join projects as p
on e.dept_id= p.dept_id;

select avg(salary)
from employees as e
right join projects as p
on e.dept_id= p.dept_id;

-- q29Show each project’s employees along with their salary rank inside that project.
select project_name,emp_name,salary,
dense_rank() over (partition by project_name order by salary desc) as salary_rank
from employees as e
right join projects as p
on e.dept_id= p.dept_id;

-- q30 (Trap) Find the highest paid employee in each project using window functions only.

with rank_table as 
(
select project_name,emp_name,salary,
dense_rank() over (partition by project_name order by salary desc) as salary_rank
from employees as e
right join projects as p
on e.dept_id= p.dept_id
)
select project_name,emp_name
from rank_table
where salary_rank= 1;



