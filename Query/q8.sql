#SELECT DISTINCT 1 FROM departments

select d.dept_name, (count(d.dept_name)-1) cnt
from employees.dept_manager dm
inner join employees.departments d on d.dept_no = dm.dept_no
group by d.dept_name
having count(d.dept_name)>2
order by d.dept_name;
