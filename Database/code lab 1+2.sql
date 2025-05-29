use QLKH5
-- Tạo bảng ROLES
CREATE TABLE ROLES (
    role_id INT PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL UNIQUE
);

-- Chèn dữ liệu vào ROLES
INSERT INTO ROLES (role_id, role_name) VALUES
(1, N'Admin'),
(2, N'Teacher'),
(3, N'Student');

-- Tạo bảng USERS
CREATE TABLE USERS (
    role_id INT,
    user_id INT PRIMARY KEY,
    user_name NVARCHAR(100) NOT NULL,
    user_email NVARCHAR(100) NOT NULL UNIQUE,
    user_password_hash NVARCHAR(100) NOT NULL,
    phone_number NVARCHAR(20),
    user_address NVARCHAR(200),
    FOREIGN KEY (role_id) REFERENCES ROLES(role_id)
);

-- Tạo bảng COURSES
CREATE TABLE COURSES (
    course_id INT PRIMARY KEY,
    course_title NVARCHAR(100) NOT NULL,
    course_description NVARCHAR(MAX),
    course_price DECIMAL(10,2),
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- Tạo bảng CHAPTERS
CREATE TABLE CHAPTERS (
    chapter_id INT PRIMARY KEY,
    course_id INT,
    chapter_title NVARCHAR(100) NOT NULL,
    chapter_description NVARCHAR(MAX),
    chapter_position INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (course_id) REFERENCES COURSES(course_id) ON DELETE CASCADE
);
GO

-- Tạo bảng VIDEOS
CREATE TABLE VIDEOS (
    video_id INT PRIMARY KEY,
    video_url NVARCHAR(255) NOT NULL,
    video_description NVARCHAR(MAX),
    video_duration INT,
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- Tạo bảng LESSONS
CREATE TABLE LESSONS (
    lesson_id INT PRIMARY KEY,
    chapter_id INT,
    video_id INT,
    lesson_title NVARCHAR(100) NOT NULL,
    lesson_description NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (chapter_id) REFERENCES CHAPTERS(chapter_id) ON DELETE CASCADE,
    FOREIGN KEY (video_id) REFERENCES VIDEOS(video_id) ON DELETE CASCADE
);
GO

-- Tạo bảng DOCUMENTS
CREATE TABLE DOCUMENTS (
    document_id INT PRIMARY KEY,
    lesson_id INT,
    document_url NVARCHAR(255) NOT NULL,
    document_description NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (lesson_id) REFERENCES LESSONS(lesson_id) ON DELETE CASCADE
);
GO

-- Tạo bảng EXAMS
CREATE TABLE EXAMS (
    exam_id INT PRIMARY KEY,
    course_id INT,
    chapter_id INT,
    exam_name NVARCHAR(100) NOT NULL,
    exam_duration INT,
    exam_description NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (course_id) REFERENCES COURSES(course_id) ON DELETE CASCADE,
    FOREIGN KEY (chapter_id) REFERENCES CHAPTERS(chapter_id) ON DELETE NO ACTION
);
GO

-- Tạo bảng ASSIGNMENTS
CREATE TABLE ASSIGNMENTS (
    assignment_id INT PRIMARY KEY,
    lesson_id INT,
    assignment_duration INT,
    assignment_description NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (lesson_id) REFERENCES LESSONS(lesson_id) ON DELETE CASCADE
);
GO

-- Tạo bảng ANSWERS
CREATE TABLE ANSWERS (
    answer_id INT PRIMARY KEY,
    answer_text NVARCHAR(MAX) NOT NULL
);
GO

-- Tạo bảng QUESTIONS với ràng buộc CHECK
CREATE TABLE QUESTIONS (
    question_id INT PRIMARY KEY,
    question_text NVARCHAR(MAX) NOT NULL,
    question_type NVARCHAR(50) NOT NULL,
    question_score DECIMAL(5,2),
    answer_id INT,
    exam_id INT,
    assignment_id INT,
    FOREIGN KEY (answer_id) REFERENCES ANSWERS(answer_id) ON DELETE CASCADE,
    FOREIGN KEY (exam_id) REFERENCES EXAMS(exam_id) ON DELETE CASCADE,
    FOREIGN KEY (assignment_id) REFERENCES ASSIGNMENTS(assignment_id) ON DELETE NO ACTION,
    CHECK ((exam_id IS NOT NULL AND assignment_id IS NULL) OR (exam_id IS NULL AND assignment_id IS NOT NULL))
);
GO

-- Tạo bảng PAYMENTS
CREATE TABLE PAYMENTS (
    payment_id INT PRIMARY KEY,
    user_id INT,
    course_id INT,
    payment_description NVARCHAR(MAX),
    payment_amount DECIMAL(10,2),
    payment_method NVARCHAR(50),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES COURSES(course_id) ON DELETE CASCADE
);
GO

-- Tạo bảng USER_PROGRESS
CREATE TABLE USER_PROGRESS (
    user_progress_id INT PRIMARY KEY,
    user_id INT,
    video_id INT,
    is_complete BIT,
    completed_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (video_id) REFERENCES VIDEOS(video_id) ON DELETE CASCADE
);
GO

-- Tạo bảng USER_COURSE_STATUS
CREATE TABLE USER_COURSE_STATUS (
    user_course_status_id INT PRIMARY KEY,
    user_id INT,
    course_id INT,
    course_status NVARCHAR(50),
    graduated_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES COURSES(course_id) ON DELETE CASCADE
);
GO

-- Tạo bảng FEEDBACK
CREATE TABLE FEEDBACK (
    feedback_id INT PRIMARY KEY,
    user_id INT,
    course_id INT,
    chapter_id INT,
    lesson_id INT,
    rating INT,
    feedback_comment NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES COURSES(course_id) ON DELETE NO ACTION,
    FOREIGN KEY (chapter_id) REFERENCES CHAPTERS(chapter_id) ON DELETE NO ACTION,
    FOREIGN KEY (lesson_id) REFERENCES LESSONS(lesson_id) ON DELETE CASCADE
);
GO

-- Tạo bảng TEACHER_COURSES
CREATE TABLE TEACHER_COURSES (
    teacher_id INT,
    course_id INT,
    PRIMARY KEY (teacher_id, course_id),
    FOREIGN KEY (teacher_id) REFERENCES USERS(user_id),
    FOREIGN KEY (course_id) REFERENCES COURSES(course_id)
);
GO

-- Tạo các trigger
CREATE TRIGGER trg_create_at_course_chapter
ON CHAPTERS
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN COURSES c ON i.course_id = c.course_id
        WHERE i.created_at <= c.created_at
    )
    BEGIN
        RAISERROR (N'Chapter phải được tạo sau Course', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER trg_created_at_chapter_lesson
ON LESSONS
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN CHAPTERS c ON i.chapter_id = c.chapter_id
        WHERE i.created_at <= c.created_at
    )
    BEGIN
        RAISERROR(N'Lesson phải được tạo sau Chapter', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER trg_created_at_chapter_exam
ON EXAMS
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN CHAPTERS c ON i.chapter_id = c.chapter_id
        WHERE i.created_at <= c.created_at
    )
    BEGIN
        RAISERROR(N'Exam phải được tạo sau Chapter', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER trg_created_at_lesson_document
ON DOCUMENTS
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN LESSONS l ON i.lesson_id = l.lesson_id
        WHERE i.created_at <= l.created_at
    )
    BEGIN
        RAISERROR(N'Document phải được tạo sau Lesson', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER trg_created_at_lesson_assignment
ON ASSIGNMENTS
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN LESSONS l ON i.lesson_id = l.lesson_id
        WHERE i.created_at <= l.created_at
    )
    BEGIN
        RAISERROR(N'Assignment phải được tạo sau Lesson', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER trg_created_at_course_feedback
ON FEEDBACK
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN COURSES c ON i.course_id = c.course_id
        WHERE i.created_at <= c.created_at
    )
    BEGIN
        RAISERROR(N'Feedback phải được tạo sau Course', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER trg_is_complete_user_progress
ON USER_PROGRESS
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE (i.is_complete = 1 AND i.completed_at IS NULL)
           OR (i.is_complete = 0 AND i.completed_at IS NOT NULL)
    )
    BEGIN
        RAISERROR(N'Kết hợp không hợp lệ giữa is_complete và completed_at', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER trg_payment_amount_validation
ON PAYMENTS
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Inserted i
        JOIN Deleted d ON i.payment_id = d.payment_id AND i.user_id = d.user_id AND i.course_id = d.course_id
        WHERE i.payment_amount > d.payment_amount
    )
    BEGIN
        RAISERROR(N'Giá trị tiền được chỉnh sửa không thể lớn hơn giá trị ban đầu', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Tạo các stored procedure
CREATE PROCEDURE update_create_user
    @user_id INT = NULL,
    @user_name NVARCHAR(100),
    @user_email NVARCHAR(100),
    @user_password NVARCHAR(100),
    @phone_number NVARCHAR(20),
    @user_address NVARCHAR(200),
    @role_id INT
AS
BEGIN
    IF @user_id IS NOT NULL AND EXISTS (SELECT 1 FROM USERS WHERE user_id = @user_id)
    BEGIN
        UPDATE USERS
        SET
            user_email = @user_email,
            user_password_hash = @user_password,
            phone_number = @phone_number,
            user_address = @user_address,
            role_id = @role_id
        WHERE user_id = @user_id;
    END
    ELSE
    BEGIN
        DECLARE @new_user_id INT;
        SELECT @new_user_id = NEXT VALUE FOR user_id_seq;
        INSERT INTO USERS (user_id, user_name, user_email, user_password_hash, phone_number, user_address, role_id)
        VALUES (@new_user_id, @user_name, @user_email, @user_password, @phone_number, @user_address, @role_id);
        SELECT @new_user_id AS new_user_id;
    END
END;
GO

CREATE PROCEDURE update_create_course
    @course_id INT = NULL,
    @course_title NVARCHAR(100),
    @course_description NVARCHAR(MAX),
    @course_price DECIMAL(10,2)
AS
BEGIN
    IF @course_id IS NOT NULL AND EXISTS (SELECT 1 FROM COURSES WHERE course_id = @course_id)
    BEGIN
        UPDATE COURSES
        SET
            course_title = @course_title,
            course_description = @course_description,
            course_price = @course_price
        WHERE course_id = @course_id;
    END
    ELSE
    BEGIN
        DECLARE @new_course_id INT;
        SELECT @new_course_id = NEXT VALUE FOR course_id_seq;
        INSERT INTO COURSES (course_id, course_title, course_description, course_price, created_at)
        VALUES (@new_course_id, @course_title, @course_description, @course_price, GETDATE());
        SELECT @new_course_id AS new_course_id;
    END
END;
GO

CREATE PROCEDURE update_create_chapter
    @chapter_id INT = NULL,
    @course_id INT,
    @chapter_title NVARCHAR(100),
    @chapter_description NVARCHAR(MAX),
    @chapter_position INT
AS
BEGIN
    IF @chapter_id IS NOT NULL AND EXISTS (SELECT 1 FROM CHAPTERS WHERE chapter_id = @chapter_id)
    BEGIN
        UPDATE CHAPTERS
        SET
            course_id = @course_id,
            chapter_title = @chapter_title,
            chapter_description = @chapter_description,
            chapter_position = @chapter_position
        WHERE chapter_id = @chapter_id;
    END
    ELSE
    BEGIN
        DECLARE @new_chapter_id INT;
        SELECT @new_chapter_id = NEXT VALUE FOR chapter_id_seq;
        INSERT INTO CHAPTERS (chapter_id, course_id, chapter_title, chapter_description, chapter_position, created_at)
        VALUES (@new_chapter_id, @course_id, @chapter_title, @chapter_description, @chapter_position, GETDATE());
        SELECT @new_chapter_id AS new_chapter_id;
    END
END;
GO

CREATE PROCEDURE update_create_video
    @video_id INT = NULL,
    @video_url NVARCHAR(255),
    @video_description NVARCHAR(MAX),
    @video_duration INT
AS
BEGIN
    IF @video_id IS NOT NULL AND EXISTS (SELECT 1 FROM VIDEOS WHERE video_id = @video_id)
    BEGIN
        UPDATE VIDEOS
        SET
            video_url = @video_url,
            video_description = @video_description,
            video_duration = @video_duration
        WHERE video_id = @video_id;
    END
    ELSE
    BEGIN
        DECLARE @new_video_id INT;
        SELECT @new_video_id = NEXT VALUE FOR video_id_seq;
        INSERT INTO VIDEOS (video_id, video_url, video_description, video_duration, created_at)
        VALUES (@new_video_id, @video_url, @video_description, @video_duration, GETDATE());
        SELECT @new_video_id AS new_video_id;
    END
END;
GO

CREATE PROCEDURE update_create_lesson
    @lesson_id INT = NULL,
    @chapter_id INT,
    @video_id INT,
    @lesson_title NVARCHAR(100),
    @lesson_description NVARCHAR(MAX)
AS
BEGIN
    IF @lesson_id IS NOT NULL AND EXISTS (SELECT 1 FROM LESSONS WHERE lesson_id = @lesson_id)
    BEGIN
        UPDATE LESSONS
        SET
            chapter_id = @chapter_id,
            video_id = @video_id,
            lesson_title = @lesson_title,
            lesson_description = @lesson_description
        WHERE lesson_id = @lesson_id;
    END
    ELSE
    BEGIN
        DECLARE @new_lesson_id INT;
        SELECT @new_lesson_id = NEXT VALUE FOR lesson_id_seq;
        INSERT INTO LESSONS (lesson_id, chapter_id, video_id, lesson_title, lesson_description, created_at)
        VALUES (@new_lesson_id, @chapter_id, @video_id, @lesson_title, @lesson_description, GETDATE());
        SELECT @new_lesson_id AS new_lesson_id;
    END
END;
GO

CREATE PROCEDURE update_create_document
    @document_id INT = NULL,
    @lesson_id INT,
    @document_url NVARCHAR(255),
    @document_description NVARCHAR(MAX)
AS
BEGIN
    IF @document_id IS NOT NULL AND EXISTS (SELECT 1 FROM DOCUMENTS WHERE document_id = @document_id)
    BEGIN
        UPDATE DOCUMENTS
        SET
            lesson_id = @lesson_id,
            document_url = @document_url,
            document_description = @document_description
        WHERE document_id = @document_id;
    END
    ELSE
    BEGIN
        DECLARE @new_document_id INT;
        SELECT @new_document_id = NEXT VALUE FOR document_id_seq;
        INSERT INTO DOCUMENTS (document_id, lesson_id, document_url, document_description, created_at)
        VALUES (@new_document_id, @lesson_id, @document_url, @document_description, GETDATE());
        SELECT @new_document_id AS new_document_id;
    END
END;
GO

CREATE PROCEDURE update_create_exam
    @exam_id INT = NULL,
    @course_id INT,
    @chapter_id INT,
    @exam_name NVARCHAR(100),
    @exam_duration INT,
    @exam_description NVARCHAR(MAX)
AS
BEGIN
    IF @exam_id IS NOT NULL AND EXISTS (SELECT 1 FROM EXAMS WHERE exam_id = @exam_id)
    BEGIN
        UPDATE EXAMS
        SET
            course_id = @course_id,
            chapter_id = @chapter_id,
            exam_name = @exam_name,
            exam_duration = @exam_duration,
            exam_description = @exam_description
        WHERE exam_id = @exam_id;
    END
    ELSE
    BEGIN
        DECLARE @new_exam_id INT;
        SELECT @new_exam_id = NEXT VALUE FOR exam_id_seq;
        INSERT INTO EXAMS (exam_id, course_id, chapter_id, exam_name, exam_duration, exam_description, created_at)
        VALUES (@new_exam_id, @course_id, @chapter_id, @exam_name, @exam_duration, @exam_description, GETDATE());
        SELECT @new_exam_id AS new_exam_id;
    END
END;
GO

CREATE PROCEDURE update_create_assignment
    @assignment_id INT = NULL,
    @lesson_id INT,
    @assignment_duration INT,
    @assignment_description NVARCHAR(MAX)
AS
BEGIN
    IF @assignment_id IS NOT NULL AND EXISTS (SELECT 1 FROM ASSIGNMENTS WHERE assignment_id = @assignment_id)
    BEGIN
        UPDATE ASSIGNMENTS
        SET
            lesson_id = @lesson_id,
            assignment_duration = @assignment_duration,
            assignment_description = @assignment_description
        WHERE assignment_id = @assignment_id;
    END
    ELSE
    BEGIN
        DECLARE @new_assignment_id INT;
        SELECT @new_assignment_id = NEXT VALUE FOR assignment_id_seq;
        INSERT INTO ASSIGNMENTS (assignment_id, lesson_id, assignment_duration, assignment_description, created_at)
        VALUES (@new_assignment_id, @lesson_id, @assignment_duration, @assignment_description, GETDATE());
        SELECT @new_assignment_id AS new_assignment_id;
    END
END;
GO

CREATE PROCEDURE update_insert_question
    @question_id INT = NULL,
    @question_text NVARCHAR(MAX),
    @question_type NVARCHAR(50),
    @question_score DECIMAL(5,2),
    @answer_id INT,
    @exam_id INT,
    @assignment_id INT
AS
BEGIN
    IF @question_id IS NOT NULL AND EXISTS (SELECT 1 FROM QUESTIONS WHERE question_id = @question_id)
    BEGIN
        UPDATE QUESTIONS
        SET
            question_text = @question_text,
            question_type = @question_type,
            question_score = @question_score,
            answer_id = @answer_id,
            exam_id = @exam_id,
            assignment_id = @assignment_id
        WHERE question_id = @question_id;
    END
    ELSE
    BEGIN
        DECLARE @new_question_id INT;
        SELECT @new_question_id = NEXT VALUE FOR question_id_seq;
        INSERT INTO QUESTIONS (
            question_id, question_text, question_type, question_score,
            answer_id, exam_id, assignment_id
        )
        VALUES (
            @new_question_id, @question_text, @question_type, @question_score,
            @answer_id, @exam_id, @assignment_id
        );
        SELECT @new_question_id AS new_question_id;
    END
END;
GO

CREATE PROCEDURE update_create_payment_course_status
    @payment_id INT = NULL,
    @user_id INT,
    @course_id INT,
    @user_course_status_id INT = NULL,
    @payment_description NVARCHAR(MAX),
    @payment_amount DECIMAL(10,2),
    @payment_method NVARCHAR(50)
AS
BEGIN
    IF @payment_id IS NOT NULL AND EXISTS (SELECT 1 FROM PAYMENTS WHERE payment_id = @payment_id)
    BEGIN
        UPDATE PAYMENTS
        SET
            payment_description = @payment_description,
            payment_amount = @payment_amount,
            payment_method = @payment_method
        WHERE payment_id = @payment_id;
    END
    ELSE
    BEGIN
        BEGIN TRANSACTION;
        BEGIN TRY
            DECLARE @new_payment_id INT;
            SELECT @new_payment_id = NEXT VALUE FOR payment_id_seq;
            DECLARE @new_user_course_status_id INT;
            SELECT @new_user_course_status_id = NEXT VALUE FOR user_course_status_id_seq;
            INSERT INTO PAYMENTS (
                payment_id, user_id, course_id, payment_description,
                payment_amount, payment_method, created_at
            )
            VALUES (
                @new_payment_id, @user_id, @course_id, @payment_description,
                @payment_amount, @payment_method, GETDATE()
            );
            INSERT INTO USER_COURSE_STATUS (
                user_course_status_id, user_id, course_id,
                course_status, graduated_at
            )
            VALUES (
                @new_user_course_status_id, @user_id, @course_id,
                N'0', NULL
            );
            COMMIT TRANSACTION;
            SELECT @new_payment_id AS new_payment_id, @new_user_course_status_id AS new_user_course_status_id;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            THROW;
        END CATCH
    END
END;
GO

CREATE PROCEDURE update_create_feedback
    @feedback_id INT = NULL,
    @user_id INT,
    @course_id INT,
    @chapter_id INT,
    @lesson_id INT,
    @rating INT,
    @feedback_comment NVARCHAR(MAX)
AS
BEGIN
    IF @feedback_id IS NOT NULL AND EXISTS (SELECT 1 FROM FEEDBACK WHERE feedback_id = @feedback_id)
    BEGIN
        UPDATE FEEDBACK
        SET
            rating = @rating,
            feedback_comment = @feedback_comment
        WHERE feedback_id = @feedback_id;
    END
    ELSE
    BEGIN
        DECLARE @new_feedback_id INT;
        SELECT @new_feedback_id = NEXT VALUE FOR feedback_id_seq;
        INSERT INTO FEEDBACK (
            feedback_id, user_id, course_id, chapter_id, lesson_id,
            rating, feedback_comment, created_at
        )
        VALUES (
            @new_feedback_id, @user_id, @course_id, @chapter_id, @lesson_id,
            @rating, @feedback_comment, GETDATE()
        );
        SELECT @new_feedback_id AS new_feedback_id;
    END
END;
GO

-- Tạo các chỉ mục
CREATE INDEX idx_chapters_course_id ON CHAPTERS(course_id);
CREATE INDEX idx_lessons_chapter_id ON LESSONS(chapter_id);
CREATE INDEX idx_lessons_video_id ON LESSONS(video_id);
CREATE INDEX idx_documents_lesson_id ON DOCUMENTS(lesson_id);
CREATE INDEX idx_exams_course_id ON EXAMS(course_id);
CREATE INDEX idx_exams_chapter_id ON EXAMS(chapter_id);
CREATE INDEX idx_assignments_lesson_id ON ASSIGNMENTS(lesson_id);
CREATE INDEX idx_questions_answer_id ON QUESTIONS(answer_id);
CREATE INDEX idx_questions_exam_id ON QUESTIONS(exam_id);
CREATE INDEX idx_questions_assignment_id ON QUESTIONS(assignment_id);
CREATE INDEX idx_payments_user_id ON PAYMENTS(user_id);
CREATE INDEX idx_payments_course_id ON PAYMENTS(course_id);
CREATE INDEX idx_user_progress_user_id ON USER_PROGRESS(user_id);
CREATE INDEX idx_user_progress_video_id ON USER_PROGRESS(video_id);
CREATE INDEX idx_user_course_status_user_id ON USER_COURSE_STATUS(user_id);
CREATE INDEX idx_user_course_status_course_id ON USER_COURSE_STATUS(course_id);
CREATE INDEX idx_feedback_user_id ON FEEDBACK(user_id);
CREATE INDEX idx_feedback_course_id ON FEEDBACK(course_id);
CREATE INDEX idx_feedback_chapter_id ON FEEDBACK(chapter_id);
CREATE INDEX idx_feedback_lesson_id ON FEEDBACK(lesson_id);
GO

-- Tạo các sequence
CREATE SEQUENCE user_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE course_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE chapter_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE video_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE lesson_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE document_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE exam_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE assignment_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE answer_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE question_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE payment_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE user_progress_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE user_course_status_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE feedback_id_seq START WITH 1 INCREMENT BY 1;
GO