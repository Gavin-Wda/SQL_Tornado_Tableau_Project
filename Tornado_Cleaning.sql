-- Explore the data

Select *
From Tornado_Tracks..Tornado_Tracks
-- Renamed columns for readability using Table Design

-- Ensure OBJECTID is a Unique Identifier 

Select Distinct(OBJECTID)
From Tornado_Tracks..Tornado_Tracks
-- OBJECTID is the Unique Identifier (same entry count)

-- Checking for duplicates 

With duplicates As
(
Select *, Row_Number() Over (
					   Partition by OBJECTID,
									om,
									year,
									month,
									day,
									date,
									time,
									time_zone,
									state_abbr
									Order by OBJECTID)
									As row_num
From Tornado_Tracks..Tornado_Tracks
)
Select *
From duplicates
Where row_num > 1

-- Fixing date & time columns (datatype) 

Alter Table Tornado_Tracks..Tornado_Tracks
Add NewDate Date

Update Tornado_Tracks..Tornado_Tracks
Set NewDate = Convert(date, date)

Select time, convert(time, time)
From Tornado_Tracks..Tornado_Tracks

Alter Table Tornado_Tracks..Tornado_Tracks
Add NewTime time

Update Tornado_Tracks..Tornado_Tracks
Set NewTime = Convert(time, time)

-- Checking for null entries

Select *
From Tornado_Tracks..Tornado_Tracks
Where year Is Null 
Or OBJECTID Is Null 
Or time_zone Is Null 
Or state_abbr Is Null 
Or magnitude Is Null 
Or fatalities Is Null 
Or miles_travelled Is Null 
Or width Is Null 
Or property_loss Is Null
Or crop_loss Is Null
Or width Is Null
--No Nulls for what we need 

-- Checking columns for misspellings

Select Distinct(time_zone)
From Tornado_Tracks..Tornado_Tracks
-- 3,6,9? Does not seem correct

Select Distinct(state_abbr)
From Tornado_Tracks..Tornado_Tracks
-- 53 (Puerto Rico, Virign Islands, D.C.)

Select Distinct(magnitude)
From Tornado_Tracks..Tornado_Tracks
-- (-9)

Select Distinct(month)
From Tornado_Tracks..Tornado_Tracks

-- Removing entries with magnitude = -9

Select *
From Tornado_Tracks..Tornado_Tracks
Where magnitude = -9

Select *
From Tornado_Tracks..Tornado_Tracks
Where year >= 2016

Delete 
From Tornado_Tracks..Tornado_Tracks
Where magnitude = -9

-- Adding correct time zones (addressing split states seperately - ID, NE, ND, SD, AK, KY, TN, HI, PR, VI)

Alter Table Tornado_Tracks..Tornado_Tracks
Add time_zones varchar(50)

Update Tornado_Tracks..Tornado_Tracks
Set time_zones = 'PST'
Where state_abbr In ('CA', 'OR', 'WA', 'NV')

Update Tornado_Tracks..Tornado_Tracks
Set time_zones = 'MST'
Where state_abbr In ('MT','WY','UT','AZ','NM','CO')

Update Tornado_Tracks..Tornado_Tracks
Set time_zones = 'CST'
Where state_abbr In ('KS','OK','TX','MN','IA','MO','AR','LA','WI','IL','MS','AL')

Update Tornado_Tracks..Tornado_Tracks
Set time_zones = 'EST'
Where state_abbr In ('ME','NH','VT','MA','RI','CT','NY','NJ','PA','DE','MD','DC','VA','WV','OH','IN','NC','SC','GA','FL','MI')

Update Tornado_Tracks..Tornado_Tracks
Set time_zones = 'EST'
Where start_longitude >= -85
And state_abbr in ('KY', 'TN')

Update Tornado_Tracks..Tornado_Tracks
Set time_zones = 'CST'
Where start_longitude < -85
And state_abbr in ('KY', 'TN')

Update Tornado_Tracks..Tornado_Tracks
Set time_zones = 'CST'
Where start_longitude >= -100
And state_abbr in ('ND', 'SD','NE')

Update Tornado_Tracks..Tornado_Tracks
Set time_zones = 'MST'
Where start_longitude < -100
And state_abbr in ('ND', 'SD','NE')

Update Tornado_Tracks..Tornado_Tracks
Set time_zones = 'MST'
Where start_longitude >= -115
And state_abbr = 'ID'

Update Tornado_Tracks..Tornado_Tracks
Set time_zones = 'PST'
Where start_longitude < -115
And state_abbr = 'ID'

Update Tornado_Tracks..Tornado_Tracks
Set time_zones = 'Other'
Where state_abbr In ('AK', 'HI', 'PR', 'VI')

-- Removing unnecessary columns 

Alter Table Tornado_Tracks..Tornado_Tracks
Drop Column time, Month_Calc, date, Date_Calc,time_zone

