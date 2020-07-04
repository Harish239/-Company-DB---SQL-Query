select e.emp_no, d.dept_name, d_e.from_date
from employees.dept_emp d_e
inner join employees.departments d on d.dept_no = d_e.dept_no
inner join employees.employees e on e.emp_no = d_e.emp_no
where d_e.to_date='9999-01-01'
order by e.emp_no;