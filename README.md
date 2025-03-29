# Use-of-SQL-for-Covid-19-Contact-tracing.
This project was engineered to track people who had contact with patients that tested positive for Covid-19.

![image](https://github.com/user-attachments/assets/6e6520ad-c56e-478d-8d99-331b40523f17)



### Table of Content
- Project Overview
- Data Sources
- Analytical tools used
- Data Cleaning/preparation
- Exploratory Data Analysis
- Results/Findings
- Recommendations
- Limitations

### Project Overview
In course of the Covid-19 outbreak, some persons reprted to the health facilities with symptoms of the aiment. Further investigations was done to knw individuals who tested positive and has been in a arge gathering e.g a party or a public space in the last 3 days before testing psitive. When individuals who has tested positive provide such information there was need to deveop a data management system to contact trace such people who might have been exposed to such, hence the need for this project work.

### Skills Used
Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types, and using SQL DDL (Data Definition Language) and DML (Data Manipulation Language) commands like 'INSERT', 'UPDATE', 'DELETE', 'CREATE', 'ALTER', and 'DROP where used to clean, transform and analyse the data.

### Data Source
The main data source for this work was derived from the "collated covid-19 data csv" containing detailed information about each each patients that tested positive, where they reside, places they visited shortly before testing psitive to ascertain individuals who might have been at risk as a resut of such visit, this information was recodred by the health care and community volunteers. 

### Analytical tools used
- SQL serverfor data analysis, quering or manipuation.
- Exce for data cleaning
- Power-Bi for Data Visulaization

### Data Cleaning/Preparation
Indepth data cleaning and preparation was done after the data sets have been inspected and collated from diferent community vounteers or health workers. This process was crucia to check for data anomalise, missing vaues, outliers and removal of duplicates. I further made use of statistical measures like mean and mode to replace missing values when it was not outrageous or on the data for a specific patient. 
 
### Exploratory Data Analysis (EDA)

EDA involves taking indepth look into the data set to answer cardinal or important questions. For this projected work, it intends to unravel the following;
- Number of people that tested positive after going to a party or large gatherings.
- Home or office address of people that tested poitive.
- Contact tracing of individuals using unique features such as phone numbers.

### Data Analysis/SQL Queries 

```sql
  CREATE TABLE sample_test  (
  SN INT NOT NULL,
  TestDate DATE,
  SubjectID VARCHAR(10) NOT NULL,
  SubjectName VARCHAR(50) NOT NULL,
  SubjectAddress VARCHAR(50) NOT NULL,
  Result VARCHAR(50) NOT NULL,
  PhoneNumber VARCHAR(50) NOT NULL,
  
  PRIMARY KEY (SN),
  foreign key(SubjectID) references subject_data(SubjectID));
```
#### Visit Tracing
```sql
  CREATE TABLE Sample_Visit_Data (
    SN INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    PlaceVisited VARCHAR(50),
    OwnersName VARCHAR(50),
    VisitDate DATE,
    ContactNumber VARCHAR(20),
    SizeOfParty INT
);
```
#### Positivity rate
```sql
SELECT s.TestDate, s.SubjectName, v.VisitDate, v.PlaceVisited 
FROM sample_test AS s 
INNER JOIN Sample_Visit_Data AS v
ON s.SN = v.SN
WHERE s.Result = 'Positive' 
AND v.VisitDate > s.TestDate;
```
#### Risk Assessment
```sql
SELECT PlaceVisited, VisitDate, 
       COUNT(*) AS NumberOfParties, 
       SUM(SizeOfParty) AS TotalVisitors
FROM Sample_Visit_Data
GROUP BY PlaceVisited, VisitDate
ORDER BY TotalVisitors DESC;
```

#### Stored Procedures
```sql
delimiter &&
create procedure subject_Number(IN var varchar(50))
begin
    if exists (select 1 from sample_test where PhoneNumber = var) then
         select SubjectName from sample_test where PhoneNumber = var;
	else
        select 'unrecognised' as SubjectName;
	end if;

end &&
delimiter ;
call top_subject('07123-123456');
```

