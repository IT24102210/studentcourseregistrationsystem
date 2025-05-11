<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.StudentEnrollSystem.model.Student" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.util.Collections" %>
<%
    // Get the logged-in student from the session
    Student loggedInStudent = (Student) session.getAttribute("loggedInStudent");
    
    // If no student in session, use the student ID from request parameter or hardcoded value for demo
    String studentName = (loggedInStudent != null) ? loggedInStudent.getStudentName() : "IT24103866";
    String currentDateTime = "2025-05-04 11:03:56";
    
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
    
    // Mock course data - simplified for assignments view
    class Course {
        String code;
        String name;
        String instructor;
        String color;
        
        Course(String code, String name, String instructor, String color) {
            this.code = code;
            this.name = name;
            this.instructor = instructor;
            this.color = color;
        }
    }
    
    // Create a map of courses for easy lookup
    Map<String, Course> coursesMap = new HashMap<>();
    coursesMap.put("CS101", new Course("CS101", "Introduction to Programming", "Prof. Johnson", "primary"));
    coursesMap.put("CS202", new Course("CS202", "Database Systems", "Prof. Smith", "success"));
    coursesMap.put("CS305", new Course("CS305", "Web Development", "Prof. Wilson", "danger"));
    coursesMap.put("CS201", new Course("CS201", "Data Structures & Algorithms", "Prof. Davis", "warning"));
    
    // Mock assignment data
    class Assignment {
        String id;
        String courseCode;
        String title;
        String description;
        String dueDate;
        String assignedDate;
        int maxPoints;
        int earnedPoints;
        String status; // "Not Started", "In Progress", "Submitted", "Late", "Graded", "Upcoming"
        int completionPercentage;
        String fileSubmission; // filename if submitted
        String feedback;
        
        Assignment(String id, String courseCode, String title, String description, 
                 String dueDate, String assignedDate, int maxPoints, int earnedPoints, 
                 String status, int completionPercentage, String fileSubmission, String feedback) {
            this.id = id;
            this.courseCode = courseCode;
            this.title = title;
            this.description = description;
            this.dueDate = dueDate;
            this.assignedDate = assignedDate;
            this.maxPoints = maxPoints;
            this.earnedPoints = earnedPoints;
            this.status = status;
            this.completionPercentage = completionPercentage;
            this.fileSubmission = fileSubmission;
            this.feedback = feedback;
        }
        
        // Calculate time remaining until due date (for display purposes)
        String getTimeRemaining() {
            // In a real app, this would calculate actual time difference
            if (status.equals("Graded") || status.equals("Submitted") || status.equals("Late")) {
                return "-"; // Already submitted or past due
            }
            
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            try {
                Date due = format.parse(dueDate);
                Date now = new Date();
                
                long diffInMillies = due.getTime() - now.getTime();
                long diffInDays = diffInMillies / (24 * 60 * 60 * 1000);
                
                if (diffInDays < 0) {
                    return "Overdue";
                } else if (diffInDays == 0) {
                    return "Due today";
                } else if (diffInDays == 1) {
                    return "Due tomorrow";
                } else if (diffInDays < 7) {
                    return diffInDays + " days left";
                } else {
                    return (diffInDays / 7) + " weeks left";
                }
            } catch (Exception e) {
                // For demo, just return static values based on status
                if (status.equals("Upcoming")) {
                    return "2 weeks left";
                } else if (status.equals("In Progress")) {
                    return "3 days left";
                } else if (status.equals("Not Started")) {
                    return "5 days left";
                } else {
                    return "-";
                }
            }
        }
    }
    
    List<Assignment> assignments = new ArrayList<>();
    
    // CS101 Assignments
    assignments.add(new Assignment(
        "A1001", "CS101", "Python Basics Lab", 
        "Complete the Python exercises covering variables, control structures, and functions.",
        "2025-04-15", "2025-04-01", 50, 48, "Graded", 100,
        "python_basics_lab.zip", "Excellent work! Your code is clean and well-documented."
    ));
    
    assignments.add(new Assignment(
        "A1002", "CS101", "Functions & Classes Quiz", 
        "Online quiz covering functions, classes, and object-oriented programming concepts in Python.",
        "2025-04-22", "2025-04-15", 20, 18, "Graded", 100,
        null, "Good understanding of OOP concepts. Review inheritance."
    ));
    
    assignments.add(new Assignment(
        "A1003", "CS101", "Final Project: Simple Game", 
        "Develop a simple game in Python incorporating all concepts learned throughout the course.",
        "2025-05-15", "2025-04-25", 100, 0, "In Progress", 60,
        null, null
    ));
    
    // CS202 Assignments
    assignments.add(new Assignment(
        "A2001", "CS202", "ER Diagram Design", 
        "Create an Entity Relationship Diagram for an e-commerce database system.",
        "2025-04-10", "2025-03-25", 25, 25, "Graded", 100,
        "er_diagram.pdf", "Perfect design. Great work on normalization."
    ));
    
    assignments.add(new Assignment(
        "A2002", "CS202", "SQL Queries Lab", 
        "Complete the lab exercises on SQL queries including joins, aggregates, and subqueries.",
        "2025-04-20", "2025-04-10", 50, 40, "Graded", 100,
        "sql_queries.sql", "Good understanding of most concepts. Review complex joins."
    ));
    
    assignments.add(new Assignment(
        "A2003", "CS202", "Database Implementation Project", 
        "Implement a complete database system with frontend and backend connectivity.",
        "2025-05-08", "2025-04-15", 100, 0, "In Progress", 45,
        null, null
    ));
    
    // CS305 Assignments
    assignments.add(new Assignment(
        "A3001", "CS305", "HTML/CSS Portfolio", 
        "Create a personal portfolio website using HTML5 and CSS3.",
        "2025-04-05", "2025-03-20", 100, 95, "Graded", 100,
        "portfolio_website.zip", "Outstanding design and responsive implementation."
    ));
    
    assignments.add(new Assignment(
        "A3002", "CS305", "JavaScript Interactive Feature", 
        "Implement an interactive feature using JavaScript and DOM manipulation.",
        "2025-04-18", "2025-04-05", 50, 47, "Graded", 100,
        "interactive_feature.js", "Excellent use of event handling and DOM manipulation."
    ));
    
    assignments.add(new Assignment(
        "A3003", "CS305", "Full Stack Web Application", 
        "Develop a full stack web application with frontend, backend, and database integration.",
        "2025-05-12", "2025-04-20", 150, 0, "Not Started", 0,
        null, null
    ));
    
    // CS201 Assignments
    assignments.add(new Assignment(
        "A4001", "CS201", "Array Implementation", 
        "Implement basic array operations and analyze their efficiency.",
        "2025-04-08", "2025-03-25", 50, 45, "Graded", 100,
        "array_implementation.java", "Good implementation. Consider efficiency improvements."
    ));
    
    assignments.add(new Assignment(
        "A4002", "CS201", "Tree Traversal Lab", 
        "Implement and compare different tree traversal algorithms.",
        "2025-04-25", "2025-04-15", 40, 38, "Graded", 100,
        "tree_traversal.java", "Excellent implementation of all traversal methods."
    ));
    
    assignments.add(new Assignment(
        "A4003", "CS201", "Algorithm Analysis Report", 
        "Write a report analyzing the time and space complexity of different algorithms.",
        "2025-05-10", "2025-04-25", 75, 0, "Not Started", 0,
        null, null
    ));
    
    // Add one more upcoming assignment
    assignments.add(new Assignment(
        "A4004", "CS201", "Final Exam Preparation", 
        "Complete the practice problems to prepare for the final exam.",
        "2025-05-20", "2025-05-10", 25, 0, "Upcoming", 0,
        null, null
    ));
    
    // Calculate assignment statistics
    int totalAssignments = assignments.size();
    int completedAssignments = 0;
    int pendingAssignments = 0;
    int upcomingAssignments = 0;
    
    for (Assignment assignment : assignments) {
        if (assignment.status.equals("Graded") || assignment.status.equals("Submitted")) {
            completedAssignments++;
        } else if (assignment.status.equals("In Progress") || assignment.status.equals("Not Started") || assignment.status.equals("Late")) {
            pendingAssignments++;
        } else if (assignment.status.equals("Upcoming")) {
            upcomingAssignments++;
        }
    }
    
    // Calculate total points earned and available
    int totalEarnedPoints = 0;
    int totalAvailablePoints = 0;
    
    for (Assignment assignment : assignments) {
        if (assignment.status.equals("Graded")) {
            totalEarnedPoints += assignment.earnedPoints;
            totalAvailablePoints += assignment.maxPoints;
        }
    }
    
    double overallPerformance = totalAvailablePoints > 0 ? ((double) totalEarnedPoints / totalAvailablePoints) * 100 : 0;
    String formattedOverallPerformance = String.format("%.1f", overallPerformance);
    
    // Get filter from request parameter (default to all)
    String filter = request.getParameter("filter");
    if (filter == null) filter = "all";
    
    // Filter the assignments based on the selected filter
    List<Assignment> filteredAssignments = new ArrayList<>();
    for (Assignment assignment : assignments) {
        boolean include = false;
        
        switch(filter) {
            case "all":
                include = true;
                break;
            case "pending":
                include = assignment.status.equals("In Progress") || assignment.status.equals("Not Started");
                break;
            case "completed":
                include = assignment.status.equals("Graded") || assignment.status.equals("Submitted");
                break;
            case "upcoming":
                include = assignment.status.equals("Upcoming");
                break;
            case "late":
                include = assignment.status.equals("Late");
                break;
            default:
                include = assignment.courseCode.equals(filter);
                break;
        }
        
        if (include) {
            filteredAssignments.add(assignment);
        }
    }
    
    // Sort assignments by due date (most recent first)
    Collections.sort(filteredAssignments, new Comparator<Assignment>() {
        public int compare(Assignment a1, Assignment a2) {
            return a2.dueDate.compareTo(a1.dueDate);
        }
    });
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assignments - EduEnroll</title>
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
        .assignment-card {
            transition: transform 0.3s;
            margin-bottom: 1.25rem;
            border-left: 4px solid #0d6efd;
            border-radius: 8px;
            overflow: hidden;
        }
        .assignment-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
        }
        .due-date-badge {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
        }
        .border-primary {
            border-left-color: #0d6efd !important;
        }
        .border-success {
            border-left-color: #198754 !important;
        }
        .border-danger {
            border-left-color: #dc3545 !important;
        }
        .border-warning {
            border-left-color: #ffc107 !important;
        }
        .assignment-header {
            background: linear-gradient(135deg, #0d6efd 0%, #0dcaf0 100%);
            color: white;
            padding: 10px 20px;
            margin-bottom: 0;
            border-radius: 8px 8px 0 0;
        }
        .assignment-list-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
            padding: 10px 15px;
            font-weight: 600;
        }
        .filter-bar {
            background-color: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }
        .stats-card {
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        .progress-small {
            height: 8px;
        }
        .calendar-header {
            background: linear-gradient(135deg, #0d6efd 0%, #0dcaf0 100%);
            color: white;
            padding: 15px 20px;
            border-radius: 8px 8px 0 0;
        }
        .calendar-card {
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 20px;
        }
        .time-remaining {
            font-size: 0.8rem;
            color: #6c757d;
        }
        .time-critical {
            color: #dc3545;
            font-weight: bold;
        }
        .submission-dropzone {
            border: 2px dashed #dee2e6;
            padding: 25px;
            text-align: center;
            border-radius: 5px;
            background-color: #f8f9fa;
            cursor: pointer;
            transition: all 0.3s;
        }
        .submission-dropzone:hover {
            border-color: #0d6efd;
            background-color: rgba(13, 110, 253, 0.05);
        }
        .file-upload-icon {
            font-size: 2.5rem;
            color: #6c757d;
            margin-bottom: 15px;
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
                            <li><a class="dropdown-item" href="#">Assignment due soon: Web Development</a></li>
                            <li><a class="dropdown-item" href="#">New assignment posted: Database Systems</a></li>
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
                            <a class="nav-link" href="grades.jsp">
                                <i class="fas fa-graduation-cap me-2"></i>Grades
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="assignments.jsp">
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
                    <h1 class="h2">Assignments</h1>
                    <div class="text-end">
                        <div class="text-muted small">Current Date and Time: <%= currentDateTime %></div>
                        <div class="text-muted small">Department: <%= departmentName %>, Year: <%= loggedInStudent.getEnrollmentYear() %></div>
                    </div>
                </div>

                <!-- Assignment Stats -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card bg-primary text-white stats-card">
                            <div class="card-body text-center">
                                <h3 class="display-4"><%= totalAssignments %></h3>
                                <p class="mb-0">Total Assignments</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-success text-white stats-card">
                            <div class="card-body text-center">
                                <h3 class="display-4"><%= completedAssignments %></h3>
                                <p class="mb-0">Completed</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-warning text-white stats-card">
                            <div class="card-body text-center">
                                <h3 class="display-4"><%= pendingAssignments %></h3>
                                <p class="mb-0">Pending</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-info text-white stats-card">
                            <div class="card-body text-center">
                                <h3 class="display-4"><%= formattedOverallPerformance %>%</h3>
                                <p class="mb-0">Overall Score</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Filter and Search Bar -->
                <div class="filter-bar mb-4">
                    <div class="row g-3">
                        <div class="col-md-5">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-0"><i class="fas fa-search"></i></span>
                                <input type="text" class="form-control border-0 bg-light" placeholder="Search assignments..." id="assignmentSearch">
                            </div>
                        </div>
                        <div class="col-md-7">
                            <div class="d-flex justify-content-end">
                                <div class="btn-group" role="group">
                                    <a href="?filter=all" class="btn btn-outline-primary <%= filter.equals("all") ? "active" : "" %>">All</a>
                                    <a href="?filter=pending" class="btn btn-outline-primary <%= filter.equals("pending") ? "active" : "" %>">Pending</a>
                                    <a href="?filter=completed" class="btn btn-outline-primary <%= filter.equals("completed") ? "active" : "" %>">Completed</a>
                                    <a href="?filter=upcoming" class="btn btn-outline-primary <%= filter.equals("upcoming") ? "active" : "" %>">Upcoming</a>
                                    <a href="?filter=late" class="btn btn-outline-primary <%= filter.equals("late") ? "active" : "" %>">Late</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="d-flex flex-wrap">
                                <span class="me-2 mb-2">Filter by Course:</span>
                                <a href="?filter=all" class="badge bg-secondary me-2 mb-2 text-decoration-none">All</a>
                                <a href="?filter=CS101" class="badge bg-primary me-2 mb-2 text-decoration-none">CS101</a>
                                <a href="?filter=CS202" class="badge bg-success me-2 mb-2 text-decoration-none">CS202</a>
                                <a href="?filter=CS305" class="badge bg-danger me-2 mb-2 text-decoration-none">CS305</a>
                                <a href="?filter=CS201" class="badge bg-warning me-2 mb-2 text-decoration-none text-dark">CS201</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Assignment List -->
                <div class="calendar-card">
                    <div class="calendar-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-clipboard-list me-2"></i>Assignment List</h5>
                        <div class="dropdown">
                            <button class="btn btn-sm btn-light dropdown-toggle" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                                Sort by
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuButton">
                                <li><a class="dropdown-item" href="#">Due Date (Nearest First)</a></li>
                                <li><a class="dropdown-item" href="#">Due Date (Furthest First)</a></li>
                                <li><a class="dropdown-item" href="#">Course Code</a></li>
                                <li><a class="dropdown-item" href="#">Status</a></li>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="assignment-list-header">
                        <div class="row">
                            <div class="col-md-5">Assignment</div>
                            <div class="col-md-2">Due Date</div>
                            <div class="col-md-2">Status</div>
                            <div class="col-md-2">Score</div>
                            <div class="col-md-1">Action</div>
                        </div>
                    </div>
                    
                    <div class="list-group list-group-flush">
                        <% if (filteredAssignments.isEmpty()) { %>
                            <div class="list-group-item p-4 text-center text-muted">
                                <i class="fas fa-check-circle fa-3x mb-3"></i>
                                <h5>No assignments found</h5>
                                <p class="mb-0">There are no assignments matching your current filter criteria.</p>
                            </div>
                        <% } else { %>
                            <% for (Assignment assignment : filteredAssignments) { 
                                Course course = coursesMap.get(assignment.courseCode);
                                String borderClass = "border-" + course.color;
                                
                                String statusBadgeClass = "bg-secondary";
                                if (assignment.status.equals("Graded")) {
                                    statusBadgeClass = "bg-success";
                                } else if (assignment.status.equals("Submitted")) {
                                    statusBadgeClass = "bg-info";
                                } else if (assignment.status.equals("In Progress")) {
                                    statusBadgeClass = "bg-warning text-dark";
                                } else if (assignment.status.equals("Not Started")) {
                                    statusBadgeClass = "bg-light text-dark border";
                                } else if (assignment.status.equals("Late")) {
                                    statusBadgeClass = "bg-danger";
                                } else if (assignment.status.equals("Upcoming")) {
                                    statusBadgeClass = "bg-secondary";
                                }
                                
                                String timeRemainingClass = "";
                                if (assignment.status.equals("In Progress") || assignment.status.equals("Not Started")) {
                                    if (assignment.getTimeRemaining().equals("Due today") || 
                                        assignment.getTimeRemaining().equals("Overdue") || 
                                        assignment.getTimeRemaining().equals("1 days left") || 
                                        assignment.getTimeRemaining().equals("2 days left")) {
                                        timeRemainingClass = "time-critical";
                                    }
                                }
                            %>
                            <div class="list-group-item assignment-card <%= borderClass %>">
                                <div class="row align-items-center">
                                    <div class="col-md-5">
                                        <h5 class="mb-1">
                                            <span class="badge bg-<%= course.color %> me-2"><%= assignment.courseCode %></span>
                                            <%= assignment.title %>
                                        </h5>
                                        <p class="mb-0 small text-muted"><%= assignment.description.length() > 70 ? assignment.description.substring(0, 70) + "..." : assignment.description %></p>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="d-flex flex-column">
                                            <span class="badge bg-light text-dark due-date-badge mb-1"><%= assignment.dueDate %></span>
                                            <span class="time-remaining <%= timeRemainingClass %>"><%= assignment.getTimeRemaining() %></span>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <span class="badge <%= statusBadgeClass %> status-badge"><%= assignment.status %></span>
                                        <% if (!assignment.status.equals("Graded") && !assignment.status.equals("Upcoming") && !assignment.status.equals("Submitted")) { %>
                                            <div class="progress progress-small mt-2">
                                                <div class="progress-bar bg-<%= course.color %>" role="progressbar" style="width: <%= assignment.completionPercentage %>%" 
                                                     aria-valuenow="<%= assignment.completionPercentage %>" aria-valuemin="0" aria-valuemax="100"></div>
                                            </div>
                                        <% } %>
                                    </div>
                                    <div class="col-md-2">
                                        <% if (assignment.status.equals("Graded")) { %>
                                            <span class="fw-bold"><%= assignment.earnedPoints %>/<%= assignment.maxPoints %></span>
                                            <span class="ms-2">(<%= Math.round((double) assignment.earnedPoints / assignment.maxPoints * 100) %>%)</span>
                                        <% } else { %>
                                            <span class="text-muted">--/<%= assignment.maxPoints %></span>
                                        <% } %>
                                    </div>
                                    <div class="col-md-1 text-center">
                                        <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#assignmentModal<%= assignment.id %>">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                        <% } %>
                    </div>
                </div>

                <!-- Assignment Calendar View -->
                <div class="row mt-4">
                    <div class="col-md-8">
                        <div class="calendar-card">
                            <div class="calendar-header">
                                <h5 class="mb-0"><i class="fas fa-calendar-alt me-2"></i>Assignment Due Dates</h5>
                            </div>
                            <div class="card-body">
                                <div class="text-center">
                                    <!-- Calendar would be implemented here - just a placeholder for the design -->
                                    <img src="https://via.placeholder.com/800x400?text=Assignment+Calendar+View" class="img-fluid" alt="Assignment Calendar">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card dashboard-widget">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0"><i class="fas fa-clock me-2 text-primary"></i>Upcoming Deadlines</h5>
                            </div>
                            <div class="card-body p-0">
                                <ul class="list-group list-group-flush">
                                    <% 
                                    int upcomingCounter = 0;
                                    for (Assignment assignment : assignments) {
                                        if ((assignment.status.equals("In Progress") || assignment.status.equals("Not Started")) && upcomingCounter < 5) {
                                            upcomingCounter++;
                                            Course course = coursesMap.get(assignment.courseCode);
                                    %>
                                    <li class="list-group-item border-<%= course.color %> border-start border-3">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="mb-0"><%= assignment.title %></h6>
                                                <small class="text-muted"><%= assignment.courseCode %> - Due: <%= assignment.dueDate %></small>
                                            </div>
                                            <span class="time-remaining <%= assignment.getTimeRemaining().equals("Due today") || assignment.getTimeRemaining().equals("Overdue") || assignment.getTimeRemaining().equals("1 days left") ? "time-critical" : "" %>">
                                                <%= assignment.getTimeRemaining() %>
                                            </span>
                                        </div>
                                    </li>
                                    <% 
                                        }
                                    } 
                                    if (upcomingCounter == 0) {
                                    %>
                                    <li class="list-group-item text-center py-4">
                                        <i class="fas fa-check-circle text-success fa-2x mb-2"></i>
                                        <p class="mb-0">You're all caught up!</p>
                                        <small class="text-muted">No pending assignments right now.</small>
                                    </li>
                                    <% } %>
                                </ul>
                            </div>
                        </div>
                        
                        <div class="card dashboard-widget mt-4">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0"><i class="fas fa-chart-bar me-2 text-success"></i>Performance Summary</h5>
                            </div>
                            <div class="card-body">
                                <div class="d-flex justify-content-center mb-3">
                                    <div class="text-center">
                                        <div class="display-4 text-success"><%= formattedOverallPerformance %>%</div>
                                        <p class="text-muted mb-0">Overall Score</p>
                                    </div>
                                </div>
                                <hr>
                                <h6>Score by Course:</h6>
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between mb-1">
                                        <small>CS101 - Introduction to Programming</small>
                                        <small>92%</small>
                                    </div>
                                    <div class="progress progress-small">
                                        <div class="progress-bar bg-primary" style="width: 92%"></div>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between mb-1">
                                        <small>CS202 - Database Systems</small>
                                        <small>87%</small>
                                    </div>
                                    <div class="progress progress-small">
                                        <div class="progress-bar bg-success" style="width: 87%"></div>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between mb-1">
                                        <small>CS305 - Web Development</small>
                                        <small>95%</small>
                                    </div>
                                    <div class="progress progress-small">
                                        <div class="progress-bar bg-danger" style="width: 95%"></div>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between mb-1">
                                        <small>CS201 - Data Structures & Algorithms</small>
                                        <small>88%</small>
                                    </div>
                                    <div class="progress progress-small">
                                        <div class="progress-bar bg-warning" style="width: 88%"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Assignment Modals -->
    <% for (Assignment assignment : assignments) { 
        Course course = coursesMap.get(assignment.courseCode);
    %>
    <div class="modal fade" id="assignmentModal<%= assignment.id %>" tabindex="-1" aria-labelledby="assignmentModalLabel<%= assignment.id %>" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-<%= course.color %> text-white">
                    <h5 class="modal-title" id="assignmentModalLabel<%= assignment.id %>"><%= assignment.courseCode %>: <%= assignment.title %></h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <p class="mb-1"><strong>Course:</strong> <%= course.code %> - <%= course.name %></p>
                            <p class="mb-1"><strong>Instructor:</strong> <%= course.instructor %></p>
                            <p class="mb-1"><strong>Assigned Date:</strong> <%= assignment.assignedDate %></p>
                            <p class="mb-0"><strong>Due Date:</strong> <%= assignment.dueDate %></p>
                        </div>
                        <div class="col-md-6 text-md-end">
                            <div class="mb-2">
                                <span class="badge <%= assignment.status.equals("Graded") ? "bg-success" : assignment.status.equals("Submitted") ? "bg-info" : assignment.status.equals("In Progress") ? "bg-warning text-dark" : assignment.status.equals("Not Started") ? "bg-light text-dark border" : assignment.status.equals("Late") ? "bg-danger" : "bg-secondary" %> p-2">
                                    <%= assignment.status %>
                                </span>
                            </div>
                            <% if (assignment.status.equals("Graded")) { %>
                                <h4>Score: <%= assignment.earnedPoints %>/<%= assignment.maxPoints %> (<%= Math.round((double) assignment.earnedPoints / assignment.maxPoints * 100) %>%)</h4>
                            <% } else if (!assignment.status.equals("Upcoming")) { %>
                                <p class="mb-0 text-<%= assignment.getTimeRemaining().equals("Overdue") || assignment.getTimeRemaining().equals("Due today") ? "danger" : "muted" %>">
                                    <i class="fas fa-clock me-1"></i> <%= assignment.getTimeRemaining() %>
                                </p>
                            <% } %>
                        </div>
                    </div>
                    
                    <h6 class="mb-3">Description:</h6>
                    <div class="card mb-4">
                        <div class="card-body">
                            <p class="mb-0"><%= assignment.description %></p>
                        </div>
                    </div>
                    
                    <% if (assignment.status.equals("Graded") && assignment.feedback != null) { %>
                        <h6 class="mb-3">Instructor Feedback:</h6>
                        <div class="card mb-4">
                            <div class="card-body">
                                <p class="mb-0"><%= assignment.feedback %></p>
                            </div>
                        </div>
                    <% } %>
                    
                    <% if (assignment.status.equals("Graded") || assignment.status.equals("Submitted")) { %>
                        <h6 class="mb-3">Your Submission:</h6>
                        <div class="card mb-4">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <i class="fas fa-file-alt fa-2x me-3 text-primary"></i>
                                    <div>
                                        <h6 class="mb-0"><%= assignment.fileSubmission != null ? assignment.fileSubmission : "Online submission" %></h6>
                                        <small class="text-muted">Submitted on <%= assignment.dueDate %></small>
                                    </div>
                                    <a href="#" class="btn btn-sm btn-outline-primary ms-auto"><i class="fas fa-download me-2"></i>Download</a>
                                </div>
                            </div>
                        </div>
                    <% } else if (assignment.status.equals("In Progress") || assignment.status.equals("Not Started")) { %>
                        <h6 class="mb-3">Submit Your Work:</h6>
                        <div class="submission-dropzone mb-4">
                            <i class="fas fa-cloud-upload-alt file-upload-icon"></i>
                            <h5>Drag and drop files here</h5>
                            <p class="text-muted">or</p>
                            <button class="btn btn-primary">Browse Files</button>
                            <p class="text-muted small mt-2">Maximum file size: 10MB. Supported formats: PDF, DOC, DOCX, ZIP</p>
                        </div>
                        <div class="progress mb-2 d-none">
                            <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" style="width: 75%" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                    <% } %>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <% if (assignment.status.equals("In Progress") || assignment.status.equals("Not Started")) { %>
                        <button type="button" class="btn btn-primary">Submit Assignment</button>
                    <% } else if (assignment.status.equals("Submitted")) { %>
                        <button type="button" class="btn btn-warning">Update Submission</button>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <!-- Footer -->
    <footer class="bg-dark text-white text-center py-3 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-6 text-md-start">
                    <p class="mb-0">&copy; 2025 EduEnroll System. All rights reserved.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <p class="mb-0">
                        Student ID: <%= studentName %> | Current Date and Time: <%= currentDateTime %>
                    </p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Font Awesome for icons (updated to more reliable CDN) -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Assignment search functionality
            const searchInput = document.getElementById('assignmentSearch');
            if (searchInput) {
                searchInput.addEventListener('keyup', function() {
                    const filter = this.value.toUpperCase();
                    const assignmentCards = document.querySelectorAll('.assignment-card');
                    
                    assignmentCards.forEach(card => {
                        const title = card.querySelector('h5').textContent;
                        const description = card.querySelector('.small').textContent;
                        
                        if (title.toUpperCase().indexOf(filter) > -1 || description.toUpperCase().indexOf(filter) > -1) {
                            card.style.display = "";
                        } else {
                            card.style.display = "none";
                        }
                    });
                });
            }
        });
    </script>
</body>
</html>
