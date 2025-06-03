ALTER DATABASE [QLKH] SET RECOVERY FULL;
GO

-- Full Backup
DECLARE @backupPath NVARCHAR(256);
SET @backupPath = 'C:\Backup\QLKH_Full_' + CONVERT(VARCHAR(10), GETDATE(), 112) + '_' + REPLACE(CONVERT(VARCHAR(8), GETDATE(), 108), ':', '') + '.bak';
BACKUP DATABASE [QLKH]
TO DISK = @backupPath
WITH INIT, FORMAT;
GO

-- Differential Backup
DECLARE @backupPath NVARCHAR(256);
SET @backupPath = 'C:\Backup\QLKH_Diff_' + CONVERT(VARCHAR(10), GETDATE(), 112) + '_' + REPLACE(CONVERT(VARCHAR(8), GETDATE(), 108), ':', '') + '.bak';
BACKUP DATABASE [QLKH]
TO DISK = @backupPath
WITH DIFFERENTIAL;
GO

-- Transaction Log Backup
DECLARE @backupPath NVARCHAR(256);
SET @backupPath = 'C:\Backup\QLKH_Log_' + CONVERT(VARCHAR(10), GETDATE(), 112) + '_' + REPLACE(CONVERT(VARCHAR(8), GETDATE(), 108), ':', '') + '.trn';
BACKUP LOG [QLKH]
TO DISK = @backupPath;
GO

