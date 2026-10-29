-- Contains a legacy reader that retrieves tickets using the original product code

-- Run before and after expansion. This query represents the old application.
select id, product_code, price, currency
from tickets
order by id;
