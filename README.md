## CSE 560 Data Models and Query Language
### Company DB - SQL Query

## 1 Project Setup

## 1.1 MySQL

This project ONLY use MySQL (version 8.0.13) as the canonical database. To
download MySQL community server, please go to https://downloads.mysql.com/archives/community/.

## 1.2 Database: Employees

Follow the steps below to install the project database

1. Download the GitHub Repository:https://github.com/datacharmer/test_db
2. Launch command line console, change the working directory to your downloaded repository
3. Type following command:
    `mysql < employees.sql`
    or
    `mysql -u YOURMYSQLUSERNAME -p < employees.sql`
    This will initialize your database.
4. To verify installation, run following commands:
    `mysql -t < testemployeesmd5.sql`
    or
    `mysql -u YOURMYSQLUSERNAME -p < testemployeesmd5.sql`


### Problem 1

Find all employees’ employee number, birth date, gender. Sort the result by
employee number. 

#### Query
`select emp_no, birth_date, gender 
from employees
order by emp_no;`

### Problem 2

Find all female employees and sort the result by employee number.

#### Query
`select * 
from employees
where gender='F'
order by emp_no;`

### Problem 3

Find all employees’ last name with their salaries in different periods. Sort the
result by last name, salary, fromdate, then todate.

#### Query

```
select e.last_name, s.salary, s.from_date,
s.to_date
from employees.employees e
inner join employees.salaries s
on e.emp_no = s.emp_no
order by e.last_name, s.salary, s.from_date,
s.to_date;
```


### Problem 4

Find all employees’ current department and the start date with their employee
number and sort the result by employee number.

#### Query

```
select e.emp_no, d.dept_name, d_e.from_date
from employees.dept_emp d_e
inner join employees.departments d on d.dept_no = d_e.dept_no
inner join employees.employees e on e.emp_no = d_e.emp_no
where d_e.to_date='9999-01-01'
order by e.emp_no;
```


### Problem 5

List the number of employees in each department. Sort the result by department
name.

#### Query

```
select d.dept_name, count(d_e.emp_no) as noe
from employees.dept_emp d_e
inner join employees.departments d on d.dept_no = d_e.dept_no
group by d.dept_name
order by d.dept_name
```


### Problem 6

List pairs of employee (e1, e2 ) which satisfies ALL following conditions:

1. Both e1 and e2 ’s current deparmnet number is d001.
2. The year of birthdate for e1 and e2 is 1955.
3. The e1’s employee number is less than e2.

Sort the result by e1 then e2.

#### Query

```
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
```


### Problem 7

For each department, list out the manager who stayed the longest time in the
department. The list needs to exclude the current manager. Sort the result by
employ number.

#### Query

```
select dm.emp_no, d.dept_name
from dept_manager dm
inner join departments d on dm.dept_no = d.dept_no
where datediff(dm.to_date, dm.from_date) >= all(select datediff(dm2.to_date, dm2.from_date) from dept_manager dm2 where dm.dept_no=dm2.dept_no and year(dm2.to_date)<>'9999')
and year(dm.to_date)<>'9999'
order by dm.emp_no
```


### Problem 8

Find out departments which has changed its manager more than once then list
out the name of the departments and the number of changes. Sort the result
by department name.

#### Query

```
select d.dept_name, (count(d.dept_name)-1) cnt
from employees.dept_manager dm
inner join employees.departments d on d.dept_no = dm.dept_no
group by d.dept_name
having count(d.dept_name)>2
order by d.dept_name;
```


### Problem 9

For each employee, find out how many times the title has been changed without
changing of the salary. e.g. An employee promoted from Engineer to Sr. Engineer
with salaries remains 10k. Sort the result by employ number.

#### Query 

```
select t.emp_no, count(t.emp_no) cnt 
from salaries s
right join titles t on t.emp_no = s.emp_no and t.from_date = s.from_date
where t.emp_no in (select t.emp_no from titles t group by t.emp_no)
and s.salary is null
group by t.emp_no
order by t.emp_no 
```


### Problem 10

Find out those pairs of employees (eH, eL) which satisfy ALL following conditions:

1. Both eH and eL born in 1965

2. eH’s current salary is higher than eL’s current salary

3. eH’s hiring date is greater than eL, which means eH is a newer employee
than eL.

Sort the result by employee number of eH then employee number of eL.

- hempno :eH’s employee number
- hsalary :eH’s current salary
- hdate :eH’s hire date
- lempno :eL’s employee number
- lsalary :eL’s current salary
- ldate :eL’s hire date

#### Query

```
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
```


### Problem 11

Find the employee with highest current salary in each department. Note that
MAX function is not allowed. Sort the result by department name.

#### Query

```
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
```


### Problem 12

Calculate the percentage of number of employees’ current salary is above the
department current average. Sort the result by department name.

#### Query

```
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
```

### Problem 13

Assuming a title is a node and a promotion is an edge between nodes. e.g.
And promotion from Engineer to Senior Engineer means their is a path from
Node ’Engineer’ to Node ’Senior Engineer’. Find out pairs of node of source
and destination (src, dst) which there is no such path in the database. Sort the
result by src then dst. 

#### Query

```
with recursive r
as
(
select distinct e1.title src, e2.title dst
from titles e1, titles e2
where e1.title<>e2.title 
and e1.from_date<e2.from_date
and e1.emp_no=e2.emp_no 
Union
select r.src, s1.dst
from (select distinct e1.title src, e2.title dst
from titles e1, titles e2
where e1.title<>e2.title 
and e1.from_date<e2.from_date
and e1.emp_no=e2.emp_no) s1, r
where r.dst = s1.src
), 
all_row
as
(
select distinct e1.title src, e2.title dst
from (select distinct title from titles) e1, (select distinct title from titles) e2
)
select * from all_row
where (all_row.src,all_row.dst)
NOT IN (select * from r)
order by src,dst
```


### Problem 14

Continued from problem 13, assuming we treat the years from beginning of a
title until promotion as the distance between nodes. e.g. An employee started as
an Assistant Engineer from 1950-01-01 to 1955-12-31 then be promoted to Engineer on 1955-12-31.
Then there is an edge between node ”Assistant Engineer” to ”Engineer” with distance 6.
Calculate the average distance of all possible pair of titles and ordered by
source node. To simplify the problem, there is no need to consider months and
date when calculating the distance. Only year is required for calculating the
distance. Besides, we can assume the distances of any given pair is less than
100.
Sort the result by src then dst.

#### Query
```
with recursive r(src,dst,years, dummy)
as
(
select e1.title src, e2.title dst, avg((year(e1.to_date) - year(e1.from_date)+1)) as years,0
from titles e1, titles e2
where e1.emp_no=e2.emp_no
and e1.title<>e2.title
and e1.to_date = e2.from_date
group by e1.title, e2.title
union
select r.src, e1.dst, (r.years+e1.years) as years, r.dummy+1
from 
(select e1.title src, e2.title dst, avg(year(e1.to_date) - year(e1.from_date)+1) as years
from titles e1, titles e2
where e1.emp_no=e2.emp_no
and e1.title<>e2.title
and e1.to_date = e2.from_date
group by e1.title, e2.title) e1, r
where r.dst = e1.src and dummy<7
)

select src,dst,min(years) years from r 
where src != dst
group by src,dst
order by src
```
