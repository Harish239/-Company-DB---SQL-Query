select d.dept_name, count(d_e.emp_no) as noe
from employees.dept_emp d_e
inner join employees.departments d on d.dept_no = d_e.dept_no
group by d.dept_name
order by d.dept_name

#SELECT DISTINCT 1 FROM departments
