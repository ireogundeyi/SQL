select top 100 * from NashvilleHousing

--------------------------------------------------------------------------------------------------------------------

--Change date format
--Sale date shows time as well as date and time is not necessary
--so we need to convert and update it

select SaleDate, Convert(Date, Saledate) from NashvilleHousing

alter table NashvilleHousing
add SaleDate2 date

Update NashvilleHousing
SET SaleDate2 = Convert(Date, SaleDate)

------------------------------------------------------------------------------
--populate property address data 
-- so when analysing data there are rows where property address is null
-- but there are some where parcel id is the same but the property address is missing
-- we infer that address is the same for each parcel id so we can use this to fill in the nulls

select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, isnull(a.propertyaddress, b.propertyaddress) as beforeupdate from 
NashvilleHousing a 
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = isnull(a.propertyaddress, b.propertyaddress)
from NashvilleHousing a 
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

---------------------------------------------------------------------------
--Splitting the address into individual columns

select SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress)-1) as part1address,
		substring(propertyaddress, charindex(',',propertyaddress)+1, len(propertyaddress)) as part2address
from NashvilleHousing

alter table NashvilleHousing
add PropertyAddressName nvarchar(255)

update NashvilleHousing
set PropertyAddressName = SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress)-1)

alter table NashvilleHousing
add PropertyAddressCity nvarchar(255)

update NashvilleHousing
set PropertyAddressCity = substring(propertyaddress, charindex(',',propertyaddress)+1, len(propertyaddress))

select PropertyAddressCity from NashvilleHousing

-------------------------------------------------------
--another way to split strings is using parsename and it automatically uses fullstops as the delimiter
--meaning you will need to split it with a period.
--the numbers at the end represent the section you are splitting and it works backwards for some reason
select 
parsename(replace(OwnerAddress, ',','.'),3) as part1,
parsename(replace(OwnerAddress, ',','.'),2) as part2,
parsename(replace(OwnerAddress, ',','.'),1) as part3
from NashvilleHousing


alter table NashvilleHousing
add OwnerAddressName nvarchar(255),
	OwnerAddressCity varchar(255),
	OwnerAddressState varchar(255)

update NashvilleHousing
set OwnerAddressName = parsename(replace(OwnerAddress, ',','.'),3),
	OwnerAddressCity = parsename(replace(OwnerAddress, ',','.'),2),
	OwnerAddressState = parsename(replace(OwnerAddress, ',','.'),1)

---------------------------------------------------------------------------------------------
-- change y and n to yes and no

--How many different values in soldasvacant and the count
select distinct soldasvacant, count(soldasvacant) as count
from NashvilleHousing
group by SoldAsVacant
order by 2 desc


select SoldAsVacant,
	case when SoldAsVacant = 'Y' then 'Yes'
		 when SoldAsVacant = 'N' then 'No'
		 else SoldAsVacant
		 end
from NashvilleHousing

update NashvilleHousing
set Soldasvacant = case when SoldAsVacant = 'Y' then 'Yes'
		 when SoldAsVacant = 'N' then 'No'
		 else SoldAsVacant
		 end

------------------------------------------------------------------------------------------------------------
--removing duplicates
--The ROW_NUMBER() is a window function that assigns a sequential integer to each row within the partition of a result set.
-- so if we partition by city and there are 3 cities that are the same, it assigns row 1,2,3 to the cities
--The row number starts with 1 for the first row in each partition.
-- so if there is 


with rownumcte as (
select *, 
		ROW_NUMBER() over (
		partition by parcelid,
					 propertyaddress,
					 saledate,
					 saleprice,
					 legalreference
					 order by parcelid
					 ) as row_num

from NashvilleHousing
) 
delete from rownumcte
where row_num > 1


-----------------------------------------------------------------------------------------------------
--Delete unused columns

alter table NashvilleHousing
drop column owneraddress,
			taxdistrict,
			propertyaddress

select * from NashvilleHousing



