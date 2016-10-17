USE reuters;  
GO  
EXEC dbo.CreateBackup @fullBackup = 1, @pathToBackup='C:\temp'