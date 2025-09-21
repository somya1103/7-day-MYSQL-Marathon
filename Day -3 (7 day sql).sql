-- q1 Count total employees in each department.
select dept_id,count(distinct emp_id) as count
from employees
group by dept_id;

-- q2 Find the average salary of each department.
select dept_id,avg(salary) as avg_salary
from employees
group by dept_id;

-- q3 Get min and max salary for each job title.
select job_title, min(salary) as min_, max(salary) as max_
from employees 
group by job_title;

-- q4 Count how many employees have NULL phone numbers, grouped by department. (Trap: NULL handling)
select dept_id, count(emp_id) as emp_with_null_contact
from employees
where phone_number is null
group by dept_id;

-- q5 Show the number of employees hired each year. (Trap: extract YEAR from hire_date)
select year(hire_date) as year_, count( distinct emp_id) as count_
from employees
group by year(hire_date);

-- q6 Show department with total salary expense.
select dept_id, sum(salary) as salary
from employees
group by dept_id;

-- q7 Find total employees per manager.
select manager_id, count(emp_id) as count_of_emp
from employees 
group by manager_id;

-- q8 Count employees grouped by email domain (@company.com, @test.com). (Trap: string functions)

select SUBSTRING_INDEX(SUBSTRING_INDEX(email,'@',-1),'.',1) as Domain,
count(distinct emp_id) as emp_count
from employees
group by Domain;

-- q9 Find departments with more than 5 employees. (Trap: HAVING vs WHERE)
select dept_id, count(emp_id) as emp_count
from employees
group by dept_id
having count(emp_id) >5;

-- q10 List job titles with average salary > 70,000.
select job_title, avg(salary) as avg_salary
from employees
group by job_title
having avg(salary) > 70000;

-- q11 Show managers who manage more than 2 employees.
select manager_id, count(emp_id) as count_of_emp
from employees 
group by manager_id
having count(emp_id) > 2;

-- q12 Find departments where total salary > 200,000.
select dept_id, sum(salary) as total_salary
from employees
group by dept_id
having sum(salary) > 200000;

-- q13 Show years where more than 3 employees were hired.
select year(hire_date) as year_, count( distinct emp_id) as count_
from employees
group by year(hire_date)
having count( distinct emp_id) > 3;

-- q14 Find email domains with more than 1 employee. (Trap: must use HAVING COUNT > 1)
select SUBSTRING_INDEX(SUBSTRING_INDEX(email,'@',-1),'.',1) as Domain,
count(distinct emp_id) as emp_count
from employees
group by Domain
having emp_count > 1;

-- q16 Get departments where max salary > 90,000.
select dept_id, max(salary) as max_salary
from employees
group by dept_id
having max(salary) > 90000;

-- q17 Show managers whose team’s avg salary is higher than company avg salary. (Trap: nested aggregate)
select manager_id,avg(salary) as team_avg
from employees 
group by manager_id
having avg(salary) > (select avg(salary) from employees);


-- q18 Count employees by department and job title.
select dept_id , job_title , count(emp_id) as emp_count
from employees
group by dept_id,job_title with rollup   ;

-- q19 Find avg salary by department and year of hire.
select dept_id,year(hire_date) as year_, avg(salary) as avg_salary
from employees
group by dept_id,year(hire_date);

select dept_id,year(hire_date) as year_, count(emp_id) as emp_count
from employees
group by dept_id,year(hire_date) with rollup ; -- roll up will give value for null dept_id and null year too


-- q20 Show department and manager combination with total employees.
select dept_id, manager_id
, count(emp_id) as emp_count
from employees
group by dept_id, manager_id with rollup;

-- q21 List department, job title pairs where avg salary > 60,000.
select dept_id, job_title, avg(salary) as avg_Salary
from employees
group by dept_id, job_title
having avg(salary) > 60000;

-- q22 Count employees by department and email domain.
select dept_id, SUBSTRING_INDEX(SUBSTRING_INDEX(email,'@',-1),'.',1) as domain
, count(emp_id) as emp_count
from employees
group by dept_id, domain ;

-- q23 Find employees who earn the highest salary in each department. (Trap: GROUP BY doesn’t allow emp_name directly → need window or join)
select dept_id, emp_id ,max(salary)
from employees
group by dept_id, emp_id;

with rank_salary as (select dept_id, emp_name ,salary,
dense_rank() over (partition by dept_id order by salary desc) as rank_
from employees
group by dept_id, emp_id)
select * from rank_salary
where rank_ =1;

-- q24 List departments where min salary = max salary. (Trap: departments with all employees same salary)
select dept_id, min(salary),max(salary)
from employees
group by dept_id
having min(salary) = max(salary);

-- q25 Find departments where at least one employee earns more than 100,000. (Trap: HAVING MAX > 100000)
select dept_id , max(salary)
from employees as e
group by dept_id
having max(salary) >= 100000;


-- q26 Show departments where no employee earns less than 50,000. (Trap: HAVING MIN >= 50000)
select dept_id, min(salary)
from employees 
group by dept_id
having min(salary) >= 50000;

-- q27 Count distinct job titles per department. (Trap: COUNT(DISTINCT))
select dept_id,count(distinct job_title) as count_
from employees
group by dept_id;

-- q28 Get percentage contribution of each department’s salary to total company salary. (Trap: aggregate + window)
select dept_id,
round(sum(salary)/ (select sum(salary) from employees)*100,2) as contribution 
from employees
group by dept_id
order by dept_id asc ;

-- q29 Find median salary per department. (Trap: requires window functions, not plain GROUP BY)
with row_table as 
(select dept_id,salary,
row_number() over (partition by dept_id order by salary desc) as row_num,
count(*) over (partition by dept_id) as total_row
from employees)
select dept_id,
avg(salary) as median
from row_table
where row_num in (floor ((total_row+1)/2),ceil((total_row+1)/2))
group by dept_id;

-- q30.	Show department(s) with max number of employees. (Trap: ties handling)
with table2 as (
select dept_id,count(emp_id) as emp_count
from employees
group by dept_id )
select dept_id, emp_count
from table2
where emp_count= (select max(emp_count) from table2);


-- q31 Get department with highest avg salary. (Trap: need ORDER BY AVG DESC LIMIT 1)
select dept_id,avg(salary) as avg_Salary
from employees
group by dept_id
order by avg_Salary desc limit 1;









