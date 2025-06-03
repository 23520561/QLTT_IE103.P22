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

-- Bước 1: Tạo bảng tạm để lưu danh sách file từ thư mục
IF OBJECT_ID('tempdb..#FileList') IS NOT NULL
    DROP TABLE #FileList;

CREATE TABLE #FileList (
    FileName NVARCHAR(255),
    Depth INT,
    IsFile BIT
);

-- Bước 2: Lấy danh sách file từ thư mục (thay đổi đường dẫn nếu cần)
DECLARE @BackupPath NVARCHAR(255) = 'C:\Backup';
DECLARE @Cmd NVARCHAR(500) = 'xp_dirtree "' + @BackupPath + '", 1, 1';
INSERT INTO #FileList (FileName, Depth, IsFile)
EXEC master.dbo.xp_dirtree @BackupPath, 1, 1;

-- Bước 3: Tạo bảng tạm để lưu danh sách file backup của QLKHL
IF OBJECT_ID('tempdb..#BackupFiles') IS NOT NULL
    DROP TABLE #BackupFiles;

CREATE TABLE #BackupFiles (
    FileName NVARCHAR(255),
    FileType NVARCHAR(50), -- 'Full', 'Diff', 'Log'
    Timestamp DATETIME
);

-- Bước 4: Lọc các file backup liên quan đến QLKHL và phân loại
INSERT INTO #BackupFiles (FileName, FileType, Timestamp)
SELECT 
    FileName,
    CASE 
        WHEN FileName LIKE 'QLKH_Full[_]%.bak' THEN 'Full'
        WHEN FileName LIKE 'QLKH_Diff[_]%.bak' THEN 'Diff'
        WHEN FileName LIKE 'QLKH_Log[_]%.trn' THEN 'Log'
        ELSE NULL
    END AS FileType,
    CASE 
        WHEN FileName LIKE 'QLKH_Full[_]%.bak' THEN 
            CONVERT(DATETIME, 
                SUBSTRING(FileName, 11, 8) + ' ' + 
                SUBSTRING(FileName, 20, 2) + ':' + 
                SUBSTRING(FileName, 22, 2) + ':' + 
                SUBSTRING(FileName, 24, 2), 120)
        WHEN FileName LIKE 'QLKH_Diff[_]%.bak' THEN 
            CONVERT(DATETIME, 
                SUBSTRING(FileName, 11, 8) + ' ' + 
                SUBSTRING(FileName, 20, 2) + ':' + 
                SUBSTRING(FileName, 22, 2) + ':' + 
                SUBSTRING(FileName, 24, 2), 120)
        WHEN FileName LIKE 'QLKH_Log[_]%.trn' THEN 
            CONVERT(DATETIME, 
                SUBSTRING(FileName, 10, 8) + ' ' + 
                SUBSTRING(FileName, 19, 2) + ':' + 
                SUBSTRING(FileName, 21, 2) + ':' + 
                SUBSTRING(FileName, 23, 2), 120)
        ELSE NULL
    END AS Timestamp
FROM #FileList
WHERE IsFile = 1
AND (
    FileName LIKE 'QLKH_Full[_]%.bak' OR
    FileName LIKE 'QLKH_Diff[_]%.bak' OR
    FileName LIKE 'QLKH_Log[_]%.trn'
);

-- Bước 5: Tìm file mới nhất cho từng loại
DECLARE @FullBackupFile NVARCHAR(255);
DECLARE @DiffBackupFile NVARCHAR(255);
DECLARE @LogBackupFile NVARCHAR(255);
DECLARE @FullBackupTime DATETIME;
DECLARE @DiffBackupTime DATETIME;
DECLARE @LogBackupTime DATETIME;

-- Tìm file Full Backup mới nhất
SELECT TOP 1 
    @FullBackupFile = @BackupPath + '\' + FileName,
    @FullBackupTime = Timestamp
FROM #BackupFiles
WHERE FileType = 'Full'
ORDER BY Timestamp DESC;

-- Tìm file Differential Backup mới nhất (nếu có, và sau Full Backup)
SELECT TOP 1 
    @DiffBackupFile = @BackupPath + '\' + FileName,
    @DiffBackupTime = Timestamp
FROM #BackupFiles
WHERE FileType = 'Diff'
AND (@FullBackupTime IS NULL OR Timestamp > @FullBackupTime)
ORDER BY Timestamp DESC;

-- Tìm filecopy file Transaction Log Backup mới nhất (nếu có, và sau Full/Diff Backup)
SELECT TOP 1 
    @LogBackupFile = @BackupPath + '\' + FileName,
    @LogBackupTime = Timestamp
FROM #BackupFiles
WHERE FileType = 'Log'
AND (@DiffBackupTime IS NULL OR Timestamp > @DiffBackupTime)
AND (@FullBackupTime IS NULL OR Timestamp > @FullBackupTime)
ORDER BY Timestamp DESC;

-- Bước 6: Kiểm tra và thực hiện Restore
IF @FullBackupFile IS NULL
BEGIN
    PRINT 'Không tìm thấy file Full Backup cho database QLKHL.';
END
ELSE
BEGIN
    PRINT 'Bắt đầu quá trình Restore...';

    -- Đưa database về chế độ single-user
    EXEC('ALTER DATABASE [QLKH] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;');

    -- Restore Full Backup
    PRINT 'Restoring Full Backup từ: ' + @FullBackupFile;
    EXEC('RESTORE DATABASE [QLKH] 
          FROM DISK = ''' + @FullBackupFile + ''' 
          WITH REPLACE, NORECOVERY;');

    -- Restore Differential Backup (nếu có)
    IF @DiffBackupFile IS NOT NULL
    BEGIN
        PRINT 'Restoring Differential Backup từ: ' + @DiffBackupFile;
        EXEC('RESTORE DATABASE [QLKH] 
              FROM DISK = ''' + @DiffBackupFile + ''' 
              WITH NORECOVERY;');
    END

    -- Restore Transaction Log (nếu có)
    IF @LogBackupFile IS NOT NULL
    BEGIN
        PRINT 'Restoring Transaction Log từ: ' + @LogBackupFile;
        EXEC('RESTORE LOG [QLKH] 
              FROM DISK = ''' + @LogBackupFile + ''' 
              WITH RECOVERY;');
    END
    ELSE
    BEGIN
        -- Nếu không có transaction log, hoàn tất restore
        EXEC('RESTORE DATABASE [QLKH] WITH RECOVERY;');
    END

    -- Đưa database về chế độ multi-user
    EXEC('ALTER DATABASE [QLKH] SET MULTI_USER;');

    PRINT 'Restore hoàn tất!';
END;

-- Dọn dẹp bảng tạm
DROP TABLE #FileList;
DROP TABLE #BackupFiles;
