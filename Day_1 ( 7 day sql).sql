DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    hire_date DATE,
    salary DECIMAL(10,2),
    manager_id INT,
    dept_id INT,
    job_title VARCHAR(50),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
INSERT INTO departments (dept_id, dept_name) VALUES
(1, 'Finance'),
(2, 'IT'),
(3, 'HR'),
(4, 'Marketing'),
(5, 'Sales');

INSERT INTO employees 
(emp_name, last_name, email, phone_number, hire_date, salary, manager_id, dept_id, job_title) 
VALUES
('John', 'Doe', 'john.doe@company.com', '1234567890', '2020-01-15', 75000, NULL, 1, 'Manager'),
('Alice', 'Smith', 'alice.smith@company.com', '', '2021-03-20', 55000, 1, 1, 'Analyst'),
('Bob', 'Brown', 'bob.brown@company.com', '9988776655', '2022-02-28', 60000, 1, 1, 'Analyst'),
('Charlie', 'Johnson', 'charlie.j@company.com', NULL, '2019-07-10', 95000, NULL, 2, 'Manager'),
('David', 'Williams', 'david@company.com', '5557773333', '2023-02-28', 45000, 4, 2, 'Developer'),
('Eve', 'Taylor', 'eve@company.com', '4445556666', '2024-02-29', 47000, 4, 2, 'Developer'), -- leap year hire
('Frank', 'Anderson', 'frank@company.com', '1231231234', '2022-05-15', 47000, 4, 2, 'Developer'),
('Grace', 'Lee', 'grace@company.com', '7894561230', '2023-08-01', 120000, NULL, 3, 'HR Head'),
('Hannah', 'Lee', 'hannah.lee@company.com', '9876543210', '2021-08-01', 62000, 8, 3, 'Recruiter'),
('Ivan', 'Davis', 'ivan.davis@company.com', NULL, '2020-12-25', 30000, 8, 3, 'Intern'),
('Jack', 'Miller', 'jack.m@company.com', '1112223333', '2022-06-15', 70000, NULL, 4, 'Manager'),
('Kelly', 'Wilson', 'kelly@company.com', '2223334444', '2018-06-15', 68000, 11, 4, 'Executive'),
('Leo', 'Thomas', 'leo.thomas@company.com', NULL, '2020-09-10', 72000, 11, 4, 'Executive'),
('Mia', 'Moore', 'mia.moore@company.com', '5551112222', '2021-11-01', 80000, 11, 4, 'Executive'),
('Noah', 'Taylor', 'noah.taylor@test.com', '6667778888', '2019-03-01', 90000, 11, 5, 'Sales Lead'),
('Olivia', 'Martin', 'olivia.martin@test.com', '', '2023-05-05', 40000, 15, 5, 'Sales Executive'),
('Paul', 'White', 'paul.white@test.com', '7778889999', '2020-05-20', 40000, 15, 5, 'Sales Executive'),
('Quinn', 'Hall', 'quinn.hall@company.com', NULL, '2022-01-10', 95000, 15, 5, 'Sales Executive'),
('Ray', 'King', 'ray.king@company.com', '0001112222', '2023-07-01', 40000, 15, 5, 'Sales Intern'),
('Sophia', 'Brown', 'sophia.brown@company.com', '9998887777', '2019-02-15', 95000, NULL, 2, 'Architect'),
('Tom', 'Doe', 'tom.doe@company.com', '8887776666', '2024-01-05', 55000, 4, 2, 'Tester'),
('Uma', 'Patel', 'uma.patel@company.com', '9991112222', '2022-03-30', 55000, 8, 3, 'Recruiter'),
('Victor', 'Singh', 'victor.singh@company.com', '1212121212', '2019-06-20', 65000, 11, 4, 'Executive'),
('Will', 'Johnson', 'will.j@company.com', '', '2021-10-15', 62000, 11, 4, 'Executive'),
('Xander', 'Doe', 'xander.doe@company.com', '3232323232', '2023-04-01', 75000, 1, 1, 'Analyst'),
('Yara', 'Sharma', 'yara.sharma@company.com', NULL, '2019-08-19', 85000, 4, 2, 'Architect'),
('Zack', 'Moore', 'zack.moore@company.com', '1212111212', '2022-12-01', 90000, 11, 4, 'Executive');

select * from employees;
select * from departments;

-- (q1) Write a query to select all columns from the employees table where salary is greater than the average salary of the table.
select * 
from employees
where salary > (select avg(salary) from employees);

-- (q2)Find employees whose name starts and ends with the same letter. 
select emp_name
from employees
where left(emp_name,1)= right(emp_name,1);

select emp_name
from employees
where Lower(left(emp_name,1))= lower(right(emp_name,1));

-- (q3)Select employees whose hire_date is within the last 24 months. (Trap: functions vs literal date comparison.)
with month_diff as (select emp_name,
timestampdiff(Month,hire_date,curdate()) as Month_difference
from employees)

select * from month_diff
where Month_difference <= 24;

-- (q4)Get all employees who don’t belong to any department. (Trap: NULL handling vs !=.)
select emp_name
from employees 
where dept_id is null;

-- (q5)Fetch all employees whose email contains 'company' but not 'test'. (Trap: multiple LIKE conditions with AND/OR.)
select emp_name, email
from employees
where email like '%company%'
      and email not like '%test%';

-- (q6)Select distinct job titles from employees and count how many employees share each title. (Trap: DISTINCT + COUNT misuse.)
select  job_title,
count( distinct emp_id) as emp_count
from employees
group by job_title
order by emp_count desc;

-- (q7)Select employees where salary is in the top 10% of all salaries. (Trap: Using LIMIT vs percentile function.)

with salary_rank as 
(
select emp_name, salary,
    ntile(10) over (order by salary desc) as Percentage_
 from employees   
)
select * from salary_rank
where Percentage_ =1 ;


-- (q8)Find employees with names containing at least 2 vowels consecutively. (Trap: Regex vs LIKE.)
select emp_name
from employees 
where lower(emp_name) regexp '[aeiou]{2}';

-- (q19)Write a query to find employees whose manager_id exists in the employees table. (Trap: self join vs IN.)
select emp_name
from employees as m
where manager_id in (select emp_id from employees );

select emp_name
from employees as m
where manager_id in (select emp_id from employees as e where m.manager_id= e.emp_id);

-- (q10)Fetch employees whose phone_number is NULL or empty string. (Trap: empty string ≠ NULL.)
select emp_name,phone_number
from employees
where phone_number is null
      or phone_number = ""
       or phone_number = " ";
       
-- (q11)Select top 5 highest-paid employees. (Trap: multiple employees tie in salary.)
with salary as (select emp_name,
salary,
dense_rank() over (order by salary desc) as Rank_by_salary
from employees)

select * from  salary
where Rank_by_salary <=5;

-- (q12)Get the second highest salary from employees. (Trap: not using LIMIT 1 OFFSET correctly.)

with salary as (select emp_name,
salary,
dense_rank() over (order by salary desc) as Rank_by_salary
from employees)

select * from  salary
where Rank_by_salary =2;

-- (q13)Fetch employees ordered by hire_date ascending but limit results to 3 per department. (Trap: requires window functions.)
with date_ as 
(
select dept_id,
(select dept_name from departments as d where d.dept_id=e.dept_id ) as dept_name,
emp_name,hire_date,
rank() over (partition by dept_id order by hire_date asc ) as rank_by_HireDate
from employees as e
)
select * from date_
where rank_by_HireDate<=3;

-- (q14)Show employees sorted by length of name descending. (Trap: ordering by expression.)
select emp_name, length(emp_name) as len
from employees
order by len desc;

-- (q15)Select 10 employees starting from 6th record. (Trap: OFFSET starts from 0 in some DBs.)
select emp_id,emp_name
from employees
limit 10 offset 6;

-- (q16)Fetch top N earners per department. (Trap: requires partitioning; tricky for interview.)
with salary_rank as
(
select dept_id, 
(select dept_name from departments as d where d.dept_id=e.dept_id ) as dept_name,
emp_name,salary,
dense_rank() over (partition by dept_id order by salary desc) as salary_rank
from employees as e
)
select * from salary_rank
where salary_rank =1;

-- (q17)List employees in alphabetical order, but show null last_name at the end. (Trap: NULLS LAST/NULLS FIRST.)       

with alpha as 
(
select emp_name,last_name
from employees
order by 
case when last_name is null then 1 else 0 end,
emp_name asc
)
select * from alpha;

-- (q18)Employees whose salary is greater than salary of manager. (Trap: self join, handling NULL manager.)
select emp_name,salary
from employees as e
where manager_id is not null
and
salary > (select salary from employees as m where m.emp_id = e.manager_id);

select e.emp_name, e.salary, m.emp_name,m.salary
from employees as e
join employees as m
on m.emp_id= e.manager_id
where e.salary > m.salary;

UPDATE employees
SET manager_id = 28
WHERE emp_id = 37;

-- (q19)Employees who joined in leap years. (Trap: date functions differ per DB.)
select emp_name,
hire_date
from employees
where mod(year(hire_date),4) = 0
and mod(year(hire_date),100) != 100 or mod(year(hire_date),400)=0;

-- (q20)Employees whose name length > department name length. (Trap: string functions and joins.)
select emp_name, dept_name
from employees as e
join departments as d
on e.dept_id=d.dept_id
where length(emp_name)> length(dept_name);

-- (q21)Employees hired on Monday. (Trap: DAYOFWEEK differences in DBs.)
select emp_name, hire_date,
dayname(hire_date) as day_name
from employees
where dayname(hire_date) ='Monday';

-- (q22)Employees whose first name has duplicate letters consecutively. (Trap: Regex or substring functions.)


-- (q23)Employees with salary not in top 10 salaries. (Trap: NOT IN with NULLs.)
 with salary_slab as 
 (
 select emp_name,
salary,
dense_rank() over ( order by salary desc) as rank_
from employees
)
select * from salary_slab
where rank_ > 10;

-- (q24)Employees whose manager has higher salary than their department average. (Trap: nested aggregation.)
with table1 as
(
select e.emp_name,e.salary,m.emp_name as mng_name,m.salary as mng_salary,
avg(e.salary) over (partition by e.dept_id ) as avg_
from employees as e
join employees as m 
on e.manager_id = m.emp_id
)
select emp_name
from table1
where mng_salary>avg_;

-- (q25)Employees who have never been managers. (Trap: NOT EXISTS vs LEFT JOIN.)

select e.emp_name 
from employees  as e
where not exists (select 1 from employees as m where m.manager_id=e.emp_id);

-- (q26)Employees whose email domain appears more than once in table. (Trap: GROUP BY + HAVING.)
with tbl as 
(select emp_name,
substring_index(substring_index(email,'@',-1),'.',1) as domain
from employees)
select domain,count(emp_name)
from tbl
group by domain
having count(*)>1;

-- (q27)Write a query to find employees who earn more than the average salary of their department. (Trap: correlated subquery.)
select dept_id, avg(salary)
from employees
group by dept_id
order by dept_id asc;


select e.dept_id,e.emp_name,e.salary
from employees as e
where e.salary >
(select avg(salary) from employees as e1 where e1.dept_id=e.dept_id);


-- (q28)Find the median salary of all employees. (Trap: median requires window function.)
with ordered as
(
select salary,
row_number() over (order by salary asc) as rn,
count(*) over() as total_count
from employees
)
select avg(salary)
from ordered
where rn in (floor((total_count+1)/2),
              (ceil(total_count+1)/2));

-- (q29)Return the first name and salary of employees who have the second highest distinct salary in their department. (Trap: DISTINCT salaries + partitioning.)
with salary_rank as 
(
select dept_id,emp_name, salary,
dense_rank() over (partition by dept_id order by  salary desc) as rank_
from employees
)
select * from salary_rank
where rank_= 2;

-- (q30)Write a query to pivot employee count by department and job title. (Trap: pivot logic.)

select job_title,
count(case when dept_id =1 then 1 end) as Finance,
count(case when dept_id =2 then 1 end) as IT,
count(case when dept_id =3 then 1 end) as HR,
count(case when dept_id =4 then 1 end) as Marketing,
count(case when dept_id =5 then 1 end) as Sales
from employees
group by job_title;

-- (q31)Find employees who have same first name and last name as any other employee. (Trap: self join.)
select e.emp_name,e.last_name, e.emp_name,e.last_name
from employees as e
join employees as e1
on e.emp_id=e1.emp_id
where e.emp_name =e1.emp_name and e.last_name=e1.last_name;

select e.emp_name,e.last_name, e.emp_name,e.last_name
from employees as e
join employees as e1
on e.emp_name =e1.emp_name and e.last_name=e1.last_name  AND e.emp_id <> e1.emp_id;

-- (q32)Get employees whose salary is strictly between the minimum and maximum salary of department X. (Trap: BETWEEN vs > and <.)
select e.dept_id,e.emp_name ,e.salary -- between include min and max also
from employees e
where e.salary between ( select min(e1.salary) from employees e1 where e.dept_id=e1.dept_id)
           and ( select max(e2.salary) from employees e2 where e.dept_id=e2.dept_id);
           
select e.dept_id,e.emp_name ,e.salary -- <> doesn't include min max
from employees e
where e.salary > ( select min(e1.salary) from employees e1 where e.dept_id=e1.dept_id)
           and e.salary < ( select max(e2.salary) from employees e2 where e.dept_id=e2.dept_id);           
           
select dept_id ,min(salary),max(salary)
from employees 
group by dept_id;
-- (q33)Write a query to fetch employees whose hire date day and month matches today’s day and month. (Trap: ignoring year.)
with date_ as 
(
select emp_name,
month(curdate()) as curr_month,
day(curdate()) as cuu_date
,hire_date,
month(hire_date) as month_,
day(hire_date) as day_
from employees
)
select emp_name
from date_
where curr_month = month_
   and cuu_date= day_;

-- (q34)Find the longest consecutive hiring streak per department. (Trap: gaps-and-islands problem.)
WITH ordered AS (
    SELECT emp_id,
           dept_id,
           hire_date,
           ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY hire_date) AS rn
    FROM employees
),
grp AS (
    SELECT emp_id,
           dept_id,
           hire_date,
           CAST(rn AS SIGNED) - CAST(DATEDIFF(hire_date, '2000-01-01') AS SIGNED) AS grp_id
    FROM ordered
),
streaks AS (
    SELECT dept_id,
           MIN(hire_date) AS streak_start,
           MAX(hire_date) AS streak_end,
           COUNT(*) AS streak_length
    FROM grp
    GROUP BY dept_id, grp_id
)
SELECT dept_id, streak_start, streak_end, streak_length
FROM (
    SELECT s.*,
           ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY streak_length DESC) AS rnk
    FROM streaks s
) t
WHERE rnk = 1;


-- (q35)Employees whose salary has not increased for more than 2 years. (Trap: requires salary history table or self join on hire date.)














