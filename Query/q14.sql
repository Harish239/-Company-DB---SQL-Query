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
