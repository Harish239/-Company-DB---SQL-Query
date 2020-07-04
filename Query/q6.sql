with md
as
(
select e.emp_no 
from employees e
inner join dept_emp d_e on e.emp_no = d_e.emp_no
where d_e.dept_no='d001' and year(e.birth_date)=1955 and year(d_e.to_date)=9999
)

select a.emp_no as e1, b.emp_no as e2
from md a, md b
where a.emp_no < b.emp_no
order by a.emp_no, b.emp_no;
