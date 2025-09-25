
-- ____________________________________Employee Headcount & Distribution_______________________________________________________________________
-- q1 Show total employees per department (sorted highest → lowest).
select dept_name,count(distinct emp_id )  as emp_count
from employees as e
right join departments as d
on e.dept_id=d.dept_id
group by dept_name
order by emp_count desc;

-- q2 Show department-wise headcount trend by year of hire.
select dept_name, year(hire_date) as year_hire,
count(distinct emp_id ) as emp_count
from employees as e
right join departments as d
on e.dept_id=d.dept_id
group by dept_name,year_hire
order by dept_name asc;

-- q3 Count how many employees joined in each quarter (Q1, Q2, Q3, Q4).
select concat("Q","",quarter(hire_date)) as quar, count(distinct emp_id) as emp_count
from employees
group by quar
order  by quar;

select distinct job_title from employees ;
-- q4 Find attrition risk → employees without manager assigned.
select emp_name
from employees
where manager_id is null
     and job_title not in ("Manager","HR Head","Sales Lead");

-- q5 (Trap) Count distinct employees per department — avoid double counting.
select d.dept_id,dept_name,count(distinct emp_id )  as emp_count
from employees as e
right join departments as d
on e.dept_id=d.dept_id
group by d.dept_id,dept_name
order by d.dept_id asc;

-- _____________________________________Manager & Hierarchy Reporting________________________________________________
-- q6 B. Manager & Hierarchy Reporting
select gm.emp_id as manager_level_1, m.emp_name as manager_name, e.emp_name
from employees as e
join employees as m
on e.manager_id= m.emp_id
join employees as gm
on gm.emp_id= m.manager_id;

-- q7 Show number of direct reports each manager has.
select  m.emp_name as manager_name, count(distinct e. emp_id) as Reportee_count
from employees as e
join employees as m
on e.manager_id= m.emp_id
group by manager_name
order by Reportee_count desc;


-- q8 Show managers with more than 3 reportees.
select  m.emp_name as manager_name, count(distinct e. emp_id) as Reportee_count
from employees as e
join employees as m
on e.manager_id= m.emp_id
group by manager_name
having  count(distinct e. emp_id) > 3
order by Reportee_count desc;

-- q9 Show hierarchy → manager name + list of employees under them.
select m.emp_name as manager_name, e.emp_name
from employees as e
join employees as m
on e.manager_id= m.emp_id;

-- q10 Show department where all employees report to the same manager.
select dept_id
from employees 
group by dept_id
having count( distinct manager_id) =1;

-- q11 (Trap) Show employees assigned to a manager who is not in the same department.
select m.emp_name as manager_name,m.dept_id,e.emp_name,e.dept_id
from employees as e
join employees as m
on e.manager_id=m.emp_id
and  e.dept_id != m.dept_id;


-- ___________________________ Salary & Compensation Analytics________________________________________

-- q12 Show average salary per department and compare with overall avg.
select dept_id , avg(salary) as dept_avg,(select round(avg(salary),2) from employees) as overall_avg
from employees
group by dept_id;

-- q13 Find department with the highest salary expense (SUM of salaries).
select dept_id, sum(salary) as salary_exp
from employees
group by dept_id
having sum(salary) = (select max(total_salary) 
                                       from ( select sum(salary)  as total_Salary
                                                        from employees
                                                        group by dept_id) as d);

-- q14 Show salary distribution per department (MIN, MAX, AVG, MEDIAN if possible).
with summ_table as 
(
select dept_id,emp_name,salary,
    row_number() over( partition by dept_id order by salary) as row_num,
    count(*) over (partition by dept_id) as total_count
from employees
),
 median_table as 
 (
 select dept_id, avg(salary) as salary
 from summ_table
 where row_num in (floor((total_count+1)/2), ceil((total_count+1)/2))
 group by dept_id
 )
select s.dept_id,
       max(s.salary) as max_salary,
       min(s.salary) as min_salary,
       avg(s.salary) as avg_salary,
       m.salary as median_salary
from summ_table as s
join median_table as m
on s.dept_id=m.dept_id
group by dept_id;       

-- q15 Show top 3 highest-paid employees per department.
with salary_table as 
(
select dept_id, emp_name,
dense_rank() over ( partition by dept_id order by salary desc) as rank_
from employees
)
select * from salary_table
where rank_<=3;

-- q16 (Trap) Find employees earning more than their manager.
select e.emp_name,e.salary,m.emp_name,m.salary
from employees as e
join employees as m
on e.manager_id=m.emp_id
where e.salary > m.salary;


