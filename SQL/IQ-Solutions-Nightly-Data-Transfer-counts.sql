use [nichd]
select top 20 datesubmitted, count(*) as thecount
from shoppingcartorders
group by datesubmitted
order by datesubmitted desc