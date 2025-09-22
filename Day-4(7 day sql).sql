-- q1 Find employees whose salary is greater than the average salary.
select emp_name,salary
from employees
where salary > (select avg(salary) from employees);

-- q2 Retrieve the employee with the highest salary using a subquery.
select emp_name,salary
from employees
where salary = (select max(salary) from employees);

-- q3 Retrieve employees who earn more than the minimum salary in their department.
select dept_id,emp_name,salary
from employees as e
where salary > (select min(salary) from employees as e1 where e1.dept_id=e.dept_id)
order by dept_id asc;

-- q4 Retrieve employees who report to a manager who has more than one subordinate. ✅
select emp_name
from employees
where manager_id in (select manager_id from employees group by manager_id having count(distinct emp_id) > 1);

-- q5 Find departments where average salary > 67,000. ✅
select dept_name
from departments
where dept_id in (select dept_id from employees group by dept_id having avg(salary) > 67000);

select dept_id, avg(salary)
from employees
group by dept_id;

-- q6 Show employees who were hired after the earliest hire date in the company. ✅
select emp_name, hire_date
from employees
where hire_date > (select min(hire_date) from employees);

-- q7 Retrieve employees whose salary is higher than the salary of the lowest-paid employee in their department. ✅
select emp_name
from employees as e
where salary > (select min(Salary) from employees as e1 where e1.dept_id=e.dept_id);

-- q8 List employees who have the same job title as at least one other employee. ✅
select emp_name, job_title
from employees as e
where job_title  in ( select job_title from employees as e1 group by job_title having count(job_title)>1 );

-- q9 Find employees whose manager_id is in the list of managers who have more than 2 subordinates. ✅
select emp_name
from employees
where manager_id in (select manager_id from employees group by manager_id having count(manager_id) >2);

-- q10 Find employees who earn more than the average salary of their department. ✅
select emp_name
from employees as e
WHERE salary > (select avg(salary) from employees as e1 where e.dept_id =e1.dept_id);

-- q11 Show employees who are the only employee in their department. ✅
select emp_name
from employees
where dept_id in (select dept_id from employees group by dept_id having count(dept_id) =1);

-- q12 List departments where every employee earns more than 50,000. ✅
select dept_id,(select dept_name from departments where departments.dept_id= employees.dept_id) as dept_name,min(salary)
from employees
group by dept_id
having min(salary) > 50000;

-- q13 Retrieve employees whose salary is higher than at least one of their colleagues in the same department. ✅
select emp_name 
from employees as e
where salary > (select min(salary) from employees as e1 where e.dept_id= e1.dept_id);

-- q14 Show employees who were hired before every other employee in their department. ✅
select emp_name,dept_id
from employees as e
where hire_date = (select min(hire_date ) from employees as e1 where e.dept_id=e1.dept_id);

-- q15 Find employees whose salary is between the minimum and maximum salary in their department. ✅
                     
 select emp_name
from employees as e
where salary > (select min(salary) from  employees e1 where e.dept_id=e1.dept_id) 
and 
salary< (select max(salary) from  employees e2 where e.dept_id=e2.dept_id) ;                    

-- q16 List departments where max salary < 100,000. ✅
select dept_name
from departments
where dept_id in (select dept_id from employees group by dept_id having max(salary)>100000);

select dept_id, max(salary)
from employees
group by dept_id;
-- q17 Get employees who have the same last name as another employee in the company. ✅
select emp_name,last_name
from employees as e
where e.last_name in (select last_name from employees as e1 where e.emp_id <> e1.emp_id);

select e.emp_name,e1.emp_name, e.last_name -- ------ with help of join
from employees as e
join employees as e1
on e.emp_id<>e1.emp_id
and e.emp_id < e1.emp_id
and e.last_name = e1.last_name;
-- q18 Find employees who report to a manager in a different department. ✅
select emp_name,dept_id
from employees as e
where dept_id != (select dept_id from employees as m where e.manager_id = m.emp_id);

select e.emp_name,e.dept_id,m.emp_name as manager_name ,m.dept_id as mang_dept -- join
from employees as e
join employees as m
on e.manager_id = m.emp_id
where e.dept_id != m.dept_id;

-- q19 List employees whose salary is above the median salary of their department. ✅
with tabel1 as 
(select dept_id,emp_name , salary,
row_number() over (partition by dept_id order by salary) as rank_
,count(*) over (partition by dept_id) as total_
from employees as e
)
select dept_id,emp_name ,salary
from tabel1 as d
where salary > (select avg(salary) 
                 from tabel1 as d1
                 where d.dept_id=d1.dept_id
                 and 
                 rank_ in (floor((total_+1)/2),ceil((total_+1)/2)));


-- q20 Find employees who are not managers of anyone. ✅
select emp_name
from employees as e
where emp_id not in (select distinct manager_id from employees as m where m.manager_id is not null);

-- q21 List employees whose manager_id is in Finance department. ✅
select emp_name
from employees as e
where manager_id in (select emp_id 
					 from employees as m
                     where e.manager_id=m.emp_id
                     AND dept_id = (select dept_id
                                     from departments
                                     where dept_name='Finance'));
                                     
-- q22 Retrieve employees whose department has more than 3 employees. ✅
select emp_name, dept_id
from employees as e
where dept_id in (select dept_id 
                   from employees
                   group by dept_id
                   having count(distinct emp_id)>3);

-- q23 Show employees whose salary is in the top 5 salaries of the company. ✅
with table1 as (select emp_name, salary,
dense_rank() over(order by salary desc) as rank_
from employees)
select * from table1
where rank_<=5;

-- q24 Find employees who share the same job title as at least one other employee. ✅
select emp_name,job_title
from employees as e
where job_title in (select job_title from employees as e1 
                             where e1.job_title =e.job_title
                              and e.emp_id <> e1.emp_id);
                              
-- q25 Find employees who have a manager in emp_table(use EXISTS). ✅
select emp_name
from employees as e
where exists (select 1 from employees  as m where e.manager_id=m.emp_id);

-- q26Show departments that have at least one employee earning more than 80,000. ✅
select distinct dept_id
from employees as e
where exists( select 1 from employees as d 
               where e.dept_id= d.dept_id
               and salary >80000);

-- q27 Retrieve employees who do not report to any manager. ✅
select emp_name
from employees
where manager_id is null;

-- q28 List departments that do not have any employees. ✅
select dept_name
from departments as d
where not exists (select 1 from employees as e where d.dept_id=e.dept_id);

-- q29 Get employees who do not have any subordinates. ✅                             
select emp_id,emp_name
from employees as e
where emp_id not in ( select distinct manager_id 
                      from employees
                      where manager_id is not null);
                      
                                            
-- q30 Find the second highest salary in the company. ✅
select max(salary)
from employees
where salary < (select max(salary) from employees );

-- q31 Find the second highest salary in each department. ✅
select dept_id,max(salary)
from employees as e
where salary < (select max(salary) from employees as e1 where e.dept_id=e1.dept_id)
group by dept_id;

-- q32 Show employees who earn higher than the company average but lower than the max. ✅
select emp_name, salary
from employees
where salary > (select avg(salary) from employees)
 and salary < (select max(salary) from employees);

-- q33 List departments where max salary = min salary (all salaries same). ✅
select dept_id, salary
from employees
group by dept_id
having min(salary)= max(salary);

-- q34 Retrieve employees whose salary is equal to the average salary of their department. ✅
select emp_name
from employees as e1
where salary = (select avg(salary) from employees  as e where e1.dept_id=e.dept_id);











