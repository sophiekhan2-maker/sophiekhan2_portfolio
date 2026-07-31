select * 
from macdonalds_hygeine_csv;

# really messy data needs cleaning, needs strandadising 

select AddressLine1, AddressLine2, AddressLine3, AddressLine4, count(*)
from macdonalds_hygeine_csv
group by  AddressLine1, AddressLine2, AddressLine3, AddressLine4;

## need to deal with the missing values 
UPDATE  macdonalds_hygeine_csv
SET AddressLine1 = NULLIF(AddressLine1, ''),
    AddressLine2 = NULLIF(AddressLine2, ''),
    AddressLine3 = NULLIF(AddressLine3, ''),
    AddressLine4 = NULLIF(AddressLine4, '');
    
    
ALTER TABLE macdonalds_hygeine_csv
ADD COLUMN full_address VARCHAR(500);

UPDATE  macdonalds_hygeine_csv
set 
full_address = concat_ws(',', AddressLine1, AddressLine2, AddressLine3, AddressLine4) 
;

select BusinessType
from macdonalds_hygeine_csv
group by  BusinessType;


### these are the colunms that are required for the analysis , it will be easy to handle
# if i just made a seperate table from it , to avoind the repeted filtering in future

create table mcdonalds_clean as
select full_address,
	   BusinessType,
       ConfidenceInManagement,
       Hygiene,
       Structural,
       RatingValue,
       RAtingKey
from macdonalds_hygeine_csv;
       
       



