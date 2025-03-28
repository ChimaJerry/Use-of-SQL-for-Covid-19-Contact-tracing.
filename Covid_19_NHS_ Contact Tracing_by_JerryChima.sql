
#Task 1 – Creating my Database 


DROP DATABASE IF EXISTS covid_19_NHS_Tayside;

CREATE DATABASE covid_19_nhs_tayside;

SHOW DATABASES;

USE covid_19_nhs_tayside;

DROP TABLE sample_test;
DROP TABLE subject_data;


-- Creating tables with the required entities for sample test data


CREATE TABLE subject_data  (
  SubjectID VARCHAR(20) NOT NULL,
  SubjectName VARCHAR(50) NOT NULL,
  SubjectAddress VARCHAR(50) NOT NULL,
  
  PRIMARY KEY (SubjectID)
);

select * from subject_data;


 INSERT INTO subject_data (SubjectID, SubjectName, SubjectAddress)
VALUES
  ('S001', 'Daniel Doppler', '6 Beetle Avenue, Aberdeen'),
  ('S002', 'Florence West', '8 Green Crescent, Dundee'),
  ('S003', 'Werner Flick', '22 Grubb Street, Stonehaven'),
  ('S004', 'Tiffany Smith', '9 Green Crescent, Dundee'),
  ('S005', 'Angela Ashe', '13 Wasp Street, Aberdeen');
  



CREATE TABLE sample_test  (
  SN INT NOT NULL,
  TestDate DATE,
  SubjectID VARCHAR(10) NOT NULL,
  SubjectName VARCHAR(50) NOT NULL,
  SubjectAddress VARCHAR(50) NOT NULL,
  Result VARCHAR(50) NOT NULL,
  PhoneNumber VARCHAR(50) NOT NULL,
  
  PRIMARY KEY (SN),
  foreign key(SubjectID) references subject_data(SubjectID)
);

SHOW TABLES;


SELECT * FROM subject_data;

  INSERT INTO sample_test (SN, TestDate, SubjectID, SubjectName, SubjectAddress, Result, PhoneNumber)
VALUES
  (1, '2020-08-05', 'S001', 'Daniel Doppler', '6 Beetle Avenue, Aberdeen', 'Negative', '07123-123456'),
  (2, '2020-08-10', 'S002', 'Florence West', '8 Green Crescent, Dundee', 'Positive', '07777-111000'),
  (3, '2020-08-17', 'S003', 'Werner Flick', '22 Grubb Street, Stonehaven', 'Negative', '07555-246810'),
  (4, '2020-08-22', 'S004', 'Tiffany Smith', '9 Green Crescent, Dundee', 'Negative', '07101-484848, 07896102304'),
  (5, '2020-08-22', 'S005', 'Angela Ashe', '13 Wasp Street, Aberdeen', 'Negative', '07777-534243'),
  (6, '2020-09-03', 'S001', 'Daniel Doppler', '6 Beetle Avenue, Aberdeen', 'Positive', '07123-123456');
  
 
 #Task 2 – Test Queries
 #   Query A: Local Test Activity
 SELECT * FROM sample_test;
 
 SELECT SubjectName, SubjectAddress, TestDate, Result FROM sample_test WHERE SubjectAddress LIKE '%Aberdeen%';
 
 
 #   Query B: Visit Tracing
  
  CREATE TABLE Sample_Visit_Data (
    SN INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    PlaceVisited VARCHAR(50),
    OwnersName VARCHAR(50),
    VisitDate DATE,
    ContactNumber VARCHAR(20),
    SizeOfParty INT
);

INSERT INTO Sample_Visit_Data (SN, PlaceVisited, OwnersName, VisitDate, ContactNumber, SizeOfParty)
VALUES
    (1, 'Pink Lion Inn, Forfar', 'Sean Smith', '2020-08-25', '07123-123456', 4),
    (2, 'Pink Lion Inn, Forfar', 'Sean Smith', '2020-08-25', '07496-285113', 2),
    (3, 'Pink Lion Inn, Forfar', 'Sean Smith', '2020-09-15', '07777-111000', 3),
    (4, 'Herma\'s Hair Salon, Stonehaven', 'Herma Jones', '2020-08-01', '07123-123456', 1),
    (5, 'Herma\'s Hair Salon, Stonehaven', 'Herma Jones', '2020-08-01', '07777-111000', 2),
    (6, 'Herma\'s Hair Salon, Stonehaven', 'Herma Jones', '2020-09-10', '07555-246810', 1);
    
    SHOW TABLES; 
    SELECT * FROM Sample_Visit_Data;
    DROP TABLE Sample_Visit_Data;


SELECT s.TestDate, s.SubjectName, v.VisitDate, v.PlaceVisited 
FROM sample_test AS s 
INNER JOIN Sample_Visit_Data AS v
ON s.SN = v.SN
WHERE s.Result = 'Positive' 
AND v.VisitDate > s.TestDate;

 

# Query C: Risk Assessment

SELECT PlaceVisited, VisitDate, 
       COUNT(*) AS NumberOfParties, 
       SUM(SizeOfParty) AS TotalVisitors
FROM Sample_Visit_Data
GROUP BY PlaceVisited, VisitDate
ORDER BY TotalVisitors DESC;


#Task 3 – Stored Procedures 
 
 #procedure



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
