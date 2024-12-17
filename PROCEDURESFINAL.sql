USE DBProject

GO
-- PROCEDURE 1
CREATE PROCEDURE ViewInfo
    @LearnerID INT
AS
BEGIN
    SELECT * 
    FROM Learner 
    WHERE LearnerID = @LearnerID;
END;

GO
-- PROCEDURE 2
CREATE PROCEDURE LearnerInfo
    @LearnerID INT
AS
BEGIN
    SELECT * 
    FROM Learner 
    WHERE LearnerID = @LearnerID;
END;

GO
-- PROCEDURE 3: EmotionalState
CREATE PROCEDURE EmotionalState
    @LearnerID INT
AS
BEGIN
-- Declare the output variable
DECLARE @emotional_state VARCHAR(50);
-- Retrieve the most recent emotional state
SELECT TOP 1
    @emotional_state = emotional_state
FROM 
    Emotional_feedback
WHERE 
    LearnerID = @LearnerID
ORDER BY timestamp DESC;

    -- Output the emotional state
    SELECT @emotional_state AS EmotionalState;
END;

GO
-- PROCEDURE 4
CREATE PROCEDURE LogDetails
    @LearnerID INT
AS
BEGIN
    SELECT *
    FROM Interaction_log
    WHERE LearnerID = @LearnerID;
END;

GO
-- PROCEDURE 5
CREATE PROCEDURE InstructorReview
    @InstructorID INT
AS
BEGIN
    SELECT *
    FROM Emotional_feedback EF INNER JOIN Emotionalfeedback_review EFR ON EF.FeedbackID = EFR.FeedbackID
    WHERE EFR.InstructorID = @InstructorID;
END;

GO
-- PROCEDURE 6
CREATE PROCEDURE CourseRemove
    @courseID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Course_enrollment WHERE CourseID = @courseID)
    BEGIN
        RETURN 0;
    END
    DELETE FROM Course WHERE CourseID = @courseID;
    PRINT 'Course removed successfully';
END;

GO
-- PROCEDURE 7
CREATE PROCEDURE Highestgrade
AS
BEGIN
    SELECT 
        A.CourseID,
        A.ID AS AssessmentID,
        A.title,
        A.total_marks
    FROM Assessments A
    INNER JOIN (SELECT CourseID, MAX(total_marks) AS MaxMarks
        FROM Assessments
        GROUP BY CourseID) AS MaxAssessments ON A.CourseID = MaxAssessments.CourseID AND A.total_marks = MaxAssessments.MaxMarks;
END;

GO
-- PROCEDURE 8
CREATE PROCEDURE InstructorCount
AS 
BEGIN
    SELECT c.Title
    FROM Course c
    INNER JOIN Teaches t ON c.CourseID = t.CourseID
    GROUP BY c.Title
    HAVING COUNT(t.InstructorID) > 1;
END;


GO
-- PROCEDURE 9
CREATE PROCEDURE ViewNot
    @LearnerID INT
AS
BEGIN
    SELECT *
    FROM Notification
    WHERE ID IN (SELECT NotificationID FROM ReceivedNotification WHERE LearnerID = @LearnerID);
END;

GO
-- PROCEDURE 10
CREATE PROCEDURE CreateDiscussion
    @ModuleID INT,
    @CourseID INT,
    @Title VARCHAR(100),
    @Description VARCHAR(100)
AS
BEGIN
DECLARE @ForumID INT;
-- Retrieve the next ForumID (assuming ForumID increments sequentially)
SELECT @ForumID = ISNULL(MAX(forumID), 0) + 1 FROM Discussion_forum;
-- Insert a new discussion forum
INSERT INTO Discussion_forum (forumID, ModuleID, CourseID, title, last_active, timestamp, description)
VALUES(
    @ForumID,  -- Using the generated ForumID
    @ModuleID,
    @CourseID,
    @Title,
    GETDATE(), -- Set last_active to the current date and time
    GETDATE(), -- Set timestamp to the current date and time
    @Description
    );
-- Print confirmation message with the new ForumID
PRINT 
    'Discussion forum successfully created.' ;
END;

GO
-- PROCEDURE 11
CREATE PROCEDURE RemoveBadge
    @BadgeID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Achievement WHERE BadgeID = @BadgeID)
    BEGIN
        RETURN 0;
    END
    DELETE FROM Badge WHERE BadgeID = @BadgeID;
    PRINT 'Badge removed successfully';
END;

GO
-- PROCEDURE 12
CREATE PROCEDURE CriteriaDelete
    @criteria VARCHAR(50)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM Skill_Mastery SM
        INNER JOIN Quest Q ON SM.QuestID = Q.QuestID
        WHERE Q.criteria = @criteria
    )
    BEGIN
        RETURN 0;
    END
    DELETE FROM Quest WHERE criteria = @criteria;
    PRINT 'Quests with criteria removed successfully';
END;


GO
-- PROCEDURE 13
CREATE PROCEDURE NotificationUpdate
    @LearnerID int,
    @NotificationID int,
    @ReadStatus bit
AS
BEGIN
    IF @ReadStatus = 1
    BEGIN
        UPDATE Notification
        SET ReadStatus = 1
        WHERE ID = @NotificationID;
    END
    ELSE
    BEGIN
        DELETE FROM ReceivedNotification
        WHERE NotificationID = @NotificationID AND LearnerID = @LearnerID;

        DELETE FROM Notification
        WHERE ID = @NotificationID;
    END
END;

GO
-- PROCEDURE 14
CREATE PROCEDURE EmotionalTrendAnalysis
    @CourseID int,
    @ModuleID int,
    @TimePeriod datetime
AS
BEGIN
    SELECT ef.emotional_state
    FROM Emotional_feedback ef
    INNER JOIN Learning_activities la ON ef.activityID = la.ActivityID
    WHERE la.CourseID = @CourseID AND la.ModuleID = @ModuleID AND ef.timestamp >= @TimePeriod
    ORDER BY ef.LearnerID, ef.timestamp;
END;

-- Section 2: 1
GO
CREATE PROCEDURE ProfileUpdate
    @LearnerID INT,
    @ProfileID INT,
    @PreferedContentType varchar(50),
    @Emotional_state varchar(50), 
    @PersonalityType varchar(50)
AS
BEGIN
UPDATE PersonalizationProfiles
SET 
    LearnerID = @LearnerID, 
    Prefered_content_type = @PreferedContentType,
    Emotional_state = @emotional_state,
    personality_type = @PersonalityType
WHERE 
    ProfileID = @ProfileID
END

-- Section 2: 2
GO
CREATE PROCEDURE TotalPoints
    @LearnerID INT, 
    @RewardType varchar(50)
AS
BEGIN
SELECT SUM(R.value) AS TotalPoints
FROM 
    QuestReward QR INNER JOIN Reward R ON QR.RewardID = R.RewardID
WHERE 
    QR.LearnerID = @LearnerID AND R.type = @RewardType
END

-- Section 2: 3
GO
CREATE PROCEDURE EnrolledCourses
    @LearnerID INT
AS
BEGIN
    -- Debugging: Check if any courses exist for the LearnerID
IF NOT EXISTS (SELECT 1 FROM Course_Enrollment WHERE LearnerID = @LearnerID)
BEGIN
    RETURN 0;
END
IF NOT EXISTS (SELECT 1 FROM Course_Enrollment WHERE LearnerID = @LearnerID AND Status = 'Enrolled')
BEGIN
    RETURN 0;
END
       -- Main Query: Fetch the enrolled courses
SELECT CE.CourseID, C.Title, C.Description, C.Difficulty_level, CE.Enrollment_Date, CE.Status
FROM 
    Course_Enrollment CE INNER JOIN Course C ON CE.CourseID = C.CourseID
WHERE 
    CE.LearnerID = @LearnerID AND CE.Status = 'Enrolled';
END;

-- Section 2: 4
GO
CREATE PROCEDURE Prerequisites
    @LearnerID INT,
    @CourseID INT
AS
BEGIN
If EXISTS(
SELECT CP.Prereq
FROM
    CoursePrerequisite CP INNER JOIN Course_Enrollment CE ON CP.Prereq = CE.CourseID AND CE.LearnerID = @LearnerID AND CE.status = 'Completed'
WHERE 
    CP.CourseID = @CourseID AND CE.CourseID IS NULL
    )
BEGIN
    print('All are completed ^^')
END
ELSE
BEGIN
    print('Nu uh, not completed :(')
END
END

-- Section 2: 5
GO
CREATE PROCEDURE ModuleTraits
    @TargetTrait VARCHAR(50),
    @CourseID INT
AS
BEGIN
SELECT M.ModuleID, M.title, M.difficulty, M.contentURL
FROM
    Modules M INNER JOIN Target_traits T ON M.ModuleID = T.ModuleID AND M.CourseID = T.CourseID
WHERE
    T.Trait = @TargetTrait AND M.CourseID = @CourseID
END

-- Section 2: 6
GO
CREATE PROCEDURE LeaderboardRank
    @LeaderboardID INT
AS
BEGIN
SELECT R.LearnerID, L.first_name + ' ' + L.last_name, R.CourseID, C.Title, R.Rank, R.Total_Points
FROM 
    Ranking R INNER JOIN Learner L ON R.LearnerID = L.LearnerID INNER JOIN Course C ON R.CourseID = C.CourseID
WHERE 
    R.BoardID = @LeaderboardID
ORDER BY 
    R.Rank ASC;
END

-- Section 2: 7
GO
CREATE PROCEDURE ActivityEmotionalFeedback
    @ActivityID INT,
    @LearnerID INT,
    @Timestamp TIME,
    @EmotionalState VARCHAR(50)
AS
BEGIN
DECLARE @FeedbackID INT;
INSERT INTO Emotional_feedback (LearnerID, ActivityID, Timestamp, Emotional_State) 
    VALUES ( 
        @LearnerID,
        @ActivityID,
        @Timestamp,
        @EmotionalState
    )
SET @FeedbackID = SCOPE_IDENTITY();
END


-- Section 2: 8
GO
CREATE PROCEDURE JoinQuest
   @LearnerID INT,
   @QuestID INT
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM LearnersCollaboration 
        WHERE LearnerID = @LearnerID AND QuestID = @QuestID
    )
    BEGIN
        PRINT 'You are already participating in this quest.';
        RETURN;
    END

    IF (
        SELECT COUNT(*) 
        FROM LearnersCollaboration 
        WHERE QuestID = @QuestID
    ) < (
        SELECT max_num_participants 
        FROM Collaborative 
        WHERE QuestID = @QuestID
    )
    BEGIN
        INSERT INTO LearnersCollaboration (LearnerID, QuestID, completion_status)
        VALUES (@LearnerID, @QuestID, 'In Progress');
        
        PRINT 'You have been added to the quest!';
    END
    ELSE
    BEGIN
        PRINT 'HAHAHA No space, loser :)';
    END
END;

--EXISTENTIAL CRISIS FOR REAL
-- Section 2: 9
GO
CREATE PROCEDURE SkillsProficiency
    @LearnerID INT
AS
BEGIN
SELECT S.skill, SP.proficiency_level, SP.timestamp
FROM 
    Skills S LEFT JOIN SkillProgression SP ON S.LearnerID = SP.LearnerID AND S.skill = SP.skill_name
WHERE 
    S.LearnerID = @LearnerID
END 

-- Section 2: 10
GO
CREATE PROCEDURE ViewScore
    @LearnerID INT,
    @AssessmentID INT,
    @OutputScore INT OUTPUT
AS
BEGIN
    SELECT @OutputScore = ISNULL(ScoredPoint, 0)
    FROM TakenAssessment
    WHERE LearnerID = @LearnerID AND AssessmentID = @AssessmentID;
END;
 

-- Section 2: 11
GO
CREATE PROCEDURE AssessmentsList
    @CourseID INT,
    @ModuleID INT,
    @LearnerID INT
AS
BEGIN
SELECT A.title, A.type, A.passing_marks, TA.scoredPoint
FROM 
    Assessments A INNER JOIN TakenAssessment TA ON A.ID = TA.AssessmentID
WHERE 
    A.CourseID = @CourseID AND A.ModuleID = @ModuleID AND TA.LearnerID = @LearnerID
IF EXISTS (
SELECT 1
FROM 
    Assessments A INNER JOIN TakenAssessment TA ON A.ID = TA.AssessmentID
WHERE 
    A.CourseID = @CourseID AND 
    A.ModuleID = @ModuleID AND 
    TA.LearnerID = @LearnerID AND 
    TA.scoredPoint >= A.passing_marks
    )
BEGIN
PRINT 
    'Yippee a pass';
END
ELSE
BEGIN
PRINT 
    'Hehe better luck ^^';
END
END

--12
go
CREATE PROCEDURE CourseRegister
    @LearnerID INT,
    @CourseID INT
AS
BEGIN
    DECLARE @NewEnrollmentID INT;
    SELECT @NewEnrollmentID = ISNULL(MAX(EnrollmentID), 0) + 1 FROM Course_Enrollment;
    IF NOT EXISTS (
        SELECT 1
        FROM CoursePrerequisite C
        LEFT JOIN Course_Enrollment CE ON C.Prereq = CE.CourseID
        WHERE C.CourseID = @CourseID AND (CE.LearnerID IS NULL OR CE.Status != 'Completed')
    )
    BEGIN
        INSERT INTO Course_Enrollment (LearnerID, CourseID, Enrollment_Date, Status, EnrollmentID)
        VALUES (@LearnerID, @CourseID, GETDATE(), 'Pending', @NewEnrollmentID);
        PRINT 'Registration successful.';
    END
    ELSE
    BEGIN
        PRINT 'Registration failed. Prerequisites not completed.';
    END
END;
go

--13
go
CREATE PROCEDURE Post
    @LearnerID INT,
    @DiscussionID INT,
    @Post VARCHAR(MAX)
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM LearnerDiscussion
        WHERE LearnerID = @LearnerID AND ForumID = @DiscussionID
    )
    BEGIN
        RETURN 0;
    END
    INSERT INTO LearnerDiscussion (ForumID, LearnerID, Post)
    VALUES (@DiscussionID, @LearnerID, @Post);
END;
go

--14
go
CREATE PROCEDURE AddGoal
    @LearnerID INT,
    @GoalID INT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM LearnersGoals WHERE GoalID = @GoalID AND LearnerID = @LearnerID
    )
    BEGIN
        RETURN 0;
    END
    INSERT INTO LearnersGoals (GoalID, LearnerID)
    VALUES (@GoalID, @LearnerID);
END;
go

--15
go
create procedure CurrentPath
    @LearnerID int
as
begin
select lp.pathID as PathID, lp.completion_status as CompletionStatus, lp.custom_content as CustomContent, lp.adaptive_rules as AdaptiveRules
from Learning_path lp
where lp.LearnerID = @LearnerID
end;
go

--16
go
CREATE PROCEDURE QuestMembers
    @LearnerID INT
AS
BEGIN
    SELECT lc.QuestID, l.LearnerID
    FROM LearnersCollaboration lc
    INNER JOIN Collaborative c ON lc.QuestID = c.QuestID
    INNER JOIN LearnersCollaboration lc2 ON lc.QuestID = lc2.QuestID
    INNER JOIN Learner l ON lc2.LearnerID = l.LearnerID
    WHERE c.deadline >= CAST(GETDATE() AS DATE) -- Compare deadline with current date
      AND lc.LearnerID = @LearnerID;
END;
go

--17
go
create procedure QuestProgress
    @LearnerID int
as 
begin
select q.title, lc.completion_status, lm.completion_status, b.title, a.date_earned
from LearnersCollaboration lc inner join Quest q on lc.QuestID = q.QuestID inner join LearnersMastery lm on lm.QuestID = q.QuestID,
    Badge b inner join Achievement a on b.badgeID = a.badgeID
where lc.LearnerID = @LearnerID
--missing badge
end;
go


--18
go
create procedure GoalReminder
    @LearnerID int
as
begin
select g.ID as GoalID, g.status as CurrentStatus
from LearnersGoals lg inner join Learning_goal g on lg.GoalID = g.ID
where lg.LearnerID = @LearnerID and g.status != 'completed'
PRINT 'Reminder: You have overdue learning goals. Please review and complete them.';
end;
go

--19
go
create procedure SkillProgressHistory
    @LearnerID int, 
    @Skill varchar(50)
as
begin
select SP.timestamp as ProgressDate, SP.proficiency_level as ProficiencyLevel
from SkillProgression SP inner join Skills S ON SP.LearnerID = S.LearnerID AND SP.skill_name = S.skill
where SP.LearnerID = @LearnerID and SP.skill_name = @Skill
order by SP.timestamp;
end;
go

--20
go
CREATE PROCEDURE AssessmentAnalytics
    @CourseID INT = NULL,
    @ModuleID INT = NULL
AS
BEGIN
    SELECT 
        ta.LearnerID,
        CONCAT(l.first_name, ' ', l.last_name) AS LearnerName,
        a.ModuleID,
        m.Title AS ModuleTitle,
        a.ID AS AssessmentID,
        a.title AS AssessmentTitle,
        ta.scoredPoint AS LearnerScore,
        a.total_marks AS TotalMarks,
        ROUND((ta.scoredPoint * 100.0) / a.total_marks, 2) AS PercentageScore
    FROM 
        Takenassessment ta
    JOIN 
        Learner l ON ta.LearnerID = l.LearnerID
    JOIN 
        Assessments a ON ta.AssessmentID = a.ID
    JOIN 
        Modules m ON a.ModuleID = m.ModuleID AND a.CourseID = m.CourseID
    WHERE 
        (@CourseID IS NULL OR a.CourseID = @CourseID) AND
        (@ModuleID IS NULL OR a.ModuleID = @ModuleID)
    ORDER BY 
        ta.LearnerID, a.ModuleID, a.ID;
END;
go


--21
go
CREATE PROCEDURE LeaderboardFilter
    @LearnerID INT
AS
BEGIN
    SELECT R.Rank AS Rank, C.Title AS CourseTitle
    FROM Leaderboard L
    INNER JOIN Ranking R ON L.BoardID = R.BoardID
    INNER JOIN Course C ON R.CourseID = C.CourseID
    WHERE R.LearnerID = @LearnerID
    ORDER BY R.Rank DESC;
END;
go


-- 3-1 List all the learners that have a certain skill.
go
create procedure SkillLearners
    @Skillname VARCHAR(50)
as
begin
    select 
        s.skill as SkillName, l.LearnerID, l.first_name, l.last_name from Skills s join Learner l on s.LearnerID = l.LearnerID where s.skill = @Skillname;
end
go


-- 3-2 Add new Learning activities for a course module.
GO
CREATE PROCEDURE NewActivity 
    @CourseID INT, 
    @ModuleID INT, 
    @Activity_Type VARCHAR(50), 
    @Instruction_Details VARCHAR(MAX), 
    @Max_Points INT
AS
BEGIN
    
    DECLARE @ActivityID INT;

    BEGIN TRANSACTION;

    SELECT @ActivityID = ISNULL(MAX(ActivityID), 0) + 1 FROM Learning_activities;

    INSERT INTO Learning_activities (ActivityID, CourseID, ModuleID, activity_type, instruction_details, Max_points)
    VALUES (@ActivityID, @CourseID, @ModuleID, @Activity_Type, @Instruction_Details, @Max_Points);

    COMMIT TRANSACTION;

END
GO

-- 3-3 Award a new achievement to a learner
go
CREATE PROCEDURE NewAchievement
    @LearnerID INT,
    @BadgeID INT,
    @Description VARCHAR(MAX),
    @DateEarned DATE,
    @Type VARCHAR(50)
AS
BEGIN
    DECLARE @AchievementID INT;

    -- Get the next available AchievementID (max value + 1)
    SELECT @AchievementID = ISNULL(MAX(AchievementID), 0) + 1 FROM Achievement;

    -- Insert the new achievement into the Achievements table
    INSERT INTO Achievement (AchievementID, LearnerID, BadgeID, Description, date_earned, Type)
    VALUES (@AchievementID, @LearnerID, @BadgeID, @Description, @DateEarned, @Type);
END;
GO

-- 3-4 view all the learners who earned a certain badge

go
CREATE PROCEDURE LearnerBadge
    @BadgeID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        l.LearnerID,
        CONCAT(l.first_name, ' ', l.last_name) AS LearnerName,
        a.date_earned,
        b.title AS BadgeTitle
    FROM 
        Achievement a
    INNER JOIN 
        Learner l ON a.LearnerID = l.LearnerID
    INNER JOIN 
        Badge b ON a.BadgeID = b.BadgeID
    WHERE 
        a.BadgeID = @BadgeID
    ORDER BY 
        a.date_earned DESC;
END;
go


-- 3-5 Add a new learning path
go
create procedure NewPath
    @LearnerID int,
    @ProfileID int,
    @Completion_Status varchar(50),
    @Custom_Content varchar(max),
    @AdaptiveRules varchar(max)
as
begin
    -- declare a variable to hold the new LearningPathID
    declare @PathID int;

    -- get the next available LearningPathID (max value + 1)
    select @PathID = isnull(max(pathID), 0) + 1 from Learning_path;

    -- insert the new learning path into the Learning_path table
    insert into Learning_path (pathID, LearnerID, ProfileID, Completion_Status, Custom_Content, adaptive_rules)
    values (@PathID, @LearnerID, @ProfileID, @Completion_Status, @Custom_Content, @AdaptiveRules);
end;
go


--3-6 View all courses a learner has taken
go
create procedure TakenCourses
    @LearnerID int
as 
begin
select c.Title from Course_enrollment ce inner join Course c on ce.CourseID = c.CourseID
where ce.LearnerID = @LearnerID;
end
go

-- 3-7  Add a new collaborative Quest
go 
create procedure CollaborativeQuest
    @difficulty_level varchar(50), 
    @criteria varchar(50), 
    @description varchar(50), 
    @title varchar(50), 
    @Maxnumparticipants int, 
    @deadline datetime
as 
begin
    declare @QuestID int;
    select @QuestID = isnull(max(QuestID), 0) + 1 from Quest;

        if exists (select 1 from Quest where QuestID = @QuestID)
    begin
        -- If the QuestID exists, handle the error or choose a different approach (like looping or retrying)
        RAISERROR('QuestID already exists. Please try again.', 16, 1);
        return;
    end

    insert into Quest(QuestID, difficulty_level, criteria, description, title) values(@QuestID, @difficulty_level, @criteria, @description, @title)


    -- get the next available LearningPathID (max value + 1)

    insert into Collaborative(QuestID, max_num_participants, deadline) values(@QuestID, @Maxnumparticipants, @deadline)
end
go

-- 3-8 Update the deadline of a quest
go
create procedure DeadlineUpdate
    @QuestID int, @deadline datetime
    as
    begin
    update Collaborative
    set deadline = @deadline where QuestID = @QuestID
end
go

-- 3-9 Update an assessment grade for a learner.
create procedure GradeUpdate
    @LearnerID int, @AssessmentID int, @points int
as
begin
    update Takenassessment
    set scoredPoint = @points
    where LearnerID = @LearnerID AND AssessmentID = @AssessmentID;
    print 'Grade updated successfully';
end;
go

-- 3-10 Send a notification to a learner about an upcoming assessment deadline.
go
create procedure AssessmentNot
    @NotificationID int, @timestamp datetime, @message varchar(max), @urgencylevel varchar(50), @LearnerID int
as
begin
    -- Check if the NotificationID already exists
    IF EXISTS (SELECT 1 FROM Notification WHERE ID = @NotificationID)
    BEGIN
        PRINT 'NotificationID already exists. Please provide a unique ID.';
        RETURN;
    END
    insert into Notification (ID, timestamp, message, urgency_level) values (@NotificationID, @timestamp, @message, @urgencylevel); 
    insert into ReceivedNotification (NotificationID, LearnerID) values (@NotificationID, @LearnerID);
    print 'Notification sent';
end;
go

-- 3-11 Define new learning goal for the learners.
GO
CREATE PROCEDURE NewGoal
    @GoalID INT,
    @status VARCHAR(MAX),
    @deadline DATETIME,
    @description VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO Learning_goal (ID, status, deadline, description) 
        VALUES (@GoalID, @status, @deadline, @description);
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 2627 -- Duplicate key error number
        BEGIN
            PRINT 'Error: Duplicate GoalID. A goal with this ID already exists.';
        END
        ELSE
        BEGIN
            PRINT 'An error occurred: ' + ERROR_MESSAGE();
        END
    END CATCH
END;
GO

-- 12. List all the learners enrolled in the courses I teach.
GO
CREATE PROCEDURE LearnersCourses
    @CourseID INT,
    @InstructorID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.CourseID,
        c.Title AS CourseTitle,
        l.LearnerID,
        CONCAT(l.first_name, ' ', l.last_name) AS LearnerName,
        ce.enrollment_date,
        ce.completion_date,
        ce.status AS EnrollmentStatus
    FROM 
        Course c
    INNER JOIN 
        Course_enrollment ce ON c.CourseID = ce.CourseID
    INNER JOIN 
        Learner l ON ce.LearnerID = l.LearnerID
    INNER JOIN 
        Teaches t ON c.CourseID = t.CourseID
    WHERE 
        t.InstructorID = @InstructorID AND
        c.CourseID = @CourseID
    ORDER BY 
        l.first_name, l.last_name;
END;

-- 13. See the last time a discussion forum was active.
GO
CREATE PROCEDURE LastActive
    @ForumID INT,
    @lastactive DATETIME OUTPUT
AS
BEGIN
    -- Check if the given ForumID exists and fetch the last active time
    SELECT @lastactive = last_active
    FROM Discussion_forum
    WHERE ForumID = @ForumID;

    -- Handle case where ForumID does not exist
    IF @lastactive IS NULL
    BEGIN
        PRINT 'No activity found for the given ForumID.';
    END
END;
GO

-- 14. Find the most common emotional state for the learners.
GO
create procedure CommonEmotionalState
    @state varchar(50) output
as
begin
    select top 1 @state = emotional_state
    from Emotional_feedback
    group by emotional_state
    order by count(*) desc;
    PRINT @state
end;

-- 15. View all modules for a certain course sorted by their difficulty.
GO
create procedure ModuleDifficulty
    @courseID int
as
begin
    select *
    from Modules
    where CourseID = @courseID
    order by difficulty;
end;

-- 16. View the skill with the highest proficiency level to a certain student.
GO
create procedure ProficiencyLevel
    @LearnerID int,
    @skill varchar(50) output
as
begin
    select top 1 @skill = skill_name
    from SkillProgression
    where LearnerID = @LearnerID
    order by proficiency_level desc;
end;

-- 17. Update a learner proficiency level for a certain skill.
GO
create procedure ProficiencyUpdate
    @Skill varchar(50),
    @LearnerID int,
    @Level varchar(50)
as
begin
    update SkillProgression
    set proficiency_level = @Level
    where LearnerID = @LearnerID and skill_name = @Skill;
end;

-- 18. Find the learner with the least number of badges earned.
GO
create procedure LeastBadge
    @LearnerID int output
as
begin
    
    select top 1 @LearnerID = LearnerID
    from Achievement
    group by LearnerID
    order by count(BadgeID) asc;

end;

-- 19. Find the most preferred learning type for the learners.
GO
create procedure PreferredType
    @type varchar(50) output
as
begin 
    select top 1 @type = Prefered_content_type
    from PersonalizationProfiles
    group by Prefered_content_type
    order by count(*) desc;
end;
go
-- 20. Generate analytics on assessment scores across various modules or courses (average of scores)
CREATE PROCEDURE AssessmentAnalysis
    @LearnerID INT
AS
BEGIN
    -- Select assessment scores for the learner, including breakdown of performance
    SELECT 
        a.ID AS AssessmentID,
        a.Title AS AssessmentTitle,
        a.Type AS AssessmentType,
        a.TotalMarks AS TotalMarks,
        ta.ScoredPoint AS ScoredPoints,
        a.PassingMarks AS PassingMarks,
        CASE
            WHEN ta.ScoredPoint >= a.PassingMarks THEN 'Passed'
            ELSE 'Failed'
        END AS Performance,
        a.Criteria AS AssessmentCriteria,
        ROUND(CAST(ta.ScoredPoint AS FLOAT) / a.TotalMarks * 100, 2) AS PercentageScore
    FROM 
        Takenassessment ta
    INNER JOIN 
        Assessment a ON ta.AssessmentID = a.ID
    WHERE 
        ta.LearnerID = @LearnerID
    ORDER BY 
        PercentageScore DESC; -- Order by performance for better analysis
END;
GO


-- 21. View trends in learners’ emotional feedback to support well-being in courses I teach.
GO
create procedure EmotionalTrendAnalysisIns
    @CourseID int,
    @ModuleID int,
    @TimePeriod datetime
as
begin
    select emotional_state, count(*) as Count
    from Emotional_feedback
    where activityID in (
        select ActivityID
        from Learning_activities
        where CourseID = @CourseID and ModuleID = @ModuleID
    )
    and timestamp >= dateadd(day, -cast(@TimePeriod as int), getdate())
    group by emotional_state;
end;


--Section 1 Executions
-- 1. ViewInfo
EXEC ViewInfo @LearnerId = 1;

-- 2. LearnerInfo
EXEC LearnerInfo @LearnerId = 2;

-- 3. EmotionalState
EXEC EmotionalState @LearnerId = 3;

-- 4. LogDetails
EXEC LogDetails @LearnerId = 1;

-- 5. InstructorReview
EXEC InstructorReview @InstructorId = 1;

-- 6. CourseRemove
EXEC CourseRemove @CourseId = 2;

-- 7. Highestgrade
EXEC Highestgrade;

-- 8. InstructorCount
EXEC InstructorCount;

-- 9. ViewNot (View Notification)
EXEC ViewNot @LearnerId = 1;

-- 10. CreateDiscussion
EXEC CreateDiscussion @ModuleID = 1, @CourseID = 1, @Title = 'Programming Basics Discussion', @Description = 'A forum to discuss programming basics and related topics.';

-- 11. RemoveBadge
EXEC RemoveBadge @BadgeId = 2;

-- 12. CriteriaDelete
EXEC CriteriaDelete @Criteria = 'Complete the programming challenges';

-- 13. NotificationUpdate
EXEC NotificationUpdate @LearnerID = 2, @NotificationId = 2, @ReadStatus = 1;

-- 14. EmotionalTrendAnalysis 
EXEC EmotionalTrendAnalysis @CourseId = 1, @ModuleID = 1, @TimePeriod = '2024-10-01 00:00:00';

--Section 2 Executions
-- 1. ProfileUpdate
EXEC ProfileUpdate @LearnerID = 1, @ProfileID = 1, @PreferedContentType = 'Video', @Emotional_State = 'Happy', @PersonalityType = 'Extrovert';

-- 2. TotalPoints
EXEC TotalPoints @LearnerId = 1, @RewardType = 'Gift';

-- 3. EnrolledCourses 
EXEC EnrolledCourses @LearnerId = 3;

-- 4. Prerequisites
EXEC Prerequisites @LearnerId = 2, @CourseId = 2;

-- 5. ModuleTraits
EXEC ModuleTraits @TargetTrait = 'Beginner', @CourseId = 1;

-- 6. LeaderboardRank
EXEC LeaderboardRank @LeaderboardID = 1;

-- 7. ActivityEmotionalFeedback
EXEC ActivityEmotionalFeedback @ActivityID = 1, @LearnerID = 1, @timestamp = '2024-11-30 09:00:00', @emotionalstate = 'Happy';

-- 8. JoinQuest 
EXEC JoinQuest @LearnerId = 2, @QuestId = 1;

-- 9. SkillsProficiency
EXEC SkillsProficiency @LearnerId = 1;

-- 10. ViewScore
DECLARE @Score INT;
EXEC ViewScore @LearnerID = 3, @AssessmentID = 3, @OutputScore = @Score OUTPUT;
SELECT @Score AS Score;

-- 11. AssessmentsList
EXEC AssessmentsList @CourseID = 1, @LearnerID = 1, @ModuleId = 1;

-- 12. CourseRegister 
EXEC CourseRegister @LearnerId = 2, @CourseId = 1; 

-- 13. Post
EXEC Post @LearnerID = 1, @DiscussionID = 1, @Post = 'What are the best resources for learning Python?'; 

-- 14. AddGoal
EXEC AddGoal @LearnerID = 1, @GoalID = 1; 

-- 15. CurrentPath
EXEC CurrentPath @LearnerID = 1;

-- 16. QuestMembers
EXEC QuestMembers @LearnerID = 1; 

-- 17. QuestProgress
EXEC QuestProgress @LearnerID = 1; 

-- 18. GoalReminder
EXEC GoalReminder @LearnerID = 1;

-- 19. SkillProgressHistory
EXEC SkillProgressHistory @LearnerID = 1, @Skill = 'Programming';

-- 20. AssessmentAnalysis
EXEC AssessmentAnalysis @LearnerID = 1; 

-- 21. LeaderboardFilter
EXEC LeaderboardFilter @LearnerID = 1; 

--Section 3 Executions
-- 1. SkillLearners
EXEC SkillLearners @Skillname = 'Programming';

-- 2. NewActivity
EXEC NewActivity @CourseID = 1, @ModuleID = 1, @activity_type = 'Quiz', @instruction_details = 'Complete programming exercises', @Max_points = 10; 

-- 3. NewAchievement
EXEC NewAchievement @LearnerID = 1, @BadgeID = 1, @description = 'Completed all programming quizzes', @DateEarned = '2024-11-30', @type = 'Badge';

-- 4. LearnerBadge
EXEC LearnerBadge @BadgeID = 1;

-- 5. NewPath 
EXEC NewPath @LearnerID = 1, @ProfileID = 1, @completion_status = 'In Progress', @custom_content = 'Extra programming resources', @adaptiverules = 'Based on quiz performance';

-- 6. TakenCourses
EXEC TakenCourses @LearnerID = 1;

-- 7. CollaborativeQuest
EXEC CollaborativeQuest @difficulty_level = 'Medium', @criteria = 'Complete programming challenges', @description = 'A set of programming challenges to test your skills', @title = 'Programming Challenge Quest', @Maxnumparticipants = 5, @deadline = '2024-12-15';

-- 8. DeadlineUpdate
EXEC DeadlineUpdate @QuestID = 1, @deadline = '2024-12-20';

-- 9. GradeUpdate
EXEC GradeUpdate @LearnerID = 1, @AssessmentID = 1, @points = 8;
 
-- 10. AssessmentNot
EXEC AssessmentNot @NotificationID = 1, @timestamp = '2024-11-30 09:00:00', @message = 'Reminder: Complete your quiz on programming', @urgencylevel = 'Medium', @LearnerID = 1;

-- 11. NewGoal
EXEC NewGoal @GoalID = 1, @status = 'In Progress', @deadline = '2024-12-01', @description = 'Complete Data Science course';

-- 12. LearnersCourses
EXEC LearnersCourses @CourseID = 1, @InstructorID = 1;

-- 13. LastActive
DECLARE @lastactive DATETIME;
EXEC LastActive @ForumID = 1, @lastactive = @lastactive OUTPUT;
SELECT @lastactive AS LastActiveTime;

-- 14. CommonEmotionalState
DECLARE @state VARCHAR(50)
EXEC CommonEmotionalState @state OUTPUT;
SELECT @state AS CommonState;

-- 15. ModuleDifficulty
EXEC ModuleDifficulty @courseID = 1;

-- 16. ProficiencyLevel
DECLARE @SkillName VARCHAR(50);
EXEC ProficiencyLevel @LearnerID = 1, @skill = @SkillName OUTPUT;
SELECT @SkillName AS ProficiencyLevelSkill;

-- 17. ProficiencyUpdate
EXEC ProficiencyUpdate @Skill = 'Programming', @LearnerId = 1, @Level = 'Advanced';

-- 18. LeastBadge
DECLARE @ResultLearnerID INT;
EXEC LeastBadge @ResultLearnerID OUTPUT;
SELECT @ResultLearnerID AS LeastBadgeLearnerID;

-- 19. PreferredType 
DECLARE @PreferredType VARCHAR(50);
EXEC PreferredType @PreferredType OUTPUT;
SELECT @PreferredType AS MostPreferredLearningType;

-- 20. AssessmentAnalytics
EXEC AssessmentAnalytics @CourseID = 1, @ModuleID = 1;

-- 21. EmotionalTrendAnalysisIns
EXEC EmotionalTrendAnalysisIns @CourseID = 1, @ModuleID = 1, @TimePeriod = '2024-11-01';



