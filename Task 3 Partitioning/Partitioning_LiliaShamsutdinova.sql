USE Paintings;
GO
ALTER DATABASE Paintings
ADD FILEGROUP group1;

ALTER DATABASE Paintings
ADD FILEGROUP group2;

ALTER DATABASE Paintings
ADD FILEGROUP group3;

ALTER DATABASE Paintings
ADD FILE
(
NAME = part1,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\part1.ndf'
) TO FILEGROUP group1;

ALTER DATABASE Paintings
ADD FILE
(
NAME = part2,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\part2.ndf'
) TO FILEGROUP group2;

ALTER DATABASE Paintings
ADD FILE
(
NAME = part3,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\part3.ndf'
) TO FILEGROUP group3;

CREATE PARTITION FUNCTION my_pf(float)
AS
RANGE LEFT
FOR VALUES (-0.5, 0)

CREATE PARTITION SCHEME my_ps
AS PARTITION my_pf 
TO (group1, group2, group3) 

EXEC sp_rename 'Paintings', 'PaintingsOld';

CREATE TABLE Paintings (ID int, Feature1 float  NOT NULL, Feature2 float  NOT NULL, Title varchar(max)  NOT NULL)
ON my_ps(Feature1);

INSERT INTO Paintings(ID, Feature1, Feature2, Title)
SELECT ID, Feature1, Feature2, Title FROM Paintings.dbo.PaintingsOld;

DROP table Paintings.dbo.PaintingsOld



