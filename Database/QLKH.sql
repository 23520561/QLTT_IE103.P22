CREATE DATABASE QLKH
USE QLKH
--- Tạo các bảng
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
