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

ALTER TABLE mcdonalds_clean
ADD COLUMN City VARCHAR(100);

       
UPDATE mcdonalds_clean as mcc
join macdonalds_hygeine_csv as mch
on mcc.full_address = mch.full_address
SET mcc.City = mch.AddressLine3;

#the data for county was missing from many rows and i needed a clean county column for analysis
#so using AI assistance to genetrate the county names using the post code i filled up the county column

ALTER TABLE mcdonalds_clean
ADD COLUMN County VARCHAR(100);

UPDATE mcdonalds_clean AS c
JOIN macdonalds_hygeine_csv AS h
    ON c.full_address = h.full_address
SET c.County =
    CASE
        WHEN h.PostCode LIKE 'CB%' THEN 'Cambridgeshire'
        WHEN h.PostCode LIKE 'PE%' THEN 'Cambridgeshire'
        WHEN h.PostCode LIKE 'SS%' THEN 'Essex'
        WHEN h.PostCode LIKE 'CM%' THEN 'Essex'
        WHEN h.PostCode LIKE 'CO%' THEN 'Essex'
        WHEN h.PostCode LIKE 'EN%' THEN 'Hertfordshire'
        WHEN h.PostCode LIKE 'HP%' THEN 'Buckinghamshire'
        WHEN h.PostCode LIKE 'WD%' THEN 'Hertfordshire'
        WHEN h.PostCode LIKE 'NR%' THEN 'Norfolk'
        WHEN h.PostCode LIKE 'IP%' THEN 'Suffolk'
        WHEN h.PostCode LIKE 'MK%' THEN 'Buckinghamshire'
        WHEN h.PostCode LIKE 'LU%' THEN 'Bedfordshire'
        WHEN h.PostCode LIKE 'RM%' THEN 'Essex'
        WHEN h.PostCode LIKE 'DE%' THEN 'Derbyshire'
        WHEN h.PostCode LIKE 'S%' THEN 'South Yorkshire'
        WHEN h.PostCode LIKE 'NG%' THEN 'Nottinghamshire'
        WHEN h.PostCode LIKE 'LE%' THEN 'Leicestershire'
        WHEN h.PostCode LIKE 'LN%' THEN 'Lincolnshire'
        WHEN h.PostCode LIKE 'NN%' THEN 'Northamptonshire'
        WHEN h.PostCode LIKE 'DN%' THEN 'South Yorkshire'
        WHEN h.PostCode LIKE 'HA%' THEN 'London'
        WHEN h.PostCode LIKE 'NW%' THEN 'London'
        WHEN h.PostCode LIKE 'N%' THEN 'London'
        WHEN h.PostCode LIKE 'BR%' THEN 'London'
        WHEN h.PostCode LIKE 'DA%' THEN 'Kent'
        WHEN h.PostCode LIKE 'CR%' THEN 'London'
        WHEN h.PostCode LIKE 'EC%' THEN 'London'
        WHEN h.PostCode LIKE 'UB%' THEN 'London'
        WHEN h.PostCode LIKE 'W%' THEN 'London'
        WHEN h.PostCode LIKE 'E%' THEN 'London'
        WHEN h.PostCode LIKE 'IG%' THEN 'London'
        WHEN h.PostCode LIKE 'KT%' THEN 'Surrey'
        WHEN h.PostCode LIKE 'SW%' THEN 'London'
        WHEN h.PostCode LIKE 'SE%' THEN 'London'
        WHEN h.PostCode LIKE 'SM%' THEN 'Surrey'
        WHEN h.PostCode LIKE 'NE%' THEN 'Tyne and Wear'
        WHEN h.PostCode LIKE 'SR%' THEN 'Tyne and Wear'
        WHEN h.PostCode LIKE 'DH%' THEN 'County Durham'
        WHEN h.PostCode LIKE 'DL%' THEN 'County Durham'
        WHEN h.PostCode LIKE 'TS%' THEN 'Teesside'
        WHEN h.PostCode LIKE 'BT%' THEN 'Northern Ireland'
        WHEN h.PostCode LIKE 'CA%' THEN 'Cumbria'
        WHEN h.PostCode LIKE 'LA%' THEN 'Lancashire'
        WHEN h.PostCode LIKE 'PR%' THEN 'Lancashire'
        WHEN h.PostCode LIKE 'FY%' THEN 'Lancashire'
        WHEN h.PostCode LIKE 'BB%' THEN 'Lancashire'
        WHEN h.PostCode LIKE 'BL%' THEN 'Greater Manchester'
        WHEN h.PostCode LIKE 'M%' THEN 'Greater Manchester'
        WHEN h.PostCode LIKE 'L%' THEN 'Merseyside'
        WHEN h.PostCode LIKE 'WN%' THEN 'Greater Manchester'
        WHEN h.PostCode LIKE 'WA%' THEN 'Cheshire'
        WHEN h.PostCode LIKE 'CW%' THEN 'Cheshire'
        WHEN h.PostCode LIKE 'CH%' THEN 'Cheshire'
        WHEN h.PostCode LIKE 'GU%' THEN 'Surrey'
        WHEN h.PostCode LIKE 'PO%' THEN 'Hampshire'
        WHEN h.PostCode LIKE 'SO%' THEN 'Hampshire'
        WHEN h.PostCode LIKE 'RG%' THEN 'Berkshire'
        WHEN h.PostCode LIKE 'BN%' THEN 'East Sussex'
        WHEN h.PostCode LIKE 'TN%' THEN 'Kent'
        WHEN h.PostCode LIKE 'CT%' THEN 'Kent'
        WHEN h.PostCode LIKE 'OX%' THEN 'Oxfordshire'
        WHEN h.PostCode LIKE 'SN%' THEN 'Wiltshire'
        WHEN h.PostCode LIKE 'PL%' THEN 'Devon'
        WHEN h.PostCode LIKE 'TR%' THEN 'Cornwall'
        WHEN h.PostCode LIKE 'EX%' THEN 'Devon'
        WHEN h.PostCode LIKE 'DT%' THEN 'Dorset'
        WHEN h.PostCode LIKE 'GL%' THEN 'Gloucestershire'
        WHEN h.PostCode LIKE 'TA%' THEN 'Somerset'
        WHEN h.PostCode LIKE 'BS%' THEN 'Bristol'
        WHEN h.PostCode LIKE 'BA%' THEN 'Somerset'
        WHEN h.PostCode LIKE 'BH%' THEN 'Dorset'
        WHEN h.PostCode LIKE 'LL%' THEN 'Wales'
        WHEN h.PostCode LIKE 'NP%' THEN 'Wales'
        WHEN h.PostCode LIKE 'CF%' THEN 'Wales'
        WHEN h.PostCode LIKE 'SA%' THEN 'Wales'
        WHEN h.PostCode LIKE 'WR%' THEN 'Worcestershire'
        WHEN h.PostCode LIKE 'DY%' THEN 'West Midlands'
        WHEN h.PostCode LIKE 'WS%' THEN 'West Midlands'
        WHEN h.PostCode LIKE 'ST%' THEN 'Staffordshire'
        WHEN h.PostCode LIKE 'CV%' THEN 'Warwickshire'
        WHEN h.PostCode LIKE 'YO%' THEN 'North Yorkshire'
        WHEN h.PostCode LIKE 'HG%' THEN 'North Yorkshire'
        WHEN h.PostCode LIKE 'BD%' THEN 'West Yorkshire'
        WHEN h.PostCode LIKE 'HX%' THEN 'West Yorkshire'
        WHEN h.PostCode LIKE 'HD%' THEN 'West Yorkshire'
        WHEN h.PostCode LIKE 'WF%' THEN 'West Yorkshire'
        WHEN h.PostCode LIKE 'LS%' THEN 'West Yorkshire'
        ELSE 'Unknown'
    END;












