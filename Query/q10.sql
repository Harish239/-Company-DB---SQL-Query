#SELECT DISTINCT 1 FROM departments

/*select eh.emp_no, eh.salary, eh.hire_date, el.emp_no, el.salary, el.hire_date
from (select e.emp_no, e.hire_date, s.salary from employees.employees e inner join employees.salaries s on e.emp_no = s.emp_no where year(e.birth_date)=1965 and year(s.to_date)=9999) eh,
(select e1.emp_no, e1.hire_date, s1.salary from employees.employees e1 inner join employees.salaries s1 on e1.emp_no = s1.emp_no where year(e1.birth_date)=1965 and year(s1.to_date)=9999) el
where eh.hire_date>el.hire_date
order by eh.emp_no, el.emp_no*/
with nt
as
(
select e.emp_no, s.salary, e.hire_date
from employees.employees e 
inner join employees.salaries s on e.emp_no = s.emp_no
where year(e.birth_date)=1965 and year(s.to_date)=9999
)

select nt.emp_no as h_empno, nt.salary as h_salary, nt.hire_date as h_date, nt1.emp_no as l_empno, nt1.salary as l_salary, nt1.hire_date as l_date 
from nt, nt as nt1
where nt.salary>nt1.salary
and nt.hire_date > nt1.hire_date
order by nt.emp_no, nt1.emp_no