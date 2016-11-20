USE master
GO

CREATE PROCEDURE dbo.RestoreBackup @fullBackup bit, @dateTimeToRestore datetime, @dbNameToRestoreTo varchar(max), @dbNameToRestoreFrom varchar(max)
AS

DECLARE @pathToBackup varchar(max)
SET @pathToBackup = (SELECT Path from BackupInfoDB.dbo.BackupInfo where BackupDate = convert(varchar(25), CONVERT(VARCHAR(10),@dateTimeToRestore,10), 120) AND dbName = @dbNameToRestoreFrom) 

DECLARE @fullPath varchar(max)
SET @fullPath = @pathToBackup+'\full_backupDB_'+convert(varchar(25), CONVERT(VARCHAR(10),@dateTimeToRestore,10), 120)+'.bak'

DECLARE @differentialPath varchar(max)
SET @differentialPath = @pathToBackup+'\differential_backupDB_'+convert(varchar(25), CONVERT(VARCHAR(10),@dateTimeToRestore,10), 120) +'.bak'

DECLARE @mdfNewPath varchar(max)
DECLARE @ldfNewPath varchar(max)
DECLARE @currentDBLog varchar(max)
DECLARE @Current_Path varchar(max)

BEGIN
SET @mdfNewPath = 'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\'+@dbNameToRestoreTo+'.mdf'
SET @ldfNewPath = 'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\'+@dbNameToRestoreTo+'_log.ldf'
SET @currentDBLog = @dbNameToRestoreFrom+'_log'

IF @fullBackup = 1
	SET @Current_Path = @fullPath
ELSE 
	SET @Current_Path = @differentialPath

RESTORE VERIFYONLY
FROM
DISK = @Current_Path
WITH
MOVE @dbNameToRestoreFrom TO @mdfNewPath,
MOVE @currentDBLog TO @ldfNewPath;

RESTORE DATABASE @dbNameToRestoreTo
FROM
DISK = @Current_Path
WITH
MOVE @dbNameToRestoreFrom TO @mdfNewPath,
MOVE @currentDBLog TO @ldfNewPath,
RECOVERY;

END
GO