
--Creating the input and target tables:
CREATE TABLE [dbo].[Inputload](
	[field1] [varchar](50),
	[field2] [varchar](50),
	[field3] [varchar](50),
	[field4] [varchar](50),
	[field5] [varchar](50),
	PRIMARY KEY (field1, field2);

) 

CREATE TABLE [dbo].[outputload](
	[field1] [varchar](50),
	[field2] [varchar](50),
	[field3] [varchar](50),
	[field4] [varchar](50),
	[field5] [varchar](50),
	[field6] [varchar](50),
	PRIMARY KEY (field1, field2);

) 

--Inserting records into the input table:
INSERT INTO Inputload VALUES ('1', 'A', '1', '1', '1');
INSERT INTO Inputload VALUES ('1', 'B', '1','1','3');
INSERT INTO Inputload VALUES ('2', 'A', '2', '2', '5');


--Creating the procedure to perform insert, update and fill values in the IUD column of the target table:
CREATE OR ALTER proc [dbo].[IUD]
as
begin
set nocount on;


MERGE [dbo].[outputload] AS TARGET
USING [dbo].[Inputload] AS SOURCE 
ON (TARGET.[Field1] = SOURCE.[Field1] AND TARGET.[Field2] = SOURCE.[Field2])  

--When records are matched, update the records if there is any change
WHEN MATCHED 

AND hashbytes('sha1', upper(TARGET.Field1+TARGET.Field2+TARGET.Field3+TARGET.Field4+TARGET.Field5)) != hashbytes('sha1', upper(SOURCE.Field1+SOURCE.Field2+SOURCE.Field3+SOURCE.Field4+SOURCE.Field5)) 

THEN 
UPDATE 
SET 
TARGET.Field1 = SOURCE.Field1, 
TARGET.Field2 = SOURCE.Field2,
TARGET.Field3 = SOURCE.Field3,
TARGET.Field4 = SOURCE.Field4,
TARGET.Field5 = SOURCE.Field5,
TARGET.Field6 = 'U'

--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET 
THEN INSERT (Field1
           ,Field2
           ,Field3
           ,Field4
           ,Field5
           ,FIeld6
 )
		   VALUES 
		   (Source.Field1
      ,Source.Field2
      ,Source.Field3
      ,Source.Field4
      ,Source.Field5
      , 'I'
)
;
end