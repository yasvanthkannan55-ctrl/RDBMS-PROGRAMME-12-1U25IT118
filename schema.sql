-- Create Department Table
CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(100) NOT NULL,
    OfficeLocation VARCHAR(100),
    Budget DECIMAL(10, 2)
);

-- Create Faculty Table (1 Department -> Many Faculty)
CREATE TABLE Faculty (
    FacultyID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialization VARCHAR(100),
    ContactInfo VARCHAR(100),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- Create Student Table (1 Department -> Many Students)
CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    EnrollmentDate DATE,
    DateOfBirth DATE,
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- Create Course Table (1 Faculty -> Many Courses)
CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseTitle VARCHAR(100) NOT NULL,
    Credits INT,
    Syllabus TEXT,
    Description TEXT,
    FacultyID INT,
    FOREIGN KEY (FacultyID) REFERENCES Faculty(FacultyID)
);

-- Create Enrollment Table (Many Students <-> Many Courses)
CREATE TABLE Enrollment (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    Grade VARCHAR(5),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

