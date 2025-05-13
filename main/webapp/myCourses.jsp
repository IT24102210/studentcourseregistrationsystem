<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.StudentEnrollSystem.model.Student" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.IOException" %>
<%
// Set current time and user ID from the provided values
String currentDateTime = "2025-05-13 13:53:12";
String currentUserLogin = "";

// The file path to the students.txt file
String FILE_PATH = "C:\\Users\\user\\Downloads\\uthtara\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\data\\students.txt";

// Get student from session (set by StudentLoginServlet or StudentSignupServlet)
Student student = (Student) session.getAttribute("student");

// If no student in session, try to get from parameter (for demo/testing)
String studentName = request.getParameter("studentName");
if (studentName == null || studentName.isEmpty()) {
    studentName = currentUserLogin; // Use the current user login if parameter not provided
}

// If student not in session but name parameter provided, try to load from file
if (student == null && studentName != null && !studentName.trim().isEmpty()) {
    try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
        String line;
        while ((line = reader.readLine()) != null) {
            String[] parts = line.split(", ");
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
                    String registrationTimestamp = (parts.length >= 7) ? parts[6] : null;
                    
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
    
// Hardcoded student data for demo if not logged in through normal flow
// If still no student found, create a default one for demo
if (student == null) {
    student = new Student();
    student.setStudentName(currentUserLogin);
    student.setFirstName("Christopher");
    student.setLastName("Martin");
    student.setEmail("cmartin@example.com");
    student.setDepartment("computer_science");
    student.setEnrollmentYear("2024");
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

// Session management - store current time and user information
session.setAttribute("currentDateTime", currentDateTime);
session.setAttribute("currentUserLogin", currentUserLogin);
    
// Mock transcript data
class TranscriptEntry {
    String semester;
    String courseCode;
    String courseName;
    int credits;
    String grade;
    double gradePoints;
    
    TranscriptEntry(String semester, String courseCode, String courseName, 
                   int credits, String grade, double gradePoints) {
        this.semester = semester;
        this.courseCode = courseCode;
        this.courseName = courseName;
        this.credits = credits;
        this.grade = grade;
        this.gradePoints = gradePoints;
    }
}

List<TranscriptEntry> transcript = new ArrayList<>();

// Previous semesters
transcript.add(new TranscriptEntry("Fall 2024", "CS100", "Computer Science Fundamentals", 3, "A", 4.0));
transcript.add(new TranscriptEntry("Fall 2024", "MATH210", "Calculus I", 4, "B+", 3.3));
transcript.add(new TranscriptEntry("Fall 2024", "ENG101", "English Composition", 3, "A-", 3.7));
transcript.add(new TranscriptEntry("Fall 2024", "PHYS101", "Physics I", 4, "B", 3.0));

transcript.add(new TranscriptEntry("Spring 2025", "CS101", "Introduction to Programming", 3, "A-", 3.7));
transcript.add(new TranscriptEntry("Spring 2025", "CS201", "Data Structures & Algorithms", 4, "B", 3.0));
transcript.add(new TranscriptEntry("Spring 2025", "CS202", "Database Systems", 4, "B+", 3.3));
transcript.add(new TranscriptEntry("Spring 2025", "CS305", "Web Development", 4, "A", 4.0));

// Calculate GPA by semester
class SemesterGPA {
    String semester;
    int totalCredits;
    double totalPoints;
    double gpa;
    
    SemesterGPA(String semester) {
        this.semester = semester;
        this.totalCredits = 0;
        this.totalPoints = 0;
        this.gpa = 0;
    }
    
    void addCourse(int credits, double gradePoints) {
        this.totalCredits += credits;
        this.totalPoints += (credits * gradePoints);
        this.gpa = this.totalCredits > 0 ? this.totalPoints / this.totalCredits : 0;
    }
}

List<SemesterGPA> semesterGPAs = new ArrayList<>();
SemesterGPA currentSemester = null;

// Calculate semester GPAs
for (TranscriptEntry entry : transcript) {
    if (currentSemester == null || !currentSemester.semester.equals(entry.semester)) {
        if (currentSemester != null) {
            semesterGPAs.add(currentSemester);
        }
        currentSemester = new SemesterGPA(entry.semester);
    }
    currentSemester.addCourse(entry.credits, entry.gradePoints);
}

// Add the last semester
if (currentSemester != null) {
    semesterGPAs.add(currentSemester);
}

// Calculate cumulative GPA
double cumulativePoints = 0;
int cumulativeCredits = 0;
for (TranscriptEntry entry : transcript) {
    cumulativePoints += (entry.credits * entry.gradePoints);
    cumulativeCredits += entry.credits;
}
double cumulativeGPA = cumulativeCredits > 0 ? cumulativePoints / cumulativeCredits : 0;
String formattedCumulativeGPA = String.format("%.2f", cumulativeGPA);

// Total credits earned
int totalCreditsEarned = cumulativeCredits;

// Available courses for enrollment
class AvailableCourse {
    String courseCode;
    String courseName;
    String description;
    int credits;
    String instructor;
    String schedule;
    String imageUrl;
    
    AvailableCourse(String courseCode, String courseName, String description, 
                   int credits, String instructor, String schedule, String imageUrl) {
        this.courseCode = courseCode;
        this.courseName = courseName;
        this.description = description;
        this.credits = credits;
        this.instructor = instructor;
        this.schedule = schedule;
        this.imageUrl = imageUrl;
    }
}

List<AvailableCourse> availableCourses = new ArrayList<>();

// Add requested courses
availableCourses.add(new AvailableCourse(
    "CS450", 
    "Software Engineering", 
    "Learn modern software development methodologies, design patterns, and architecture principles for building scalable applications.", 
    4, 
    "Dr. James Wilson", 
    "Mon, Wed 10:00 AM - 11:30 AM", 
    "https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"
));

availableCourses.add(new AvailableCourse(
    "DS310", 
    "Data Science", 
    "Explore data analysis, visualization, and machine learning techniques to extract meaningful insights from complex datasets.", 
    4, 
    "Prof. Sarah Johnson", 
    "Tue, Thu 1:00 PM - 2:30 PM", 
    "https://images.unsplash.com/photo-1527474305487-b87b222841cc?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"
));

availableCourses.add(new AvailableCourse(
    "SEC405", 
    "Cybersecurity", 
    "Study network security, ethical hacking, threat assessment, and cryptography to protect information systems.", 
    4, 
    "Dr. Michael Torres", 
    "Mon, Wed 2:00 PM - 3:30 PM", 
    "https://images.unsplash.com/photo-1550751827-4bd374c3f58b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"
));

availableCourses.add(new AvailableCourse(
    "AI420", 
    "Artificial Intelligence", 
    "Study the fundamentals of AI including search algorithms, knowledge representation, reasoning, and machine learning.", 
    4, 
    "Dr. Emily Chen", 
    "Tue, Thu 3:00 PM - 4:30 PM", 
    "https://images.unsplash.com/photo-1535378620166-273708d44e4c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"
));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Academic Courses- EduEnroll</title>
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
        .semester-header {
            background: linear-gradient(135deg, #0d6efd 0%, #0dcaf0 100%);
            color: white;
            padding: 10px 20px;
            border-radius: 8px 8px 0 0;
        }
        .transcript-summary {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #0d6efd;
        }
        .gpa-display {
            font-size: 2.5rem;
            font-weight: bold;
            color: #0d6efd;
        }
        .stats-card {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        .navbar-brand {
            font-weight: 700;
        }
        .transcript-table th {
            background-color: #f1f1f1;
        }
        .transcript-card {
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 30px;
        }
        .print-button {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            z-index: 1000;
        }
        @media print {
            .sidebar, .navbar-top, .print-button, footer {
                display: none !important;
            }
            .main-content {
                margin-left: 0;
                padding: 0;
            }
            .transcript-card {
                box-shadow: none;
                margin-bottom: 15px;
            }
            body {
                background-color: #fff;
            }
        }
        
        /* New styles for course enrollment cards */
        .course-card {
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 25px;
            transition: transform 0.3s, box-shadow 0.3s;
            height: 100%;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.15);
        }
        .course-image {
            height: 180px;
            background-size: cover;
            background-position: center;
            position: relative;
        }
        .course-image-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(rgba(0, 0, 0, 0.1), rgba(0, 0, 0, 0.7));
        }
        .course-code {
            position: absolute;
            top: 15px;
            left: 15px;
            z-index: 2;
        }
        .course-credits {
            position: absolute;
            top: 15px;
            right: 15px;
            z-index: 2;
        }
        .course-title {
            position: absolute;
            bottom: 15px;
            left: 15px;
            right: 15px;
            color: white;
            font-weight: 600;
            font-size: 1.2rem;
            z-index: 2;
        }
        .instructor-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            margin-bottom: 8px;
        }
        .course-schedule {
            display: flex;
            align-items: center;
            gap: 5px;
            color: #6c757d;
            margin-bottom: 10px;
            font-size: 0.9rem;
        }
        .enroll-button {
            width: 100%;
            border-radius: 30px;
            padding: 8px 15px;
            transition: all 0.3s;
        }
        .enroll-button:hover {
            transform: scale(1.03);
        }
        .enrollment-section-header {
            position: relative;
            margin-bottom: 30px;
            padding-bottom: 15px;
        }
        .enrollment-section-header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 4px;
            background: linear-gradient(90deg, #0d6efd, #0dcaf0);
            border-radius: 2px;
        }
        
        /* Session information styles */
        .session-info {
            background-color: #e3f2fd;
            border-left: 4px solid #0d6efd;
            padding: 10px 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .session-timer {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            padding: 8px 12px;
            border-radius: 20px;
            font-family: monospace;
            font-size: 0.9rem;
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
                                2
                            </span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                            <li><h6 class="dropdown-header">Notifications</h6></li>
                            <li><a class="dropdown-item" href="#">Transcript updated with new grades</a></li>
                            <li><a class="dropdown-item" href="#">Registration for next semester opens soon</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="#">View all notifications</a></li>
                        </ul>
                    </div>
                    <div class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user-circle me-2"></i><%= student.getFirstName() %> <%= student.getLastName() %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>My Profile</a></li>
                            <li><a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i>Account Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="logout.jsp"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
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
                    </div>
                    <hr class="bg-light">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="studentDashboard.jsp">
                                <i class=""></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="myCourses.jsp">
                                <i class=""></i>My Courses
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="shedule.jsp">
                                <i class=""></i>Schedule
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class=""></i>Grades
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class=""></i>Assignments
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="manageTranscript.jsp">
                                <i class=""></i>Transcript
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class=""></i>Progress
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class=""></i>Announcements
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class=""></i>Profile
                            </a>
                        </li>
                    </ul>
                    <hr class="bg-light">
                    <div class="d-grid gap-2 px-3">
                        <a href="logout.jsp" class="btn btn-danger">
                            <i class="fas fa-sign-out-alt me-2"></i>Logout
                        </a>
                    </div>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <!-- Session Information Banner -->
                <div class="session-info mt-3 mb-4">
                    <div class="d-flex flex-wrap justify-content-between align-items-center">
                        <div>
                            <h6 class="mb-1"><i class="fas fa-clock me-2"></i>Session Information</h6>
                            <p class="mb-0">Current Date and Time (UTC): <span class="session-timer"><%= currentDateTime %></span></p>
                        </div>
                        <div class="mt-2 mt-md-0">
                            <p class="mb-0">Current User's Login: <span class="badge bg-primary"><%= currentUserLogin %></span></p>
                            <p class="mb-0 small text-muted">Session will expire after 30 minutes of inactivity</p>
                        </div>
                    </div>
                </div>
            
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">My Courses</h1>
                    <div class="text-end">
                        <div class="text-muted small">Department: <%= departmentName %>, Year: <%= student.getEnrollmentYear() %></div>
                    </div>
                </div>

                <!-- Course Enrollment Section -->
                <section class="mb-5">
                    <div class="enrollment-section-header">
                        <h3>Course Enrollment</h3>
                        <p class="text-muted">Select from available courses to enroll for the upcoming semester</p>
                    </div>

                    <div class="alert alert-info mb-4">
                        <div class="d-flex align-items-center">
                            <div class="me-3">
                                <i class="fas fa-info-circle fa-2x"></i>
                            </div>
                            <div>
                                <h5 class="mb-1">Fall 2025 Enrollment Now Open</h5>
                                <p class="mb-0">Registration period: May 15 - June 30, 2025. You may enroll in up to 5 courses (20 credits maximum).</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <% for(AvailableCourse course : availableCourses) { %>
                        <div class="col-md-6 col-lg-3 mb-4">
                            <div class="course-card">
                                <div class="course-image" style="background-image: url('<%= course.imageUrl %>')">
                                    <div class="course-image-overlay"></div>
                                    <span class="badge bg-primary course-code"><%= course.courseCode %></span>
                                    <span class="badge bg-secondary course-credits"><%= course.credits %> Credits</span>
                                    <h5 class="course-title"><%= course.courseName %></h5>
                                </div>
                                <div class="card-body">
                                    <p class="course-description text-muted mb-3" style="font-size: 0.9rem; height: 60px; overflow: hidden;">
                                        <%= course.description %>
                                    </p>
                                    
                                    <div class="instructor-badge">
                                        <i class="fas fa-user-tie text-primary"></i>
                                        <span><%= course.instructor %></span>
                                    </div>
                                    
                                    <div class="course-schedule">
                                        <i class="far fa-clock text-muted"></i>
                                        <span><%= course.schedule %></span>
                                    </div>
                                    
                                    <form action="enrollCourse" method="post" class="mt-3">
                                        <input type="hidden" name="courseCode" value="<%= course.courseCode %>">
                                        <input type="hidden" name="courseName" value="<%= course.courseName %>">
                                        <input type="hidden" name="studentId" value="<%= student.getStudentName() %>">
                                        <input type="hidden" name="enrollmentTimestamp" value="<%= currentDateTime %>">
                                        <button type="submit" class="btn btn-primary enroll-button">
                                            <i class="fas fa-plus-circle me-2"></i>Enroll Now
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </section>

                <!-- Transcript Header -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h5><strong>Student Information</strong></h5>
                                <table class="table table-sm table-borderless">
                                    <tr>
                                        <th width="40%">Name:</th>
                                        <td><%= student.getFirstName() %> <%= student.getLastName() %></td>
                                    </tr>
                                    <tr>
                                        <th>Student ID:</th>
                                        <td><%= student.getStudentName() %></td>
                                    </tr>
                                    <tr>
                                        <th>Department:</th>
                                        <td><%= departmentName %></td>
                                    </tr>
                                    <tr>
                                        <th>Enrollment Year:</th>
                                        <td><%= student.getEnrollmentYear() %></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-md-6">
                                <div class="text-md-end mt-3 mt-md-0">
                                    <a href="#" onclick="window.print()" class="btn btn-outline-primary">
                                        <i class="fas fa-print me-2"></i>Print Transcript
                                    </a>
                                    <a href="#" class="btn btn-outline-secondary ms-2">
                                        <i class="fas fa-download me-2"></i>Download PDF
                                    </a>
                                </div>
                                <div class="transcript-summary mt-3">
                                    <div class="row">
                                        <div class="col-6">
                                            <h5 class="text-muted mb-1">Cumulative GPA</h5>
                                            <div class="gpa-display"><%= formattedCumulativeGPA %></div>
                                        </div>
                                        <div class="col-6">
                                            <h5 class="text-muted mb-1">Credits Earned</h5>
                                            <div class="gpa-display"><%= totalCreditsEarned %></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- GPA Summary Cards -->
                <h4 class="mb-3">GPA by Semester</h4>
                <div class="row mb-4">
                    <% for(SemesterGPA semGPA : semesterGPAs) { %>
                    <div class="col-md-6 col-lg-3 mb-3">
                        <div class="card stats-card bg-white h-100">
                            <div class="card-body">
                                <h5 class="card-title"><%= semGPA.semester %></h5>
                                <div class="display-4 text-success"><%= String.format("%.2f", semGPA.gpa) %></div>
                                <p class="text-muted"><%= semGPA.totalCredits %> Credits</p>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>

                <!-- Transcript Tables by Semester -->
                <h4 class="mb-3">Course History</h4>
                
                <% 
                String currentSem = "";
                for(TranscriptEntry entry : transcript) {
                    if(!entry.semester.equals(currentSem)) {
                        if(!currentSem.equals("")) {
                            // Close previous table
                %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <% 
                        }
                        currentSem = entry.semester;
                        // Start new table
                %>
                <div class="card transcript-card mb-4">
                    <div class="semester-header">
                        <h5 class="mb-0"><%= entry.semester %></h5>
                    </div>
                    <div class="card-body p-0">
                        <table class="table table-hover mb-0 transcript-table">
                            <thead>
                                <tr>
                                    <th>Course Code</th>
                                    <th>Course Name</th>
                                    <th>Credits</th>
                                    <th>Grade</th>
                                    <th>Grade Points</th>
                                </tr>
                            </thead>
                            <tbody>
                <% 
                    }
                %>
                                <tr>
                                    <td><%= entry.courseCode %></td>
                                    <td><%= entry.courseName %></td>
                                    <td><%= entry.credits %></td>
                                    <td><span class="badge bg-primary"><%= entry.grade %></span></td>
                                    <td><%= entry.gradePoints %></td>
                                </tr>
                <% 
                }
                
                // Close the last table
                if(!currentSem.equals("")) {
                %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <% } %>

                <!-- Transcript Notes -->
                <div class="card mb-4">
                    <div class="card-header bg-light">
                        <h5 class="mb-0">Transcript Notes</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6>Grading Scale</h6>
                                <table class="table table-sm">
                                    <tbody>
                                        <tr><td>A</td><td>4.0</td><td>90-100%</td><td>Excellent</td></tr>
                                        <tr><td>A-</td><td>3.7</td><td>87-89%</td><td>Very Good</td></tr>
                                        <tr><td>B+</td><td>3.3</td><td>83-86%</td><td>Good</td></tr>
                                        <tr><td>B</td><td>3.0</td><td>80-82%</td><td>Above Average</td></tr>
                                        <tr><td>B-</td><td>2.7</td><td>77-79%</td><td>Average</td></tr>
                                        <tr><td>C+</td><td>2.3</td><td>73-76%</td><td>Below Average</td></tr>
                                        <tr><td>C</td><td>2.0</td><td>70-72%</td><td>Passing</td></tr>
                                        <tr><td>F</td><td>0.0</td><td>0-69%</td><td>Failing</td></tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-md-6">
                                <h6>Academic Standing</h6>
                                <p>Your academic standing is <strong class="text-success">Good Standing</strong>.</p>
                                <p class="small text-muted">Academic standing is determined by your cumulative GPA:</p>
                                <ul class="small text-muted">
                                    <li>Good Standing: 2.0 or higher</li>
                                    <li>Academic Warning: 1.75-1.99</li>
                                    <li>Academic Probation: Below 1.75</li>
                                </ul>
                                
                                <div class="alert alert-info mt-3">
                                    <i class="fas fa-info-circle me-2"></i>
                                    This transcript is unofficial unless printed on official university letterhead and signed by the registrar.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <!-- Print Button -->
    <a href="#" onclick="window.print()" class="btn btn-primary print-button">
        <i class="fas fa-print"></i>
    </a>

    <!-- Enrollment Confirmation Modal -->
    <div class="modal fade" id="enrollmentModal" tabindex="-1" aria-labelledby="enrollmentModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="enrollmentModalLabel">Confirm Enrollment</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>You are about to enroll in <strong id="courseNamePlaceholder"></strong>.</p>
                    <p>Course Code: <span id="courseCodePlaceholder"></span></p>
                    <p>Credits: <span id="courseCreditsPlaceholder"></span></p>
                    <p>This action will add the course to your schedule for the upcoming semester.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" id="confirmEnrollButton" class="btn btn-primary">Confirm Enrollment</button>
                </div>
            </div>
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
                    <p class="mb-0">
                        Student ID: <%= student.getStudentName() %> | Current Date and Time: <%= currentDateTime %>
                    </p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Font Awesome for icons (updated to more reliable CDN) -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
    
    <!-- Session Management Script -->
    <script>
        // Track session activity
        let lastActivity = Date.now();
        const sessionTimeout = 30 * 60 * 1000; // 30 minutes in milliseconds
        
        // Update last activity time on user interactions
        function updateActivity() {
            lastActivity = Date.now();
            // In a real implementation, you would send an AJAX request to update session on server
            console.log("Activity detected, session refreshed at: " + new Date().toISOString());
        }
        
        // Check session status periodically
        function checkSession() {
            const now = Date.now();
            const inactiveTime = now - lastActivity;
            
            // If inactive for too long, warn user
            if (inactiveTime > (sessionTimeout - (5 * 60 * 1000))) { // 5 minutes before timeout
                if (!document.getElementById('timeoutWarning')) {
                    const warning = document.createElement('div');
                    warning.id = 'timeoutWarning';
                    warning.className = 'alert alert-warning alert-dismissible fade show fixed-top m-3';
                    warning.innerHTML = `
                        <strong>Session Expiring!</strong> You'll be logged out in 5 minutes due to inactivity.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        <div class="mt-2">
                            <button onclick="updateActivity()" class="btn btn-sm btn-primary">Stay Logged In</button>
                        </div>
                    `;
                    document.body.appendChild(warning);
                }
            }
            
            // If session has expired, redirect to login
            if (inactiveTime > sessionTimeout) {
                window.location.href = "logout.jsp?reason=timeout";
            }
        }
        
        // Event listeners for activity detection
        const events = ['mousedown', 'mousemove', 'keypress', 'scroll', 'touchstart'];
        events.forEach(name => {
            document.addEventListener(name, updateActivity, true);
        });
        
        // Start session monitoring
        document.addEventListener('DOMContentLoaded', function() {
            setInterval(checkSession, 60000); // Check every minute
        });
        
        // Script to handle enrollment confirmation modal
        document.addEventListener('DOMContentLoaded', function() {
            const enrollButtons = document.querySelectorAll('.enroll-button');
            enrollButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    
                    const form = this.closest('form');
                    const courseCode = form.querySelector('input[name="courseCode"]').value;
                    const courseName = form.querySelector('input[name="courseName"]').value;
                    
                    document.getElementById('courseNamePlaceholder').textContent = courseName;
                    document.getElementById('courseCodePlaceholder').textContent = courseCode;
                    
                    // Credits lookup
                    let credits = 0;
                    <% for(AvailableCourse course : availableCourses) { %>
                        if('<%= course.courseCode %>' === courseCode) {
                            credits = <%= course.credits %>;
                        }
                    <% } %>
                    document.getElementById('courseCreditsPlaceholder').textContent = credits;
                    
                    // Show modal
                    const enrollmentModal = new bootstrap.Modal(document.getElementById('enrollmentModal'));
                    enrollmentModal.show();
                    
                    // Set up confirm button
                    document.getElementById('confirmEnrollButton').onclick = function() {
                        form.submit();
                    };
                });
            });
        });
    </script>
</body>
</html>
