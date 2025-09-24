-- q1 Show employees with salary category → "High" (>80k), "Medium" (50k–80k), "Low" (<50k).
select emp_name,
case when salary > 80000 then "High" 
     when salary  between 50000 and 80000 then "Medium"
     when salary < 50000 then "Low"
     else "Other"
     end as Salary_Category
from employees;     
-- q2 Show employees’ dept_name and a CASE column → if dept = IT → “Tech Team”, else “Non-Tech”.

select emp_name,
dept_name,
case when dept_name ="IT" then "Tech Team" Else "Non-Tech" end as Dept_Type
from employees as e
inner join departments as d
on e.dept_id= d.dept_id;

-- q3 Display employees → if manager_id IS NULL → "Top Manager", else "Reportee".
select emp_name,
case when manager_id is null then "Top Manager" else "Reportee" end as Emp_type
from employees;

-- q4 Show project employees with case → if no project assigned → "Unassigned".
select emp_name, project_name,
case when project_name is null then "Unassigned" else "Assigned" end as project_status
from employees as e
left join projects as p
on e.dept_id= p.dept_id;

-- q5 (Trap) Show salary hikes: if dept = HR → +10%, IT → +15%, others → +5% (using CASE).

select emp_name,salary,
case when dept_name = "HR" then "10%"
     when dept_name= "IT" then "15%"
     else "5%"
     end as Hike_perc
,
case when dept_name = "HR" then round(salary+(salary * 10)/100 ,0)
     when dept_name= "IT" then round(salary+(salary * 15)/100,0)
     else round(salary+(salary * 5)/100,0)
     end as Hiked_salary
from employees as e     
inner join departments as d
on e.dept_id = d.dept_id;


-- q6 Categorize employees based on hire_date → "Before 2020", "2020–2022", "After 2022".

select emp_name,
case when year(hire_date) < 2020 then "Before 2020"
     when year(hire_date) between 2020 and 2022 then "2020-2022"
     when  year(hire_date) > 2022 then "After 2022"
     else "Other"
     end as hire_category
from employees;

-- q7 Show employees’ full name (first + last) using CONCAT().
select concat(emp_name," " ,last_name) as full_name
from employees ;

-- q8 Extract domain name from email (SUBSTRING + CHARINDEX/INSTR).
select emp_name,
SUBSTRING_INDEX(SUBSTRING_INDEX(email,"@",-1),".",1) as domain_name
from employees;

-- q9Show employees whose email ends with "@company.com".
select emp_name
from employees
where email like "%@company.com";

-- q10 Find employees with phone numbers starting with '123'.

select emp_name, phone_number
from employees
where phone_number like "123%";

-- q11 Show employees whose last name length > 5 (LENGTH function).
select emp_name,last_name
from employees
where length(last_name) >5;

-- q12 Convert all employee names into UPPERCASE.
select upper(emp_name) as EMP_Name
from employees;

-- q13 Display first 3 letters of each employee’s last name.
select emp_name,last_name,
left(last_name,3) as first3_letters
from employees;

-- q14 Replace all '@company.com' with '@test.com'.
select emp_name, email,
replace(email,
         "@company.com",
         "@test.com") as revised_email
from employees;		

-- q15 (Trap) Find employees whose first name and last name start with the same letter.
select emp_name ,last_name
from employees
where left(emp_name,1)= left(last_name,1);

-- q16 Count employees grouped by email domain (SUBSTRING logic).
select SUBSTRING_INDEX(SUBSTRING_INDEX(email,"@",-1),".",1) as domain_name,
count(distinct emp_id) as emp_count
from employees
group by SUBSTRING_INDEX(SUBSTRING_INDEX(email,"@",-1),".",1) ;


-- q17 Show initials of each employee (LEFT(first_name,1) + LEFT(last_name,1)).
select concat(upper(left(emp_name,1)), upper(left(last_name,1))) as Initials
from employees;

-- q18 Show employees hired in the year 2023.
select emp_name
from employees
where year(hire_date) = 2023;

-- q19 Show employees hired in February month (any year).
select emp_name,hire_date
from employees
where month(hire_date)=2;

-- q20 Show employees hired on weekends (Saturday/Sunday).
select emp_name
from employees
where dayname(hire_date)="Saturday"
      or dayname(hire_date)="Sunday";

-- q21 Find employees hired in a leap year.
select emp_name,year(hire_date) as year
from employees
where year(hire_date)%4 = 0
     or  year(hire_date)%100 <> 0 and  year(hire_date)%400 = 0;

-- q22 Show employees with tenure > 3 years (DATEDIFF from today).
select emp_name,datediff(curdate(),hire_date) as tenure_days
from employees
where datediff(curdate(),hire_date) > 1095;

select emp_name,hire_date,
timestampdiff(year,hire_date,curdate())
from employees
where timestampdiff(year,hire_date,curdate()) >3;

-- q23 Show employees whose hire_date is the earliest in each department.
with hire_table as 
(select dept_id,emp_name,hire_date,
dense_rank() over (partition by dept_id order by hire_date asc) as rank_
from employees
)
select * from hire_table
where rank_=1;

-- q24 Find employees whose hire_date = last day of any month.
select emp_name,hire_date
from employees
where hire_date= last_day(hire_date);

-- q25 Show how many employees joined each year (YEAR(hire_date) + COUNT).
select year(hire_date) as joined_year ,count(distinct emp_id) as emp_count
from employees
group by year(hire_date) 
order by emp_count desc;

-- q26 Calculate employees’ exact experience in months (TIMESTAMPDIFF).
select emp_name,
timestampdiff(month,hire_date,curdate()) as exp_months
from employees;

-- q27 (Trap) Find employees hired on the same date across different years.
select e.emp_name,e1.emp_name
from employees as e
join employees as e1 
where day(e.hire_date)=day(e1.hire_date)
      and month(e.hire_date)= month(e1.hire_date)
      and e1.emp_id<>e.emp_id
      and e.emp_id<e1.emp_id;

-- q28 Show employees who joined in the last 30 months.
select emp_name,
timestampdiff(month,hire_date,curdate()) as exp_months
from employees
where timestampdiff(month,hire_date,curdate()) < 30;

-- q29 Find employees whose hire_date = today’s date (ignoring year).
select emp_name
from employees
where day(hire_date)=day(curdate())
      and month(hire_date)= month(curdate());

-- q30 Show day name of hire_date (Monday, Tuesday, etc.).
select emp_name,
dayname(hire_date) as day_name
from employees;

-- q31 Show employees with CASE → if email domain = company.com → "Internal", else "External".
select emp_name,
case when SUBSTRING_INDEX(sUBSTRING_INDEX(email,"@",-1),".",1) = "company" then "INTERNAL"
     ELSE "EXTRENAL"
     END as emp_contract_type
from employees;     

-- q32 Show employees hired before 2020 → label them "Old Employee", others "New Employee".
select emp_name,
case when year(hire_date) <= 2020 then "Old Employee" else "New Employees" end as emp_type
from employees;

-- q33 Display employees’ phone → if missing/NULL → "Not Provided", else show last 4 digits.
select emp_name,
case when phone_number is null 
	or trim(phone_number)= ''
    then "Not- Provided" 
	else right(phone_number,4)
	end as Contact_status
from employees;     

-- q34 Show employees with CASE → if salary > dept_avg → "Above Avg", else "Below Avg".
with avg_table as
(
select dept_id,emp_name,salary,
avg(salary) over (partition by dept_id) as dept_avg
from employees
)
select emp_name,
case when salary > dept_avg then "Above AVG"
	 else "Below AVG"
	 end as salary_type
from avg_table;

-- q35 (Trap) Display employees → if hire month = current month → "Work Anniversary", else "Regular".
select emp_name,
case when month(hire_date)= month(curdate()) then " Anniversary" 
      else "Regular"
      end as anniversary
from employees;      