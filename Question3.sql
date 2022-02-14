-- Write queries for the following:

-- 3)Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.

select customer.cus_gender, count(customer.cus_gender) as count 
from customer 
inner join `order`
on customer.cus_id = `order`.cus_id
where `order`.ORD_AMOUNT >= 3000
group by customer.cus_gender;


-- 4)Display all the orders along with the product name ordered by a customer having Customer_Id=2.

select `order`.PROD_ID , product.PRO_NAME, `order`.ORD_ID, `order`.ORD_AMOUNT , `order`.ORD_DATE, `order`.CUS_ID  from `order`
inner join product_details
on `order`.PROD_ID = product_details.PRO_ID
inner join product
on product_details.PROD_ID = product.PRO_ID
where `order`.CUS_ID=2 ;

-- 5)Display the Supplier details who can supply more than one product.

select * from `supplier` where `supplier`.supp_id in (
select product_details.SUPP_ID from product_details
group by product_details.SUPP_ID
having count(product_details.SUPP_ID) > 1);

-- 6)Find the category of the product whose order amount is minimum.

select category.*, product.PRO_ID, product_details.PROD_ID, `order`.ORD_AMOUNT  from `order`
inner join product_details 
on `order`.PROD_ID = product_details.PROD_ID
inner join product
on product.PRO_ID = product_details.PROD_ID
inner join category
on category.CAT_ID = product.CAT_ID
having min(`order`.ORD_AMOUNT);


-- 7)Display the Id and Name of the Product ordered after “2021-10-05”.

select product.PRO_ID,product.PRO_NAME from product
inner join product_details
on product.PRO_ID = product_details.PROD_ID
inner join `order`
on `order`.PROD_ID = product_details.PROD_ID
where `order`.ORD_DATE > "2021-10-05";

-- 8)Display customer name and gender whose names start or end with character 'A'.

select * from customer 
where  ( customer.CUS_NAME like 'A%') OR ( customer.CUS_NAME like '%A');

-- 9) Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.

DELIMITER //
DROP PROCEDURE IF EXISTS SP_CATEGORY;
CREATE PROCEDURE SP_CATEGORY()
BEGIN
SELECT supplier.supp_id,supplier.supp_name,
case when rating.RAT_RATSTARS > 4 then 'Genuine Supplier'
	when rating.RAT_RATSTARS > 2 then 'Average Supplier'
    else 'Supplier should not be considered'
    end as verdict
from rating SP_CATEGORY
inner join supplier
on rating.SUPP_ID=supplier.SUPP_ID;
end
//
DELIMITER ;

call SP_CATEGORY();