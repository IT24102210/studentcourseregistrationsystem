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
    String studentName = (loggedInStudent != null) ? loggedInStudent.getStudentName() : "IT24103866";
    String currentDateTime = "2025-05-04 10:42:26";
    
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
                            <li><a class="dropdown-item" href="#">Transcript updated with new grades</a></li>
                            <li><a class="dropdown-item" href="#">Registration for next semester opens soon</a></li>
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
                            <a class="nav-link" href="#">
                                <i class="fas fa-graduation-cap me-2"></i>Grades
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="fas fa-tasks me-2"></i>Assignments
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="manageTranscript.jsp">
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
                    <h1 class="h2">Academic Courses</h1>
                    <div class="text-end">
                        <div class="text-muted small">Current Date and Time: <%= currentDateTime %></div>
                        <div class="text-muted small">Department: <%= departmentName %>, Year: <%= loggedInStudent.getEnrollmentYear() %></div>
                    </div>
                </div>

                <!-- Transcript Header -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h5><strong>Student Information</strong></h5>
                                <table class="table table-sm table-borderless">
                                    <tr>
                                        <th width="40%">Name:</th>
                                        <td><%= loggedInStudent.getFirstName() %> <%= loggedInStudent.getLastName() %></td>
                                    </tr>
                                    <tr>
                                        <th>Student ID:</th>
                                        <td><%= loggedInStudent.getStudentName() %></td>
                                    </tr>
                                    <tr>
                                        <th>Department:</th>
                                        <td><%= departmentName %></td>
                                    </tr>
                                    <tr>
                                        <th>Enrollment Year:</th>
                                        <td><%= loggedInStudent.getEnrollmentYear() %></td>
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
</body>
</html>
