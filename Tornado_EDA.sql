-- Check data

Select *
From Tornado_Tracks..Tornado_Tracks

-- Checking min-max values 

Select MIN(injuries) min_injuries, MAX(injuries) max_injuries, 
	   MIN(fatalities)min_fatalities, MAX(fatalities) max_fatalities, 
	   MIN(property_loss) min_property_loss, MAX(property_loss) max_property_loss, 
	   MIN(crop_loss) min_crop_loss, MAX(crop_loss) max_crop_loss,
	   MIN(miles_travelled) min_miles, MAX(miles_travelled) max_miles
From Tornado_Tracks..Tornado_Tracks

Select * 
From Tornado_Tracks..Tornado_Tracks
Where injuries = 1740
	  Or fatalities = 158
	  Or property_loss = 1550000000
	  Or crop_loss = 12250000
	  Or miles_travelled = 234.7

-- Reviewing metrics by Year

Select state_abbr As State, 
	   COUNT(OBJECTID) As Total_Tornadoes, 
	   SUM(injuries) As Total_Injuries, 
	   SUM(fatalities) As Total_Fatalities, 
	   SUM(property_loss) As Total_Property_Loss, 
	   SUM(crop_loss) As Total_Crop_Loss
From Tornado_Tracks..Tornado_Tracks
Group by state_abbr
Order by 2 Desc

-- Reviewing metrics by Time Zone

Select time_zones, 
	   COUNT(OBJECTID) As Total_Tornadoes, 
	   SUM(injuries) As Total_Injuries, 
	   SUM(fatalities) As Total_Fatalities, 
	   SUM(property_loss) As Total_Property_Loss, 
	   SUM(crop_loss) As Total_Crop_Loss
From Tornado_Tracks..Tornado_Tracks
Group by time_zones
Order by 2 Desc

-- Reviewing magnitude numbers

Select magnitude, 
	   Round(AVG(miles_travelled), 2) As Avg_Miles,
	   Round(AVG(injuries),2) As Avg_Injuries,
	   Round(AVG(fatalities),2) As Avg_Deaths
From Tornado_Tracks..Tornado_Tracks
Group by magnitude
Order by 2

-- Property loss by State with adjustable dates  

Select state_abbr, Round(SUM(property_loss),2) As Total_Property_Loss
From Tornado_Tracks..Tornado_Tracks
Where NewDate Between '01/03/1950' And '12/30/2022'
Group by state_abbr
Order by 2 Desc

-- Deadliest tornado by Year

With Top_Tornado As
(
Select *, DENSE_RANK() Over (Partition by Year Order by fatalities Desc) As Rank
From Tornado_Tracks..Tornado_Tracks
)
Select *
From Top_Tornado
Where Rank = 1
Order by year

-- Most Injuries by State by Year 

With Top_State_by_Year (Year, State, Total_Injuries) As
(
Select year, state_abbr, SUM(injuries)
From Tornado_Tracks..Tornado_Tracks
Group by year, state_abbr
),
State_Rank As
(
Select *,
DENSE_RANK() Over (Partition by Year Order by Total_Injuries Desc) As Rank
From Top_State_by_Year
)
Select *
From State_Rank
Where Rank = 1
Order by Year


Select MIN(NewDate), max(NewDate)
From Tornado_Tracks..Tornado_Tracks

-- Extracting entries for Tableau (CST entries 2000-2022)

Select OBJECTID, 
	   state_abbr,
	   magnitude, 
	   injuries, 
	   fatalities, 
	   property_loss, 
	   crop_loss, 
	   miles_travelled,
	   start_latitide,
	   end_latitude,
	   start_longitude,
	   end_longitude,
	   NewDate, 
	   NewTime
From Tornado_Tracks..Tornado_Tracks
Where time_zones = 'CST'
 And year >= 2000

Select state_abbr, 
	   COUNT(OBJECTID) As Total_Tornadoes, 
	   SUM(injuries) As Total_Injuries, 
	   SUM(fatalities) As Total_Fatalities, 
	   SUM(property_loss) As Total_Property_Loss, 
	   SUM(crop_loss) As Total_Crop_Loss
From Tornado_Tracks..Tornado_Tracks
Where time_zones = 'CST'
Group by state_abbr

