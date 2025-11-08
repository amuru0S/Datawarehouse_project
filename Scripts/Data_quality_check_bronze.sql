#Quality check 1- 
# 1. Primary key should be unique and not null 
# 2. Expectations no records
select cst_id, count(*) 
from bronze_crm_cust_info 
group by cst_id
having count(*)>1 or cst_id is null;

select * from bronze_crm_cust_info where cst_id = 29466;

select * from (select *, row_number() over (partition by cst_id order by cst_create_date DESC) as flag
from bronze_crm_cust_info) as tbl1
where flag=1 and cst_id!= 0;

#Quality check 2-
# 1. check for whitespaces in the string value.
# 2. expectation no records

select cst_id,
cst_key,
trim(cst_firstname) as cst_firstname,
trim(cst_lastname) as cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
from bronze_crm_cust_info;

#Quality check 3-
#1. Check for consistency in values of low cardinal columns
#2. Store clear meaningful values rather than abbreviations
#3. Use 'N/A' for missing values in non-nul columns like gender
#4. Make sure capitalize the abbreviated names and trim to maitain the same check for each data
#5. These are done for standadizations
select cst_id,
cst_key,
trim(cst_firstname) as cst_firstname,
trim(cst_lastname) as cst_lastname,
case when upper(trim(cst_marital_status)) = 'M' then 'Married'
when upper(trim(cst_marital_status)) = 'S' then 'Single'
else 'N/A' end as cst_marital_status,
case when upper(trim(cst_gndr)) = "M" then "Male"
when upper(trim(cst_gndr)) = 'F' then 'Female'
else 'N/A' end as cst_gndr,
cst_create_date
from bronze_crm_cust_info;

# Data Transformations which has done - 
# 1. Removed unwanted spaces
# 2. Handeled missing values
# 3. Data normalizations & standadizations
# 4. removed duplicates