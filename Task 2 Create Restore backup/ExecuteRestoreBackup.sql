USE master;  
GO  
DECLARE @dateTime datetime
SET @dateTime=GETDATE()
EXEC dbo.RestoreBackup @fullBackup = 1, @dateTimeToRestore=@dateTime, @dbNameToRestoreTo='reuters'