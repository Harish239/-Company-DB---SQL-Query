#SELECT DISTINCT 1 FROM departments

select dm.emp_no, d.dept_name
from dept_manager dm
inner join departments d on dm.dept_no = d.dept_no
where datediff(dm.to_date, dm.from_date) >= all(select datediff(dm2.to_date, dm2.from_date) from dept_manager dm2 where dm.dept_no=dm2.dept_no and year(dm2.to_date)<>'9999')
and year(dm.to_date)<>'9999'
order by dm.emp_no