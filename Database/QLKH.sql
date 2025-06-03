CREATE DATABASE QLKH
USE QLKH

--- Tạo các bảng
CREATE TABLE Users (
    UserId INT PRIMARY KEY,
    UserName VARCHAR(100),
    UserEmail VARCHAR(100),
    UserPassword VARCHAR(100),
    PhoneNumber VARCHAR(20),
    UserAddress VARCHAR(200)
);

CREATE TABLE Courses (
    CourseId INT PRIMARY KEY,
    CourseTitle VARCHAR(100),
    CourseDesc TEXT,
    CoursePrice DECIMAL(10,2),
    Author INT,
    CreatedAt DATETIME,
    FOREIGN KEY (Author) REFERENCES Users(UserId) ON DELETE CASCADE
);

CREATE TABLE Chapters (
    ChapterId INT PRIMARY KEY,
    CourseId INT,
    ChapterTitle VARCHAR(100),
    ChapterDesc TEXT,
    ChapterPosition INT,
    CreatedAt DATETIME,
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId) ON DELETE CASCADE
);

CREATE TABLE Videos (
    VideoId INT PRIMARY KEY,
    VideoUrl VARCHAR(200),
    VideoDesc TEXT,
    VideoDuration INT,
    CreatedAt DATETIME
);

CREATE TABLE Lessons (
    LessonId INT PRIMARY KEY,
    ChapterId INT,
    VideoId INT,
    LessonTitle VARCHAR(100),
    LessonDesc TEXT,
    CreatedAt DATETIME,
    FOREIGN KEY (ChapterId) REFERENCES Chapters(ChapterId) ON DELETE CASCADE,
    FOREIGN KEY (VideoId) REFERENCES Videos(VideoId) ON DELETE CASCADE
);

CREATE TABLE Documents (
    DocumentId INT PRIMARY KEY,
    LessonID INT,
    DocumentUrl VARCHAR(200),
    DocumentDesc TEXT,
    CreatedAt DATETIME,
    FOREIGN KEY (LessonID) REFERENCES Lessons(LessonID) ON DELETE CASCADE
);

CREATE TABLE Exams (
    ExamId INT PRIMARY KEY,
    CourseId INT,
    ChapterId INT,
    ExamName VARCHAR(100),
    ExamDuration INT,
    ExamDesc TEXT,
    CreatedAt DATETIME,
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId) ON DELETE CASCADE,
    FOREIGN KEY (ChapterId) REFERENCES Chapters(ChapterId) ON DELETE CASCADE
);

CREATE TABLE Assignments (
    AssignmentId INT PRIMARY KEY,
    LessonId INT,
    AssignmentDuration INT,
    AssignmentDesc TEXT,
    CreatedAt DATETIME,
    FOREIGN KEY (LessonId) REFERENCES Lessons(LessonId) ON DELETE CASCADE
);

CREATE TABLE Answers (
    AnswerId INT PRIMARY KEY,
    AnswerText TEXT
);

CREATE TABLE Questions (
    QuestionId INT PRIMARY KEY,
    QuestionText TEXT,
    QuestionType VARCHAR(50),
    QuestionScore DECIMAL(5,2),
    AnswerId INT,
    ExamId INT,
    AssignmentId INT,
    FOREIGN KEY (AnswerId) REFERENCES Answers(AnswerId) ON DELETE CASCADE,
    FOREIGN KEY (ExamId) REFERENCES Exams(ExamId) ON DELETE CASCADE,
    FOREIGN KEY (AssignmentId) REFERENCES Assignments(AssignmentId) ON DELETE CASCADE
);

CREATE TABLE Payments (
    PaymentId INT PRIMARY KEY,
    UserId INT,
    CourseId INT,
    PaymentDesc TEXT,
    PaymentAmount DECIMAL(10,2),
    PaymentMethod VARCHAR(50),
    CreatedAt DATETIME,
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId) ON DELETE CASCADE
);

CREATE TABLE UserProgress (
    UserId INT,
    VideoId INT,
    IsComplete BIT,
    CompletedAt DATETIME,
    PRIMARY KEY (UserId, VideoId),
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    FOREIGN KEY (VideoId) REFERENCES Videos(VideoId) ON DELETE CASCADE
);

CREATE TABLE UserCourseStatus (
    UserId INT,
    CourseId INT,
    CourseStatus VARCHAR(50),
    GraduatedAt DATETIME,
    PRIMARY KEY (UserId, CourseId),
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId) ON DELETE CASCADE
);

CREATE TABLE Feedback (
    FeedbackId INT PRIMARY KEY,
    UserId INT,
    CourseId INT,
    ChapterId INT,
    LessonId INT,
    Rating INT,
    FeedbackComment TEXT,
    CreatedAt DATETIME,
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId) ON DELETE CASCADE,
    FOREIGN KEY (ChapterId) REFERENCES Chapters(ChapterId) ON DELETE CASCADE,
    FOREIGN KEY (LessonId) REFERENCES Lessons(LessonId) ON DELETE CASCADE,
    CHECK (
        (CourseId IS NOT NULL AND ChapterId IS NULL AND LessonId IS NULL)
        OR (ChapterId IS NOT NULL AND LessonId IS NULL)
        OR (LessonId IS NOT NULL)
    )
);

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
        -- Roll back the operation
        RAISERROR (
            'Chapter phải được tạo sau Course',
            16, 1
        );
        ROLLBACK TRANSACTION;
    END
END;
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
        RAISERROR('Lesson phải được tạo sau Chapter', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
CREATE TRIGGER CreatedAt_Chapter_Exam
ON Exams
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
        RAISERROR('Exam phải được tạo sau Chapter', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
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
        RAISERROR('Document phải được tạo sau Lesson', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
CREATE TRIGGER CreatedAt_Lesson_Assigment
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
        RAISERROR('Assignment phải được tạo sau Lesson', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
CREATE TRIGGER CreatedAt_Course_FeedBack
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
        RAISERROR('Feedback phải được tạo sau Course', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
CREATE TRIGGER IsComplete_UserProgress
ON UserProgress
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.IsComplete = 1 AND (i.CompletedAt IS NULL OR i.CompletedAt < 100)
    )
    BEGIN
        RAISERROR('Chỉ hoàn thành video khi đã xem 100% video', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

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

    IF NOT EXISTS (
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

CREATE TRIGGER trg_ResetAndInitializeUserProgress
ON Payments
AFTER INSERT
AS
BEGIN
   
    DELETE UP
    FROM UserProgress UP
    JOIN inserted i ON UP.UserId = i.UserId
    JOIN Chapters c ON c.CourseId = i.CourseId
    JOIN Lessons l ON l.ChapterId = c.ChapterId
    WHERE l.VideoId = UP.VideoId;

    DELETE UCS
    FROM UserCourseStatus UCS
    JOIN inserted i ON UCS.UserId = i.UserId AND UCS.CourseId = i.CourseId;

    INSERT INTO UserProgress (UserId, VideoId, IsComplete, CompletedAt)
    SELECT
        i.UserId,
        v.VideoId,
        0,        
        NULL      
    FROM inserted i
    JOIN Chapters c ON c.CourseId = i.CourseId
    JOIN Lessons l ON l.ChapterId = c.ChapterId
    JOIN Videos v ON v.VideoId = l.VideoId;

    INSERT INTO UserCourseStatus (UserId, CourseId, CourseStatus, GraduatedAt)
    SELECT i.UserId, i.CourseId, 'in_progress', NULL
    FROM inserted i;
END;

CREATE PROCEDURE Update_Create_User
    @UserId INT,
    @UserName VARCHAR(100),
    @UserEmail VARCHAR(100),
    @UserPassword VARCHAR(100),
    @PhoneNumber VARCHAR(20),
    @UserAddress VARCHAR(200)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Users WHERE UserId = @UserId)
    BEGIN
        UPDATE Users
        SET
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
CREATE PROCEDURE Update_Create_Course
    @CourseId INT,
    @CourseTitle VARCHAR(100),
    @CourseDesc TEXT,
    @CoursePrice DECIMAL(10,2)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Courses WHERE CourseId = @CourseId)
    BEGIN
        UPDATE Courses
        SET
            CourseTitle = @CourseTitle,
            CourseDesc = @CourseDesc,
            CoursePrice = @CoursePrice
        WHERE CourseId = @CourseId;
    END
    ELSE
    BEGIN
        INSERT INTO Courses (CourseId, CourseTitle, CourseDesc, CoursePrice, CreatedAt)
        VALUES (@CourseId, @CourseTitle, @CourseDesc, @CoursePrice, GETDATE());
    END
END;
CREATE PROCEDURE Update_Create_Chapter
    @ChapterId INT,
    @CourseId INT,
    @ChapterTitle VARCHAR(100),
    @ChapterDesc TEXT,
    @ChapterPosition INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Chapters WHERE ChapterId = @ChapterId)
    BEGIN
        UPDATE Chapters
        SET
            CourseId = @CourseId,
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
CREATE PROCEDURE Update_Create_Video
    @VideoId INT,
    @VideoUrl VARCHAR(200),
    @VideoDesc TEXT,
    @VideoDuration INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Videos WHERE VideoId = @VideoId)
    BEGIN
        UPDATE Videos
        SET
            VideoUrl = @VideoUrl,
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
CREATE PROCEDURE Update_Create_Lesson
    @LessonId INT,
    @ChapterId INT,
    @VideoId INT,
    @LessonTitle VARCHAR(100),
    @LessonDesc TEXT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Lessons WHERE LessonId = @LessonId)
    BEGIN
        UPDATE Lessons
        SET
            ChapterId = @ChapterId,
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
CREATE PROCEDURE Update_Create_Document
    @DocumentId INT,
    @LessonId INT,
    @DocumentUrl VARCHAR(200),
    @DocumentDesc TEXT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Documents WHERE DocumentId = @DocumentId)
    BEGIN
        UPDATE Documents
        SET
            LessonId = @LessonId,
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
CREATE PROCEDURE Update_Create_Exam
    @ExamId INT,
    @CourseId INT,
    @ChapterId INT,
    @ExamName VARCHAR(100),
    @ExamDuration INT,
    @ExamDesc TEXT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Exams WHERE ExamId = @ExamId)
    BEGIN
        UPDATE Exams
        SET
            CourseId = @CourseId,
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
CREATE PROCEDURE Update_Create_Assignment
    @AssignmentId INT,
    @LessonId INT,
    @AssignmentDuration INT,
    @AssignmentDesc TEXT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Assignments WHERE AssignmentId = @AssignmentId)
    BEGIN
        UPDATE Assignments
        SET
            LessonId = @LessonId,
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
CREATE PROCEDURE Update_Insert_Question
    @QuestionId INT,
    @QuestionText TEXT,
    @QuestionType VARCHAR(50),
    @QuestionScore DECIMAL(5,2),
    @AnswerId INT,
    @ExamId INT,
    @AssignmentId INT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM Questions
        WHERE QuestionId = @QuestionId
          AND ExamId = @ExamId
          AND AssignmentId = @AssignmentId
    )
    BEGIN
        UPDATE Questions
        SET
            QuestionText = @QuestionText,
            QuestionType = @QuestionType,
            QuestionScore = @QuestionScore,
            AnswerId = @AnswerId
        WHERE QuestionId = @QuestionId
          AND ExamId = @ExamId
          AND AssignmentId = @AssignmentId;
    END
    ELSE
    BEGIN
        INSERT INTO Questions (
            QuestionId, QuestionText, QuestionType, QuestionScore,
            AnswerId, ExamId, AssignmentId
        )
        VALUES (
            @QuestionId, @QuestionText, @QuestionType, @QuestionScore,
            @AnswerId, @ExamId, @AssignmentId
        );
    END
END;
CREATE TRIGGER PaymentAmount_Validation
ON Payments
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Inserted i
        JOIN Deleted d ON i.PaymentId = d.PaymentId AND i.UserId = d.UserId AND i.CourseId = d.CourseId
        WHERE i.PaymentAmount > d.PaymentAmount
    )
    BEGIN
        RAISERROR('Giá trị tiền được chỉnh sửa không thể lớn hơn giá trị ban đầu', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

CREATE PROCEDURE Update_Create_Payment_CourseStatus
    @PaymentId INT,
    @UserId INT,
    @CourseId INT,
    @UserCourseStt INT,
    @PaymentDesc TEXT,
    @PaymentAmount DECIMAL(10,2),
    @PaymentMethod VARCHAR(50)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM Payments
        WHERE PaymentId = @PaymentId
          AND UserId = @UserId
          AND CourseId = @CourseId
    )
    BEGIN
        UPDATE Payments
        SET
            PaymentDesc = @PaymentDesc,
            PaymentAmount = @PaymentAmount,
            PaymentMethod = @PaymentMethod
        WHERE PaymentId = @PaymentId
          AND UserId = @UserId
          AND CourseId = @CourseId;
    END
    ELSE
    BEGIN
        INSERT INTO Payments (
            PaymentId, UserId, CourseId, PaymentDesc,
            PaymentAmount, PaymentMethod, CreatedAt
        )
        VALUES (
            @PaymentId, @UserId, @CourseId, @PaymentDesc,
            @PaymentAmount, @PaymentMethod, GETDATE()
        );
        INSERT INTO UserCourseStatus (
            UserCourseStt, UserId, CourseId, 
            CourseStatus, GraduatedAt
        )
        VALUES (
            @UserCourseStt, @UserId, @CourseId,
            0, NULL
        );
    END
END;
CREATE PROCEDURE Update_Create_Feedback
    @FeedbackId INT,
    @UserId INT,
    @CourseId INT,
    @ChapterId INT,
    @LessonId INT,
    @Rating INT,
    @FeedbackComment TEXT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Feedback
        WHERE FeedbackId = @FeedbackId
          AND UserId = @UserId
          AND CourseId = @CourseId
          AND ChapterId = @ChapterId
          AND LessonId = @LessonId
    )
    BEGIN
        UPDATE Feedback
        SET
            Rating = @Rating,
            FeedbackComment = @FeedbackComment
        WHERE FeedbackId = @FeedbackId
          AND UserId = @UserId
          AND CourseId = @CourseId
          AND ChapterId = @ChapterId
          AND LessonId = @LessonId;
    END
    ELSE
    BEGIN
        INSERT INTO Feedback (
            FeedbackId, UserId, CourseId, ChapterId, LessonId,
            Rating, FeedbackComment, CreatedAt
        )
        VALUES (
            @FeedbackId, @UserId, @CourseId, @ChapterId, @LessonId,
            @Rating, @FeedbackComment, GETDATE()
        );
    END
END;
