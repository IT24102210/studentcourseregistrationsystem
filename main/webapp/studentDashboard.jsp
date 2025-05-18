<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.StudentEnrollSystem.model.Student" %>
<%@ page import="com.StudentEnrollSystem.model.Assignment" %>
<%@ page import="com.StudentEnrollSystem.model.Message" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    // Get student from session (set by StudentLoginServlet or StudentSignupServlet)     session
    Student student = (Student) session.getAttribute("student");
    
    // If no student in session, try to get from parameter (for demo/testing)
    String studentName = request.getParameter("studentName");
    
    // Current date and time from request parameter or use default
    String currentDateTime = "2025-05-16 23:00:40";
    String currentUserLogin = "IT24103866";
    
    // The file path to the students.txt file
    String studentsFilePath = ("C:\\Users\\rasin\\Downloads\\project3\\StudentEnrollSystem\\src (9)\\src\\main\\webapp\\WEB-INF\\lib\\data\\students.txt");
    File studentsFile = new File(studentsFilePath);
    
    // If student not in session but name parameter provided, try to load from file
    if (student == null && studentName != null && !studentName.trim().isEmpty()) {
        try (BufferedReader reader = new BufferedReader(new FileReader(studentsFilePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",\\s*");
                if (parts.length >= 6) {
                    // Format: firstName lastName, studentName, password, email, department, enrollmentYear, [registrationTimestamp]
                    String[] names = parts[0].split(" ", 2);
                    String firstName = names[0];
                    String lastName = names.length > 1 ? names[1] : "";
                    String username = parts[1].trim();
                    
                    // If this is the student we're looking for
                    if (username.equals(studentName)) {
                        String password = parts[2];
                        String email = parts[3];
                        String department = parts[4];
                        String enrollmentYear = parts[5];
                        
                        // Check if registration timestamp exists
                        String registrationTimestamp = (parts.length >= 7) ? parts[6] : currentDateTime;
                        
                        // Create student object
                        student = new Student(username, firstName, lastName, email, password, department, enrollmentYear, registrationTimestamp);
                        
                        // Store in session for future use
                        session.setAttribute("student", student);
                        break;
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    // If still no student found, create a default one for demo
    if (student == null) {
        student = new Student();
        student.setStudentName("krishmal");
        student.setFirstName("Christopher");
        student.setLastName("Martin");
        student.setEmail("cmartin@example.com");
        student.setDepartment("computer_science");
        student.setEnrollmentYear("2024");
        student.setRegistrationTimestamp(currentDateTime);
    }
    
    // Format department name for display
    String departmentName = "";
    switch(student.getDepartment()) {
        case "computer_science": departmentName = "Computer Science"; break;
        case "engineering": departmentName = "Engineering"; break;
        case "business": departmentName = "Business"; break;
        case "arts": departmentName = "Arts & Humanities"; break;
        case "science": departmentName = "Science"; break;
        default: departmentName = student.getDepartment();
    }
    
    // Load courses from file
    String coursesFilePath = ("C:\\Users\\rasin\\Downloads\\project3\\StudentEnrollSystem\\src (9)\\src\\main\\webapp\\WEB-INF\\lib\\data\\courses.txt");
    List<Map<String, Object>> courses = new ArrayList<>();
    
    try (BufferedReader reader = new BufferedReader(new FileReader(coursesFilePath))) {
        String line;
        while ((line = reader.readLine()) != null) {
            line = line.trim();
            if (line.isEmpty()) continue;
            String[] parts = line.split("\\|");
            if (parts.length >= 4) {
                Map<String, Object> course = new HashMap<>();
                course.put("courseCode", parts[0].trim());
                course.put("title", parts[1].trim());
                course.put("day", parts[2].trim());
                course.put("time", parts[3].trim());
                course.put("enrolledStudents", parts.length > 4 ? Integer.parseInt(parts[4].trim()) : 0);
                course.put("instructor", "Prof. " + (parts.length > 5 ? parts[5].trim() : "Johnson"));
                course.put("progress", Math.random() * 100); // Random progress for demo
                course.put("gradeLetters", "Not Graded");
                courses.add(course);
            }
        }
    } catch (Exception e) {
        // If there's an error or no courses file, add mock data
        Map<String, Object> course1 = new HashMap<>();
        course1.put("courseCode", "CS101");
        course1.put("title", "Introduction to Programming");
        course1.put("day", "Monday/Wednesday");
        course1.put("time", "10:00-11:30");
        course1.put("enrolledStudents", 25);
        course1.put("instructor", "Prof. Johnson");
        course1.put("progress", 75);
        course1.put("gradeLetters", "Not Graded");
        
        Map<String, Object> course2 = new HashMap<>();
        course2.put("courseCode", "CS202");
        course2.put("title", "Database Systems");
        course2.put("day", "Tuesday/Thursday");
        course2.put("time", "13:00-14:30");
        course2.put("enrolledStudents", 20);
        course2.put("instructor", "Prof. Smith");
        course2.put("progress", 60);
        course2.put("gradeLetters", "Not Graded");
        
        Map<String, Object> course3 = new HashMap<>();
        course3.put("courseCode", "CS305");
        course3.put("title", "Web Development");
        course3.put("day", "Wednesday/Friday");
        course3.put("time", "15:00-16:30");
        course3.put("enrolledStudents", 30);
        course3.put("instructor", "Prof. Wilson");
        course3.put("progress", 85);
        course3.put("gradeLetters", "Not Graded");
        
        courses.add(course1);
        courses.add(course2);
        courses.add(course3);
    }
    
    // Load assignments
    String assignmentsFilePath = ("C:\\Users\\rasin\\Downloads\\project3\\StudentEnrollSystem\\src (9)\\src\\main\\webapp\\WEB-INF\\lib\\data\\assignments.txt");
    List<Map<String, Object>> assignments = new ArrayList<>();
    
    try (BufferedReader reader = new BufferedReader(new FileReader(assignmentsFilePath))) {
        String line;
        while ((line = reader.readLine()) != null) {
            line = line.trim();
            if (line.isEmpty()) continue;
            String[] parts = line.split("\\|");
            if (parts.length >= 9) {
                Map<String, Object> assignment = new HashMap<>();
                assignment.put("id", parts[0]);
                assignment.put("courseCode", parts[1]);
                assignment.put("title", parts[2]);
                assignment.put("description", parts[3]);
                assignment.put("dueDate", new Date(Long.parseLong(parts[4])));
                assignment.put("maxPoints", Integer.parseInt(parts[5]));
                assignment.put("teacherId", parts[6]);
                assignment.put("teacherName", parts[7]);
                assignment.put("status", "Not Submitted");
                
                // Get course title for this assignment
                for (Map<String, Object> course : courses) {
                    if (course.get("courseCode").equals(parts[1])) {
                        assignment.put("courseTitle", course.get("title"));
                        break;
                    }
                }
                
                assignments.add(assignment);
            }
        }
    } catch (Exception e) {
        // If there's an error or no assignments file, add mock data
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        
        try {
            Map<String, Object> assignment1 = new HashMap<>();
            assignment1.put("id", "ASG-001");
            assignment1.put("courseCode", "CS101");
            assignment1.put("title", "Programming Fundamentals Exercise");
            assignment1.put("description", "Complete exercises 1-10 on basic programming concepts.");
            assignment1.put("dueDate", sdf.parse("2025-05-23 23:59:00"));
            assignment1.put("maxPoints", 100);
            assignment1.put("teacherId", currentUserLogin);
            assignment1.put("teacherName", "Prof. Johnson");
            assignment1.put("status", "Not Submitted");
            assignment1.put("courseTitle", "Introduction to Programming");
            
            Map<String, Object> assignment2 = new HashMap<>();
            assignment2.put("id", "ASG-002");
            assignment2.put("courseCode", "CS202");
            assignment2.put("title", "Database Design Project");
            assignment2.put("description", "Create an ER diagram and implement it in SQL.");
            assignment2.put("dueDate", sdf.parse("2025-05-25 23:59:00"));
            assignment2.put("maxPoints", 100);
            assignment2.put("teacherId", currentUserLogin);
            assignment2.put("teacherName", "Prof. Smith");
            assignment2.put("status", "Not Submitted");
            assignment2.put("courseTitle", "Database Systems");
            
            assignments.add(assignment1);
            assignments.add(assignment2);
        } catch (Exception ex) {
            // In case of parsing error
            ex.printStackTrace();
        }
    }
    
    // Load messages
    List<Map<String, Object>> messages = new ArrayList<>();
    String messagesFilePath = ("C:\\Users\\rasin\\Downloads\\project3\\StudentEnrollSystem\\src (9)\\src\\main\\webapp\\WEB-INF\\lib\\data\\messages.txt");
    
    try (BufferedReader reader = new BufferedReader(new FileReader(messagesFilePath))) {
        String line;
        while ((line = reader.readLine()) != null) {
            line = line.trim();
            if (line.isEmpty()) continue;
            
            // Split by | and check if recipient matches current student
            String[] parts = line.split("\\|");
            if (parts.length >= 5 && parts[1].equals(student.getStudentName())) {
                Map<String, Object> message = new HashMap<>();
                message.put("id", parts[0]);
                message.put("recipient", parts[1]);
                message.put("sender", parts[2]);
                message.put("subject", parts[3]);
                message.put("content", parts[4]);
                message.put("timestamp", parts.length > 5 ? parts[5] : currentDateTime);
                message.put("read", false);
                
                messages.add(message);
            }
        }
    } catch (Exception e) {
        // If there's an error or no messages file, add mock data
        Map<String, Object> message1 = new HashMap<>();
        message1.put("id", "MSG-001");
        message1.put("recipient", student.getStudentName());
        message1.put("sender", "Prof. Johnson");
        message1.put("subject", "Important Assignment Update");
        message1.put("content", "The deadline for your programming assignment has been extended by 2 days. Please submit your work by the new due date.");
        message1.put("timestamp", currentDateTime);
        message1.put("read", false);
        
        Map<String, Object> message2 = new HashMap<>();
        message2.put("id", "MSG-002");
        message2.put("recipient", student.getStudentName());
        message2.put("sender", "Prof. Smith");
        message2.put("subject", "Database Project Feedback");
        message2.put("content", "Your preliminary database design looks good, but please add more details to the relationships between entities.");
        message2.put("timestamp", currentDateTime);
        message2.put("read", false);
        
        messages.add(message1);
        messages.add(message2);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - EduEnroll</title>
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
            z-index: 100;
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
        .course-card {
            transition: transform 0.3s;
            margin-bottom: 1rem;
            border-left: 4px solid #0d6efd;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .student-info {
            font-size: 0.9rem;
        }
        .navbar-top {
            background-color: #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .announcement-card {
            border-left: 4px solid #ffc107;
        }
        .event-card {
            border-left: 4px solid #dc3545;
        }
        .event-exam {
            border-left: 4px solid #dc3545;
        }
        .event-assignment {
            border-left: 4px solid #198754;
        }
        .event-event {
            border-left: 4px solid #0dcaf0;
        }
        .dashboard-widget {
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: transform 0.3s;
        }
        .dashboard-widget:hover {
            transform: translateY(-5px);
        }
        .quick-stats {
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .stat-item {
            padding: 15px;
            border-radius: 8px;
        }
        .date-display {
            font-size: 0.85rem;
            color: #6c757d;
        }
        .progress {
            height: 10px;
        }
        .navbar-brand {
            font-weight: 700;
        }
        .cs-count {
            font-size: 2.5rem;
            font-weight: bold;
        }
        .registration-time {
            font-size: 0.9rem;
            background-color: rgba(0, 123, 255, 0.15);
            padding: 4px 8px;
            border-radius: 4px;
            display: inline-block;
        }
        .message-card {
            border-left: 4px solid #0d6efd;
            transition: all 0.3s;
        }
        .message-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .message-card.unread {
            background-color: #f0f7ff;
        }
        .unread-badge {
            position: absolute;
            top: 10px;
            right: 10px;
        }
        .assignment-card {
            border-left: 4px solid #198754;
            transition: all 0.3s;
        }
        .assignment-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .status-badge {
            position: absolute;
            top: 10px;
            right: 10px;
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }
        
        /* Mobile responsive fixes */
        @media (max-width: 767.98px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }
            .main-content {
                margin-left: 0;
            }
            .sidebar .nav-link {
                display: block;
            }
            .col-md-4, .col-md-8, .col-md-6 {
                margin-bottom: 20px;
            }
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
                    <span class="nav-link"><i class="fas fa-user-circle me-2"></i>Student ID: <%= student.getStudentName() %></span>
                </div>
                <div class="navbar-nav">
                    <div class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-bell me-2"></i>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                <%= messages.size() %>
                            </span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                            <li><h6 class="dropdown-header">Notifications</h6></li>
                            <% for (Map<String, Object> message : messages) { %>
                                <li><a class="dropdown-item" href="#" data-message-id="<%= message.get("id") %>">
                                    New message: <%= message.get("subject") %>
                                </a></li>
                            <% } %>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="#" onclick="switchTab('messages')">View all messages</a></li>
                        </ul>
                    </div>
                    <div class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user-circle me-2"></i><%= student.getFirstName() %> <%= student.getLastName() %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="#" onclick="switchTab('profile')"><i class="fas fa-user me-2"></i>My Profile</a></li>
                            <li><a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i>Account Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="index.jsp"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
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
                            <%= student.getFirstName().charAt(0) %><%= student.getLastName().charAt(0) %>
                        </div>
                        <h6 class="text-white"><%= student.getFirstName() %> <%= student.getLastName() %></h6>
                        <p class="text-light small"><%= student.getStudentName() %></p>
                        <% if(student.getRegistrationTimestamp() != null) { %>
                            <p class="text-light small">Registered: <span class="badge bg-info"><%= student.getRegistrationTimestamp() %></span></p>
                        <% } %>
                    </div>
                    <hr class="bg-light">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="#dashboard" onclick="return switchTab('dashboard');">
                                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#myCourses" onclick="return switchTab('myCourses');">
                                <i class="fas fa-book me-2"></i>My Courses
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#assignments" onclick="return switchTab('assignments');">
                                <i class="fas fa-tasks me-2"></i>Assignments
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#messages" onclick="return switchTab('messages');">
                                <i class="fas fa-envelope me-2"></i>Messages
                                <span class="badge bg-danger"><%= messages.size() %></span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#profile" onclick="return switchTab('profile');">
                                <i class="fas fa-user-cog me-2"></i>Profile
                            </a>
                        </li>
                    </ul>
                    <hr class="bg-light">
                    <div class="d-grid gap-2 px-3">
                        <a href="index.jsp" class="btn btn-danger">
                            <i class="fas fa-sign-out-alt me-2"></i>Logout
                        </a>
                    </div>
                    
                    <div class="text-center mt-5 px-3">
                        <p class="text-light small mb-1">Current Date and Time:</p>
                        <p class="text-light small"><%= currentDateTime %></p>
                        <p class="text-light small mb-1">User Login:</p>
                        <p class="text-light small"><%= currentUserLogin %></p>
                    </div>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <!-- Dashboard Tab -->
                <div class="tab-content active" id="dashboard">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Dashboard</h1>
                        <div class="text-end">
                            <div class="text-muted small">Current Date and Time: <%= currentDateTime %></div>
                            <div class="text-muted small">Department: <%= departmentName %>, Year: <%= student.getEnrollmentYear() %></div>
                        </div>
                    </div>

                    <!-- Welcome Section -->
                    <div class="alert alert-info mb-4">
                        <h4>Welcome, <%= student.getFirstName() %>!</h4>
                        <p class="mb-0">You've successfully logged into your student dashboard. Here you can view your courses, assignments, and messages from your instructors.</p>
                    </div>

                    <!-- Quick Stats Section -->
                    <div class="row quick-stats mb-4">
                        <div class="col-md-4 mb-3 mb-md-0">
                            <div class="stat-item bg-primary bg-opacity-10 text-center">
                                <div class="text-primary mb-1"><i class="fas fa-book fa-2x"></i></div>
                                <div class="cs-count text-primary"><%= courses.size() %></div>
                                <div class="text-muted">Enrolled Courses</div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3 mb-md-0">
                            <div class="stat-item bg-success bg-opacity-10 text-center">
                                <div class="text-success mb-1"><i class="fas fa-tasks fa-2x"></i></div>
                                <div class="cs-count text-success"><%= assignments.size() %></div>
                                <div class="text-muted">Current Assignments</div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="stat-item bg-warning bg-opacity-10 text-center">
                                <div class="text-warning mb-1"><i class="fas fa-envelope fa-2x"></i></div>
                                <div class="cs-count text-warning"><%= messages.size() %></div>
                                <div class="text-muted">Unread Messages</div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <!-- Course Overview Section -->
                        <div class="col-lg-8">
                            <div class="card dashboard-widget mb-4">
                                <div class="card-header bg-white">
                                    <h5 class="card-title mb-0"><i class="fas fa-book me-2 text-primary"></i>My Courses</h5>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Code</th>
                                                    <th>Course</th>
                                                    <th>Instructor</th>
                                                    <th>Schedule</th>
                                                    <th>Progress</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% for(Map<String, Object> course : courses) { %>
                                                <tr>
                                                    <td><span class="badge bg-primary"><%= course.get("courseCode") %></span></td>
                                                    <td><strong><%= course.get("title") %></strong></td>
                                                    <td><%= course.get("instructor") %></td>
                                                    <td><%= course.get("day") %> at <%= course.get("time") %></td>
                                                    <td>
                                                        <div class="progress">
                                                            <div class="progress-bar bg-success" role="progressbar" 
                                                                style="width: <%= course.get("progress") %>%" 
                                                                aria-valuenow="<%= course.get("progress") %>" 
                                                                aria-valuemin="0" aria-valuemax="100">
                                                            </div>
                                                        </div>
                                                        <small class="text-muted"><%= course.get("progress") %>% Complete</small>
                                                    </td>
                                                </tr>
                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="text-end">
                                        <button class="btn btn-outline-primary btn-sm" onclick="switchTab('myCourses')">View All Courses</button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Upcoming Assignments Section -->
                            <div class="card dashboard-widget">
                                <div class="card-header bg-white">
                                    <h5 class="card-title mb-0"><i class="fas fa-tasks me-2 text-success"></i>Upcoming Assignments</h5>
                                </div>
                                <div class="card-body">
                                    <% if(assignments.isEmpty()) { %>
                                        <p class="text-center text-muted">No upcoming assignments at this time.</p>
                                    <% } else { %>
                                        <div class="table-responsive">
                                            <table class="table table-hover">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Course</th>
                                                        <th>Assignment</th>
                                                        <th>Due Date</th>
                                                        <th>Status</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <% for(Map<String, Object> assignment : assignments) { 
                                                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                                                        String dueDate = sdf.format(assignment.get("dueDate"));
                                                    %>
                                                    <tr>
                                                        <td><span class="badge bg-primary"><%= assignment.get("courseCode") %></span></td>
                                                        <td><strong><%= assignment.get("title") %></strong></td>
                                                        <td><%= dueDate %></td>
                                                        <td><span class="badge bg-warning"><%= assignment.get("status") %></span></td>
                                                        <td>
                                                            <button class="btn btn-sm btn-outline-primary" onclick="viewAssignment('<%= assignment.get("id") %>')">
                                                                View
                                                            </button>
                                                            <button class="btn btn-sm btn-success" onclick="switchTab('assignments'); showSubmissionForm('<%= assignment.get("id") %>')">
                                                                Submit
                                                            </button>
                                                        </td>
                                                    </tr>
                                                    <% } %>
                                                </tbody>
                                            </table>
                                        </div>
                                        <div class="text-end">
                                            <button class="btn btn-outline-success btn-sm" onclick="switchTab('assignments')">View All Assignments</button>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Messages Section -->
                        <div class="col-lg-4">
                            <div class="card dashboard-widget mb-4">
                                <div class="card-header bg-white">
                                    <h5 class="card-title mb-0"><i class="fas fa-envelope me-2 text-primary"></i>Recent Messages</h5>
                                </div>
                                <div class="card-body p-0">
                                    <% if(messages.isEmpty()) { %>
                                        <div class="text-center p-4">
                                            <i class="fas fa-envelope fa-3x text-muted mb-3"></i>
                                            <p class="text-muted">No messages yet.</p>
                                        </div>
                                    <% } else { %>
                                        <ul class="list-group list-group-flush">
                                            <% for(Map<String, Object> message : messages) { %>
                                                <li class="list-group-item message-card position-relative">
                                                    <% if(!(Boolean)message.get("read")) { %>
                                                        <span class="unread-badge badge rounded-pill bg-danger">New</span>
                                                    <% } %>
                                                    <h6 class="mb-1"><%= message.get("subject") %></h6>
                                                    <p class="mb-1 small text-truncate"><%= message.get("content") %></p>
                                                    <div class="d-flex justify-content-between">
                                                        <small class="text-muted">From: <%= message.get("sender") %></small>
                                                        <small class="text-muted"><%= message.get("timestamp") %></small>
                                                    </div>
                                                    <a href="#" class="stretched-link" onclick="event.preventDefault(); switchTab('messages'); viewMessage('<%= message.get("id") %>')"></a>
                                                </li>
                                            <% } %>
                                        </ul>
                                    <% } %>
                                    <div class="card-footer bg-white">
                                        <div class="d-grid">
                                            <button class="btn btn-outline-primary btn-sm" onclick="switchTab('messages')">View All Messages</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Student Profile Card -->
                            <div class="card dashboard-widget">
                                <div class="card-header bg-white">
                                    <h5 class="card-title mb-0"><i class="fas fa-user-circle me-2 text-primary"></i>My Profile</h5>
                                </div>
                                <div class="card-body">
                                    <ul class="list-group list-group-flush">
                                        <li class="list-group-item d-flex justify-content-between">
                                            <span>Student ID:</span>
                                            <span class="fw-bold"><%= student.getStudentName() %></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between">
                                            <span>Name:</span>
                                            <span class="fw-bold"><%= student.getFirstName() %> <%= student.getLastName() %></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between">
                                            <span>Department:</span>
                                            <span class="fw-bold"><%= departmentName %></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between">
                                            <span>Year:</span>
                                            <span class="fw-bold"><%= student.getEnrollmentYear() %></span>
                                        </li>
                                        <% if(student.getRegistrationTimestamp() != null) { %>
                                            <li class="list-group-item d-flex justify-content-between">
                                                <span>Registration:</span>
                                                <span class="registration-time"><%= student.getRegistrationTimestamp() %></span>
                                            </li>
                                        <% } %>
                                    </ul>
                                    <div class="d-grid mt-3">
                                        <button class="btn btn-outline-primary btn-sm" onclick="switchTab('profile')">Edit Profile</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- My Courses Tab -->
                <div class="tab-content" id="myCourses">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">My Courses</h1>
                        <div class="text-end">
                            <div class="text-muted small">Current Date and Time: <%= currentDateTime %></div>
                        </div>
                    </div>
                    
                    <div class="card mb-4">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">Enrolled Courses</h5>
                        </div>
                        <div class="card-body">
                            <% if(courses.isEmpty()) { %>
                                <p class="text-center text-muted">You are not enrolled in any courses yet.</p>
                            <% } else { %>
                                <div class="row">
                                    <% for(Map<String, Object> course : courses) { %>
                                        <div class="col-md-6 mb-4">
                                            <div class="card course-card h-100">
                                                <div class="card-body">
                                                    <h5 class="card-title"><%= course.get("courseCode") %>: <%= course.get("title") %></h5>
                                                    <h6 class="card-subtitle mb-2 text-muted"><%= course.get("instructor") %></h6>
                                                    <p class="card-text"><strong>Schedule:</strong> <%= course.get("day") %> at <%= course.get("time") %></p>
                                                    
                                                    <div class="mb-3">
                                                        <small class="text-muted">Progress:</small>
                                                        <div class="progress">
                                                            <div class="progress-bar bg-success" role="progressbar" 
                                                                style="width: <%= course.get("progress") %>%" 
                                                                aria-valuenow="<%= course.get("progress") %>" 
                                                                aria-valuemin="0" aria-valuemax="100">
                                                            </div>
                                                        </div>
                                                        <small class="text-muted"><%= course.get("progress") %>% Complete</small>
                                                    </div>
                                                    
                                                    <div class="d-flex justify-content-between">
                                                        <span class="badge bg-primary"><%= course.get("enrolledStudents") %> Students</span>
                                                        <span class="badge bg-success"><%= course.get("gradeLetters") %></span>
                                                    </div>
                                                </div>
                                                <div class="card-footer bg-white">
                                                    <div class="d-flex justify-content-between">
                                                        <button class="btn btn-sm btn-outline-primary">View Materials</button>
                                                        <button class="btn btn-sm btn-outline-success">View Assignments</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
                
                <!-- Assignments Tab -->
                <div class="tab-content" id="assignments">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Assignments</h1>
                        <div class="text-end">
                            <div class="text-muted small">Current Date and Time: <%= currentDateTime %></div>
                        </div>
                    </div>
                    
                    <div class="card mb-4">
                        <div class="card-header bg-white">
                            <div class="d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Current Assignments</h5>
                                <div>
                                    <select class="form-select form-select-sm" id="assignmentFilterSelect">
                                        <option value="all">All Assignments</option>
                                        <option value="submitted">Submitted</option>
                                        <option value="pending">Pending</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <% if(assignments.isEmpty()) { %>
                                <p class="text-center text-muted">No assignments available at this time.</p>
                            <% } else { %>
                                <div class="row" id="assignmentsContainer">
                                    <% for(Map<String, Object> assignment : assignments) { 
                                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                                        String dueDate = sdf.format(assignment.get("dueDate"));
                                    %>
                                        <div class="col-md-6 mb-4 assignment-item" data-status="<%= assignment.get("status") %>">
                                            <div class="card assignment-card h-100 position-relative">
                                                <% if(assignment.get("status").equals("Not Submitted")) { %>
                                                    <span class="status-badge badge rounded-pill bg-warning">Not Submitted</span>
                                                <% } else { %>
                                                    <span class="status-badge badge rounded-pill bg-success">Submitted</span>
                                                <% } %>
                                                <div class="card-body">
                                                    <h5 class="card-title"><%= assignment.get("title") %></h5>
                                                    <h6 class="card-subtitle mb-2 text-muted">
                                                        <%= assignment.get("courseCode") %>: <%= assignment.get("courseTitle") %>
                                                    </h6>
                                                    <p class="card-text"><%= assignment.get("description") %></p>
                                                    
                                                    <div class="mb-3">
                                                        <small class="text-muted">Due Date: <%= dueDate %></small><br>
                                                        <small class="text-muted">Instructor: <%= assignment.get("teacherName") %></small><br>
                                                        <small class="text-muted">Max Points: <%= assignment.get("maxPoints") %></small>
                                                    </div>
                                                </div>
                                                <div class="card-footer bg-white">
                                                    <div class="d-grid gap-2">
                                                        <button class="btn btn-success" onclick="showSubmissionForm('<%= assignment.get("id") %>')">
                                                            <i class="fas fa-upload me-2"></i>Submit Assignment
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                    
                    <!-- Assignment Submission Modal -->
                    <div class="modal fade" id="assignmentSubmissionModal" tabindex="-1" aria-labelledby="submissionModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header bg-success text-white">
                                    <h5 class="modal-title" id="submissionModalLabel">Submit Assignment</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="assignmentSubmissionForm">
                                        <input type="hidden" id="submissionAssignmentId" name="assignmentId" value="">
                                        <input type="hidden" name="studentId" value="<%= student.getStudentName() %>">
                                        <input type="hidden" name="submissionDate" value="<%= currentDateTime %>">
                                        
                                        <div class="mb-3">
                                            <label for="submissionTitle" class="form-label">Assignment Title</label>
                                            <input type="text" class="form-control" id="submissionTitle" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label for="submissionCourse" class="form-label">Course</label>
                                            <input type="text" class="form-control" id="submissionCourse" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label for="submissionComment" class="form-label">Comments</label>
                                            <textarea class="form-control" id="submissionComment" name="comment" rows="3" placeholder="Add any comments about your submission"></textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label for="submissionFile" class="form-label">Upload Files</label>
                                            <input class="form-control" type="file" id="submissionFile" name="submissionFile" multiple>
                                            <div class="form-text">Upload your assignment files here. Allowed file types: PDF, DOC, DOCX, ZIP, etc.</div>
                                        </div>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    <button type="button" class="btn btn-success" id="submitAssignmentBtn">Submit Assignment</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Messages Tab -->
                <div class="tab-content" id="messages">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Messages</h1>
                        <div class="text-end">
                            <div class="text-muted small">Current Date and Time: <%= currentDateTime %></div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-4">
                            <div class="card mb-4">
                                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">My Messages</h5>
                                    <span class="badge bg-danger"><%= messages.size() %> unread</span>
                                </div>
                                <div class="card-body p-0">
                                    <div class="list-group list-group-flush" id="messagesList">
                                        <% if(messages.isEmpty()) { %>
                                            <div class="text-center p-4">
                                                <i class="fas fa-envelope fa-3x text-muted mb-3"></i>
                                                <p class="text-muted">No messages yet.</p>
                                            </div>
                                        <% } else { 
                                            for(Map<String, Object> message : messages) { %>
                                                <a href="#" class="list-group-item list-group-item-action message-item" 
                                                   onclick="event.preventDefault(); viewMessage('<%= message.get("id") %>')"
                                                   data-message-id="<%= message.get("id") %>">
                                                    <div class="d-flex justify-content-between">
                                                        <strong><%= message.get("subject") %></strong>
                                                        <% if(!(Boolean)message.get("read")) { %>
                                                            <span class="badge bg-danger rounded-pill">New</span>
                                                        <% } %>
                                                    </div>
                                                    <p class="mb-1 small text-truncate"><%= message.get("content") %></p>
                                                    <div class="d-flex justify-content-between">
                                                        <small class="text-muted">From: <%= message.get("sender") %></small>
                                                        <small class="text-muted"><%= message.get("timestamp") %></small>
                                                    </div>
                                                </a>
                                            <% }
                                        } %>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header bg-white">
                                    <h5 class="mb-0" id="messageViewTitle">Select a message to view</h5>
                                </div>
                                <div class="card-body" id="messageViewBody">
                                    <div class="text-center p-5">
                                        <i class="fas fa-envelope-open fa-4x text-muted mb-3"></i>
                                        <p class="text-muted">Select a message from the list to view its contents.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Profile Tab -->
                <div class="tab-content" id="profile">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">My Profile</h1>
                        <div class="text-end">
                            <div class="text-muted small">Current Date and Time: <%= currentDateTime %></div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-4">
                            <div class="card mb-4">
                                <div class="card-body text-center">
                                    <div class="profile-avatar mx-auto">
                                        <%= student.getFirstName().charAt(0) %><%= student.getLastName().charAt(0) %>
                                    </div>
                                    <h5 class="my-3"><%= student.getFirstName() %> <%= student.getLastName() %></h5>
                                    <p class="text-muted mb-1"><%= departmentName %></p>
                                    <p class="text-muted mb-4">Student ID: <%= student.getStudentName() %></p>
                                </div>
                            </div>
                            <div class="card mb-4">
                                <div class="card-header bg-white">
                                    <h5 class="mb-0">Academic Information</h5>
                                </div>
                                <div class="card-body">
                                    <ul class="list-group list-group-flush">
                                        <li class="list-group-item d-flex justify-content-between">
                                            <span>Department:</span>
                                            <span class="fw-bold"><%= departmentName %></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between">
                                            <span>Enrollment Year:</span>
                                            <span class="fw-bold"><%= student.getEnrollmentYear() %></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between">
                                            <span>Enrolled Courses:</span>
                                            <span class="fw-bold"><%= courses.size() %></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between">
                                            <span>Academic Status:</span>
                                            <span class="badge bg-success">Active</span>
                                        </li>
                                        <% if(student.getRegistrationTimestamp() != null) { %>
                                            <li class="list-group-item d-flex justify-content-between">
                                                <span>Registration:</span>
                                                <span class="registration-time"><%= student.getRegistrationTimestamp() %></span>
                                            </li>
                                        <% } %>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-8">
                            <div class="card mb-4">
                                <div class="card-header bg-white">
                                    <h5 class="mb-0">Personal Information</h5>
                                </div>
                                <div class="card-body">
                                    <form>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label" for="firstName">First Name</label>
                                                    <input type="text" id="firstName" class="form-control" value="<%= student.getFirstName() %>">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label" for="lastName">Last Name</label>
                                                    <input type="text" id="lastName" class="form-control" value="<%= student.getLastName() %>">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label" for="email">Email</label>
                                            <input type="email" id="email" class="form-control" value="<%= student.getEmail() %>">
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label" for="department">Department</label>
                                            <select class="form-select" id="department">
                                                <option value="computer_science" <%= student.getDepartment().equals("computer_science") ? "selected" : "" %>>Computer Science</option>
                                                <option value="engineering" <%= student.getDepartment().equals("engineering") ? "selected" : "" %>>Engineering</option>
                                                <option value="business" <%= student.getDepartment().equals("business") ? "selected" : "" %>>Business</option>
                                                <option value="arts" <%= student.getDepartment().equals("arts") ? "selected" : "" %>>Arts & Humanities</option>
                                                <option value="science" <%= student.getDepartment().equals("science") ? "selected" : "" %>>Science</option>
                                            </select>
                                        </div>
                                        <div class="d-grid gap-2">
                                            <button type="submit" class="btn btn-primary">Update Profile</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            
                            <div class="card">
                                <div class="card-header bg-white">
                                    <h5 class="mb-0">Change Password</h5>
                                </div>
                                <div class="card-body">
                                    <form>
                                        <div class="mb-3">
                                            <label class="form-label" for="currentPassword">Current Password</label>
                                            <input type="password" id="currentPassword" class="form-control">
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label" for="newPassword">New Password</label>
                                            <input type="password" id="newPassword" class="form-control">
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label" for="confirmPassword">Confirm New Password</label>
                                            <input type="password" id="confirmPassword" class="form-control">
                                        </div>
                                        <div class="d-grid gap-2">
                                            <button type="submit" class="btn btn-primary">Change Password</button>
                                        </div>
                                    </form>
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
                <div class="col-md-6 text-md-start">
                    <p class="mb-0">&copy; 2025 EduEnroll System. All rights reserved.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <p class="mb-0 date-display">
                        Current Date and Time: <%= currentDateTime %>
                    </p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Font Awesome for icons -->
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    
    <script>
        // Tab switching function - FIXED
        function switchTab(tabId) {
            // Hide all tab contents
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
            });
            
            // Show the selected tab content
            document.getElementById(tabId).classList.add('active');
            
            // Update active nav item - FIXED SELECTOR
            document.querySelectorAll('.nav-link').forEach(link => {
                link.classList.remove('active');
            });
            
            // Find the nav link that points to this tab and make it active - FIXED SELECTOR
            const activeNavLink = document.querySelector(`.nav-link[href="#${tabId}"]`);
            if (activeNavLink) {
                activeNavLink.classList.add('active');
            }
            
            // Close mobile menu if open
            const sidebar = document.getElementById('sidebarMenu');
            if (sidebar && sidebar.classList.contains('show')) {
                sidebar.classList.remove('show');
            }
            
            return false;
        }
        
        // Message viewing function
        function viewMessage(messageId) {
            // In a real application, this would fetch message details from the server
            // For demo purposes, we'll just update based on the messages array
            
            // Find the message in your data
            const messages = [
                <% for(Map<String, Object> message : messages) { %>
                {
                    id: "<%= message.get("id") %>",
                    subject: "<%= message.get("subject") %>",
                    content: "<%= message.get("content") %>",
                    sender: "<%= message.get("sender") %>",
                    timestamp: "<%= message.get("timestamp") %>"
                },
                <% } %>
            ];
            
            const message = messages.find(m => m.id === messageId);
            
            if (message) {
                // Update the message view
                document.getElementById('messageViewTitle').textContent = message.subject;
                
                const messageBody = document.getElementById('messageViewBody');
                messageBody.innerHTML = `
                    <div class="card mb-3">
                        <div class="card-body bg-light">
                            <div class="row mb-2">
                                <div class="col-md-6">
                                    <strong>From:</strong> ${message.sender}
                                </div>
                                <div class="col-md-6 text-md-end">
                                    <strong>Date:</strong> ${message.timestamp}
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="message-content">
                        <p>${message.content}</p>
                    </div>
                    <div class="mt-4">
                        <button class="btn btn-outline-primary">
                            <i class="fas fa-reply"></i> Reply
                        </button>
                        <button class="btn btn-outline-danger ms-2">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </div>
                `;
                
                // Mark the message as read in the UI
                const messageItem = document.querySelector(`.message-item[data-message-id="${messageId}"]`);
                if (messageItem) {
                    messageItem.classList.add('active');
                    messageItem.querySelector('.badge')?.remove();
                }
            }
        }
        
        // Assignment viewing function
        function viewAssignment(assignmentId) {
            // Redirect to assignment view page
            // In a real app, this would navigate to a detailed view
            alert("Viewing assignment: " + assignmentId);
        }
        
        // Show assignment submission form
        function showSubmissionForm(assignmentId) {
            // Find the assignment details
            const assignments = [
                                <% for(Map<String, Object> assignment : assignments) { %>
                {
                    id: "<%= assignment.get("id") %>",
                    title: "<%= assignment.get("title") %>",
                    courseCode: "<%= assignment.get("courseCode") %>",
                    courseTitle: "<%= assignment.get("courseTitle") %>"
                },
                <% } %>
            ];
            
            const assignment = assignments.find(a => a.id === assignmentId);
            
            if (assignment) {
                // Populate the modal form
                document.getElementById('submissionAssignmentId').value = assignment.id;
                document.getElementById('submissionTitle').value = assignment.title;
                document.getElementById('submissionCourse').value = `${assignment.courseCode}: ${assignment.courseTitle}`;
                
                // Show the modal using Bootstrap 5 API
                const submissionModal = new bootstrap.Modal(document.getElementById('assignmentSubmissionModal'));
                submissionModal.show();
            }
        }
        
        // FIXED - properly initialize event handlers when DOM is loaded
        document.addEventListener('DOMContentLoaded', function() {
            // Current date and time display - UPDATED as requested
            const currentDateTime = "2025-05-16 23:06:51";
            const currentUserLogin = "IT24103866";
            console.log(`Student Dashboard initialized at ${currentDateTime} for user ${currentUserLogin}`);
            
            // FIXED - First add proper event listeners to all navbar links
            document.querySelectorAll('.nav-link').forEach(link => {
                link.addEventListener('click', function(event) {
                    if (this.getAttribute('href') && this.getAttribute('href').startsWith('#')) {
                        event.preventDefault();
                        const targetId = this.getAttribute('href').substring(1);
                        switchTab(targetId);
                    }
                });
            });
            
            // Assignment submission handler
            const submitAssignmentBtn = document.getElementById('submitAssignmentBtn');
            if (submitAssignmentBtn) {
                submitAssignmentBtn.addEventListener('click', function() {
                    // Get form data
                    const assignmentId = document.getElementById('submissionAssignmentId').value;
                    const comment = document.getElementById('submissionComment').value;
                    const files = document.getElementById('submissionFile').files;
                    
                    // Validate form
                    if (files.length === 0) {
                        alert("Please attach at least one file for your submission.");
                        return;
                    }
                    
                    // In a real application, this would send the submission to the server
                    // For demo purposes, we'll just show a success message
                    alert("Assignment submitted successfully!");
                    
                    // Update the UI to show the assignment as submitted
                    const assignmentCard = document.querySelector(`.assignment-item[data-status="Not Submitted"] .card`);
                    if (assignmentCard) {
                        const statusBadge = assignmentCard.querySelector('.status-badge');
                        if (statusBadge) {
                            statusBadge.textContent = "Submitted";
                            statusBadge.classList.remove('bg-warning');
                            statusBadge.classList.add('bg-success');
                        }
                        assignmentCard.parentNode.dataset.status = "Submitted";
                    }
                    
                    // Close the modal - FIXED Bootstrap 5 API call
                    const modal = bootstrap.Modal.getInstance(document.getElementById('assignmentSubmissionModal'));
                    if (modal) {
                        modal.hide();
                    }
                });
            }
            
            // Assignment filter
            const filterSelect = document.getElementById('assignmentFilterSelect');
            if (filterSelect) {
                filterSelect.addEventListener('change', function() {
                    const status = this.value;
                    const assignments = document.querySelectorAll('.assignment-item');
                    
                    assignments.forEach(assignment => {
                        if (status === 'all' || 
                          (status === 'submitted' && assignment.dataset.status === 'Submitted') ||
                          (status === 'pending' && assignment.dataset.status === 'Not Submitted')) {
                            assignment.style.display = 'block';
                        } else {
                            assignment.style.display = 'none';
                        }
                    });
                });
            }
            
            // Fix for mobile sidebar toggle - UPDATED
            const toggler = document.querySelector('.navbar-toggler');
            const sidebar = document.getElementById('sidebarMenu');
            
            if (toggler && sidebar) {
                toggler.addEventListener('click', function() {
                    if (sidebar.classList.contains('show')) {
                        sidebar.classList.remove('show');
                    } else {
                        sidebar.classList.add('show');
                    }
                });
            }
            
            // FIXED - Properly initialize Bootstrap components
            // Initialize tooltips
            const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
            if (tooltipTriggerList.length > 0) {
                tooltipTriggerList.forEach(tooltipTriggerEl => {
                    new bootstrap.Tooltip(tooltipTriggerEl);
                });
            }
            
            // Initialize dropdowns
            const dropdownElementList = document.querySelectorAll('.dropdown-toggle');
            if (dropdownElementList.length > 0) {
                dropdownElementList.forEach(dropdownToggleEl => {
                    new bootstrap.Dropdown(dropdownToggleEl);
                });
            }
            
            // Check if we should show a specific tab on load
            const urlParams = new URLSearchParams(window.location.search);
            const tabParam = urlParams.get('tab');
            if (tabParam) {
                switchTab(tabParam);
            }
            
            // Add event listeners to notification dropdowns
            const notificationItems = document.querySelectorAll('.dropdown-item[data-message-id]');
            notificationItems.forEach(item => {
                item.addEventListener('click', function(event) {
                    event.preventDefault();
                    const messageId = this.getAttribute('data-message-id');
                    switchTab('messages');
                    viewMessage(messageId);
                    
                    // Close dropdown
                    const dropdown = bootstrap.Dropdown.getInstance(document.querySelector('#navbarDropdown'));
                    if (dropdown) {
                        dropdown.hide();
                    }
                });
            });
            
            // Fix the modal close button
            const modalCloseButtons = document.querySelectorAll('.btn-close');
            modalCloseButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const modalId = this.closest('.modal').id;
                    const modal = bootstrap.Modal.getInstance(document.getElementById(modalId));
                    if (modal) {
                        modal.hide();
                    }
                });
            });
            
            console.log("All event handlers initialized successfully for user " + currentUserLogin + " at " + currentDateTime);
        });
    </script>
</body>
</html>
