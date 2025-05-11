<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.StudentEnrollSystem.model.Student" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    // Get the logged-in student from the session
    Student loggedInStudent = (Student) session.getAttribute("loggedInStudent");
    
    // If no student in session, use the student ID from request parameter or hardcoded value for demo
    String studentName = (loggedInStudent != null) ? loggedInStudent.getStudentName() : "IT24102210";
    String currentDateTime = "2025-05-09 10:31:24";
    
    // Hardcoded student data for demo if not logged in through normal flow
    if (loggedInStudent == null) {
        loggedInStudent = new Student();
        loggedInStudent.setStudentName(studentName);
        loggedInStudent.setFirstName("Christopher");
        loggedInStudent.setLastName("Martin");
        loggedInStudent.setEmail("cmartin@example.com");
        loggedInStudent.setDepartment("computer_science");
        loggedInStudent.setEnrollmentYear("2024");
    }
    
    // Format department name for display
    String departmentName = "";
    switch(loggedInStudent.getDepartment()) {
        case "computer_science": departmentName = "Computer Science"; break;
        case "engineering": departmentName = "Engineering"; break;
        case "business": departmentName = "Business"; break;
        case "arts": departmentName = "Arts & Humanities"; break;
        case "science": departmentName = "Science"; break;
        default: departmentName = loggedInStudent.getDepartment();
    }
    
    // Mock course data
    class Course {
        String code;
        String name;
        String instructor;
        int credits;
        String letterGrade;
        double gradePoints;
        double percentageGrade;
        boolean isCurrentSemester;
        String semester;
        
        Course(String code, String name, String instructor, int credits, String letterGrade, 
               double gradePoints, double percentageGrade, boolean isCurrentSemester, String semester) {
            this.code = code;
            this.name = name;
            this.instructor = instructor;
            this.credits = credits;
            this.letterGrade = letterGrade;
            this.gradePoints = gradePoints;
            this.percentageGrade = percentageGrade;
            this.isCurrentSemester = isCurrentSemester;
            this.semester = semester;
        }
    }
    
    // Grade category data
    class GradeCategory {
        String categoryName;
        double weight;
        double score;
        String courseCode;
        
        GradeCategory(String categoryName, double weight, double score, String courseCode) {
            this.categoryName = categoryName;
            this.weight = weight;
            this.score = score;
            this.courseCode = courseCode;
        }
    }
    
    // Grade item data
    class GradeItem {
        String itemName;
        String category;
        double maxPoints;
        double earnedPoints;
        String dueDate;
        String courseCode;
        
        GradeItem(String itemName, String category, double maxPoints, double earnedPoints, 
                 String dueDate, String courseCode) {
            this.itemName = itemName;
            this.category = category;
            this.maxPoints = maxPoints;
            this.earnedPoints = earnedPoints;
            this.dueDate = dueDate;
            this.courseCode = courseCode;
        }
        
        double getPercentage() {
            return maxPoints > 0 ? (earnedPoints / maxPoints * 100) : 0;
        }
    }
    
    // Previous courses (past semesters)
    List<Course> previousCourses = new ArrayList<>();
    previousCourses.add(new Course("CS100", "Computer Science Fundamentals", "Prof. Miller", 3, "A", 4.0, 95.0, false, "Fall 2024"));
    previousCourses.add(new Course("MATH210", "Calculus I", "Prof. Thompson", 4, "B+", 3.3, 87.0, false, "Fall 2024"));
    previousCourses.add(new Course("ENG101", "English Composition", "Prof. Williams", 3, "A-", 3.7, 92.0, false, "Fall 2024"));
    previousCourses.add(new Course("PHYS101", "Physics I", "Prof. Brown", 4, "B", 3.0, 83.0, false, "Fall 2024"));
    
    // Current courses (current semester)
    List<Course> currentCourses = new ArrayList<>();
    currentCourses.add(new Course("CS101", "Introduction to Programming", "Prof. Johnson", 3, "A-", 3.7, 92.5, true, "Spring 2025"));
    currentCourses.add(new Course("CS202", "Database Systems", "Prof. Smith", 4, "B+", 3.3, 87.2, true, "Spring 2025"));
    currentCourses.add(new Course("CS305", "Web Development", "Prof. Wilson", 4, "A", 4.0, 96.8, true, "Spring 2025"));
    currentCourses.add(new Course("CS201", "Data Structures & Algorithms", "Prof. Davis", 4, "B", 3.0, 84.5, true, "Spring 2025"));
    
    // All courses (combined)
    List<Course> allCourses = new ArrayList<>();
    allCourses.addAll(previousCourses);
    allCourses.addAll(currentCourses);
    
    // Grade categories for each course
    Map<String, List<GradeCategory>> courseCategories = new HashMap<>();
    
    // CS101 Categories
    List<GradeCategory> cs101Categories = new ArrayList<>();
    cs101Categories.add(new GradeCategory("Assignments", 30.0, 94.0, "CS101"));
    cs101Categories.add(new GradeCategory("Quizzes", 15.0, 88.0, "CS101"));
    cs101Categories.add(new GradeCategory("Midterm Exam", 25.0, 93.0, "CS101"));
    cs101Categories.add(new GradeCategory("Final Project", 20.0, 95.0, "CS101"));
    cs101Categories.add(new GradeCategory("Participation", 10.0, 90.0, "CS101"));
    courseCategories.put("CS101", cs101Categories);
    
    // CS202 Categories
    List<GradeCategory> cs202Categories = new ArrayList<>();
    cs202Categories.add(new GradeCategory("Labs", 30.0, 85.0, "CS202"));
    cs202Categories.add(new GradeCategory("Assignments", 20.0, 89.0, "CS202"));
    cs202Categories.add(new GradeCategory("Midterm Exam", 20.0, 84.0, "CS202"));
    cs202Categories.add(new GradeCategory("Final Exam", 25.0, 90.0, "CS202"));
    cs202Categories.add(new GradeCategory("Participation", 5.0, 95.0, "CS202"));
    courseCategories.put("CS202", cs202Categories);
    
    // CS305 Categories
    List<GradeCategory> cs305Categories = new ArrayList<>();
    cs305Categories.add(new GradeCategory("Assignments", 25.0, 97.0, "CS305"));
    cs305Categories.add(new GradeCategory("Project 1", 15.0, 95.0, "CS305"));
    cs305Categories.add(new GradeCategory("Project 2", 15.0, 98.0, "CS305"));
    cs305Categories.add(new GradeCategory("Final Project", 35.0, 97.0, "CS305"));
    cs305Categories.add(new GradeCategory("Participation", 10.0, 96.0, "CS305"));
    courseCategories.put("CS305", cs305Categories);
    
    // CS201 Categories
    List<GradeCategory> cs201Categories = new ArrayList<>();
    cs201Categories.add(new GradeCategory("Assignments", 30.0, 83.0, "CS201"));
    cs201Categories.add(new GradeCategory("Quizzes", 10.0, 78.0, "CS201"));
    cs201Categories.add(new GradeCategory("Midterm Exam", 25.0, 88.0, "CS201"));
    cs201Categories.add(new GradeCategory("Final Exam", 30.0, 86.0, "CS201"));
    cs201Categories.add(new GradeCategory("Participation", 5.0, 90.0, "CS201"));
    courseCategories.put("CS201", cs201Categories);
    
    // Grade items for each course
    Map<String, List<GradeItem>> courseGradeItems = new HashMap<>();
    
    // CS101 Grade Items
    List<GradeItem> cs101Items = new ArrayList<>();
    cs101Items.add(new GradeItem("Assignment 1: Python Basics", "Assignments", 100, 95, "2025-02-10", "CS101"));
    cs101Items.add(new GradeItem("Assignment 2: Functions", "Assignments", 100, 92, "2025-02-24", "CS101"));
    cs101Items.add(new GradeItem("Assignment 3: Classes", "Assignments", 100, 96, "2025-03-10", "CS101"));
    cs101Items.add(new GradeItem("Quiz 1: Variables & Control Flow", "Quizzes", 20, 18, "2025-02-05", "CS101"));
    cs101Items.add(new GradeItem("Quiz 2: Functions & Methods", "Quizzes", 20, 17, "2025-02-19", "CS101"));
    cs101Items.add(new GradeItem("Quiz 3: OOP Concepts", "Quizzes", 20, 18, "2025-03-05", "CS101"));
    cs101Items.add(new GradeItem("Midterm Exam", "Midterm Exam", 100, 93, "2025-03-15", "CS101"));
    cs101Items.add(new GradeItem("Final Project: Simple Game", "Final Project", 100, 95, "2025-04-20", "CS101"));
    courseGradeItems.put("CS101", cs101Items);
    
    // CS202 Grade Items
    List<GradeItem> cs202Items = new ArrayList<>();
    cs202Items.add(new GradeItem("Lab 1: ER Diagrams", "Labs", 50, 47, "2025-02-12", "CS202"));
    cs202Items.add(new GradeItem("Lab 2: SQL Basics", "Labs", 50, 42, "2025-02-26", "CS202"));
    cs202Items.add(new GradeItem("Lab 3: Joins & Subqueries", "Labs", 50, 41, "2025-03-12", "CS202"));
    cs202Items.add(new GradeItem("Lab 4: Stored Procedures", "Labs", 50, 45, "2025-03-26", "CS202"));
    cs202Items.add(new GradeItem("Assignment 1: DB Design", "Assignments", 100, 89, "2025-02-19", "CS202"));
    cs202Items.add(new GradeItem("Assignment 2: Normalization", "Assignments", 100, 87, "2025-03-19", "CS202"));
    cs202Items.add(new GradeItem("Midterm Exam", "Midterm Exam", 100, 84, "2025-03-10", "CS202"));
    cs202Items.add(new GradeItem("Final Exam", "Final Exam", 100, 90, "2025-04-30", "CS202"));
    courseGradeItems.put("CS202", cs202Items);
    
    // CS305 Grade Items - only add a few for brevity
    List<GradeItem> cs305Items = new ArrayList<>();
    cs305Items.add(new GradeItem("Assignment 1: HTML/CSS Portfolio", "Assignments", 100, 98, "2025-02-15", "CS305"));
    cs305Items.add(new GradeItem("Assignment 2: JavaScript DOM", "Assignments", 100, 95, "2025-03-01", "CS305"));
    cs305Items.add(new GradeItem("Project 1: Static Website", "Project 1", 100, 95, "2025-03-15", "CS305"));
    cs305Items.add(new GradeItem("Project 2: Interactive App", "Project 2", 100, 98, "2025-04-01", "CS305"));
    cs305Items.add(new GradeItem("Final Project: Full Stack App", "Final Project", 100, 97, "2025-04-25", "CS305"));
    courseGradeItems.put("CS305", cs305Items);
    
    // CS201 Grade Items - only add a few for brevity
    List<GradeItem> cs201Items = new ArrayList<>();
    cs201Items.add(new GradeItem("Assignment 1: Array Implementation", "Assignments", 50, 45, "2025-02-08", "CS201"));
    cs201Items.add(new GradeItem("Assignment 2: Linked Lists", "Assignments", 50, 40, "2025-02-22", "CS201"));
    cs201Items.add(new GradeItem("Assignment 3: Trees & Graphs", "Assignments", 50, 44, "2025-03-08", "CS201"));
    cs201Items.add(new GradeItem("Quiz 1: Data Structures", "Quizzes", 20, 16, "2025-02-10", "CS201"));
    cs201Items.add(new GradeItem("Quiz 2: Algorithm Analysis", "Quizzes", 20, 15, "2025-03-03", "CS201"));
    cs201Items.add(new GradeItem("Midterm Exam", "Midterm Exam", 100, 88, "2025-03-20", "CS201"));
    cs201Items.add(new GradeItem("Final Exam", "Final Exam", 100, 86, "2025-05-05", "CS201"));
    courseGradeItems.put("CS201", cs201Items);
    
    // Calculate GPAs
    double totalCreditPoints = 0;
    int totalCredits = 0;
    
    // Cumulative GPA (all courses)
    for (Course course : allCourses) {
        totalCreditPoints += (course.gradePoints * course.credits);
        totalCredits += course.credits;
    }
    double cumulativeGPA = totalCreditPoints / totalCredits;
    
    // Current semester GPA
    double currentTotalCreditPoints = 0;
    int currentTotalCredits = 0;
    for (Course course : currentCourses) {
        currentTotalCreditPoints += (course.gradePoints * course.credits);
        currentTotalCredits += course.credits;
    }
    double currentSemesterGPA = currentTotalCreditPoints / currentTotalCredits;
    
    // Previous semester GPA
    double previousTotalCreditPoints = 0;
    int previousTotalCredits = 0;
    for (Course course : previousCourses) {
        previousTotalCreditPoints += (course.gradePoints * course.credits);
        previousTotalCredits += course.credits;
    }
    double previousSemesterGPA = previousTotalCreditPoints / previousTotalCredits;
    
    // Format GPAs to 2 decimal places
    String formattedCumulativeGPA = String.format("%.2f", cumulativeGPA);
    String formattedCurrentSemesterGPA = String.format("%.2f", currentSemesterGPA);
    String formattedPreviousSemesterGPA = String.format("%.2f", previousSemesterGPA);
    
    // Generate GPA trend data
    String[] semesterLabels = {"Fall 2024", "Spring 2025"};
    double[] semesterGPAs = {previousSemesterGPA, currentSemesterGPA};
    
    // Get the selected course for detailed view, if any
    String selectedCourseCode = request.getParameter("course");
    if (selectedCourseCode == null && !currentCourses.isEmpty()) {
        selectedCourseCode = currentCourses.get(0).code;
    }
    
    // Find the selected course
    Course selectedCourse = null;
    for (Course course : allCourses) {
        if (course.code.equals(selectedCourseCode)) {
            selectedCourse = course;
            break;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grades - EduEnroll</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            min-height: 100vh;
            background-color: #343a40;
            position: fixed;
            padding-top: 20px;
        }
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.75);
            padding: 0.75rem 1rem;
            border-radius: 5px;
            margin: 2px 10px;
        }
        .sidebar .nav-link.active {
            color: #fff;
            background-color: rgba(255, 255, 255, 0.1);
        }
        .sidebar .nav-link:hover {
            color: #fff;
            background-color: rgba(255, 255, 255, 0.05);
        }
        .main-content {
            margin-left: 250px;
            padding: 2rem;
        }
        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: #17a2b8;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin: 0 auto 1rem;
        }
        .navbar-top {
            background-color: #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .dashboard-widget {
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: transform 0.3s;
        }
        .dashboard-widget:hover {
            transform: translateY(-5px);
        }
        .navbar-brand {
            font-weight: 700;
        }
        .grade-card {
            border-left: 4px solid #0d6efd;
            transition: transform 0.3s;
            margin-bottom: 0.75rem;
            border-radius: 8px;
            overflow: hidden;
        }
        .grade-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .grade-card.current {
            border-left: 4px solid #198754;
        }
        .grade-card.previous {
            border-left: 4px solid #6c757d;
        }
        .gpa-display {
            font-size: 3rem;
            font-weight: bold;
            color: #0d6efd;
        }
        .gpa-widget {
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            background-color: white;
        }
        .grade-badge {
            font-size: 1.5rem;
            display: inline-block;
            min-width: 45px;
            text-align: center;
        }
        .progress-sm {
            height: 8px;
        }
        .category-row {
            padding: 10px 15px;
            border-bottom: 1px solid #f1f1f1;
        }
        .category-row:last-child {
            border-bottom: none;
        }
        .grade-header {
            background: linear-gradient(135deg, #0d6efd 0%, #0dcaf0 100%);
            color: white;
            padding: 15px 20px;
            border-radius: 8px 8px 0 0;
        }
        .grade-container {
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 20px;
        }
        .grade-nav .nav-link {
            color: #495057;
            border-bottom: 2px solid transparent;
        }
        .grade-nav .nav-link.active {
            color: #0d6efd;
            border-bottom-color: #0d6efd;
            font-weight: 600;
        }
        .course-item {
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .course-item:hover {
            background-color: rgba(13, 110, 253, 0.05);
        }
        .course-item.active {
            background-color: rgba(13, 110, 253, 0.1);
            border-left: 3px solid #0d6efd;
        }
        .grade-item-row {
            padding: 10px 15px;
            border-bottom: 1px solid #f1f1f1;
            transition: background-color 0.2s;
        }
        .grade-item-row:hover {
            background-color: rgba(13, 110, 253, 0.03);
        }
        .score-excellent {
            color: #198754;
        }
        .score-good {
            color: #0d6efd;
        }
        .score-average {
            color: #fd7e14;
        }
        .score-poor {
            color: #dc3545;
        }
        .comparison-line {
            height: 5px;
            width: 100%;
            background-color: #e9ecef;
            position: relative;
            margin: 15px 0;
        }
        .your-score-marker {
            height: 15px;
            width: 15px;
            background-color: #0d6efd;
            border-radius: 50%;
            position: absolute;
            top: -5px;
            transform: translateX(-50%);
            border: 2px solid white;
            box-shadow: 0 0 5px rgba(0,0,0,0.2);
        }
        .class-average-marker {
            height: 12px;
            width: 3px;
            background-color: #6c757d;
            position: absolute;
            top: -3.5px;
            transform: translateX(-50%);
        }
        .chart-container {
            position: relative;
            min-height: 200px;
            width: 100%;
        }
    </style>
</head>
<body>
    <!-- Top Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top navbar-top">
        <div class="container-fluid">
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#sidebarMenu" aria-controls="sidebarMenu" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <a class="navbar-brand me-4" href="#">
                <span class="text-primary">Edu</span><span class="text-dark">Enroll</span>
            </a>
            
            <div class="collapse navbar-collapse justify-content-between" id="navbarTop">
                <div class="navbar-nav d-flex flex-row me-auto">
                    <span class="nav-link me-3"><i class="far fa-calendar-alt me-2"></i><%= currentDateTime %></span>
                    <span class="nav-link"><i class="fas fa-user-circle me-2"></i>Student ID: <%= studentName %></span>
                </div>
                <div class="navbar-nav">
                    <div class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-bell me-2"></i>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                2
                            </span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                            <li><h6 class="dropdown-header">Notifications</h6></li>
                            <li><a class="dropdown-item" href="#">New grade posted: Web Development</a></li>
                            <li><a class="dropdown-item" href="#">Feedback available: Data Structures Quiz</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="#">View all notifications</a></li>
                        </ul>
                    </div>
                    <div class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user-circle me-2"></i><%= loggedInStudent.getFirstName() %> <%= loggedInStudent.getLastName() %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>My Profile</a></li>
                            <li><a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i>Account Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-5 pt-3">
        <div class="row">
            <!-- Sidebar -->
            <nav id="sidebarMenu" class="col-md-3 col-lg-2 sidebar collapse d-md-block">
                <div class="position-sticky">
                    <div class="text-center my-4">
                        <div class="profile-avatar">
                            <%= loggedInStudent.getFirstName().charAt(0) %><%= loggedInStudent.getLastName().charAt(0) %>
                        </div>
                        <h6 class="text-white"><%= loggedInStudent.getFirstName() %> <%= loggedInStudent.getLastName() %></h6>
                        <p class="text-light small"><%= loggedInStudent.getStudentName() %></p>
                    </div>
                    <hr class="bg-light">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="studentDashboard.jsp">
                                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="myCourses.jsp">
                                <i class="fas fa-book me-2"></i>My Courses
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="shedule.jsp">
                                <i class="fas fa-calendar-alt me-2"></i>Schedule
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="grades.jsp">
                                <i class="fas fa-graduation-cap me-2"></i>Grades
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="assignments.jsp">
                                <i class="fas fa-tasks me-2"></i>Assignments
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="transcript.jsp">
                                <i class="fas fa-file-alt me-2"></i>Transcript
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="fas fa-chart-line me-2"></i>Progress
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="fas fa-bullhorn me-2"></i>Announcements
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="fas fa-user-cog me-2"></i>Profile
                            </a>
                        </li>
                    </ul>
                    <hr class="bg-light">
                    <div class="d-grid gap-2 px-3">
                        <a href="logout" class="btn btn-danger">
                            <i class="fas fa-sign-out-alt me-2"></i>Logout
                        </a>
                    </div>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Academic Grades</h1>
                    <div class="text-end">
                        <div class="text-muted small">Current Date and Time: <%= currentDateTime %></div>
                        <div class="text-muted small">Department: <%= departmentName %>, Year: <%= loggedInStudent.getEnrollmentYear() %></div>
                    </div>
                </div>

                <!-- GPA Overview Section -->
                <div class="row mb-4">
                    <div class="col-lg-4">
                        <div class="gpa-widget">
                            <h5 class="text-muted mb-1">Cumulative GPA</h5>
                            <div class="gpa-display"><%= formattedCumulativeGPA %></div>
                            <div class="mt-2 d-flex justify-content-between">
                                <span class="text-muted">Total Credits: <%= totalCredits %></span>
                                <div>
                                    <span class="badge bg-success">Dean's List</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="gpa-widget">
                            <h5 class="text-muted mb-1">Current Semester GPA</h5>
                            <div class="gpa-display"><%= formattedCurrentSemesterGPA %></div>
                            <div class="mt-2 d-flex justify-content-between">
                                <span class="text-muted">Credits: <%= currentTotalCredits %></span>
                                <% if (currentSemesterGPA > previousSemesterGPA) { %>
                                    <span class="text-success"><i class="fas fa-arrow-up me-1"></i><%= String.format("%.2f", currentSemesterGPA - previousSemesterGPA) %></span>
                                <% } else if (currentSemesterGPA < previousSemesterGPA) { %>
                                    <span class="text-danger"><i class="fas fa-arrow-down me-1"></i><%= String.format("%.2f", previousSemesterGPA - currentSemesterGPA) %></span>
                                <% } else { %>
                                    <span class="text-muted"><i class="fas fa-equals me-1"></i>0.00</span>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="gpa-widget">
                            <h5 class="text-muted mb-1">Previous Semester GPA</h5>
                            <div class="gpa-display"><%= formattedPreviousSemesterGPA %></div>
                            <div class="mt-2 d-flex justify-content-between">
                                <span class="text-muted">Credits: <%= previousTotalCredits %></span>
                                <span class="text-muted">Fall 2024</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- Course List -->
                    <div class="col-lg-4">
                        <div class="grade-container mb-4">
                            <div class="grade-header">
                                <h5 class="mb-0"><i class="fas fa-book me-2"></i>Courses</h5>
                            </div>
                            <div class="list-group list-group-flush">
                                <div class="list-group-item bg-light fw-bold">
                                    <div class="row">
                                        <div class="col-5">Course</div>
                                        <div class="col-4">Semester</div>
                                        <div class="col-3 text-end">Grade</div>
                                    </div>
                                </div>
                                
                                <!-- Current Semester Courses -->
                                <div class="list-group-item bg-light">
                                    <small class="text-muted">CURRENT SEMESTER</small>
                                </div>
                                <% for (Course course : currentCourses) { %>
                                <a href="?course=<%= course.code %>" class="list-group-item course-item <%= selectedCourseCode != null && selectedCourseCode.equals(course.code) ? "active" : "" %>">
                                    <div class="row align-items-center">
                                        <div class="col-5">
                                            <span class="badge bg-primary me-1"><%= course.code %></span>
                                        </div>
                                        <div class="col-4 small">
                                            <%= course.semester %>
                                        </div>
                                        <div class="col-3 text-end">
                                            <span class="badge bg-light text-dark"><%= course.letterGrade %></span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-12 small text-truncate">
                                            <%= course.name %>
                                        </div>
                                    </div>
                                </a>
                                <% } %>
                                
                                <!-- Previous Semester Courses -->
                                <div class="list-group-item bg-light">
                                    <small class="text-muted">PREVIOUS SEMESTER</small>
                                </div>
                                <% for (Course course : previousCourses) { %>
                                <a href="?course=<%= course.code %>" class="list-group-item course-item <%= selectedCourseCode != null && selectedCourseCode.equals(course.code) ? "active" : "" %>">
                                    <div class="row align-items-center">
                                        <div class="col-5">
                                            <span class="badge bg-secondary me-1"><%= course.code %></span>
                                        </div>
                                        <div class="col-4 small">
                                            <%= course.semester %>
                                        </div>
                                        <div class="col-3 text-end">
                                            <span class="badge bg-light text-dark"><%= course.letterGrade %></span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-12 small text-truncate">
                                            <%= course.name %>
                                        </div>
                                    </div>
                                </a>
                                <% } %>
                            </div>
                        </div>
                        
                        <!-- GPA Trend -->
                        <div class="grade-container">
                            <div class="grade-header">
                                <h5 class="mb-0"><i class="fas fa-chart-line me-2"></i>GPA Trend</h5>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="gpaChart" height="200"></canvas>
                                </div>
                                <div class="d-flex justify-content-between mt-3">
                                    <div>
                                        <div class="mb-1"><i class="fas fa-square text-primary me-2"></i>Semester GPA</div>
                                        <div><i class="fas fa-square text-success me-2"></i>Cumulative GPA</div>
                                    </div>
                                    <div class="text-end">
                                        <span class="badge bg-light text-dark p-2">
                                            <i class="fas fa-arrow-up text-success me-1"></i> +0.15 from Fall 2024
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Course Details -->
                    <div class="col-lg-8">
                        <% if (selectedCourse != null) { %>
                        <div class="grade-container">
                            <div class="grade-header d-flex justify-content-between align-items-center">
                                <div>
                                    <h5 class="mb-0"><%= selectedCourse.code %>: <%= selectedCourse.name %></h5>
                                    <div class="small text-white-50">
                                        <i class="fas fa-user me-1"></i> <%= selectedCourse.instructor %> | 
                                        <i class="fas fa-calendar me-1"></i> <%= selectedCourse.semester %> | 
                                        <i class="fas fa-award me-1"></i> <%= selectedCourse.credits %> Credits
                                    </div>
                                </div>
                                <div class="text-center">
                                    <div class="grade-badge bg-light text-dark rounded-circle p-2"><%= selectedCourse.letterGrade %></div>
                                    <div class="text-white-50 small"><%= String.format("%.1f", selectedCourse.percentageGrade) %>%</div>
                                </div>
                            </div>
                            
                            <div class="p-3">
                                <!-- Course Grade Navigation -->
                                <ul class="nav nav-tabs grade-nav mb-3" id="courseGradeTabs" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link active" id="grade-breakdown-tab" data-bs-toggle="tab" 
                                                data-bs-target="#grade-breakdown" type="button" role="tab" 
                                                aria-controls="grade-breakdown" aria-selected="true">
                                            Grade Breakdown
                                        </button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="grade-items-tab" data-bs-toggle="tab" 
                                                data-bs-target="#grade-items" type="button" role="tab" 
                                                aria-controls="grade-items" aria-selected="false">
                                            Individual Items
                                        </button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="grade-comparison-tab" data-bs-toggle="tab" 
                                                data-bs-target="#grade-comparison" type="button" role="tab" 
                                                aria-controls="grade-comparison" aria-selected="false">
                                            Class Comparison
                                        </button>
                                    </li>
                                </ul>
                                
                                <div class="tab-content" id="courseGradeTabsContent">
                                    <!-- Grade Breakdown Tab -->
                                    <div class="tab-pane fade show active" id="grade-breakdown" role="tabpanel" aria-labelledby="grade-breakdown-tab">
                                        <div class="mb-4">
                                            <div class="d-flex justify-content-between mb-2">
                                                <h6>Category Distribution</h6>
                                                <div>
                                                    <span class="badge bg-primary p-2">Overall: <%= String.format("%.1f", selectedCourse.percentageGrade) %>%</span>
                                                </div>
                                            </div>
                                            <div class="chart-container" style="height: 300px;">
                                                <canvas id="categoryChart"></canvas>
                                            </div>
                                        </div>
                                        
                                        <div class="mt-4">
                                            <div class="row fw-bold bg-light p-2 mb-2">
                                                <div class="col-4">Category</div>
                                                <div class="col-2 text-center">Weight</div>
                                                <div class="col-3 text-center">Score</div>
                                                <div class="col-3 text-center">Weighted</div>
                                            </div>
                                            
                                            <% 
                                            List<GradeCategory> categories = courseCategories.get(selectedCourse.code);
                                            if (categories != null) {
                                                double totalWeightedScore = 0;
                                                for (GradeCategory category : categories) {
                                                    double weightedScore = (category.score / 100) * category.weight;
                                                    totalWeightedScore += weightedScore;
                                                    
                                                    String scoreColorClass = "score-average";
                                                    if (category.score >= 90) {
                                                        scoreColorClass = "score-excellent";
                                                    } else if (category.score >= 80) {
                                                        scoreColorClass = "score-good";
                                                    } else if (category.score < 70) {
                                                        scoreColorClass = "score-poor";
                                                    }
                                            %>
                                            <div class="category-row">
                                                <div class="row">
                                                    <div class="col-4"><%= category.categoryName %></div>
                                                    <div class="col-2 text-center"><%= String.format("%.1f", category.weight) %>%</div>
                                                    <div class="col-3 text-center <%= scoreColorClass %>"><%= String.format("%.1f", category.score) %>%</div>
                                                    <div class="col-3 text-center"><%= String.format("%.1f", weightedScore) %>%</div>
                                                </div>
                                                <div class="progress progress-sm mt-2">
                                                    <div class="progress-bar" role="progressbar" style="width: <%= category.score %>%" 
                                                         aria-valuenow="<%= category.score %>" aria-valuemin="0" aria-valuemax="100"></div>
                                                </div>
                                            </div>
                                            <% 
                                                }
                                            %>
                                            <div class="category-row bg-light fw-bold">
                                                <div class="row">
                                                    <div class="col-4">Total</div>
                                                    <div class="col-2 text-center">100%</div>
                                                    <div class="col-3 text-center">-</div>
                                                    <div class="col-3 text-center"><%= String.format("%.1f", totalWeightedScore) %>%</div>
                                                </div>
                                            </div>
                                            <% } else { %>
                                            <div class="alert alert-info">
                                                No grade categories available for this course.
                                            </div>
                                            <% } %>
                                        </div>
                                        
                                        <div class="alert alert-primary mt-4">
                                            <i class="fas fa-info-circle me-2"></i>
                                            Your current grade in this course is based on completed assessments. 
                                            Additional assignments and exams may affect your final grade.
                                        </div>
                                    </div>
                                    
                                    <!-- Individual Grade Items Tab -->
                                    <div class="tab-pane fade" id="grade-items" role="tabpanel" aria-labelledby="grade-items-tab">
                                        <div class="table-responsive">
                                            <table class="table table-hover">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Item</th>
                                                        <th>Category</th>
                                                        <th>Score</th>
                                                        <th>Out Of</th>
                                                        <th>Percentage</th>
                                                        <th>Date</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <% 
                                                    List<GradeItem> items = courseGradeItems.get(selectedCourse.code);
                                                    if (items != null && !items.isEmpty()) {
                                                        for (GradeItem item : items) {
                                                            String percentageClass = "score-average";
                                                            double percentage = item.getPercentage();
                                                            if (percentage >= 90) {
                                                                percentageClass = "score-excellent";
                                                            } else if (percentage >= 80) {
                                                                percentageClass = "score-good";
                                                            } else if (percentage < 70) {
                                                                percentageClass = "score-poor";
                                                            }
                                                    %>
                                                    <tr>
                                                        <td><%= item.itemName %></td>
                                                        <td><span class="badge bg-light text-dark"><%= item.category %></span></td>
                                                        <td><%= String.format("%.1f", item.earnedPoints) %></td>
                                                        <td><%= String.format("%.1f", item.maxPoints) %></td>
                                                        <td><span class="<%= percentageClass %>"><%= String.format("%.1f", percentage) %>%</span></td>
                                                        <td><small><%= item.dueDate %></small></td>
                                                    </tr>
                                                    <% 
                                                        }
                                                    } else { 
                                                    %>
                                                    <tr>
                                                        <td colspan="6" class="text-center">No grade items available for this course.</td>
                                                    </tr>
                                                    <% } %>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    
                                    <!-- Class Comparison Tab -->
                                    <div class="tab-pane fade" id="grade-comparison" role="tabpanel" aria-labelledby="grade-comparison-tab">
                                        <div class="mb-4">
                                            <h6>Your Performance Compared to Class Average</h6>
                                            <div class="chart-container" style="height: 300px;">
                                                <canvas id="comparisonChart"></canvas>
                                            </div>
                                        </div>
                                        
                                        <!-- Overall Course Comparison -->
                                        <div class="card mb-4">
                                            <div class="card-header bg-light">
                                                <h6 class="mb-0">Overall Course Performance</h6>
                                            </div>
                                            <div class="card-body">
                                                <div class="row align-items-center">
                                                    <div class="col-md-3 text-center">
                                                        <div class="display-6 mb-0 <%= selectedCourse.percentageGrade >= 90 ? "score-excellent" : selectedCourse.percentageGrade >= 80 ? "score-good" : selectedCourse.percentageGrade >= 70 ? "score-average" : "score-poor" %>">
                                                            <%= String.format("%.1f", selectedCourse.percentageGrade) %>%
                                                        </div>
                                                        <div class="small text-muted">Your Score</div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="comparison-line">
                                                            <div class="your-score-marker" style="left: <%= selectedCourse.percentageGrade %>%;"></div>
                                                            <div class="class-average-marker" style="left: 82%;"></div>
                                                        </div>
                                                        <div class="d-flex justify-content-between">
                                                            <div class="small text-muted">0%</div>
                                                            <div class="small text-muted">100%</div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3 text-center">
                                                        <div class="display-6 mb-0 text-muted">82.0%</div>
                                                        <div class="small text-muted">Class Average</div>
                                                    </div>
                                                </div>
                                                
                                                <div class="mt-3 text-center">
                                                    <span class="badge bg-success p-2">
                                                        <i class="fas fa-arrow-up me-1"></i>
                                                        <%= String.format("%.1f", selectedCourse.percentageGrade - 82.0) %>% above class average
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="alert alert-info">
                                            <i class="fas fa-chart-pie me-2"></i>
                                            <strong>Grade Distribution:</strong> In this course, <%= selectedCourse.percentageGrade >= 90 ? "15%" : "25%" %> of students achieved an A grade, 
                                            35% a B grade, 30% a C grade, and 10% below a C grade.
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% } else { %>
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            Please select a course from the list to view detailed grade information.
                        </div>
                        <% } %>
                        
                        <!-- Grade History -->
                        <div class="grade-container mt-4">
                            <div class="grade-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0"><i class="fas fa-history me-2"></i>Recently Updated Grades</h5>
                                <button class="btn btn-sm btn-light">View All</button>
                            </div>
                            <div class="list-group list-group-flush">
                                <div class="list-group-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="mb-1">CS305: JavaScript Interactive Feature</h6>
                                            <div class="small text-muted">Web Development | Prof. Wilson</div>
                                        </div>
                                        <div class="text-end">
                                            <div class="fw-bold score-excellent">47/50 (94%)</div>
                                            <div class="small text-muted">Updated: 2025-05-02</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="list-group-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="mb-1">CS202: SQL Queries Lab</h6>
                                            <div class="small text-muted">Database Systems | Prof. Smith</div>
                                        </div>
                                        <div class="text-end">
                                            <div class="fw-bold score-good">40/50 (80%)</div>
                                            <div class="small text-muted">Updated: 2025-04-30</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="list-group-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="mb-1">CS201: Tree Traversal Lab</h6>
                                            <div class="small text-muted">Data Structures & Algorithms | Prof. Davis</div>
                                        </div>
                                        <div class="text-end">
                                            <div class="fw-bold score-excellent">38/40 (95%)</div>
                                            <div class="small text-muted">Updated: 2025-04-28</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-white text-center py-3 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h5>EduEnroll</h5>
                    <p class="small">A comprehensive student enrollment and management system.</p>
                </div>
                <div class="col-md-4">
                    <h5>Quick Links</h5>
                    <ul class="list-unstyled">
                        <li><a href="#" class="text-white-50">Help Center</a></li>
                        <li><a href="#" class="text-white-50">Privacy Policy</a></li>
                        <li><a href="#" class="text-white-50">Terms of Service</a></li>
                    </ul>
                </div>
                <div class="col-md-4">
                    <h5>Contact</h5>
                    <p class="small text-white-50">
                        <i class="fas fa-envelope me-2"></i>support@eduenroll.edu<br>
                        <i class="fas fa-phone me-2"></i>(123) 456-7890
                    </p>
                </div>
            </div>
            <hr class="my-2 bg-light">
            <p class="mb-0 small">© 2025 EduEnroll. All rights reserved.</p>
        </div>
    </footer>

    <!-- Required JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    
    <!-- Fix for overlapping charts -->
    <script>
    // Wait for the document to be fully loaded
    document.addEventListener('DOMContentLoaded', function() {
        // Store chart instances for later reference
        const chartInstances = {};
        
        // Function to destroy existing chart if it exists
        function destroyChartIfExists(canvasId) {
            if (chartInstances[canvasId]) {
                chartInstances[canvasId].destroy();
                delete chartInstances[canvasId];
            }
        }
        
        // Set Chart.js default options for better appearance and spacing
        Chart.defaults.font.family = "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif";
        Chart.defaults.color = '#666';
        Chart.defaults.responsive = true;
        Chart.defaults.maintainAspectRatio = false;
        
        // Initialize GPA Trend Chart
        const gpaCtx = document.getElementById('gpaChart');
        if (gpaCtx) {
            destroyChartIfExists('gpaChart');
            chartInstances['gpaChart'] = new Chart(gpaCtx, {
                type: 'line',
                data: {
                    labels: ['Fall 2024', 'Spring 2025'],
                    datasets: [
                        {
                            label: 'Semester GPA',
                            data: [<%= previousSemesterGPA %>, <%= currentSemesterGPA %>],
                            borderColor: '#0d6efd',
                            backgroundColor: 'rgba(13, 110, 253, 0.1)',
                            borderWidth: 2,
                            tension: 0.1,
                            fill: true
                        },
                        {
                            label: 'Cumulative GPA',
                            data: [<%= previousSemesterGPA %>, <%= cumulativeGPA %>],
                            borderColor: '#198754',
                            backgroundColor: 'rgba(25, 135, 84, 0.1)',
                            borderWidth: 2,
                            tension: 0.1,
                            fill: true
                        }
                    ]
                },
                options: {
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            mode: 'index',
                            intersect: false
                        }
                    },
                    scales: {
                        y: {
                            min: 0,
                            max: 4.0,
                            ticks: {
                                stepSize: 0.5
                            }
                        }
                    }
                }
            });
        }
        
        // Initialize Category Distribution Chart with fixed positioning and spacing
        const categoryCtx = document.getElementById('categoryChart');
        <% if (selectedCourse != null) { %>
        if (categoryCtx) {
            // Get the categories from the page
            const categoryNames = [];
            const categoryScores = [];
            const categoryWeights = [];
            
            <% 
            List<GradeCategory> categories = courseCategories.get(selectedCourse.code);
            if (categories != null && !categories.isEmpty()) {
                for (GradeCategory category : categories) {
            %>
                categoryNames.push("<%= category.categoryName %>");
                categoryScores.push(<%= category.score %>);
                categoryWeights.push(<%= category.weight %>);
            <% 
                }
            }
            %>
            
            // Define colors for the chart
            const colors = [
                'rgba(13, 110, 253, 0.7)',
                'rgba(25, 135, 84, 0.7)',
                'rgba(255, 193, 7, 0.7)',
                'rgba(220, 53, 69, 0.7)',
                'rgba(111, 66, 193, 0.7)'
            ];
            
            // Destroy existing chart if it exists
            destroyChartIfExists('categoryChart');
            
            // Create new chart with proper spacing and positioning
            chartInstances['categoryChart'] = new Chart(categoryCtx, {
                type: 'bar',
                data: {
                    labels: categoryNames,
                    datasets: [
                        {
                            label: 'Score (%)',
                            data: categoryScores,
                            backgroundColor: colors.slice(0, categoryNames.length),
                            borderColor: colors.slice(0, categoryNames.length).map(c => c.replace('0.7', '1')),
                            borderWidth: 1
                        }
                    ]
                },
                options: {
                    indexAxis: 'y',  // Horizontal bar chart
                    layout: {
                        padding: {
                            top: 20,
                            right: 30,
                            bottom: 10,
                            left: 20
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const index = context.dataIndex;
                                    return `Score: ${context.raw}% (Weight: ${categoryWeights[index]}%)`;
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            min: 0,
                            max: 100,
                            grid: {
                                display: false
                            }
                        },
                        y: {
                            grid: {
                                display: false
                            }
                        }
                    },
                    // Critical settings to prevent bar overlap
                    barThickness: 20,              // Fixed bar thickness in pixels
                    maxBarThickness: 25,           // Maximum bar thickness in pixels
                    barPercentage: 0.7,            // Percentage of available width for each bar
                    categoryPercentage: 0.8        // Percentage of available width for all bars in a category
                }
            });
        }
        <% } %>
        
        // Initialize Comparison Chart with anti-overlap settings
        const comparisonCtx = document.getElementById('comparisonChart');
        <% if (selectedCourse != null) { %>
        if (comparisonCtx) {
                        // Destroy existing chart if it exists
                        destroyChartIfExists('comparisonChart');
            
            chartInstances['comparisonChart'] = new Chart(comparisonCtx, {
                type: 'bar',
                data: {
                    labels: ['Assignments', 'Quizzes', 'Midterm', 'Final/Project', 'Participation', 'Overall'],
                    datasets: [
                        {
                            label: 'Your Score',
                            data: [92, 88, 90, 95, 90, <%= selectedCourse.percentageGrade %>],
                            backgroundColor: 'rgba(13, 110, 253, 0.7)',
                            borderColor: 'rgba(13, 110, 253, 1)',
                            borderWidth: 1
                        },
                        {
                            label: 'Class Average',
                            data: [84, 80, 78, 82, 88, 82],
                            backgroundColor: 'rgba(108, 117, 125, 0.7)',
                            borderColor: 'rgba(108, 117, 125, 1)',
                            borderWidth: 1
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top'
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 100,
                            ticks: {
                                callback: function(value) {
                                    return value + '%';
                                }
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                maxRotation: 45,
                                minRotation: 45
                            }
                        }
                    },
                    // Critical settings to prevent bar overlap
                    barThickness: 'flex',       // Let Chart.js calculate the bar thickness
                    maxBarThickness: 40,        // Maximum bar thickness in pixels
                    barPercentage: 0.6,         // Percentage of available width for each bar
                    categoryPercentage: 0.7     // Percentage of available width for all bars in a category
                }
            });
        }
        <% } %>
        
        // Add event listener for window resize to make charts responsive
        window.addEventListener('resize', function() {
            for (const chartId in chartInstances) {
                if (chartInstances[chartId]) {
                    chartInstances[chartId].resize();
                }
            }
        });
        
        // Handle tab changes to redraw charts when they become visible
        document.querySelectorAll('button[data-bs-toggle="tab"]').forEach(tab => {
            tab.addEventListener('shown.bs.tab', function(event) {
                setTimeout(function() {  // Add small delay to ensure the tab content is fully visible
                    const targetId = event.target.getAttribute('data-bs-target');
                    const targetPane = document.querySelector(targetId);
                    
                    if (targetPane) {
                        const canvasIds = [];
                        targetPane.querySelectorAll('canvas').forEach(canvas => {
                            canvasIds.push(canvas.id);
                            const chartInstance = chartInstances[canvas.id];
                            if (chartInstance) {
                                chartInstance.resize();
                            }
                        });
                    }
                }, 50);
            });
        });
    });
    </script>
</body>
</html>
