USE reuters
GO

CREATE PROCEDURE dbo.CreateBackup @fullBackup bit, @pathToBackup varchar(max)
AS

DECLARE @fullPath varchar(max)
SET @fullPath = @pathToBackup+'\full_backupDB_'+convert(varchar(25), CONVERT(VARCHAR(10),GETDATE(),10), 120)+'.bak'

DECLARE @differentialPath varchar(max)
SET @differentialPath = @pathToBackup+'\differential_backupDB_'+convert(varchar(25), CONVERT(VARCHAR(10),GETDATE(),10), 120) +'.bak'

DECLARE @Current_Database varchar(max)
DECLARE @Current_Path varchar(max)

DECLARE @dbname nvarchar(128)
SET @dbname = N'BackupInfoDB'

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

IF NOT(EXISTS (SELECT name 
FROM master.dbo.sysdatabases 
WHERE ('[' + name + ']' = @dbname 
OR name = @dbname)))
BEGIN
CREATE DATABASE BackupInfoDB
END
EXEC ('USE [BackupInfoDB]; IF NOT(EXISTS (SELECT * 
                 FROM BackupInfoDB.INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = ''dbo'' 
                 AND  TABLE_NAME = N''BackupInfo''))
BEGIN
CREATE TABLE [BackupInfoDB].[dbo].[BackupInfo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BackupDate] [varchar](25) NOT NULL,
	[Path] [varchar](max) NOT NULL,
	[dbName] [varchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

END')


EXEC ('USE BackupInfoDB; INSERT INTO BackupInfo (BackupDate,Path,dbName)
VALUES (convert(varchar(25), CONVERT(VARCHAR(10),GETDATE(),10), 120),'''+@pathToBackup+''', '''+@Current_Database+''')')

END
GO