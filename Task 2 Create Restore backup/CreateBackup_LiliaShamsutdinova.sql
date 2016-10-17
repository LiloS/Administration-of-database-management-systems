USE reuters
GO

CREATE PROCEDURE dbo.CreateBackup @fullBackup bit, @pathToBackup varchar(max)
AS

DECLARE @fullPath varchar(max)
SET @fullPath = @pathToBackup+'\full_backupDB_'+convert(varchar(25), CONVERT(VARCHAR(10),GETDATE(),10), 120)+'.bak'

DECLARE @differentialPath varchar(max)
SET @differentialPath = @pathToBackup+'\differential_backupDB_'+convert(varchar(25),CONVERT(VARCHAR(10),GETDATE(),10), 120) +'.bak'

DECLARE @Current_Database varchar(max)
DECLARE @Current_Path varchar(max)

BEGIN
SET @Current_Database = (SELECT DB_NAME())

IF @fullBackup = 1
	SET @Current_Path = @fullPath
ELSE 
	SET @Current_Path = @differentialPath

BACKUP DATABASE @Current_Database
TO
DISK = @Current_Path
WITH INIT;

EXEC ('USE BackupInfoDB; INSERT INTO BackupInfo (BackupDate,Path,dbName)
VALUES (convert(varchar(25), CONVERT(VARCHAR(10),GETDATE(),10), 120),'''+@pathToBackup+''', '''+@Current_Database+''')')

END
GO