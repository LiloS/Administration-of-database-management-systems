GO

CREATE PROCEDURE CheckPermissions
AS

print ('Server level permissions')
SELECT * FROM fn_my_permissions (NULL, 'SERVER')

print ('Database level permissions')
SELECT * FROM fn_my_permissions (NULL, 'DATABASE')

print ('Permissions for each table')
EXEC sp_MSforeachtable '
if not exists (select * from sys.columns 
				where object_id = object_id(''?'')
				and name = ''diagram_id'')
SELECT * FROM fn_my_permissions (''?'', ''OBJECT'')
'
GO