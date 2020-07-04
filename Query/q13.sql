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



