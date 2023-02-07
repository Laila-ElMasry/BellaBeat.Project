--count the users of each app

Select COUNT(Distinct Id)
From dailyActivity_merged
--33

Select COUNT(Distinct Id)
From heartrate_seconds_merged
--14

Select COUNT(Distinct Id)
From sleepDay_merged
--24

Select COUNT(Distinct Id)
From weightLogInfo_merged
--8


--To show how many times each Id used app
Select Id, COUNT(Id) as Total_Usage
From dailyActivity_merged
Group by Id
order by 2

Select Id, COUNT(Id) as Total_Usage,
CASE 
When COUNT(Id) BETWEEN 0 and 11 then 'Light User'
When COUNT(Id) BETWEEN 12 and 22 then 'Moderate User'
When COUNT(Id) BETWEEN 23 and 31 then 'Heavy User'
End As Usage_Level
From dailyActivity_merged
Group by Id

--Relationship between Total steps and Total Calories by Id

select Id,SUM(StepTotal) as TotalSteps
From dailySteps_merged
Group by Id

select Id,SUM(Calories) as TotalCalories
From dailyCalories_merged
Group by Id

--Relationship between Total steps and Total Calories by ActivityDay

select ActivityDay,AVG(StepTotal) as AVG_TotalSteps
From dailySteps_merged
Group by ActivityDay

select ActivityDay,AVG(Calories) as AVG_TotalCalories
From dailyCalories_merged
Group by ActivityDay

--Measure activity by days of week

Select ActivityDay, AVG(StepTotal) AVG_StepTotal
From dailySteps_merged
Group by ActivityDay

Select ActivityDay, AVG(LightActiveDistance) as AVG_LightActiveDistance,
AVG(ModeratelyActiveDistance) as AVG_ModeratelyActiveDistance,
AVG(VeryActiveDistance) as AVG_VeryActiveDistance
From dailyIntensities_merged
Group by ActivityDay

Select ActivityDay, Sum(LightActiveDistance) as Sum_LightActiveDistance,
Sum(ModeratelyActiveDistance) as Sum_ModeratelyActiveDistance,
Sum(VeryActiveDistance) as Sum_VeryActiveDistance
From dailyIntensities_merged
Group by ActivityDay

--To show average active minutes by Id,week

Select Id, AVG(SedentaryMinutes) as AVG_SedentaryMinutes,
AVG(LightlyActiveMinutes) as AVG_LightlyActiveMinutes,
AVG(FairlyActiveMinutes) as AVG_FairlyActiveMinutes,
AVG(VeryActiveMinutes) as AVG_VerytActiveMinutes
From dailyIntensities_merged
Group by Id

Select ActivityDay, AVG(SedentaryMinutes) as AVG_SedentaryMinutes,
AVG(LightlyActiveMinutes) as AVG_LightlyActiveMinutes,
AVG(FairlyActiveMinutes) as AVG_FairlyActiveMinutes,
AVG(VeryActiveMinutes) as AVG_VeryActiveMinutes
From dailyIntensities_merged
Group by ActivityDay


--Split Activity Hour coulumn into date and hour in hourly calories table
Select * 
From hourlyCalories_merged

Select
SUBSTRING(ActivityHour,1, CHARINDEX(' ',ActivityHour,-1)) As Date,
SUBSTRING(ActivityHour,CHARINDEX(' ',ActivityHour)+1,Len(ActivityHour)) As Time
From hourlyCalories_merged 

Alter Table hourlyCalories_merged
Add Date nvarchar(255)

update hourlyCalories_merged
Set Date = SUBSTRING(ActivityHour,1, CHARINDEX(' ',ActivityHour,-1))

Alter Table hourlyCalories_merged
Add Time nvarchar(255)

update hourlyCalories_merged
Set Time = SUBSTRING(ActivityHour,CHARINDEX(' ',ActivityHour)+1,Len(ActivityHour))

--calculate average calories by time of day

Select Time, AVG(Cast(Calories as int)) as AVG_Calories
From hourlyCalories_merged
Group by TIME

--Split Activity Hour coulumn into date and hour in hourly steps table

Select *
From hourlySteps_merged

Select
SUBSTRING(ActivityHour,1, CHARINDEX(' ',ActivityHour,-1)) As Date,
SUBSTRING(ActivityHour,CHARINDEX(' ',ActivityHour)+1,Len(ActivityHour)) As Time
From hourlysteps_merged 

Alter Table hourlySteps_merged
Add Date nvarchar(255)

update hourlySteps_merged
Set Date = SUBSTRING(ActivityHour,1, CHARINDEX(' ',ActivityHour,-1))

Alter Table hourlySteps_merged
Add Time nvarchar(255)

update hourlySteps_merged
Set Time = SUBSTRING(ActivityHour,CHARINDEX(' ',ActivityHour)+1,Len(ActivityHour))

Select Time, AVG(Cast(StepTotal as int)) as AVG_Steps
From hourlySteps_merged
Group by TIME

--Calculate average intensity by time

Select *
From hourlyIntensities_merged

Select
SUBSTRING(ActivityHour,1, CHARINDEX(' ',ActivityHour,-1)) As Date,
SUBSTRING(ActivityHour,CHARINDEX(' ',ActivityHour)+1,Len(ActivityHour)) As Time
From hourlyIntensities_merged

Alter Table hourlyIntensities_merged
Add Date nvarchar(255)

update hourlyIntensities_merged
Set Date = SUBSTRING(ActivityHour,1, CHARINDEX(' ',ActivityHour,-1))

Alter Table hourlyIntensities_merged
Add Time nvarchar(255)

update hourlyIntensities_merged
Set Time = SUBSTRING(ActivityHour,CHARINDEX(' ',ActivityHour)+1,Len(ActivityHour))

Select Time, AVG(Cast(TotalIntensity as int)) as AVG_TotalIntensity
From hourlyIntensities_merged
Group by Time

--Calculate average minutes asleep by day

Select *
From sleepDay_merged

Select
SUBSTRING(SleepDay,1, CHARINDEX(' ',SleepDay,-1)) As Date,
SUBSTRING(SleepDay,CHARINDEX(' ',SleepDay)+1,Len(SleepDay)) As Time
From sleepDay_merged

Alter Table sleepDay_merged
Add Date nvarchar(255)

update sleepDay_merged
Set Date = SUBSTRING(SleepDay,1, CHARINDEX(' ',SleepDay,-1))

Alter Table sleepDay_merged
Add Time nvarchar(255)

update sleepDay_merged
Set Time = SUBSTRING(SleepDay,CHARINDEX(' ',SleepDay)+1,Len(SleepDay))

Select Date, AVG(Cast(TotalMinutesAsleep as int)) as AVG_MinutesAsleep
From sleepDay_merged
Group by Date
order by Date



