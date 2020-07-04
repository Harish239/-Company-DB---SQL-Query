select t.emp_no, count(t.emp_no) cnt 
from salaries s
right join titles t on t.emp_no = s.emp_no and t.from_date = s.from_date
where t.emp_no in (select t.emp_no from titles t group by t.emp_no)
and s.salary is null
group by t.emp_no
order by t.emp_no 