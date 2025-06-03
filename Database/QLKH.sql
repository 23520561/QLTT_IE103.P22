CREATE DATABASE QLKH
USE QLKH

-- Tạo các bảng
CREATE TABLE Users (
    UserId INT PRIMARY KEY,
    UserName NVARCHAR(100) NOT NULL,
    UserEmail VARCHAR(100) NOT NULL UNIQUE,
    UserPassword VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20),
    UserAddress NVARCHAR(200),
    CONSTRAINT CHK_Email CHECK (UserEmail LIKE '%@%.%')
);

CREATE TABLE Courses (
    CourseId INT PRIMARY KEY,
    CourseTitle NVARCHAR(100) NOT NULL,
    CourseDesc NTEXT,
    CoursePrice DECIMAL(10,2) NOT NULL CHECK (CoursePrice >= 0),
    Author INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (Author) REFERENCES Users(UserId) ON DELETE CASCADE
);

CREATE TABLE Chapters (
    ChapterId INT PRIMARY KEY,
    CourseId INT NOT NULL,
    ChapterTitle NVARCHAR(100) NOT NULL,
    ChapterDesc NTEXT,
    ChapterPosition INT NOT NULL CHECK (ChapterPosition > 0),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId) ON DELETE CASCADE
);

CREATE TABLE Videos (
    VideoId INT PRIMARY KEY,
    VideoUrl VARCHAR(200) NOT NULL,
    VideoDesc NTEXT,
    VideoDuration INT NOT NULL CHECK (VideoDuration > 0),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Lessons (
    LessonId INT PRIMARY KEY,
    ChapterId INT NOT NULL,
    VideoId INT NOT NULL,
    LessonTitle NVARCHAR(100) NOT NULL,
    LessonDesc NTEXT,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (ChapterId) REFERENCES Chapters(ChapterId) ON DELETE CASCADE,
    FOREIGN KEY (VideoId) REFERENCES Videos(VideoId) ON DELETE CASCADE
);

CREATE TABLE Documents (
    DocumentId INT PRIMARY KEY,
    LessonId INT NOT NULL,
    DocumentUrl NVARCHAR(200) NOT NULL,
    DocumentDesc NTEXT,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (LessonId) REFERENCES Lessons(LessonId) ON DELETE CASCADE
);

CREATE TABLE Exams (
    ExamId INT PRIMARY KEY,
    CourseId INT NOT NULL,
    ChapterId INT,
    ExamName NVARCHAR(100) NOT NULL,
    ExamDuration INT NOT NULL CHECK (ExamDuration > 0),
    ExamDesc TEXT,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId) ON DELETE CASCADE,
    FOREIGN KEY (ChapterId) REFERENCES Chapters(ChapterId) ON DELETE NO ACTION
);

CREATE TABLE Assignments (
    AssignmentId INT PRIMARY KEY,
    LessonId INT NOT NULL,
    AssignmentDuration INT NOT NULL CHECK (AssignmentDuration > 0),
    AssignmentDesc TEXT,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (LessonId) REFERENCES Lessons(LessonId) ON DELETE CASCADE
);

CREATE TABLE Answers (
    AnswerId INT PRIMARY KEY,
    AnswerText NTEXT NOT NULL
);

CREATE TABLE Questions (
    QuestionId INT PRIMARY KEY,
    QuestionText NTEXT NOT NULL,
    QuestionType NVARCHAR(50) NOT NULL,
    QuestionScore DECIMAL(5,2) NOT NULL CHECK (QuestionScore >= 0),
    AnswerId INT,
    ExamId INT,
    AssignmentId INT,
    FOREIGN KEY (AnswerId) REFERENCES Answers(AnswerId) ON DELETE SET NULL,
    FOREIGN KEY (ExamId) REFERENCES Exams(ExamId) ON DELETE CASCADE,
    FOREIGN KEY (AssignmentId) REFERENCES Assignments(AssignmentId) ON DELETE NO ACTION, 
    CONSTRAINT CHK_Question CHECK (
        (ExamId IS NOT NULL AND AssignmentId IS NULL) OR
        (ExamId IS NULL AND AssignmentId IS NOT NULL)
    )
);

CREATE TABLE Payments (
    PaymentId INT PRIMARY KEY,
    UserId INT NOT NULL,
    CourseId INT NOT NULL,
    PaymentDesc NTEXT,
    PaymentAmount DECIMAL(10,2) NOT NULL CHECK (PaymentAmount >= 0),
    PaymentMethod VARCHAR(50) NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId) ON DELETE NO ACTION 
);

CREATE TABLE UserProgress (
    UserId INT NOT NULL,
    VideoId INT NOT NULL,
    IsComplete BIT NOT NULL DEFAULT 0,
    CompletedAt DATETIME,
    PRIMARY KEY (UserId, VideoId),
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    FOREIGN KEY (VideoId) REFERENCES Videos(VideoId) ON DELETE CASCADE
);

CREATE TABLE UserCourseStatus (
    UserId INT NOT NULL,
    CourseId INT NOT NULL,
    CourseStatus NNVARCHAR(50) NOT NULL DEFAULT 'in_progress',
    GraduatedAt DATETIME,
    PRIMARY KEY (UserId, CourseId),
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId) ON DELETE NO ACTION 
);

CREATE TABLE Feedback (
    FeedbackId INT PRIMARY KEY,
    UserId INT NOT NULL,
    CourseId INT,
    ChapterId INT,
    LessonId INT,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    FeedbackComment N;

CREATE TABLE Questions (
    QuestionId INT PRIMARY KEY,
    QuestionText NTEXT NOT NULL,
    QuestionType NVARCHAR(50) NOT NULL,
    QuestionScore DECIMAL(5,2) NOT NULL CHECK (QuestionScore >= 0),
    AnswerId INT,
    ExamId INT,
    AssignmentId INT,
    FOREIGN KEY (AnswerId) REFERENCES Answers(AnswerId) ON DELETE SET NULL,
    FOREIGN KEY (ExamId) REFERENCES Exams(ExamId) ON DELETE CASCADE,
    FOREIGN KEY (AssignmentId) REFERENCES Assignments(AssignmentId) ON DELETE NO ACTION, 
    CONSTRAINT CHK_Question CHECK (
        (ExamId IS NOT NULL AND AssignmentId IS NULL) OR
        (ExamId IS NULL AND AssignmentId IS NOT NULL)
    )
);

CREATE TABLE Payments (
    PaymentId INT PRIMARY KEY,
    UserId INT NOT NULL,
    CourseId INT NOT NULL,
    PaymentDesc NTEXT,
    PaymentAmount DECIMAL(10,2) NOT NULL CHECK (PaymentAmount >= 0),
    PaymentMethod VARCHAR(50) NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId) ON DELETE NO ACTION 
);

CREATE TABLE UserProgress (
    UserId INT NOT NULL,
    VideoId INT NOT NULL,
    IsComplete BIT NOT NULL DEFAULT 0,
    CompletedAt DATETIME,
    PRIMARY KEY (UserId, VideoId),
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    FOREIGN KEY (VideoId) REFERENCES Videos(VideoId) ON DELETE CASCADE
);

CREATE TABLE UserCourseStatus (
    UserId INT NOT NULL,
    CourseId INT NOT NULL,
    CourseStatus NVARCHAR(50) NOT NULL DEFAULT 'in_progress',
    GraduatedAt DATETIME,
    PRIMARY KEY (UserId, CourseId),
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId) ON DELETE NO ACTION 
);

CREATE TABLE Feedback (
    FeedbackId INT PRIMARY KEY,
    UserId INT NOT NULL,
    CourseId INT,
    ChapterId INT,
    LessonId INT,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    FeedbackComment NTEXT,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId) ON DELETE NO ACTION, 
    FOREIGN KEY (ChapterId) REFERENCES Chapters(ChapterId) ON DELETE NO ACTION,
    FOREIGN KEY (LessonId) REFERENCES Lessons(LessonId) ON DELETE NO ACTION,
    CONSTRAINT CHK_Feedback CHECK (
        (CourseId IS NOT NULL AND ChapterId IS NULL AND LessonId IS NULL)
        OR (CourseId IS NOT NULL AND ChapterId IS NOT NULL AND LessonId IS NULL)
        OR (CourseId IS NOT NULL AND ChapterId IS NOT NULL AND LessonId IS NOT NULL)
    )
);
GO

-- Tạo các trigger
CREATE TRIGGER CreateAt_Course_Chapter
ON Chapters
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Courses c ON i.CourseId = c.CourseId
        WHERE i.CreatedAt <= c.CreatedAt
    )
    BEGIN
        RAISERROR ('Chapter must be created after Course', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER CreatedAt_Chapter_Lesson
ON Lessons
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Chapters c ON i.ChapterId = c.ChapterId
        WHERE i.CreatedAt <= c.CreatedAt
    )
    BEGIN
        RAISERROR ('Lesson must be created after Chapter', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER CreatedAt_Chapter_Exam
ON Exams
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Chapters c ON i.ChapterId = c.ChapterId
        WHERE i.CreatedAt <= c.CreatedAt AND i.ChapterId IS NOT NULL
    )
    BEGIN
        RAISERROR ('Exam must be created after Chapter', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER CreatedAt_Lesson_Document
ON Documents
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Lessons l ON i.LessonId = l.LessonId
        WHERE i.CreatedAt <= l.CreatedAt
    )
    BEGIN
        RAISERROR ('Document must be created after Lesson', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER CreatedAt_Lesson_Assignment
ON Assignments
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Lessons l ON i.LessonId = l.LessonId
        WHERE i.CreatedAt <= l.CreatedAt
    )
    BEGIN
        RAISERROR ('Assignment must be created after Lesson', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER CreatedAt_Course_Feedback
ON Feedback
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Courses c ON i.CourseId = c.CourseId
        WHERE i.CreatedAt <= c.CreatedAt
    )
    BEGIN
        RAISERROR ('Feedback must be created after Course', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER IsComplete_UserProgress
ON UserProgress
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.IsComplete = 1 AND (i.CompletedAt IS NULL OR i.CompletedAt < 90)
    )
    BEGIN
        RAISERROR('Chỉ hoàn thành video khi đã xem 90% video', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER trg_UpdateCourseStatus_WhenAllVideosCompleted
ON UserProgress
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId INT, @VideoId INT;
    SELECT @UserId = UserId, @VideoId = VideoId
    FROM inserted;

    DECLARE @CourseId INT;
    SELECT TOP 1 @CourseId = c.CourseId
    FROM Videos v
    JOIN Lessons l ON v.VideoId = l.VideoId
    JOIN Chapters ch ON l.ChapterId = ch.ChapterId
    JOIN Courses c ON ch.CourseId = c.CourseId
    WHERE v.VideoId = @VideoId;

    IF @CourseId IS NOT NULL AND NOT EXISTS (
        SELECT 1
        FROM Videos v
        JOIN Lessons l ON v.VideoId = l.VideoId
        JOIN Chapters ch ON l.ChapterId = ch.ChapterId
        WHERE ch.CourseId = @CourseId
        AND NOT EXISTS (
            SELECT 1
            FROM UserProgress up
            WHERE up.VideoId = v.VideoId AND up.UserId = @UserId AND up.IsComplete = 1
        )
    )
    BEGIN
        UPDATE UserCourseStatus
        SET CourseStatus = 'Completed',
            GraduatedAt = GETDATE()
        WHERE UserId = @UserId AND CourseId = @CourseId;
    END
END;
GO

CREATE TRIGGER trg_ResetAndInitializeUserProgress
ON Payments
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE UP
    FROM UserProgress UP
    JOIN inserted i ON UP.UserId = i.UserId
    JOIN Lessons l ON l.VideoId = UP.VideoId
    JOIN Chapters c ON l.ChapterId = c.ChapterId
    WHERE c.CourseId = i.CourseId;

    DELETE UCS
    FROM UserCourseStatus UCS
    JOIN inserted i ON UCS.UserId = i.UserId AND UCS.CourseId = i.CourseId;

    INSERT INTO UserProgress (UserId, VideoId, IsComplete, CompletedAt)
    SELECT i.UserId, v.VideoId, 0, NULL
    FROM inserted i
    JOIN Chapters c ON c.CourseId = i.CourseId
    JOIN Lessons l ON l.ChapterId = c.ChapterId
    JOIN Videos v ON v.VideoId = l.VideoId;

    INSERT INTO UserCourseStatus (UserId, CourseId, CourseStatus, GraduatedAt)
    SELECT i.UserId, i.CourseId, 'in_progress', NULL
    FROM inserted i;
END;
GO

-- Tạo các stored procedures
CREATE PROCEDURE Update_Create_User
    @UserId INT,
    @UserName NVARCHAR(100),
    @UserEmail VARCHAR(100),
    @UserPassword VARCHAR(100),
    @PhoneNumber VARCHAR(20),
    @UserAddress NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Users WHERE UserId = @UserId)
    BEGIN
        UPDATE Users
        SET UserName = @UserName,
            UserEmail = @UserEmail,
            UserPassword = @UserPassword,
            PhoneNumber = @PhoneNumber,
            UserAddress = @UserAddress
        WHERE UserId = @UserId;
    END
    ELSE
    BEGIN
        INSERT INTO Users (UserId, UserName, UserEmail, UserPassword, PhoneNumber, UserAddress)
        VALUES (@UserId, @UserName, @UserEmail, @UserPassword, @PhoneNumber, @UserAddress);
    END
END;
GO

CREATE PROCEDURE Update_Create_Course
    @CourseId INT,
    @CourseTitle VARCHAR(100),
    @CourseDesc TEXT,
    @CoursePrice DECIMAL(10,2),
    @Author INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Courses WHERE CourseId = @CourseId)
    BEGIN
        UPDATE Courses
        SET CourseTitle = @CourseTitle,
            CourseDesc = @CourseDesc,
            CoursePrice = @CoursePrice,
            Author = @Author
        WHERE CourseId = @CourseId;
    END
    ELSE
    BEGIN
        INSERT INTO Courses (CourseId, CourseTitle, CourseDesc, CoursePrice, Author, CreatedAt)
        VALUES (@CourseId, @CourseTitle, @CourseDesc, @CoursePrice, @Author, GETDATE());
    END
END;
GO

CREATE PROCEDURE Update_Create_Chapter
    @ChapterId INT,
    @CourseId INT,
    @ChapterTitle NVARCHAR(100),
    @ChapterDesc TEXT,
    @ChapterPosition INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Chapters WHERE ChapterId = @ChapterId)
    BEGIN
        UPDATE Chapters
        SET CourseId = @CourseId,
            ChapterTitle = @ChapterTitle,
            ChapterDesc = @ChapterDesc,
            ChapterPosition = @ChapterPosition
        WHERE ChapterId = @ChapterId;
    END
    ELSE
    BEGIN
        INSERT INTO Chapters (ChapterId, CourseId, ChapterTitle, ChapterDesc, ChapterPosition, CreatedAt)
        VALUES (@ChapterId, @CourseId, @ChapterTitle, @ChapterDesc, @ChapterPosition, GETDATE());
    END
END;
GO

CREATE PROCEDURE Update_Create_Video
    @VideoId INT,
    @VideoUrl VARCHAR(200),
    @VideoDesc NTEXT,
    @VideoDuration INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Videos WHERE VideoId = @VideoId)
    BEGIN
        UPDATE Videos
        SET VideoUrl = @VideoUrl,
            VideoDesc = @VideoDesc,
            VideoDuration = @VideoDuration
        WHERE VideoId = @VideoId;
    END
    ELSE
    BEGIN
        INSERT INTO Videos (VideoId, VideoUrl, VideoDesc, VideoDuration, CreatedAt)
        VALUES (@VideoId, @VideoUrl, @VideoDesc, @VideoDuration, GETDATE());
    END
END;
GO

CREATE PROCEDURE Update_Create_Lesson
    @LessonId INT,
    @ChapterId INT,
    @VideoId INT,
    @LessonTitle NVARCHAR(100),
    @LessonDesc NTEXT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Lessons WHERE LessonId = @LessonId)
    BEGIN
        UPDATE Lessons
        SET ChapterId = @ChapterId,
            VideoId = @VideoId,
            LessonTitle = @LessonTitle,
            LessonDesc = @LessonDesc
        WHERE LessonId = @LessonId;
    END
    ELSE
    BEGIN
        INSERT INTO Lessons (LessonId, ChapterId, VideoId, LessonTitle, LessonDesc, CreatedAt)
        VALUES (@LessonId, @ChapterId, @VideoId, @LessonTitle, @LessonDesc, GETDATE());
    END
END;
GO

CREATE PROCEDURE Update_Create_Document
    @DocumentId INT,
    @LessonId INT,
    @DocumentUrl VARCHAR(200),
    @DocumentDesc NTEXT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Documents WHERE DocumentId = @DocumentId)
    BEGIN
        UPDATE Documents
        SET LessonId = @LessonId,
            DocumentUrl = @DocumentUrl,
            DocumentDesc = @DocumentDesc
        WHERE DocumentId = @DocumentId;
    END
    ELSE
    BEGIN
        INSERT INTO Documents (DocumentId, LessonId, DocumentUrl, DocumentDesc, CreatedAt)
        VALUES (@DocumentId, @LessonId, @DocumentUrl, @DocumentDesc, GETDATE());
    END
END;
GO

CREATE PROCEDURE Update_Create_Exam
    @ExamId INT,
    @CourseId INT,
    @ChapterId INT,
    @ExamName NVARCHAR(100),
    @ExamDuration INT,
    @ExamDesc NTEXT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Exams WHERE ExamId = @ExamId)
    BEGIN
        UPDATE Exams
        SET CourseId = @CourseId,
            ChapterId = @ChapterId,
            ExamName = @ExamName,
            ExamDuration = @ExamDuration,
            ExamDesc = @ExamDesc
        WHERE ExamId = @ExamId;
    END
    ELSE
    BEGIN
        INSERT INTO Exams (ExamId, CourseId, ChapterId, ExamName, ExamDuration, ExamDesc, CreatedAt)
        VALUES (@ExamId, @CourseId, @ChapterId, @ExamName, @ExamDuration, @ExamDesc, GETDATE());
    END
END;
GO

CREATE PROCEDURE Update_Create_Assignment
    @AssignmentId INT,
    @LessonId INT,
    @AssignmentDuration INT,
    @AssignmentDesc NTEXT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Assignments WHERE AssignmentId = @AssignmentId)
    BEGIN
        UPDATE Assignments
        SET LessonId = @LessonId,
            AssignmentDuration = @AssignmentDuration,
            AssignmentDesc = @AssignmentDesc
        WHERE AssignmentId = @AssignmentId;
    END
    ELSE
    BEGIN
        INSERT INTO Assignments (AssignmentId, LessonId, AssignmentDuration, AssignmentDesc, CreatedAt)
        VALUES (@AssignmentId, @LessonId, @AssignmentDuration, @AssignmentDesc, GETDATE());
    END
END;
GO

CREATE PROCEDURE Update_Insert_Question
    @QuestionId INT,
    @QuestionText NTEXT,
    @QuestionType NVARCHAR(50),
    @QuestionScore DECIMAL(5,2),
    @AnswerId INT,
    @ExamId INT,
    @AssignmentId INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Questions WHERE QuestionId = @QuestionId)
    BEGIN
        UPDATE Questions
        SET QuestionText = @QuestionText,
            QuestionType = @QuestionType,
            QuestionScore = @QuestionScore,
            AnswerId = @AnswerId,
            ExamId = @ExamId,
            AssignmentId = @AssignmentId
        WHERE QuestionId = @QuestionId;
    END
    ELSE
    BEGIN
        INSERT INTO Questions (QuestionId, QuestionText, QuestionType, QuestionScore, AnswerId, ExamId, AssignmentId)
        VALUES (@QuestionId, @QuestionText, @QuestionType, @QuestionScore, @AnswerId, @ExamId, @AssignmentId);
    END
END;
GO

CREATE PROCEDURE Update_Create_Payment_CourseStatus
    @PaymentId INT,
    @UserId INT,
    @CourseId INT,
    @PaymentDesc NTEXT,
    @PaymentAmount DECIMAL(10,2),
    @PaymentMethod NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Payments WHERE PaymentId = @PaymentId)
    BEGIN
        UPDATE Payments
        SET PaymentDesc = @PaymentDesc,
            PaymentAmount = @PaymentAmount,
            PaymentMethod = @PaymentMethod
        WHERE PaymentId = @PaymentId;
    END
    ELSE
    BEGIN
        INSERT INTO Payments (PaymentId, UserId, CourseId, PaymentDesc, PaymentAmount, PaymentMethod, CreatedAt)
        VALUES (@PaymentId, @UserId, @CourseId, @PaymentDesc, @PaymentAmount, @PaymentMethod, GETDATE());

        IF NOT EXISTS (SELECT 1 FROM UserCourseStatus WHERE UserId = @UserId AND CourseId = @CourseId)
        BEGIN
            INSERT INTO UserCourseStatus (UserId, CourseId, CourseStatus, GraduatedAt)
            VALUES (@UserId, @CourseId, 'in_progress', NULL);
        END
    END
END;
GO

CREATE PROCEDURE Update_Create_Feedback
    @FeedbackId INT,
    @UserId INT,
    @CourseId INT,
    @ChapterId INT,
    @LessonId INT,
    @Rating INT,
    @FeedbackComment NTEXT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Feedback WHERE FeedbackId = @FeedbackId)
    BEGIN
        UPDATE Feedback
        SET UserId = @UserId,
            CourseId = @CourseId,
            ChapterId = @ChapterId,
            LessonId = @LessonId,
            Rating = @Rating,
            FeedbackComment = @FeedbackComment
        WHERE FeedbackId = @FeedbackId;
    END
    ELSE
    BEGIN
        INSERT INTO Feedback (FeedbackId, UserId, CourseId, ChapterId, LessonId, Rating, FeedbackComment, CreatedAt)
        VALUES (@FeedbackId, @UserId, @CourseId, @ChapterId, @LessonId, @Rating, @FeedbackComment, GETDATE());
    END
END;
GO

-- Tạo các hàm (functions)
CREATE FUNCTION GetCourseTotalDuration (@CourseId INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalDuration INT;
    SELECT @TotalDuration = SUM(v.VideoDuration)
    FROM Videos v
    JOIN Lessons l ON v.VideoId = l.VideoId
    JOIN Chapters c ON l.ChapterId = c.ChapterId
    WHERE c.CourseId = @CourseId;
    RETURN ISNULL(@TotalDuration, 0);
END;
GO

CREATE FUNCTION GetCourseLessonCount (@CourseId INT)
RETURNS INT
AS
BEGIN
    DECLARE @LessonCount INT;
    SELECT @LessonCount = COUNT(l.LessonId)
    FROM Lessons l
    JOIN Chapters c ON l.ChapterId = c.ChapterId
    WHERE c.CourseId = @CourseId;
    RETURN ISNULL(@LessonCount, 0);
END;
GO

CREATE FUNCTION GetCourseCompletionPercentage (@UserId INT, @CourseId INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @TotalVideos INT;
    DECLARE @CompletedVideos INT;
    SELECT @TotalVideos = COUNT(v.VideoId)
    FROM Videos v
    JOIN Lessons l ON v.VideoId = l.VideoId
    JOIN Chapters c ON l.ChapterId = c.ChapterId
    WHERE c.CourseId = @CourseId;
    SELECT @CompletedVideos = COUNT(up.VideoId)
    FROM UserProgress up
    JOIN Videos v ON up.VideoId = v.VideoId
    JOIN Lessons l ON v.VideoId = l.VideoId
    JOIN Chapters c ON l.ChapterId = c.ChapterId
    WHERE c.CourseId = @CourseId AND up.UserId = @UserId AND up.IsComplete = 1;
    IF @TotalVideos = 0
        RETURN 0;
    RETURN (@CompletedVideos * 100.0) / @TotalVideos;
END;
GO

-- Tạo thủ tục sử dụng con trỏ
CREATE PROCEDURE GetCompletedUsersForCourse
    @CourseId INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @UserId INT, @UserName VARCHAR(100);
    DECLARE completed_users CURSOR LOCAL STATIC FOR
        SELECT u.UserId, u.UserName
        FROM Users u
        JOIN UserCourseStatus ucs ON u.UserId = ucs.UserId
        WHERE ucs.CourseId = @CourseId AND ucs.CourseStatus = 'Completed';
    OPEN completed_users;
    FETCH NEXT FROM completed_users INTO @UserId, @UserName;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'User ' + @UserName + ' (ID: ' + CAST(@UserId AS VARCHAR) + ') has completed the course.';
        FETCH NEXT FROM completed_users INTO @UserId, @UserName;
    END
    CLOSE completed_users;
    DEALLOCATE completed_users;
END;
GO
