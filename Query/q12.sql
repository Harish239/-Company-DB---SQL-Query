#SELECT DISTINCT 1 FROM departments
with md
as
(
select de.dept_no,d.dept_name, avg(s.salary) as avg_salary, count(s.salary) as head_count
from dept_emp de
inner join salaries s on de.emp_no = s.emp_no
inner join departments d on d.dept_no = de.dept_no 
where year(s.to_date)=9999 and year(de.to_date)=9999
group by dept_no
)

select md.dept_name, (count(de.dept_no)/head_count)*100 as above_avg_pect
from dept_emp de
inner join salaries s on s.emp_no = de.emp_no
inner join md on md.dept_no = de.dept_no
where year(de.to_date)=9999 and year(s.to_date)=9999
and s.salary> md.avg_salary
group by de.dept_no
order by md.dept_name

