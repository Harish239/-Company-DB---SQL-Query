select e.last_name, s.salary, s.from_date,
s.to_date
from employees.employees e
inner join employees.salaries s
on e.emp_no = s.emp_no
order by e.last_name, s.salary, s.from_date,
s.to_date;