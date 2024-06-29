
--Query For Power BI
With SFI as (Select*
From SFI_2022
Union all
Select * 
From SFI_2023
Union all
Select * 
From SFI_2024)

Select 
ID,
Commodity, 
Month, 
Year, 
Average_Price,
Month_on_Month,
Year_on_Year,
Lowest_State,
Lowest_Price,
Highest_State,
Highest_Price
From SFI
Left join Month_Hierarchy as MH
on SFI.Month= MH.Month_Name




--Avg Price Per Commodity
With SFI as (Select*
From SFI_2022
Union all
Select * 
From SFI_2023
Union all
Select * 
From SFI_2024)

Select Commodity, Round(Avg(Average_Price),2) as AvgPrice
From SFI
Left join Month_Hierarchy as MH
on SFI.Month= MH.Month_Name




--Highest and Lowest Prices of Commodities
With SFI as (Select*
From SFI_2022
Union all
Select * 
From SFI_2023
Union all
Select * 
From SFI_2024)

Select Commodity, Max(Average_Price) as Max_Price, Min(Average_Price) as Min_Price,
From SFI
Group by Commodity


--Monthly Trends of Prices of Each commodity showing seasonal trends
With SFI as (Select*
From SFI_2022
Union all
Select * 
From SFI_2023
Union all
Select * 
From SFI_2024)

Select Commodity, Month, Avg(Average_Price) as AvgPrice
From SFI
Left join Month_Hierarchy as MH
on SFI.Month= MH.Month_Name
Group by Commodity, Month
Order by Commodity, AvgPrice desc


--Price Volatity
With SFI as (Select*
From SFI_2022
Union all
Select * 
From SFI_2023
Union all
Select * 
From SFI_2024)

Select Commodity, Round(stdev(Average_Price),2) as Price_Volatility, Round(AVG(Average_price),2) as Price, 
Round((stdev(Average_Price)/AVG(Average_price))*100,2) as Volatility_Percentage,
CASE
WHEN (STDEV(Average_Price)/AVG(Average_Price))*100 < 5 THEN 'low Volatility'
WHEN (STDEV(Average_Price)/AVG(Average_Price))*100 > 10  THEN 'High Volatility'
WHEN (STDEV(Average_Price)/AVG(Average_Price))*100  Between 5 And 10 THEN 'Medium Volatility'


Else 'Null'
END as Volatility_Category
From SFI
--Where Year = 2022  --Price Votality for 2022
--Where Year = 2023  --Price Votality for 2023
--Where Year = 2024  --Price Votality for 2024
--Where YEAR in (2023,2024) --Price Votality for 2023 and 2024
--Where Year in (2022,2023) --Price Votality for 2022 and 2024
Group by Commodity


--Moving Average
With SFI as (Select*
From SFI_2022
Union all
Select * 
From SFI_2023
Union all
Select * 
From SFI_2024)

Select Commodity, Month, Year, Average_Price, Round(Avg(Average_Price)
Over (Partition by Commodity Order by Year rows between 2 preceding and current row),2) as Three_Months_Moving_Avg
From SFI
Left join Month_Hierarchy as MH
on SFI.Month= MH.Month_Name


