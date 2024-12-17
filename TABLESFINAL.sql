Create database DBProject
Use DBProject

CREATE TABLE Admin (
    AdminID INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(100) NOT NULL,
    last_name NVARCHAR(100) NOT NULL,
    gender NVARCHAR(10),
    birth_date DATE,
    country NVARCHAR(100),
    email NVARCHAR(255) NOT NULL UNIQUE,
    full_name AS (first_name + ' ' + last_name),
    password_hash NVARCHAR(255) NOT NULL,
    role NVARCHAR(50) DEFAULT 'Admin'
);


-- TABLE 1
CREATE TABLE Learner (
    LearnerID INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email nvarchar(255),
    gender VARCHAR(10),
    birth_date DATE,
    country VARCHAR(100),
    cultural_background VARCHAR(100),
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(50) DEFAULT 'Learner'
);


-- TABLE 2
CREATE TABLE Skills (
    LearnerID INT,
    skill VARCHAR(100),
    PRIMARY KEY (LearnerID, skill),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

-- TABLE 3
CREATE TABLE LearningPreference (
    LearnerID INT,
    preference VARCHAR(100),
    PRIMARY KEY (LearnerID, preference),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

-- TABLE 4
CREATE TABLE PersonalizationProfiles (
    LearnerID INT,
    ProfileID INT,
    Prefered_content_type VARCHAR(100),
    emotional_state VARCHAR(100),
    personality_type VARCHAR(100),
    PRIMARY KEY (LearnerID, ProfileID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) on delete cascade
);

-- TABLE 5
CREATE TABLE HealthCondition (
    LearnerID INT,
    ProfileID INT,
    condition VARCHAR(100),
    PRIMARY KEY (LearnerID, ProfileID, condition),
    FOREIGN KEY (LearnerID, ProfileID) REFERENCES PersonalizationProfiles(LearnerID, ProfileID)
);


-- TABLE 6
CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    Title VARCHAR(100),
    learning_objective VARCHAR(100),
    credit_points INT,
    difficulty_level VARCHAR(50),
    description VARCHAR(100)
);

-- TABLE 7
CREATE TABLE CoursePrerequisite (
    CourseID INT,
    Prereq INT,
    PRIMARY KEY (CourseID, Prereq),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (Prereq) REFERENCES Course(CourseID)
);

-- TABLE 8
CREATE TABLE Modules (
    ModuleID INT,
    CourseID INT,
    Title VARCHAR(100),
    difficulty VARCHAR(50),
    contentURL VARCHAR(255),
    primary key(ModuleID, CourseID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- TABLE 9
CREATE TABLE Target_traits (
    ModuleID INT,
    CourseID INT,
    Trait VARCHAR(100),
    PRIMARY KEY (ModuleID, CourseID, Trait),
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID)
);

-- TABLE 10
CREATE TABLE ModuleContent (
    ModuleID INT,
    CourseID INT,
    content_type VARCHAR(100),
    PRIMARY KEY (ModuleID, CourseID, content_type),
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID)
);

-- TABLE 11
CREATE TABLE ContentLibrary (
    ID INT PRIMARY KEY,
    ModuleID INT,
    CourseID INT,
    Title VARCHAR(100),
    description VARCHAR(100),
    metadata VARCHAR(100),
    type VARCHAR(100),
    content_URL VARCHAR(255),
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID)
);

-- TABLE 12
CREATE TABLE Assessments (
    ID INT PRIMARY KEY,
    ModuleID INT,
    CourseID INT,
    type VARCHAR(100),
    total_marks INT,
    passing_marks INT,
    criteria VARCHAR(100),
    weightage DECIMAL(5, 2),
    description VARCHAR(100),
    title VARCHAR(100),
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID)
);

-- TABLE 13
CREATE TABLE Takenassessment (
    AssessmentID INT,
    LearnerID INT,
    scoredPoint INT,
    PRIMARY KEY (AssessmentID, LearnerID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID),
    FOREIGN KEY (AssessmentID) REFERENCES Assessments(ID)
);

-- TABLE 14
CREATE TABLE Learning_activities (
    ActivityID INT PRIMARY KEY,
    ModuleID INT,
    CourseID INT,
    activity_type VARCHAR(100),
    instruction_details VARCHAR(100),
    Max_points INT,
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- TABLE 15
CREATE TABLE Interaction_log (
    LogID INT PRIMARY KEY,
    activity_ID INT,
    LearnerID INT,
    Duration INT,
    Timestamp DATETIME,
    action_type VARCHAR(100),
    FOREIGN KEY (activity_ID) REFERENCES Learning_activities(ActivityID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

-- TABLE 16
CREATE TABLE Emotional_feedback (
    FeedbackID INT IDENTITY PRIMARY KEY,
    LearnerID INT,
    activityID INT,
    timestamp DATETIME,
    emotional_state VARCHAR(100),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID),
    FOREIGN KEY (activityID) REFERENCES Learning_activities(ActivityID)
);

-- TABLE 17
CREATE TABLE Learning_path (
    pathID INT PRIMARY KEY,
    LearnerID INT,
    ProfileID INT,
    completion_status VARCHAR(50),
    custom_content VARCHAR(100),
    adaptive_rules VARCHAR(100),
    FOREIGN KEY (LearnerID, ProfileID) REFERENCES PersonalizationProfiles(LearnerID, ProfileID)
);

-- TABLE 18
CREATE TABLE Instructor (
    InstructorID INT PRIMARY KEY,
    last_name varchar (100),
    first_name varchar(100),
    latest_qualification VARCHAR(100),
    expertise_area VARCHAR(100),
    email VARCHAR(100),
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(50) DEFAULT 'Instructor'
);





-- TABLE 19
CREATE TABLE Pathreview (
    InstructorID INT,
    PathID INT,
    review VARCHAR(100),
    PRIMARY KEY (InstructorID, PathID),
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID),
    FOREIGN KEY (PathID) REFERENCES Learning_path(pathID)
);

-- TABLE 20
CREATE TABLE Emotionalfeedback_review (
    FeedbackID INT IDENTITY,
    InstructorID INT,
    review VARCHAR(100),
    PRIMARY KEY (FeedbackID, InstructorID),
    FOREIGN KEY (FeedbackID) REFERENCES Emotional_feedback(FeedbackID),
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID)
);

-- TABLE 21
CREATE TABLE Course_enrollment (
    EnrollmentID INT PRIMARY KEY,
    CourseID INT,
    LearnerID INT,
    completion_date DATE,
    enrollment_date DATE,
    status VARCHAR(50),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

-- TABLE 22
CREATE TABLE Teaches (
    InstructorID INT,
    CourseID INT,
    PRIMARY KEY (InstructorID, CourseID),
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- TABLE 23
CREATE TABLE Leaderboard (
    BoardID INT PRIMARY KEY,
    season VARCHAR(50)
);

-- TABLE 24
CREATE TABLE Ranking (
    BoardID INT,
    LearnerID INT,
    CourseID INT,
    rank INT,
    total_points INT,
    PRIMARY KEY (BoardID, LearnerID, CourseID),
    FOREIGN KEY (BoardID) REFERENCES Leaderboard(BoardID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- TABLE 25
CREATE TABLE Learning_goal (
    ID INT PRIMARY KEY,
    status VARCHAR(50),
    deadline DATE,
    description VARCHAR(100)
);

-- TABLE 26
CREATE TABLE LearnersGoals (
    GoalID INT,
    LearnerID INT,
    PRIMARY KEY (GoalID, LearnerID),
    FOREIGN KEY (GoalID) REFERENCES Learning_goal(ID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

-- TABLE 27
CREATE TABLE Survey (
    ID INT PRIMARY KEY,
    Title VARCHAR(100)
);

-- TABLE 28
CREATE TABLE SurveyQuestions (
    SurveyID INT,
    Question VARCHAR(255),
    PRIMARY KEY (SurveyID, Question),
    FOREIGN KEY (SurveyID) REFERENCES Survey(ID)
);

-- TABLE 29
CREATE TABLE FilledSurvey (
    SurveyID INT,
    Question VARCHAR(255),
    LearnerID INT,
    Answer VARCHAR(100),
    PRIMARY KEY (SurveyID, Question, LearnerID), 
    FOREIGN KEY (SurveyID, Question) REFERENCES SurveyQuestions(SurveyID, Question),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

-- TABLE 30
CREATE TABLE Notification (
    ID INT PRIMARY KEY,
    timestamp DATETIME,
    message VARCHAR(100),
    urgency_level VARCHAR(50),
    ReadStatus bit
);

-- TABLE 31
CREATE TABLE ReceivedNotification (
    NotificationID INT,
    LearnerID INT,
    PRIMARY KEY (NotificationID, LearnerID),
    FOREIGN KEY (NotificationID) REFERENCES Notification(ID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

-- TABLE 32
CREATE TABLE Badge (
    BadgeID INT PRIMARY KEY,
    title VARCHAR(100),
    description VARCHAR(100),
    criteria VARCHAR(100),
    points INT
);

-- TABLE 33
CREATE TABLE SkillProgression (
    ID INT PRIMARY KEY,
    proficiency_level VARCHAR(50),
    LearnerID INT,
    skill_name VARCHAR(100),
    timestamp DATETIME,
    FOREIGN KEY (LearnerID, skill_name) REFERENCES Skills(LearnerID, skill)
);

-- TABLE 34
CREATE TABLE Achievement (
    AchievementID INT PRIMARY KEY,
    LearnerID INT,
    BadgeID INT,
    description VARCHAR(100),
    date_earned DATE,
    type VARCHAR(50),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID),
    FOREIGN KEY (BadgeID) REFERENCES Badge(BadgeID)
);

-- TABLE 35
CREATE TABLE Reward (
    RewardID INT PRIMARY KEY,
    value INT,
    description VARCHAR(100),
    type VARCHAR(50)
);

-- TABLE 36
CREATE TABLE Quest (
    QuestID INT PRIMARY KEY,
    difficulty_level VARCHAR(50),
    criteria VARCHAR(50),
    description VARCHAR(100),
    title VARCHAR(100)
);


-- TABLE 37
CREATE TABLE Skill_Mastery (
    QuestID INT,
    skill VARCHAR(100),
    PRIMARY KEY (QuestID, skill),
    FOREIGN KEY (QuestID) REFERENCES Quest(QuestID)
);

-- TABLE 38
CREATE TABLE Collaborative (
    QuestID INT PRIMARY KEY,
    deadline DATE,
    max_num_participants INT,
    FOREIGN KEY (QuestID) REFERENCES Quest(QuestID)
);

-- TABLE 39
CREATE TABLE LearnersCollaboration (
    LearnerID INT,
    QuestID INT,
    completion_status VARCHAR(50),
    PRIMARY KEY (LearnerID, QuestID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID),
    FOREIGN KEY (QuestID) REFERENCES Collaborative(QuestID)
);

-- TABLE 40
CREATE TABLE LearnersMastery (
    LearnerID INT,
    QuestID INT,
    Skill VARCHAR(100),
    completion_status VARCHAR(50),
    PRIMARY KEY (LearnerID, QuestID, Skill),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID),
    FOREIGN KEY (QuestID, Skill) REFERENCES Skill_Mastery(QuestID, Skill)
);

-- TABLE 41
CREATE TABLE Discussion_forum (
    forumID INT PRIMARY KEY,
    ModuleID INT,
    CourseID INT,
    title VARCHAR(100),
    last_active DATETIME,
    timestamp DATETIME,
    description VARCHAR(100),
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID),
);

-- TABLE 42
CREATE TABLE LearnerDiscussion (
    ForumID INT,
    LearnerID INT,
    Post VARCHAR(100),
    time DATETIME,
    PRIMARY KEY (ForumID, LearnerID),
    FOREIGN KEY (ForumID) REFERENCES Discussion_forum(forumID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

-- TABLE 43
CREATE TABLE QuestReward (
    RewardID INT,
    QuestID INT,
    LearnerID INT,
    Time_earned DATETIME,
    PRIMARY KEY (RewardID, QuestID, LearnerID),
    FOREIGN KEY (RewardID) REFERENCES Reward(RewardID),
    FOREIGN KEY (QuestID) REFERENCES Quest(QuestID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);



