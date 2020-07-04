#SELECT DISTINCT 1 FROM departments
with md
as
(
select d.dept_name, (min(s.salary*-1)*-1) as salary
from dept_emp d_e
inner join departments d on d.dept_no = d_e.dept_no
inner join salaries s on d_e.emp_no = s.emp_no
where year(s.to_date)= 9999
group by d.dept_name
)

select d.dept_name, d_e.emp_no, s.salary
from dept_emp d_e 
inner join salaries s on d_e.emp_no = s.emp_no
inner join departments d on d.dept_no = d_e.dept_no
where s.salary = (select md.salary from md where md.salary = s.salary and md.dept_name = d.dept_name)







 