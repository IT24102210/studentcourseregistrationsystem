<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.StudentEnrollSystem.model.Student" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    // Get the logged-in student from the session
    Student loggedInStudent = (Student) session.getAttribute("loggedInStudent");
    
    // If no student in session, use the student ID from request parameter or hardcoded value for demo
    String studentName = (loggedInStudent != null) ? loggedInStudent.getStudentName() : "krishmal";
    String currentDateTime = "2025-04-30 20:46:55";
    
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
        String schedule;
        int progress;
        String gradeLetters;
        double gradePoints;
        
        Course(String code, String name, String instructor, String schedule, int progress, String gradeLetters, double gradePoints) {
            this.code = code;
            this.name = name;
            this.instructor = instructor;
            this.schedule = schedule;
            this.progress = progress;
            this.gradeLetters = gradeLetters;
            this.gradePoints = gradePoints;
        }
    }
    
    List<Course> courses = new ArrayList<>();
    courses.add(new Course("CS101", "Introduction to Programming", "Prof. Johnson", "Mon/Wed 10:00-11:30", 75, "A-", 3.7));
    courses.add(new Course("CS202", "Database Systems", "Prof. Smith", "Tue/Thu 13:00-14:30", 60, "B+", 3.3));
    courses.add(new Course("CS305", "Web Development", "Prof. Wilson", "Wed/Fri 15:00-16:30", 85, "A", 4.0));
    courses.add(new Course("CS201", "Data Structures & Algorithms", "Prof. Davis", "Mon/Fri 9:00-10:30", 70, "B", 3.0));
    
    // Calculate GPA
    double totalPoints = 0;
    int totalCourses = courses.size();
    for (Course course : courses) {
        totalPoints += course.gradePoints;
    }
    double gpa = totalPoints / totalCourses;
    
    // Format GPA to 2 decimal places
    String formattedGPA = String.format("%.2f", gpa);
    
    // Mock upcoming events
    class Event {
        String title;
        String date;
        String type;
        
        Event(String title, String date, String type) {
            this.title = title;
            this.date = date;
            this.type = type;
        }
    }
    
    List<Event> events = new ArrayList<>();
    events.add(new Event("Database Systems Midterm", "2025-05-05", "exam"));
    events.add(new Event("Web Development Project Due", "2025-05-07", "assignment"));
    events.add(new Event("Career Fair", "2025-05-10", "event"));
    
    // Mock announcements
    class Announcement {
        String title;
        String content;
        String date;
        
        Announcement(String title, String content, String date) {
            this.title = title;
            this.content = content;
            this.date = date;
        }
    }
    
    List<Announcement> announcements = new ArrayList<>();
    announcements.add(new Announcement("Summer Registration Open", "Registration for summer courses is now open. Please check the course catalog and register by May 15.", "2025-04-28"));
    announcements.add(new Announcement("System Maintenance", "EduEnroll will be down for maintenance on May 3rd from 2:00 AM to 6:00 AM.", "2025-04-29"));
    announcements.add(new Announcement("New Computer Lab Hours", "The computer science lab will have extended hours (7:00 AM - 10:00 PM) starting next week for finals preparation.", "2025-04-30"));
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
        .cs-gpa {
            font-size: 2.5rem;
            font-weight: bold;
        }
        .cs-courses {
            font-size: 1.8rem;
            font-weight: bold;
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
                    <span class="nav-link"><i class="fas fa-user-circle me-2"></i>Student Name: <%= studentName %></span>
                </div>
                <div class="navbar-nav">
                    <div class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-bell me-2"></i>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                3
                            </span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                            <li><h6 class="dropdown-header">Notifications</h6></li>
                            <li><a class="dropdown-item" href="#">New announcement: Summer Registration</a></li>
                            <li><a class="dropdown-item" href="#">Assignment due soon: Web Development</a></li>
                            <li><a class="dropdown-item" href="#">Grade posted: Database Systems</a></li>
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
                            <a class="nav-link active" href="studentDashboard.jsp">
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
                            <a class="nav-link" href="#">
                                <i class="fas fa-tasks me-2"></i>Assignments
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="manageTranscript.jsp">
                                <i class="fas fa-file-alt me-2"></i>Transcripts
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
                    <h1 class="h2">Dashboard</h1>
                    <div class="text-end">
                        <div class="text-muted small">Current Date and Time: <%= currentDateTime %></div>
                        <div class="text-muted small">Department: <%= departmentName %>, Year: <%= loggedInStudent.getEnrollmentYear() %></div>
                    </div>
                </div>

                <!-- Welcome Section -->
                <div class="alert alert-info mb-4">
                    <h4>Welcome, <%= loggedInStudent.getFirstName() %>!</h4>
                    <p class="mb-0">You've successfully logged into your student dashboard. Here you can manage your courses, view your schedule, and track your academic progress.</p>
                </div>

                <!-- Quick Stats Section -->
                <div class="row quick-stats mb-4">
                    <div class="col-md-4 mb-3 mb-md-0">
                        <div class="stat-item bg-primary bg-opacity-10 text-center">
                            <div class="text-primary mb-1"><i class="fas fa-book fa-2x"></i></div>
                            <div class="cs-courses text-primary"><%= courses.size() %></div>
                            <div class="text-muted">Enrolled Courses</div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3 mb-md-0">
                        <div class="stat-item bg-success bg-opacity-10 text-center">
                            <div class="text-success mb-1"><i class="fas fa-chart-line fa-2x"></i></div>
                            <div class="cs-gpa text-success"><%= formattedGPA %></div>
                            <div class="text-muted">Current GPA</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-item bg-warning bg-opacity-10 text-center">
                            <div class="text-warning mb-1"><i class="fas fa-calendar-alt fa-2x"></i></div>
                            <div class="cs-courses text-warning"><%= events.size() %></div>
                            <div class="text-muted">Upcoming Events</div>
                        </div>
                    </div>
                </div>

                <!-- Main Dashboard Content -->
                <div class="row">
                    <!-- Left Column -->
                    <div class="col-lg-8">
                        <!-- Current Courses Section -->
                        <div class="card dashboard-widget mb-4">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0"><i class="fas fa-book me-2 text-primary"></i>Current Courses</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Code</th>
                                                <th>Course</th>
                                                <th>Instructor</th>
                                                <th>Grade</th>
                                                <th>Progress</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for(Course course : courses) { %>
                                            <tr>
                                                <td><span class="badge bg-primary"><%= course.code %></span></td>
                                                <td><strong><%= course.name %></strong><br><small class="text-muted"><%= course.schedule %></small></td>
                                                <td><%= course.instructor %></td>
                                                <td><span class="badge bg-success"><%= course.gradeLetters %></span></td>
                                                <td>
                                                    <div class="progress">
                                                        <div class="progress-bar bg-success" role="progressbar" style="width: <%= course.progress %>%" 
                                                             aria-valuenow="<%= course.progress %>" aria-valuemin="0" aria-valuemax="100">
                                                        </div>
                                                    </div>
                                                    <small class="text-muted"><%= course.progress %>% Complete</small>
                                                </td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="text-end">
                                    <a href="#" class="btn btn-outline-primary btn-sm">View All Courses</a>
                                </div>
                            </div>
                        </div>

                        <!-- Academic Calendar Section -->
                        <div class="card dashboard-widget mb-4">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0"><i class="fas fa-calendar-alt me-2 text-danger"></i>Weekly Schedule</h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-bordered mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th width="20%">Time</th>
                                                <th>Monday</th>
                                                <th>Tuesday</th>
                                                <th>Wednesday</th>
                                                <th>Thursday</th>
                                                <th>Friday</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="text-center">9:00-10:30</td>
                                                <td class="bg-primary bg-opacity-10">CS201<br>Data Structures</td>
                                                <td></td>
                                                <td></td>
                                                <td></td>
                                                <td class="bg-primary bg-opacity-10">CS201<br>Data Structures</td>
                                            </tr>
                                            <tr>
                                                <td class="text-center">10:00-11:30</td>
                                                <td class="bg-success bg-opacity-10">CS101<br>Intro to Programming</td>
                                                <td></td>
                                                <td class="bg-success bg-opacity-10">CS101<br>Intro to Programming</td>
                                                <td></td>
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td class="text-center">13:00-14:30</td>
                                                <td></td>
                                                <td class="bg-warning bg-opacity-10">CS202<br>Database Systems</td>
                                                <td></td>
                                                <td class="bg-warning bg-opacity-10">CS202<br>Database Systems</td>
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td class="text-center">15:00-16:30</td>
                                                <td></td>
                                                <td></td>
                                                <td class="bg-info bg-opacity-10">CS305<br>Web Development</td>
                                                <td></td>
                                                <td class="bg-info bg-opacity-10">CS305<br>Web Development</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Grades Overview Section -->
                        <div class="card dashboard-widget">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0"><i class="fas fa-graduation-cap me-2 text-success"></i>Academic Performance</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-4 text-center">
                                        <div class="display-5 text-success fw-bold"><%= formattedGPA %></div>
                                        <p class="text-muted">Current GPA</p>
                                    </div>
                                    <div class="col-md-8">
                                        <canvas id="gradeChart" height="200"></canvas>
                                    </div>
                                </div>
                                <hr>
                                <div class="table-responsive">
                                    <table class="table table-sm">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Course</th>
                                                <th>Grade</th>
                                                <th>Points</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for(Course course : courses) { %>
                                            <tr>
                                                <td><%= course.code %>: <%= course.name %></td>
                                                <td><%= course.gradeLetters %></td>
                                                <td><%= course.gradePoints %></td>
                                                <td><span class="badge bg-success">In Progress</span></td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column -->
                    <div class="col-lg-4">
                        <!-- Student Info Card -->
                        <div class="card dashboard-widget mb-4">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0"><i class="fas fa-user-circle me-2 text-primary"></i>Student Information</h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-4 text-center">
                                    <div class="profile-avatar mx-auto">
                                        <%= loggedInStudent.getFirstName().charAt(0) %><%= loggedInStudent.getLastName().charAt(0) %>
                                    </div>
                                    <h5 class="mb-0"><%= loggedInStudent.getFirstName() %> <%= loggedInStudent.getLastName() %></h5>
                                    <p class="text-muted"><%= departmentName %></p>
                                </div>
                                
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item d-flex justify-content-between">
                                        <span>Student ID:</span>
                                        <span class="fw-bold"><%= loggedInStudent.getStudentName() %></span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between">
                                        <span>Email:</span>
                                        <span class="fw-bold"><%= loggedInStudent.getEmail() %></span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between">
                                        <span>Department:</span>
                                        <span class="fw-bold"><%= departmentName %></span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between">
                                        <span>Enrollment Year:</span>
                                        <span class="fw-bold"><%= loggedInStudent.getEnrollmentYear() %></span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between">
                                        <span>Academic Status:</span>
                                        <span class="badge bg-success">Active</span>
                                    </li>
                                </ul>
                                
                                <div class="d-grid mt-3">
                                    <a href="#" class="btn btn-outline-primary btn-sm">Edit Profile</a>
                                </div>
                            </div>
                        </div>

                        <!-- Upcoming Events Card -->
                        <div class="card dashboard-widget mb-4">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0"><i class="fas fa-calendar me-2 text-warning"></i>Upcoming Events</h5>
                            </div>
                            <div class="card-body p-0">
                                <ul class="list-group list-group-flush">
                                    <% for(Event event : events) { %>
                                    <li class="list-group-item event-<%= event.type %>">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="mb-0"><%= event.title %></h6>
                                                <small class="text-muted"><%= event.date %></small>
                                            </div>
                                            <% if(event.type.equals("exam")) { %>
                                                <span class="badge bg-danger">Exam</span>
                                            <% } else if(event.type.equals("assignment")) { %>
                                                <span class="badge bg-success">Assignment</span>
                                            <% } else { %>
                                                <span class="badge bg-info">Event</span>
                                            <% } %>
                                        </div>
                                    </li>
                                    <% } %>
                                </ul>
                                <div class="card-footer bg-white">
                                    <div class="d-grid">
                                        <a href="#" class="btn btn-outline-secondary btn-sm">View All Events</a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Announcements Card -->
                        <div class="card dashboard-widget">
                            <div class="card-header bg-white">
                                <h5 class="card-title mb-0"><i class="fas fa-bullhorn me-2 text-warning"></i>Announcements</h5>
                            </div>
                            <div class="card-body p-0">
                                <ul class="list-group list-group-flush">
                                    <% for(Announcement announcement : announcements) { %>
                                    <li class="list-group-item announcement-card">
                                        <h6 class="mb-1"><%= announcement.title %></h6>
                                        <p class="mb-1 small"><%= announcement.content %></p>
                                        <small class="text-muted">Posted: <%= announcement.date %></small>
                                    </li>
                                    <% } %>
                                </ul>
                                <div class="card-footer bg-white">
                                    <div class="d-grid">
                                        <a href="#" class="btn btn-outline-secondary btn-sm">View All Announcements</a>
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
                <div class="col-md-6 text-md-start">
                    <p class="mb-0">&copy; 2025 EduEnroll System. All rights reserved.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <p class="mb-0 date-display">
                        Student ID: <%= studentName %> | Current Date and Time: <%= currentDateTime %>
                    </p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Font Awesome for icons -->
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <script>
        // Chart for grades
        const ctx = document.getElementById('gradeChart').getContext('2d');
        const gradeChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['CS101', 'CS202', 'CS305', 'CS201'],
                datasets: [{
                    label: 'Grade Points',
                    data: [3.7, 3.3, 4.0, 3.0],
                    backgroundColor: [
                        'rgba(75, 192, 192, 0.6)',
                        'rgba(255, 159, 64, 0.6)',
                        'rgba(54, 162, 235, 0.6)',
                        'rgba(153, 102, 255, 0.6)'
                    ],
                    borderColor: [
                        'rgba(75, 192, 192, 1)',
                        'rgba(255, 159, 64, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(153, 102, 255, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 4.0,
                        ticks: {
                            stepSize: 1.0
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>
