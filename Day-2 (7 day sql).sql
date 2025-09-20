-- (q1)List all employees with their department name.
-- (Trap: dept_id mismatch returns NULL if INNER JOIN used.)
select emp_name, dept_name
from employees as e
inner join departments as d
on e.dept_id=d.dept_id;

-- (q2)Show employees and their manager names.
-- (Trap: self join, avoid joining employee to themselves.)
select e.emp_name, m.emp_name as manager_name
from employees as e
join employees as m
on e.manager_id= m.emp_id;

-- (q3)Find employees earning more than their department average salary.
-- (Trap: correlated subquery vs join with GROUP BY.)
select emp_name, salary
from employees e
where salary > (select avg(salary) from employees e1 where e.dept_id= e1.dept_id);

select e.dept_id,e.emp_name,e.salary,d.avg_salary
from employees as e
join (select dept_id, avg(salary) as avg_salary
       from employees as d
       group by dept_id ) as d
on d.dept_id = e.dept_id       
where e.salary > d.avg_salary
order by e.dept_id asc ;

-- (q4)Get employees along with their department and manager’s department.
-- (Trap: double join on same table alias.)

select e.emp_name, d.dept_name as emp_dept,
 m.emp_name as manager_name,
  (select dept_name from departments d where d.dept_id=m.dept_id )as Manger_dept
from employees as e
join departments as d
on e.dept_id = d.dept_id
join employees as m
on e.manager_id = m.emp_id;

-- (q5)Show department names where at least one employee is hired after 2022.
select d.dept_name
from employees as e
inner join departments as d
on d.dept_id=e.dept_id
where year(hire_date) > 2022
group by dept_name;

select emp_name,dept_id, year(hire_date) as yr from employees where year(hire_date) > 2022;

-- (q6)Find employees whose salary is higher than any other employee in the same department.
-- (Trap: requires window or self join with dept_id condition.)
select e.dept_id, e.emp_name, e.salary
from employees as e
left join employees as d
on e.dept_id = d.dept_id
and e.salary < d.salary
where e.dept_id is null;


-- (q7)Show employees who share same last name but are in different departments.
-- (Trap: join condition must exclude same emp_id.)
select e.dept_id as dept_id1,e.emp_name as emp_name1,e.last_name as last_name1,e1.dept_id as dept_id2,e1.emp_name as emp_name2,e1.last_name as last_name2
from employees as e
join employees as e1
    on e.dept_id <> e1.dept_id
    and e.last_name = e1.last_name
    and e.emp_id < e1.emp_id;

-- (q8)Fetch employee-department pairs where department exists but no employees.
-- (Trap: INNER JOIN fails, need LEFT join — interviewer test.)
select e.emp_name,d.dept_name
from employees as e
Right join departments as d
on e.dept_id =d.dept_id
where emp_name is null;


update employees
set 
emp_name = null
where emp_id = 47;

update employees
set 
dept_id = null
where emp_id = 44;


-- (q9)show all employees and their department names (include employees without a department).
select emp_name ,dept_name
from employees as e
left join departments as d
on e.dept_id=d.dept_id;


-- (q10)List departments with employee count (including 0 if no employee).
-- (Trap: requires LEFT JOIN + COUNT.)

select d.dept_name ,count(distinct e.emp_id) as emp_count
from departments as d
left join employees as e
on e.dept_id =d.dept_id
group by dept_name;

-- (q11)Show all employees and their manager names (include employees without managers).
select e.emp_name, m.emp_name as manager_name
from employees as e
left join employees as m
on e.manager_id= m.emp_id;

-- (q12)List employees whose manager record is missing.
-- (Trap: LEFT JOIN + WHERE manager_name IS NULL.)
select e.emp_name, m.emp_name
from employees as e
left join employees as m
on e.manager_id=m.emp_id
where m.emp_name is null;


-- (q13)Show employees whose department is missing in departments table.
-- (Trap: LEFT JOIN with NULL filter.)

select emp_name, dept_name
from employees as e
left join departments as d
on e.dept_id = d.dept_id
where dept_name is null or dept_name = "";

-- (q14)Show all departments and their employees (guarantee departments show even if no employees).
-- (Trap: some DBs require RIGHT JOIN vs LEFT JOIN flipped.)
select dept_name, count(distinct emp_id) as emp_count
from employees as e
right join departments as d
on d.dept_id= e.dept_id
group by dept_name 
order by emp_count asc;


-- (q15)Write query to list departments that do not have any employees.
-- (Trap: RIGHT JOIN / FULL JOIN + NULL filter.)
select dept_name, count(distinct emp_id) as emp_count
from employees as e
right join departments as d
on d.dept_id= e.dept_id
group by dept_name 
having count(distinct emp_id) =0
order by emp_count asc;

-- (q16)Display all employees and all departments — even if they don’t match.
-- (Trap: FULL OUTER JOIN not in MySQL → need UNION of LEFT + RIGHT.)

select emp_name ,dept_name
from employees as e
left join departments as d
on e.dept_id=d.dept_id
union
select emp_name ,dept_name
from employees as e
right join departments as d
on e.dept_id=d.dept_id;

-- (q17)Get employees not assigned to any department + departments without employees.
-- (Trap: FULL OUTER JOIN filter WHERE emp_id IS NULL OR dept_id IS NULL.)

select emp_name ,dept_name
from employees as e
left join departments as d
on e.dept_id=d.dept_id
where emp_id is null or dept_name is null
union
select emp_name ,dept_name
from employees as e
right join departments as d
on e.dept_id=d.dept_id
where emp_id is null or dept_name is null;


-- (q18)Show all employees with same hire_date as at least one other employee.
SELECT e.emp_name, e1.emp_name, month(e.hire_date) as month_
FROM employees e
JOIN employees e1
  ON e.emp_id <> e1.emp_id
  and e.emp_id < e1.emp_id
WHERE month(e.hire_date) = month(e1.hire_date);

-- (q19)Show all employees who earn the same salary as someone else in the company.
select e.emp_name as emp_name1 ,e1.emp_name as emp_name2, e.salary
from employees as e
join employees as e1
on e.emp_id <> e1.emp_id
   and e.emp_id < e1.emp_id
  and e.salary = e1.salary;


-- (q20)List employees who share the same manager.

select e.emp_name as emp_name1 ,e1.emp_name as emp_name2, e.manager_id
from employees as e
join employees as e1
on e.emp_id <> e1.emp_id
   and e.emp_id < e1.emp_id
   and e.manager_id =e1.manager_id;

-- (q21)Find pairs of employees where one earns at least double of the other.
select e.emp_name as emp_name1 ,e1.emp_name as emp_name2, e.salary,e1.salary
from employees as e
join employees as e1
on e.emp_id <> e1.emp_id
   and e.emp_id < e1.emp_id
   and 2*e.salary <= e1.salary;

-- (q22)Get employees where last_name matches another employee’s last_name
select e.emp_name as emp_name1 ,e1.emp_name as emp_name2,e.last_name
from employees as e
join employees as e1
on e.emp_id <> e1.emp_id
   and e.emp_id < e1.emp_id
   and e.last_name =e1.last_name;
   
-- (q22)Generate all possible pairs of department and job titles.
select dept_name, e.job_title
from departments as d
cross join (select distinct job_title from employees) e;

-- (q22)List all possible combinations of employee and project (projects table).
select  emp_name, project_name
from employees as e
cross join (select distinct project_name from projects) as p;

-- (q22)Show every employee compared against every other employee (like similarity matrix).
-- (Trap: need emp1.emp_id < emp2.emp_id to avoid duplicate reverse pairs.)
select e.*, e1.*
from employees as e
inner join employees as e1
on e.emp_id <> e1.emp_id
and e.emp_id < e1.emp_id;

-- (q23)Employees earning more than their manager. (Self join.)
select e.emp_name
from employees as e
join employees as m
on e.manager_id=m.emp_id
where e.salary > m.salary;

-- (q24)Find the second highest salary in each department using join.
-- (Trap: correlated subquery alternative.)
select e.dept_id ,max(e.salary) as second_highest
from employees as e
join (select dept_id,max(salary) as max_Sal from  employees group by dept_id) as e1
on e.dept_id = e1.dept_id
where e.salary < e1.max_Sal
group by e.dept_id;

select dept_id,max(salary) as max_Sal from  employees group by dept_id;

-- (q25)Show employees whose manager works in a different department.
select e.emp_name, e.dept_id,m.emp_name, m.dept_id
from employees as e
join employees as m
on e.manager_id=m.emp_id
and e.dept_id != m.dept_id;

-- (q26)List employees who joined after their manager.
-- (Trap: self join + hire_date condition.)
select e.emp_name,e.hire_date,m.hire_date
from employees as e
join employees as m
on e.manager_id=m.emp_id
and e.hire_date > m.hire_date;


-- (q27)Find employees who don’t have a department, and departments without employees.
-- (Trap: FULL OUTER JOIN simulation.)
select emp_name,dept_name
from employees as e
left join departments as d
on e.dept_id= d.dept_id
where emp_id is null or dept_name is null
union 
select emp_name,dept_name
from employees as e
right join departments as d
on e.dept_id= d.dept_id
where emp_id is null or dept_name is null;


-- (q28)Return employees who share the same email domain as their manager.
select e.emp_name,
SUBSTRING_INDEX(e.email,'@',-1) as domain
from employees as e
join employees as m
on e.manager_id = m.emp_id
where SUBSTRING_INDEX(e.email,'@',-1) = SUBSTRING_INDEX(m.email,'@',-1);

-- (q29)List departments where average salary is greater than average salary of IT department.
-- (Trap: join with subquery.)

select dept_name,avg(salary) as avg_salary
from departments as d
join employees as e
on e.dept_id =d.dept_id
group by dept_name 
having avg(salary) > (select avg(salary) from employees where dept_id=2);


-- (q30)Show employees whose salary is equal to min salary of another department.
select emp_name
from employees as e
join (select dept_id, min(salary) as min_Sal from employees group by dept_id ) as d
on e.dept_id <> d.dept_id
and  e.salary = d.min_Sal;


-- (q31)Show employees who are managers but also report to someone else.

select m.emp_name as manager_name
from employees as e
join employees as m
on e.manager_id= m.emp_id
where m.manager_id is not null;

-- (q32)Show the hiring streak (earliest hire to latest hire) per department.
-- (Trap: MIN + MAX join.)




-- (q32)Find employees who work in multiple departments 
SELECT emp_id, emp_name, COUNT(DISTINCT dept_id) AS dept_count
FROM employees
GROUP BY emp_id, emp_name
HAVING COUNT(DISTINCT dept_id) > 1;


-- (q32)List employees who are the only employee in their department.
-- (Trap: HAVING COUNT=1.)

SELECT emp_id, emp_name, COUNT(DISTINCT dept_id) AS dept_count
FROM employees
GROUP BY emp_id, emp_name
HAVING COUNT(DISTINCT dept_id) = 1;



