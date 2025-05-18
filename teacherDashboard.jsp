<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.StudentEnrollSystem.model.Teacher" %>
<%@ page import="com.StudentEnrollSystem.model.Student" %>
<%@ page import="com.StudentEnrollSystem.model.Message" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*, java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%    
    // Check if teacher is logged in
    Teacher teacher = (Teacher) session.getAttribute("teacher");
    if (teacher == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Current date time and user login
    String currentDateTime = "2025-05-16 22:18:56"; // Updated UTC time
    String currentUserLogin = "IT24103866"; // Updated user login
    
    // Get teacher's full name
    String teacherFullName = teacher.getFirstName() + " " + teacher.getLastName();
    
    // Read all courses for Courses tab and Dashboard stats
    String coursesFilePath = ("C:\\Users\\user\\Downloads\\uthtara\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\data\\courses.txt");
    File coursesFile = new File(coursesFilePath);
    if (!coursesFile.exists()) {
        // Create parent directories if they don't exist
        coursesFile.getParentFile().mkdirs();
        try {
            coursesFile.createNewFile();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    int courseCount = 0;
    List<Map<String, Object>> courses = new ArrayList<>();
    StringBuilder courseReadError = new StringBuilder();
    
    try (BufferedReader reader = new BufferedReader(new FileReader(coursesFilePath))) {
        String line;
        int lineNumber = 0;
        while ((line = reader.readLine()) != null) {
            lineNumber++;
            line = line.trim();
            if (line.isEmpty()) continue;
            String[] parts = line.split("\\|");
            if (parts.length < 4) {
                courseReadError.append("Line ").append(lineNumber).append(": Invalid number of fields in entry: ").append(line).append("<br>");
                continue;
            }
            
            try {
                Map<String, Object> course = new HashMap<>();
                course.put("courseCode", parts[0].trim());
                course.put("title", parts[1].trim());
                course.put("day", parts.length > 2 ? parts[2].trim() : "");
                course.put("time", parts.length > 3 ? parts[3].trim() : "");
                course.put("enrolledStudents", parts.length > 4 ? Integer.parseInt(parts[4].trim()) : 0);
                course.put("sessionsCount", parts.length > 5 ? Integer.parseInt(parts[5].trim()) : 0);
                course.put("description", "Course: " + parts[0].trim() + " - " + parts[1].trim());
                courses.add(course);
                courseCount++;
            } catch (NumberFormatException e) {
                courseReadError.append("Line ").append(lineNumber).append(": Invalid number format in entry: ").append(line).append("<br>");
            }
        }
    } catch (IOException e) {
        courseReadError.append("Error reading courses: ").append(e.getMessage()).append("<br>");
        e.printStackTrace();
    }
    
    pageContext.setAttribute("courses", courses);
    pageContext.setAttribute("courseCount", courseCount);
    pageContext.setAttribute("courseReadError", courseReadError.toString());
    
    // Read all students using the updated Student model structure
    String studentsFilePath = ("C:\\Users\\user\\Downloads\\uthtara\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\data\\students.txt");
    File studentsFile = new File(studentsFilePath);
    if (!studentsFile.exists()) {
        studentsFile.getParentFile().mkdirs();
        try {
            studentsFile.createNewFile();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    int studentCount = 0;
    List<Map<String, String>> students = new ArrayList<>();
    StringBuilder studentReadError = new StringBuilder();
    
    try (BufferedReader reader = new BufferedReader(new FileReader(studentsFilePath))) {
        String line;
        while ((line = reader.readLine()) != null) {
            line = line.trim();
            if (line.isEmpty()) continue;
            String[] parts = line.split(",\\s*"); // Split by comma followed by optional whitespace
            if (parts.length >= 6) { // Expecting at least 6 fields based on the model
                Map<String, String> student = new HashMap<>();
                
                // Parse according to the Student model's toString format
                student.put("name", parts[0].trim()); // firstName + " " + lastName
                student.put("studentName", parts[1].trim()); // studentName (username)
                student.put("email", parts[3].trim()); // email
                student.put("department", parts[4].trim()); // department
                student.put("enrollmentYear", parts[5].trim()); // enrollmentYear
                
                // Registration timestamp if available
                if (parts.length > 6) {
                    student.put("registrationTimestamp", parts[6].trim());
                } else {
                    student.put("registrationTimestamp", currentDateTime);
                }
                
                students.add(student);
                studentCount++;
            }
        }
    } catch (IOException e) {
        studentReadError.append("Error reading students: ").append(e.getMessage());
        e.printStackTrace();
    }
    
    // Check if we need to resort (in case server-side sort was called)
    String sortOrder = request.getParameter("sort");
    if (sortOrder != null && (sortOrder.equals("asc") || sortOrder.equals("desc"))) {
        // Sort will be handled by the servlet - leave the data as is
    } else {
        // Default sort - newest first (will be replaced by client-side insertion sort)
        Collections.sort(students, new Comparator<Map<String, String>>() {
            @Override
            public int compare(Map<String, String> s1, Map<String, String> s2) {
                return s2.get("registrationTimestamp").compareTo(s1.get("registrationTimestamp"));
            }
        });
    }
    
    pageContext.setAttribute("students", students);
    pageContext.setAttribute("studentCount", studentCount);
    pageContext.setAttribute("studentReadError", studentReadError.toString());
    pageContext.setAttribute("sortOrder", sortOrder != null ? sortOrder : "desc");
    
    // Get Recently Added Students (last 5)
    List<Map<String, String>> recentStudents = new ArrayList<>();
    int recentCount = Math.min(5, students.size());
    for (int i = 0; i < recentCount; i++) {
        recentStudents.add(students.get(i));
    }
    pageContext.setAttribute("recentStudents", recentStudents);
    
    // Active tab handling
    String activeTab = request.getParameter("tab");
    if (activeTab == null || activeTab.trim().isEmpty()) {
        activeTab = "dashboard";
    }
    pageContext.setAttribute("activeTab", activeTab);

    // Success and error messages
    String successMessage = request.getParameter("successMessage");
    String errorMessage = request.getParameter("errorMessage");
    pageContext.setAttribute("successMessage", successMessage);
    pageContext.setAttribute("errorMessage", errorMessage);
    
    // Messages module variables
    int unreadCount = 0;
    if (request.getAttribute("unreadCount") != null) {
        unreadCount = (Integer) request.getAttribute("unreadCount");
    }
    pageContext.setAttribute("unreadCount", unreadCount);
    
    String messageType = request.getAttribute("messageType") != null ? 
                        (String) request.getAttribute("messageType") : "inbox";
    pageContext.setAttribute("messageType", messageType);
    
    // Get assignments for the teacher (if any)
    List<Map<String, Object>> assignments = new ArrayList<>();
    try {
        String assignmentsFilePath = ("C:\\Users\\user\\Downloads\\uthtara\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\data\\assignments.txt");
        File assignmentsFile = new File(assignmentsFilePath);
        if (assignmentsFile.exists()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(assignmentsFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    if (!line.isEmpty()) {
                        String[] parts = line.split("\\|");
                        if (parts.length >= 9 && parts[6].equals(currentUserLogin)) {
                            Map<String, Object> assignment = new HashMap<>();
                            assignment.put("id", parts[0]);
                            assignment.put("courseCode", parts[1]);
                            assignment.put("title", parts[2]);
                            assignment.put("description", parts[3]);
                            assignment.put("dueDate", new Date(Long.parseLong(parts[4])));
                            assignment.put("maxPoints", Integer.parseInt(parts[5]));
                            assignment.put("teacherId", parts[6]);
                            assignment.put("teacherName", parts[7]);
                            assignment.put("createdDate", new Date(Long.parseLong(parts[8])));
                            
                            // Get course title
                            for (Map<String, Object> course : courses) {
                                if (course.get("courseCode").equals(parts[1])) {
                                    assignment.put("courseTitle", course.get("title"));
                                    break;
                                }
                            }
                            
                            assignments.add(assignment);
                        }
                    }
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    // Sort assignments by due date (newest first)
    Collections.sort(assignments, new Comparator<Map<String, Object>>() {
        @Override
        public int compare(Map<String, Object> a1, Map<String, Object> a2) {
            Date d1 = (Date) a1.get("dueDate");
            Date d2 = (Date) a2.get("dueDate");
            return d2.compareTo(d1);
        }
    });
    
    pageContext.setAttribute("assignments", assignments);
    pageContext.setAttribute("assignmentCount", assignments.size());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduEnroll - Teacher Dashboard</title>
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --sidebar-width: 250px;
            --header-height: 60px;
            --primary-color: #3498db;
            --secondary-color: #2980b9;
            --dark-color: #343a40;
            --light-color: #ecf0f1;
            --success-color: #2ecc71;
            --warning-color: #f39c12;
            --danger-color: #e74c3c;
            --border-radius: 6px;
            --box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            display: flex;
            min-height: 100vh;
            background-color: #f5f7fa;
            color: #333;
        }
        
        .sidebar {
            width: var(--sidebar-width);
            background-color: var(--dark-color);
            color: white;
            height: 100vh;
            position: fixed;
            transition: all 0.3s;
            z-index: 1000;
            overflow-y: auto;
        }
        
        .sidebar-header {
            padding: 20px;
            background-color: rgba(0, 0, 0, 0.2);
            text-align: center;
        }
        
        .profile-header {
            display: flex;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .profile-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: var(--primary-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-right: 15px;
        }
        
        .sidebar-menu {
            padding: 10px 0;
        }
        
        .menu-item {
            padding: 12px 20px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            color: rgba(255, 255, 255, 0.8);
        }
        
        .menu-item:hover {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
        }
        
        .menu-item.active {
            background-color: var(--primary-color);
            color: white;
        }
        
        .menu-item i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        
        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            transition: all 0.3s;
        }
        
        .header {
            height: var(--header-height);
            background-color: white;
            box-shadow: var(--box-shadow);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .header-left h1 {
            font-size: 20px;
            color: var(--dark-color);
        }
        
        .header-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .user-profile {
            display: flex;
            align-items: center;
            cursor: pointer;
        }
        
        .user-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background-color: var(--primary-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
            font-weight: bold;
        }
        
        .btn-signout {
            padding: 8px 15px;
            border-radius: var(--border-radius);
            background-color: var(--danger-color);
            color: white;
            font-weight: 500;
            text-decoration: none;
            transition: background-color 0.3s;
        }
        
        .btn-signout:hover {
            background-color: #c0392b;
        }
        
        .content {
            padding: 20px;
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
        }
        
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 20px;
            display: flex;
            flex-direction: column;
        }
        
        .stat-value {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .stat-card.primary {
            border-top: 4px solid var(--primary-color);
        }
        
        .stat-card.warning {
            border-top: 4px solid var(--warning-color);
        }
        
        .stat-card.info {
            border-top: 4px solid #17a2b8;
        }
        
        .stat-card.danger {
            border-top: 4px solid var(--danger-color);
        }
        
        .welcome-card {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 20px;
            border-radius: var(--border-radius);
            margin-bottom: 20px;
        }
        
        .card {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            margin-bottom: 20px;
        }
        
        .card-header {
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            font-weight: 500;
        }
        
        .card-body {
            padding: 20px;
        }
        
        .btn {
            padding: 8px 15px;
            border-radius: var(--border-radius);
            cursor: pointer;
            border: none;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-block;
            text-align: center;
            text-decoration: none;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--secondary-color);
        }
        
        .btn-outline {
            background-color: transparent;
            border: 1px solid #ddd;
            color: #555;
        }
        
        .btn-outline:hover {
            background-color: #f5f5f5;
        }
        
        .btn-danger {
            background-color: var(--danger-color);
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #c0392b;
        }
        
        .btn-success {
            background-color: var(--success-color);
            color: white;
        }
        
        .btn-success:hover {
            background-color: #27ae60;
        }
        
        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
        }
        
        .mr-2 {
            margin-right: 0.5rem;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }
        
        .form-control {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            font-size: 14px;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .table th, .table td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
            text-align: left;
        }
        
        .table th {
            font-weight: 600;
            background-color: #f8f9fa;
        }
        
        .course-card {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            margin-bottom: 20px;
            padding: 20px;
            transition: transform 0.3s;
        }
        
        .course-card:hover {
            transform: translateY(-5px);
        }
        
        .course-title {
            color: var(--dark-color);
            margin-bottom: 10px;
            font-size: 18px;
        }
        
        .course-info {
            color: #666;
            margin-bottom: 15px;
        }
        
        .course-meta {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            color: #777;
        }
        
        .course-actions {
            display: flex;
            gap: 10px;
        }
        
        .attendance-container {
            display: grid;
            grid-template-columns: 1fr;
            gap: 20px;
        }
        
        @media (min-width: 768px) {
            .attendance-container {
                grid-template-columns: 300px 1fr;
            }
        }

        .currentDateTime {
            font-size: 0.9rem;
            color: rgba(255, 255, 255, 0.7);
            padding: 15px 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            margin-top: 20px;
        }
        
        @media (max-width: 768px) {
            .sidebar {
                width: 0;
                overflow: hidden;
            }
            
            .sidebar.active {
                width: var(--sidebar-width);
            }
            
            .main-content {
                margin-left: 0;
            }
            
            .menu-toggle {
                display: block !important;
            }
        }
        
        .menu-toggle {
            display: none;
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: var(--dark-color);
            margin-right: 15px;
        }
        
        .badge {
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .badge-primary {
            background-color: var(--primary-color);
            color: white;
        }
        
        .badge-success {
            background-color: var(--success-color);
            color: white;
        }
        
        .badge-danger {
            background-color: var(--danger-color);
            color: white;
        }
        
        .badge-light {
            background-color: white;
            color: var(--dark-color);
        }
        
        .error-message {
            color: var(--danger-color);
            margin-bottom: 15px;
            padding: 10px;
            background-color: #fdecea;
            border-radius: var(--border-radius);
            border-left: 4px solid var(--danger-color);
        }
        
        .success-message {
            color: var(--success-color);
            margin-bottom: 15px;
            padding: 10px;
            background-color: #e3f7eb;
            border-radius: var(--border-radius);
            border-left: 4px solid var(--success-color);
        }
        
        /* Simple Grid System */
        .row {
            display: flex;
            flex-wrap: wrap;
            margin: 0 -15px;
        }
        
        .col {
            flex: 1;
            padding: 0 15px;
        }
        
        .col-4 {
            flex: 0 0 33.333333%;
            max-width: 33.333333%;
            padding: 0 15px;
        }
        
        .col-6 {
            flex: 0 0 50%;
            max-width: 50%;
            padding: 0 15px;
        }
        
        .col-8 {
            flex: 0 0 66.666667%;
            max-width: 66.666667%;
            padding: 0 15px;
        }
        
        .col-12 {
            flex: 0 0 100%;
            max-width: 100%;
            padding: 0 15px;
        }
        
        @media (max-width: 768px) {
            .col, .col-4, .col-6, .col-8, .col-12 {
                flex: 0 0 100%;
                max-width: 100%;
            }
        }
        
        .mb-3 {
            margin-bottom: 15px;
        }
        
        .mb-4 {
            margin-bottom: 20px;
        }
        
        .mt-3 {
            margin-top: 15px;
        }
        
        .d-flex {
            display: flex;
        }
        
        .justify-content-between {
            justify-content: space-between;
        }
        
        .align-items-center {
            align-items: center;
        }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 2000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }
        
        .modal-content {
            background-color: #fefefe;
            margin: 10% auto;
            padding: 0;
            border: 1px solid #888;
            width: 50%;
            border-radius: var(--border-radius);
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            animation: modalopen 0.3s;
            max-width: 600px;
        }
        
        @keyframes modalopen {
          from {opacity: 0; transform: translateY(-30px);}
          to {opacity: 1; transform: translateY(0);}
        }
        
        .modal-header {
            padding: 15px 20px;
            background-color: var(--primary-color);
            color: white;
            border-top-left-radius: var(--border-radius);
            border-top-right-radius: var(--border-radius);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .modal-header h3 {
            margin: 0;
            font-size: 18px;
        }
        
        .close-modal {
            color: white;
            font-size: 24px;
            font-weight: bold;
            cursor: pointer;
            background: none;
            border: none;
            padding: 0;
            margin: 0;
        }
        
        .close-modal:hover {
            color: #f8f9fa;
        }
        
        .modal-body {
            padding: 20px;
        }
        
        .modal-footer {
            padding: 15px 20px;
            display: flex;
            justify-content: flex-end;
            border-top: 1px solid #e9ecef;
            gap: 10px;
        }
        
        @media (max-width: 768px) {
            .modal-content {
                width: 90%;
            }
        }
        
        /* Search box style */
        .search-box {
            position: relative;
            margin-bottom: 15px;
        }
        
        .search-box input {
            width: 100%;
            padding: 10px 15px;
            padding-left: 35px;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            font-size: 14px;
        }
        
        .search-box i {
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
        }
        
        /* Filter tabs */
        .filter-tabs {
            display: flex;
            margin-bottom: 20px;
            border-bottom: 1px solid #ddd;
        }

        .filter-tab {
            padding: 10px 15px;
            cursor: pointer;
            border-bottom: 2px solid transparent;
            transition: all 0.3s;
        }

        .filter-tab:hover {
            color: var(--primary-color);
        }

        .filter-tab.active {
            border-bottom: 2px solid var(--primary-color);
            color: var(--primary-color);
            font-weight: 500;
        }
        
        /* Student card styles */
        .student-card {
            display: flex;
            justify-content: space-between;
            padding: 15px;
            border-radius: var(--border-radius);
            background-color: white;
            box-shadow: var(--box-shadow);
            margin-bottom: 15px;
            transition: transform 0.2s;
        }
        
        .student-card:hover {
            transform: translateY(-3px);
        }
        
        .student-info {
            flex: 1;
        }
        
        .student-name {
            font-size: 16px;
            font-weight: 500;
            margin-bottom: 5px;
        }
        
        .student-email {
            color: #666;
            margin-bottom: 5px;
        }
        
        .student-year {
            font-size: 13px;
            color: #555;
        }
        
        .registration-time {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
            font-style: italic;
        }
        
        /* Animation for sorting */
        .highlight {
            animation: highlight 1s ease-in-out;
        }
        
        @keyframes highlight {
            0% { background-color: rgba(52, 152, 219, 0.2); }
            100% { background-color: transparent; }
        }
        
        /* Message system styles */
        .message-item {
            cursor: pointer;
            transition: all 0.2s;
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }
        
        .message-item:hover {
            background-color: #f8f9fa;
        }
        
        .message-item.active {
            background-color: #e9f5ff;
            border-left: 3px solid var(--primary-color);
        }
        
        .message-item.unread {
            background-color: #f0f7ff;
        }
        
        .message-subject {
            font-weight: 500;
            margin-top: 5px;
        }
        
        .message-preview {
            color: #666;
            font-size: 13px;
            margin-top: 5px;
        }
        
        .message-meta {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: var(--border-radius);
        }
        
        .message-body {
            padding: 10px 0;
            white-space: pre-line;
        }
        
        .message-body p {
            margin-bottom: 16px;
        }
        
        /* Animation for new messages */
        @keyframes newMessage {
            from { background-color: rgba(52, 152, 219, 0.3); }
            to { background-color: transparent; }
        }
        
        .new-message {
            animation: newMessage 2s ease-in-out;
        }
        
        /* Basic notification style */
        #notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            z-index: 9999;
            transition: all 0.5s ease;
            opacity: 0;
            transform: translateY(-20px);
        }
        
        /* List group styles */
        .list-group {
            display: flex;
            flex-direction: column;
            padding-left: 0;
            margin-bottom: 0;
        }
        
        .list-group-item {
            position: relative;
            display: block;
            padding: .75rem 1.25rem;
            background-color: #fff;
            border: 1px solid rgba(0,0,0,.125);
        }
        
        .list-group-flush .list-group-item {
            border-right: 0;
            border-left: 0;
            border-radius: 0;
        }
        
        .list-group-item:first-child {
            border-top-left-radius: .25rem;
            border-top-right-radius: .25rem;
        }
        
        .list-group-item:last-child {
            border-bottom-left-radius: .25rem;
            border-bottom-right-radius: .25rem;
        }
        
        /* Form validation styles */
        .is-invalid {
            border-color: #e74c3c !important;
            box-shadow: 0 0 0 0.2rem rgba(231, 76, 60, 0.25) !important;
        }
        
        .invalid-feedback {
            display: none;
            width: 100%;
            margin-top: 0.25rem;
            font-size: 80%;
            color: #e74c3c;
        }
        
        .is-invalid + .invalid-feedback {
            display: block;
        }
        
        .text-danger {
            color: #e74c3c !important;
        }
        
        /* Progress bar */
        .progress {
            display: flex;
            height: 6px;
            overflow: hidden;
            background-color: #e9ecef;
            border-radius: 0.25rem;
        }
        
        .progress-bar {
            display: flex;
            flex-direction: column;
            justify-content: center;
            overflow: hidden;
            color: #fff;
            text-align: center;
            white-space: nowrap;
            background-color: var(--primary-color);
            transition: width 0.6s ease;
        }
        
        /* Assignment specific styles */
        .text-muted {
            color: #6c757d !important;
        }
        
        .text-center {
            text-align: center !important;
        }
        
        .action-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        
        .table-responsive {
            display: block;
            width: 100%;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }
        
        @media (min-width: 768px) {
            .col-md-4 {
                flex: 0 0 33.333333%;
                max-width: 33.333333%;
            }
        }
    </style>
    
    <!-- Message Button Fix Script -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            console.log("🚀 Message Button Enhancement Script - v1.1");
            
            // Wait for the DOM to be fully loaded
            setTimeout(function() {
                const sendMessageBtn = document.getElementById('sendMessageBtn');
                
                if (sendMessageBtn) {
                    console.log("🔍 Found message button, fixing event handlers...");
                    
                    // Remove any existing event handlers (to prevent duplicates)
                    const newSendMessageBtn = sendMessageBtn.cloneNode(true);
                    if (sendMessageBtn.parentNode) {
                        sendMessageBtn.parentNode.replaceChild(newSendMessageBtn, sendMessageBtn);
                    }
                    
                    // Add our new improved event handler
                    newSendMessageBtn.addEventListener('click', function(event) {
                        // Prevent any default behaviors
                        event.preventDefault();
                        event.stopPropagation();
                        
                        console.log("📨 Send Message button clicked");
                        
                        // Form validation
                        const recipientField = document.getElementById('recipient');
                        const subjectField = document.getElementById('subject');
                        const contentField = document.getElementById('messageContent');
                        
                        if (!recipientField || !subjectField || !contentField) {
                            console.error("❌ Required form fields not found!");
                            alert("Error: Form fields not found. Please refresh the page and try again.");
                            return;
                        }
                        
                        console.log("📝 Form values:", {
                            recipient: recipientField.value,
                            subject: subjectField.value,
                            content_length: contentField.value ? contentField.value.length : 0
                        });
                        
                        // Reset validation classes
                        document.querySelectorAll('.is-invalid').forEach(field => {
                            field.classList.remove('is-invalid');
                        });
                        
                        // Validate required fields
                        let isValid = true;
                        if (!recipientField.value.trim()) {
                            recipientField.classList.add('is-invalid');
                            isValid = false;
                        }
                        
                        if (!subjectField.value.trim()) {
                            subjectField.classList.add('is-invalid');
                            isValid = false;
                        }
                        
                        if (!contentField.value.trim()) {
                            contentField.classList.add('is-invalid');
                            isValid = false;
                        }
                        
                        if (!isValid) {
                            console.log("❌ Validation failed");
                            showNotification('Please fill in all required fields', 'error');
                            return;
                        }
                        
                        // Show sending state
                        this.disabled = true;
                        this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';
                        console.log("📤 Preparing to send message...");
                        
                        // Create form data
                        const formData = new URLSearchParams();
                        formData.append('action', 'create');
                        formData.append('recipient', recipientField.value.trim());
                        formData.append('subject', subjectField.value.trim());
                        formData.append('content', contentField.value.trim());
                        
                        // Add optional fields
                        const categoryField = document.getElementById('category');
                        if (categoryField && categoryField.value) {
                            formData.append('category', categoryField.value);
                        }
                        
                        const importantField = document.getElementById('important');
                        if (importantField && importantField.checked) {
                            formData.append('important', 'true');
                        }
                        
                        // Log the request
                        console.log("📤 Sending request to MessageServlet:", formData.toString());
                        
                        // Send the message using fetch API
                        fetch('MessageServlet', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: formData.toString()
                        })
                        .then(response => {
                            console.log(`📥 Response status: ${response.status}`);
                            if (!response.ok) {
                                throw new Error(`Server returned ${response.status}: ${response.statusText}`);
                            }
                            return response.json().catch(e => {
                                console.error("📛 Error parsing JSON response:", e);
                                return { success: false, message: "Invalid server response format" };
                            });
                        })
                        .then(data => {
                            console.log("📋 Response data:", data);
                            
                            if (data && data.success) {
                                // Success - close modal and show notification
                                const newMessageModal = document.getElementById('newMessageModal');
                                if (newMessageModal) newMessageModal.style.display = 'none';
                                
                                showNotification('Message sent successfully!', 'success');
                                
                                // Reset form
                                const form = document.getElementById('messageForm');
                                if (form) form.reset();
                                
                                // Redirect after delay
                                setTimeout(() => {
                                    window.location.href = 'MessageServlet?action=sent';
                                }, 1500);
                            } else {
                                // Error handling
                                const errorMsg = data && data.message ? data.message : 'Unknown error sending message';
                                showNotification('Error: ' + errorMsg, 'error');
                            }
                        })
                        .catch(error => {
                            console.error("❌ Fetch error:", error);
                            showNotification('Error sending message: ' + error.message, 'error');
                        })
                        .finally(() => {
                            // Reset button state regardless of outcome
                            this.disabled = false;
                            this.innerHTML = '<i class="fas fa-paper-plane"></i> Send Message';
                        });
                    });
                    
                    console.log("✅ Message button event handler replaced successfully");
                } else {
                    console.error("❌ Send message button not found in the DOM!");
                }
            }, 500); // Small delay to ensure DOM is ready
        });
    </script>
</head>
<body>
    <!-- Sidebar Navigation -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h2>EduEnroll</h2>
            <p>Teacher Portal</p>
        </div>
        
        <div class="profile-header">
            <div class="profile-avatar">
                <%= teacher.getFirstName().charAt(0) %><%= teacher.getLastName().charAt(0) %>
            </div>
            <div>
                <h6><%= teacherFullName %></h6>
                <small><%= teacher.getDepartment() %></small>
            </div>
        </div>
        
        <div class="sidebar-menu">
            <div class="menu-item ${activeTab == 'dashboard' ? 'active' : ''}" data-tab="dashboard" onclick="return switchTab('dashboard');">
                <i class="fas fa-tachometer-alt"></i>
                <span>Dashboard</span>
            </div>
            <div class="menu-item ${activeTab == 'courses' ? 'active' : ''}" data-tab="courses" onclick="return switchTab('courses');">
                <i class="fas fa-book"></i>
                <span>My Courses</span>
            </div>
            <div class="menu-item ${activeTab == 'students' ? 'active' : ''}" data-tab="students" onclick="return switchTab('students');">
                <i class="fas fa-user-graduate"></i>
                <span>Students</span>
            </div>
            <div class="menu-item ${activeTab == 'attendance' ? 'active' : ''}" data-tab="attendance" onclick="return switchTab('attendance');">
                <i class="fas fa-clipboard-check"></i>
                <span>Attendance</span>
            </div>
            <div class="menu-item ${activeTab == 'grades' ? 'active' : ''}" data-tab="grades" onclick="return switchTab('grades');">
                <i class="fas fa-chart-bar"></i>
                <span>Grades</span>
            </div>
            <div class="menu-item ${activeTab == 'assignments' ? 'active' : ''}" data-tab="assignments" onclick="return switchTab('assignments');">
                <i class="fas fa-tasks"></i>
                <span>Assignments</span>
            </div>
            <div class="menu-item ${activeTab == 'messages' ? 'active' : ''}" data-tab="messages" onclick="return switchTab('messages');">
                <i class="fas fa-envelope"></i>
                <span>Messages</span>
                <c:if test="${unreadCount > 0}">
                    <span class="badge badge-danger">${unreadCount}</span>
                </c:if>
            </div>
            <div class="menu-item ${activeTab == 'profile' ? 'active' : ''}" data-tab="profile" onclick="return switchTab('profile');">
                <i class="fas fa-user-circle"></i>
                <span>My Profile</span>
            </div>
        </div>
        
        <div class="currentDateTime">
            Current Date and Time:<br>
            <%= currentDateTime %><br>
            User: <%= currentUserLogin %>
        </div>
    </div>

    <!-- Mobile Navigation -->
    <div class="menu-toggle">
        <i class="fas fa-bars"></i>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <div class="header-left">
                <button class="menu-toggle">
                    <i class="fas fa-bars"></i>
                </button>
                <h1 id="page-title">
                    ${activeTab == 'dashboard' ? 'Dashboard' : 
                      activeTab == 'courses' ? 'My Courses' : 
                      activeTab == 'students' ? 'Students' : 
                      activeTab == 'attendance' ? 'Attendance' : 
                      activeTab == 'grades' ? 'Grades' : 
                      activeTab == 'assignments' ? 'Assignments' : 
                      activeTab == 'messages' ? 'Messages' : 
                      activeTab == 'profile' ? 'My Profile' : 'Dashboard'}
                </h1>
            </div>
            <div class="header-right">
                <div class="user-profile">
                    <div class="user-avatar">
                        <%= teacher.getFirstName().charAt(0) %><%= teacher.getLastName().charAt(0) %>
                    </div>
                    <span><%= teacherFullName %></span>
                </div>
                <a href="logout" class="btn-signout">
                    Sign Out
                </a>
            </div>
        </div>

        <div class="content">
            <!-- Success and Error Messages -->
            <c:if test="${not empty successMessage}">
                <div class="success-message">
                    <i class="fas fa-check-circle"></i> ${successMessage}
                </div>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                </div>
            </c:if>
            
            <!-- Dashboard Tab -->
            <div class="tab-content ${activeTab == 'dashboard' ? 'active' : ''}" id="dashboard">
                <div class="welcome-card">
                    <h2>Welcome, <%= teacherFullName %>!</h2>
                    <p>Today is <%= new SimpleDateFormat("EEEE, MMMM d, yyyy").format(new Date()) %></p>
                    <p>Current Time (UTC): <%= currentDateTime %></p>
                </div>
                
                <div class="stats-container">
                    <div class="stat-card primary">
                        <i class="fas fa-book fa-2x mb-3"></i>
                        <div class="stat-value">${courseCount}</div>
                        <div class="stat-label">Active Courses</div>
                    </div>
                    <div class="stat-card info">
                        <i class="fas fa-user-graduate fa-2x mb-3"></i>
                        <div class="stat-value">${studentCount}</div>
                        <div class="stat-label">Enrolled Students</div>
                    </div>
                    <div class="stat-card warning">
                        <i class="fas fa-tasks fa-2x mb-3"></i>
                        <div class="stat-value">${assignmentCount}</div>
                        <div class="stat-label">Assignments</div>
                    </div>
                    <div class="stat-card danger">
                        <i class="fas fa-comment fa-2x mb-3"></i>
                        <div class="stat-value">${unreadCount}</div>
                        <div class="stat-label">Unread Messages</div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-6">
                        <div class="card">
                            <div class="card-header">
                                <h3>Upcoming Classes</h3>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${empty courses}">
                                        <p>No upcoming classes available.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${courses}" var="course" begin="0" end="2">
                                            <div class="mb-3">
                                                <h4>${course.courseCode}: ${course.title}</h4>
                                                <p>${course.day} at ${course.time}</p>
                                                <p>${course.enrolledStudents} students enrolled</p>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-6">
                        <div class="card">
                            <div class="card-header">
                                <h3>Recently Registered Students</h3>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${empty recentStudents}">
                                        <p>No recently registered students.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${recentStudents}" var="student">
                                            <div class="student-card">
                                                <div class="student-info">
                                                    <div class="student-name">${student.name}</div>
                                                    <div class="student-email">${student.email}</div>
                                                    <div class="student-year">Year: ${student.enrollmentYear}</div>
                                                    <div class="registration-time">Registered: ${student.registrationTimestamp}</div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Courses Tab -->
            <div class="tab-content ${activeTab == 'courses' ? 'active' : ''}" id="courses">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>My Courses</h2>
                    <button id="openAddCourseModal" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add New Course
                    </button>
                </div>
                
                <c:if test="${not empty courseReadError}">
                    <div class="error-message">
                        ${courseReadError}
                    </div>
                </c:if>
                
                <div class="row">
                    <c:choose>
                        <c:when test="${empty courses}">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-body">
                                        <p>No courses available. Click "Add New Course" to create your first course.</p>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${courses}" var="course">
                                <div class="col-6">
                                    <div class="course-card">
                                        <h3 class="course-title">${course.courseCode}: ${course.title}</h3>
                                        <p class="course-info">${course.description}</p>
                                        <div class="course-meta">
                                            <span>${course.day} at ${course.time}</span>
                                            <span>${course.enrolledStudents} students</span>
                                        </div>
                                        <div class="course-actions">
                                            <a href="#" class="btn btn-primary">Edit</a>
                                            <a href="#" class="btn btn-outline">View Students</a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Students Tab -->
            <div class="tab-content ${activeTab == 'students' ? 'active' : ''}" id="students">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Students</h2>
                    <button id="openAddStudentModal" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add Student
                    </button>
                </div>
                
                <c:if test="${not empty studentReadError}">
                    <div class="error-message">
                        ${studentReadError}
                    </div>
                </c:if>
                
                <div class="card mb-4">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h3>Student Management</h3>
                            <div>
                                <span class="badge badge-primary">${studentCount} students registered</span>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <!-- Search and Filter Section -->
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" id="studentSearch" placeholder="Search by name, username, or email...">
                        </div>
                        
                        <div class="filter-tabs">
                            <div class="filter-tab active" data-filter="all">All Students</div>
                            <div class="filter-tab" data-filter="2025">Year 2025</div>
                            <div class="filter-tab" data-filter="2024">Year 2024</div>
                            <div class="filter-tab" data-filter="2023">Year 2023</div>
                        </div>
                        
                        <div id="studentsContainer">
                            <c:choose>
                                <c:when test="${empty students}">
                                    <p>No students available. Click "Add Student" to add your first student.</p>
                                </c:when>
                                <c:otherwise>
                                    <div style="overflow-x:auto;">
                                        <table class="table" id="studentsTable">
                                            <thead>
                                                <tr>
                                                    <th>Username</th>
                                                    <th>Name</th>
                                                    <th>Email</th>
                                                    <th>Enrollment Year</th>
                                                    <th class="sortable" data-column="registration">
                                                        Registration Time 
                                                        <span class="sort-indicator">
                                                            <i class="fas fa-sort-amount-${sortOrder == 'asc' ? 'up' : 'down'}"></i>
                                                        </span>
                                                    </th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${students}" var="student">
                                                    <tr class="student-row" data-year="${student.enrollmentYear}">
                                                        <td>${student.studentName}</td>
                                                        <td>${student.name}</td>
                                                        <td>${student.email}</td>
                                                        <td>${student.enrollmentYear}</td>
                                                        <td>${student.registrationTimestamp}</td>
                                                        <td>
                                                            <button class="btn btn-primary btn-sm edit-student" 
                                                                   data-student-username="${student.studentName}"
                                                                   data-student-name="${student.name}"
                                                                   data-student-email="${student.email}"
                                                                   data-student-year="${student.enrollmentYear}">
                                                                <i class="fas fa-edit"></i> Edit
                                                            </button>
                                                            <button class="btn btn-outline btn-sm delete-student"
                                                                   data-student-username="${student.studentName}">
                                                                <i class="fas fa-trash"></i> Delete
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Attendance Tab -->
            <div class="tab-content ${activeTab == 'attendance' ? 'active' : ''}" id="attendance">
                <h2 class="mb-4">Attendance</h2>
                
                <div class="attendance-container">
                    <div class="card">
                        <div class="card-header">
                            <h3>Courses</h3>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty courses}">
                                    <p>No courses available to mark attendance.</p>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${courses}" var="course">
                                        <div class="mb-3">
                                            <a href="#" class="btn btn-outline" style="width:100%; text-align:left;">
                                                ${course.courseCode}: ${course.title}
                                            </a>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header">
                            <h3>Mark Attendance</h3>
                        </div>
                        <div class="card-body">
                            <p>Select a course from the left to mark attendance for students.</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Grades Tab -->
            <div class="tab-content ${activeTab == 'grades' ? 'active' : ''}" id="grades">
                <h2 class="mb-4">Grades Management</h2>
                
                <div class="card">
                    <div class="card-header">
                        <h3>Select Course</h3>
                    </div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="course-select">Choose a course:</label>
                            <select id="course-select" class="form-control">
                                <option value="">-- Select Course --</option>
                                <c:forEach items="${courses}" var="course">
                                    <option value="${course.courseCode}">${course.courseCode}: ${course.title}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div id="grades-content">
                            <p>Please select a course to view and manage grades.</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Assignments Tab -->
            <div class="tab-content ${activeTab == 'assignments' ? 'active' : ''}" id="assignments">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Assignments Management</h2>
                    <a href="createAssignment.jsp" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Create Assignment
                    </a>
                </div>
                
                <!-- Current Date/Time Info -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <span><strong>Current DateTime:</strong> ${currentDateTime}</span>
                            <span><strong>User:</strong> ${currentUserLogin}</span>
                        </div>
                    </div>
                </div>
                
                <!-- Assignment Filters -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h3>Assignment Filters</h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="coursesFilter">Filter by Course</label>
                                    <select id="coursesFilter" class="form-control">
                                        <option value="">All Courses</option>
                                        <c:forEach items="${courses}" var="course">
                                            <option value="${course.courseCode}">${course.courseCode}: ${course.title}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="statusFilter">Filter by Status</label>
                                    <select id="statusFilter" class="form-control">
                                        <option value="">All Status</option>
                                        <option value="active">Active</option>
                                        <option value="upcoming">Upcoming</option>
                                                                                <option value="active">Active</option>
                                        <option value="upcoming">Upcoming</option>
                                        <option value="past">Past Due</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>&nbsp;</label>
                                    <div>
                                        <button id="applyFilters" class="btn btn-primary">
                                            <i class="fas fa-filter"></i> Apply Filters
                                        </button>
                                        <button id="resetFilters" class="btn btn-outline">
                                            <i class="fas fa-undo"></i> Reset
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Assignments List -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h3>Your Assignments</h3>
                        <div>
                            <span class="badge badge-primary">
                                <i class="fas fa-list"></i> <span id="assignmentCount">${assignmentCount}</span> assignments
                            </span>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table" id="assignmentTable">
                                <thead>
                                    <tr>
                                        <th>Title</th>
                                        <th>Course</th>
                                        <th>Due Date</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty assignments}">
                                            <tr>
                                                <td colspan="5" class="text-center">No assignments found.</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${assignments}" var="assignment">
                                                <tr>
                                                    <td>
                                                        <strong>${assignment.title}</strong>
                                                    </td>
                                                    <td>${assignment.courseCode}
                                                        <c:if test="${not empty assignment.courseTitle}">
                                                            : ${assignment.courseTitle}
                                                        </c:if>
                                                    </td>
                                                    <td><fmt:formatDate value="${assignment.dueDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                                    <td>
                                                        <c:set var="now" value="<%= new java.util.Date() %>" />
                                                        <c:choose>
                                                            <c:when test="${assignment.dueDate.time < now.time}">
                                                                <span class="badge badge-danger">Past Due</span>
                                                            </c:when>
                                                            <c:when test="${assignment.dueDate.time < now.time + 86400000 * 3}">
                                                                <span class="badge badge-primary">Active</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-success">Upcoming</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline action-btn" data-assignment-id="${assignment.id}" data-assignment-title="${assignment.title}">
                                                            <i class="fas fa-ellipsis-v"></i>
                                                        </button>
                                                        <a href="AssignmentServlet?action=view&id=${assignment.id}" class="btn btn-sm btn-primary">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="editAssignment.jsp?id=${assignment.id}" class="btn btn-sm btn-outline">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Empty state message -->
                        <div id="emptyAssignments" class="text-center p-5" style="display: ${empty assignments ? 'block' : 'none'}">
                            <img src="assets/img/empty-assignments.svg" alt="No assignments" style="width: 120px; opacity: 0.5;" onerror="this.style.display='none'">
                            <h4 class="mt-3 text-muted">No assignments found</h4>
                            <p class="text-muted">Get started by creating your first assignment!</p>
                            <a href="createAssignment.jsp" class="btn btn-primary mt-2">
                                <i class="fas fa-plus"></i> Create Assignment
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Messages Tab -->
            <div class="tab-content ${activeTab == 'messages' ? 'active' : ''}" id="messages">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Messages 
                        <c:if test="${unreadCount > 0}">
                            <span class="badge badge-danger">${unreadCount} new</span>
                        </c:if>
                    </h2>
                    <button id="openNewMessageModal" class="btn btn-primary">
                        <i class="fas fa-plus"></i> New Message
                    </button>
                </div>
                
                <div class="row">
                    <div class="col-4">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h3>Inbox</h3>
                                <div>
                                    <a href="${pageContext.request.contextPath}/MessageServlet?action=inbox" 
                                       class="btn btn-sm ${messageType != 'sent' ? 'btn-primary' : 'btn-outline'}" 
                                       id="inboxTabBtn" title="Inbox">
                                        <i class="fas fa-inbox"></i>
                                        <c:if test="${unreadCount > 0}">
                                            <span class="badge badge-light">${unreadCount}</span>
                                        </c:if>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/MessageServlet?action=sent" 
                                       class="btn btn-sm ${messageType == 'sent' ? 'btn-primary' : 'btn-outline'}" 
                                       id="sentTabBtn" title="Sent Messages">
                                        <i class="fas fa-paper-plane"></i>
                                    </a>
                                </div>
                            </div>
                            <div class="card-body p-0" style="max-height: 500px; overflow-y: auto;">
                                <div class="search-box m-3">
                                    <i class="fas fa-search"></i>
                                    <input type="text" id="messageSearch" placeholder="Search messages...">
                                </div>
                                
                                <div id="messagesList">
                                    <c:choose>
                                        <c:when test="${empty messages}">
                                            <div class="text-center p-4">
                                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                                <p>No messages ${messageType == 'sent' ? 'sent' : 'received'} yet.</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <ul class="list-group list-group-flush">
                                                <c:forEach items="${messages}" var="msg">
                                                    <li class="list-group-item message-item ${!msg.read && messageType != 'sent' ? 'unread' : ''}" 
                                                        data-id="${msg.id}" data-search="${msg.subject} ${msg.sender} ${msg.content}">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <strong class="${!msg.read && messageType != 'sent' ? 'font-weight-bold' : ''}">
                                                                ${messageType == 'sent' ? msg.recipient : msg.sender}
                                                            </strong>
                                                            <small class="text-muted">
                                                                <fmt:formatDate value="${msg.timestamp}" pattern="MM/dd/yyyy HH:mm" />
                                                            </small>
                                                        </div>
                                                        <div class="message-subject">
                                                            ${msg.subject}
                                                            <c:if test="${msg.important}">
                                                                <i class="fas fa-exclamation-circle text-warning"></i>
                                                            </c:if>
                                                        </div>
                                                        <div class="message-preview">
                                                            ${fn:substring(msg.content, 0, 60)}${fn:length(msg.content) > 60 ? '...' : ''}
                                                        </div>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-8">
                        <div class="card" id="messageContent">
                            <c:choose>
                                <c:when test="${not empty message}">
                                    <!-- Single message view -->
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <h4>${message.subject}</h4>
                                        <div>
                                            <button class="btn btn-sm btn-danger delete-message" data-id="${message.id}">
                                                <i class="fas fa-trash"></i> Delete
                                            </button>
                                            <c:if test="${canReply}">
                                                <button class="btn btn-sm btn-primary reply-message" 
                                                        data-recipient="${message.sender}" 
                                                        data-subject="Re: ${message.subject}">
                                                    <i class="fas fa-reply"></i> Reply
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="message-meta mb-4">
                                            <div class="row">
                                                <div class="col-6">
                                                    <strong>From:</strong> ${message.sender}
                                                </div>
                                                <div class="col-6">
                                                    <strong>To:</strong> ${message.recipient}
                                                </div>
                                            </div>
                                            <div class="row mt-2">
                                                <div class="col-6">
                                                    <strong>Date:</strong> <fmt:formatDate value="${message.timestamp}" pattern="MMMM d, yyyy 'at' HH:mm" />
                                                </div>
                                                <div class="col-6">
                                                    <c:if test="${not empty message.category}">
                                                        <strong>Category:</strong> ${message.category}
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="message-body">
                                            <p>${message.content}</p>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Default view -->
                                    <div class="card-header">
                                        <h3>Message Content</h3>
                                    </div>
                                    <div class="card-body text-center">
                                        <i class="fas fa-envelope fa-4x text-muted mb-3"></i>
                                        <p>Select a message to view its contents.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Profile Tab -->
            <div class="tab-content ${activeTab == 'profile' ? 'active' : ''}" id="profile">
                <h2 class="mb-4">My Profile</h2>
                
                <div class="row">
                    <div class="col-4">
                        <div class="card">
                            <div class="card-header">
                                <h3>Account Information</h3>
                            </div>
                            <div class="card-body">
                                <div class="profile-avatar" style="width:100px; height:100px; margin:0 auto 20px; font-size:2.5rem;">
                                    <%= teacher.getFirstName().charAt(0) %><%= teacher.getLastName().charAt(0) %>
                                </div>
                                
                                <p><strong>Name:</strong> <%= teacherFullName %></p>
                                <p><strong>Email:</strong> <%= teacher.getEmail() %></p>
                                <p><strong>Department:</strong> <%= teacher.getDepartment() %></p>
                                <p><strong>User ID:</strong> <%= currentUserLogin %></p>
                                <p><strong>Last Login:</strong> <%= currentDateTime %></p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-8">
                        <div class="card mb-4">
                            <div class="card-header">
                                <h3>Edit Profile</h3>
                            </div>
                            <div class="card-body">
                                <form>
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="form-group">
                                                <label for="firstName">First Name</label>
                                                <input type="text" id="firstName" name="firstName" class="form-control" value="<%= teacher.getFirstName() %>">
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="form-group">
                                                <label for="lastName">Last Name</label>
                                                <input type="text" id="lastName" name="lastName" class="form-control" value="<%= teacher.getLastName() %>">
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="email">Email</label>
                                        <input type="email" id="email" name="email" class="form-control" value="<%= teacher.getEmail() %>">
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="department">Department</label>
                                        <input type="text" id="department" name="department" class="form-control" value="<%= teacher.getDepartment() %>">
                                    </div>
                                    
                                    <button type="submit" class="btn btn-primary">Update Profile</button>
                                </form>
                            </div>
                        </div>
                        
                        <div class="card">
                            <div class="card-header">
                                <h3>Change Password</h3>
                            </div>
                            <div class="card-body">
                                <form>
                                    <div class="form-group">
                                        <label for="currentPassword">Current Password</label>
                                        <input type="password" id="currentPassword" name="currentPassword" class="form-control">
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="newPassword">New Password</label>
                                        <input type="password" id="newPassword" name="newPassword" class="form-control">
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="confirmPassword">Confirm New Password</label>
                                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control">
                                    </div>
                                    
                                    <button type="submit" class="btn btn-primary">Change Password</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- New Message Modal -->
    <div id="newMessageModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>New Message</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="messageForm">
                    <!-- Updated timestamp -->
                    <input type="hidden" name="timestamp" value="2025-05-16 22:26:55">
                    <input type="hidden" name="action" value="create">
                    
                    <div class="form-group">
                        <label for="recipient">To: <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="recipient" name="recipient" 
                               placeholder="Enter username or select a recipient" required>
                        <div class="invalid-feedback">Please enter a recipient</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="subject">Subject: <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="subject" name="subject" required>
                        <div class="invalid-feedback">Please enter a subject</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="messageContent">Message: <span class="text-danger">*</span></label>
                        <textarea class="form-control" id="messageContent" name="content" rows="5" required></textarea>
                        <div class="invalid-feedback">Please enter your message</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="category">Category:</label>
                        <select class="form-control" id="category" name="category">
                            <option value="">-- Select Category --</option>
                            <option value="personal">Personal</option>
                            <option value="course">Course Related</option>
                            <option value="announcement">Announcement</option>
                            <option value="schedule">Schedule</option>
                            <option value="grades">Grades</option>
                            <option value="other">Other</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input" id="important" name="important">
                            <label class="form-check-label" for="important">Mark as important</label>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline close-modal-btn">Cancel</button>
                <button type="button" class="btn btn-primary" id="sendMessageBtn">
                    <i class="fas fa-paper-plane"></i> Send Message
                </button>
            </div>
        </div>
    </div>
    
    <!-- Add New Course Modal -->
    <div id="addCourseModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Add New Course</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="addCourseForm" action="${pageContext.request.contextPath}/CourseServlet" method="post">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="createdBy" value="IT24103866">
                    <input type="hidden" name="creationDate" value="2025-05-16 22:26:55">
                    
                    <div class="form-group">
                        <label for="courseCode">Course Code <span class="text-danger">*</span></label>
                        <input type="text" id="courseCode" name="courseCode" class="form-control" required placeholder="e.g., CS101">
                        <div class="invalid-feedback">Please enter a course code</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="courseTitle">Course Title <span class="text-danger">*</span></label>
                        <input type="text" id="courseTitle" name="courseTitle" class="form-control" required placeholder="e.g., Introduction to Computer Science">
                        <div class="invalid-feedback">Please enter a course title</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="courseDescription">Course Description</label>
                        <textarea id="courseDescription" name="courseDescription" class="form-control" rows="3" placeholder="Brief description of the course"></textarea>
                    </div>
                    
                    <div class="row">
                        <div class="col-6">
                            <div class="form-group">
                                <label for="courseDay">Day <span class="text-danger">*</span></label>
                                <select id="courseDay" name="courseDay" class="form-control" required>
                                    <option value="">Select Day</option>
                                    <option value="Monday">Monday</option>
                                    <option value="Tuesday">Tuesday</option>
                                    <option value="Wednesday">Wednesday</option>
                                    <option value="Thursday">Thursday</option>
                                    <option value="Friday">Friday</option>
                                    <option value="Saturday">Saturday</option>
                                    <option value="Sunday">Sunday</option>
                                </select>
                                <div class="invalid-feedback">Please select a day</div>
                            </div>
                        </div>
                        
                        <div class="col-6">
                            <div class="form-group">
                                <label for="courseTime">Time <span class="text-danger">*</span></label>
                                <input type="time" id="courseTime" name="courseTime" class="form-control" required>
                                <div class="invalid-feedback">Please enter a time</div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline close-modal-btn">Cancel</button>
                <button type="button" class="btn btn-primary" id="saveCourseBtn">Save Course</button>
            </div>
        </div>
    </div>

    <!-- Add New Student Modal -->
    <div id="addStudentModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Add New Student</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="addStudentForm" action="${pageContext.request.contextPath}/StudentServlet" method="post">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="registrationTimestamp" value="2025-05-16 22:26:55">
                    
                    <div class="form-group">
                        <label for="studentName">Username (Student ID) <span class="text-danger">*</span></label>
                        <input type="text" id="studentName" name="studentName" class="form-control" required placeholder="e.g., jsmith123">
                        <div class="invalid-feedback">Please enter a username</div>
                    </div>
                    
                    <div class="row">
                        <div class="col-6">
                            <div class="form-group">
                                <label for="studentFirstName">First Name <span class="text-danger">*</span></label>
                                <input type="text" id="studentFirstName" name="firstName" class="form-control" required>
                                <div class="invalid-feedback">Please enter first name</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="form-group">
                                <label for="studentLastName">Last Name <span class="text-danger">*</span></label>
                                <input type="text" id="studentLastName" name="lastName" class="form-control" required>
                                <div class="invalid-feedback">Please enter last name</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="studentEmail">Email <span class="text-danger">*</span></label>
                        <input type="email" id="studentEmail" name="email" class="form-control" required placeholder="student@example.com">
                        <div class="invalid-feedback">Please enter a valid email address</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="studentPassword">Password <span class="text-danger">*</span></label>
                        <input type="password" id="studentPassword" name="password" class="form-control" required>
                        <small class="text-muted">Password must be at least 8 characters long</small>
                        <div class="invalid-feedback">Password must be at least 8 characters long</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="studentDepartment">Department</label>
                        <input type="text" id="studentDepartment" name="department" class="form-control" value="Computer Science">
                    </div>
                    
                    <div class="form-group">
                        <label for="enrollmentYear">Enrollment Year <span class="text-danger">*</span></label>
                        <select id="enrollmentYear" name="enrollmentYear" class="form-control" required>
                            <option value="2025">2025</option>
                            <option value="2024">2024</option>
                            <option value="2023">2023</option>
                            <option value="2022">2022</option>
                        </select>
                        <div class="invalid-feedback">Please select enrollment year</div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline close-modal-btn">Cancel</button>
                <button type="button" class="btn btn-primary" id="saveStudentBtn">Save Student</button>
            </div>
        </div>
    </div>
    
    <!-- Edit Student Modal -->
    <div id="editStudentModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Edit Student</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="editStudentForm" action="${pageContext.request.contextPath}/StudentActionServlet" method="post">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="lastModified" value="2025-05-16 22:26:55">
                    <input type="hidden" name="modifiedBy" value="IT24103866">
                    <input type="hidden" id="editStudentName" name="studentName" value="">
                    
                    <div class="row">
                        <div class="col-6">
                            <div class="form-group">
                                <label for="editStudentFirstName">First Name <span class="text-danger">*</span></label>
                                <input type="text" id="editStudentFirstName" name="firstName" class="form-control" required>
                                <div class="invalid-feedback">Please enter first name</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="form-group">
                                <label for="editStudentLastName">Last Name <span class="text-danger">*</span></label>
                                <input type="text" id="editStudentLastName" name="lastName" class="form-control" required>
                                <div class="invalid-feedback">Please enter last name</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="editStudentEmail">Email <span class="text-danger">*</span></label>
                        <input type="email" id="editStudentEmail" name="email" class="form-control" required>
                        <div class="invalid-feedback">Please enter a valid email address</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="editStudentDepartment">Department</label>
                        <input type="text" id="editStudentDepartment" name="department" class="form-control">
                    </div>
                    
                    <div class="form-group">
                        <label for="editEnrollmentYear">Enrollment Year <span class="text-danger">*</span></label>
                        <select id="editEnrollmentYear" name="enrollmentYear" class="form-control" required>
                            <option value="2025">2025</option>
                            <option value="2024">2024</option>
                            <option value="2023">2023</option>
                            <option value="2022">2022</option>
                        </select>
                        <div class="invalid-feedback">Please select enrollment year</div>
                    </div>
                    
                    <div class="form-group">
                        <label>Registration Date</label>
                        <p id="studentRegistrationDate" class="form-control-plaintext"></p>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline close-modal-btn">Cancel</button>
                <button type="button" class="btn btn-primary" id="updateStudentBtn">Update Student</button>
            </div>
        </div>
    </div>
    
    <!-- Assignment Action Modal -->
    <div id="assignmentActionModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="assignmentModalTitle">Assignment Actions</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <div id="assignmentDetails">
                    <h4 id="selectedAssignmentTitle"></h4>
                    <p id="selectedAssignmentInfo"></p>
                    
                    <div class="action-buttons mt-4">
                        <a id="viewAssignmentBtn" href="#" class="btn btn-primary">
                            <i class="fas fa-eye"></i> View Details
                        </a>
                        <a id="editAssignmentBtn" href="#" class="btn btn-outline">
                            <i class="fas fa-edit"></i> Edit Assignment
                        </a>
                        <a id="gradeSubmissionsBtn" href="#" class="btn btn-outline">
                            <i class="fas fa-check-square"></i> Grade Submissions
                        </a>
                        <button id="deleteAssignmentBtn" class="btn btn-danger">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Notification element (will be created dynamically) -->
    <div id="notification" style="display:none;"></div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Current date time and user login constants - UPDATED
            const currentDateTime = "2025-05-16 22:26:55"; // Updated timestamp
            const currentUserLogin = "IT24103866"; // Updated user login
            
            console.log("Initializing Teacher Dashboard with updated timestamp:", currentDateTime);
            
            // =========== Tab Navigation ===========
            function setupTabNavigation() {
                const menuItems = document.querySelectorAll('.menu-item');
                const tabContents = document.querySelectorAll('.tab-content');
                
                menuItems.forEach(item => {
                    item.addEventListener('click', function(event) {
                        event.preventDefault();
                        
                        const tabId = this.getAttribute('data-tab');
                        
                        // Remove active class from all menu items and tabs
                        menuItems.forEach(i => i.classList.remove('active'));
                        tabContents.forEach(content => content.classList.remove('active'));
                        
                        // Add active class to clicked item and corresponding tab
                        this.classList.add('active');
                        document.getElementById(tabId).classList.add('active');
                        
                        // Update page title
                        const title = this.querySelector('span').textContent;
                        document.getElementById('page-title').textContent = title;
                        
                        // Update URL without refreshing page
                        try {
                            window.history.pushState({tab: tabId}, '', '?tab=' + tabId);
                        } catch (e) {
                            console.warn("Failed to update URL:", e);
                        }
                    });
                });
            }
            
            // Global switchTab function (can be called from onclick attributes)
            window.switchTab = function(tabId) {
                const menuItems = document.querySelectorAll('.menu-item');
                const tabContents = document.querySelectorAll('.tab-content');
                
                // Remove active class from all menu items and tabs
                menuItems.forEach(i => i.classList.remove('active'));
                tabContents.forEach(content => content.classList.remove('active'));
                
                // Add active class to menu item and tab
                const menuItem = document.querySelector(`.menu-item[data-tab="${tabId}"]`);
                const tabContent = document.getElementById(tabId);
                
                if (menuItem) menuItem.classList.add('active');
                if (tabContent) tabContent.classList.add('active');
                
                // Update page title
                if (menuItem) {
                    const title = menuItem.querySelector('span').textContent;
                    document.getElementById('page-title').textContent = title;
                }
                
                // Update URL without refreshing page
                try {
                    window.history.pushState({tab: tabId}, '', '?tab=' + tabId);
                } catch (e) {
                    console.warn("Failed to update URL:", e);
                }
                
                return false; // Prevent default behavior
            };
            
            // =========== Message Module ===========
            // Set up modal for new messages
            const newMessageModal = document.getElementById('newMessageModal');
            const openNewMessageBtn = document.getElementById('openNewMessageModal');
            const closeModalBtns = document.querySelectorAll(".close-modal, .close-modal-btn");
            
            // Open message modal
            if (openNewMessageBtn) {
                openNewMessageBtn.addEventListener('click', function() {
                    newMessageModal.style.display = 'block';
                    // Reset form and validation states when opening modal
                    const form = document.getElementById('messageForm');
                    form.reset();
                    
                    // Clear any previous validation styling
                    form.querySelectorAll('.is-invalid').forEach(field => {
                        field.classList.remove('is-invalid');
                    });
                });
            }
            
            // Close all modals
            closeModalBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    document.querySelectorAll('.modal').forEach(modal => {
                        modal.style.display = 'none';
                    });
                });
            });
            
            // Close modals when clicking outside
            window.addEventListener('click', function(event) {
                document.querySelectorAll('.modal').forEach(modal => {
                    if (event.target == modal) {
                        modal.style.display = 'none';
                    }
                });
            });
            
            // The Message Button Fix script in the <head> handles the send message functionality
            
            // Set up message item click event
            const messageItems = document.querySelectorAll('.message-item');
            messageItems.forEach(item => {
                item.addEventListener('click', function() {
                    const messageId = this.getAttribute('data-id');
                    window.location.href = '${pageContext.request.contextPath}/MessageServlet?action=view&id=' + messageId;
                });
            });
            
            // Set up delete message button
            const deleteButtons = document.querySelectorAll('.delete-message');
            deleteButtons.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const messageId = this.getAttribute('data-id');
                    
                    if (confirm('Are you sure you want to delete this message?')) {
                        // Send AJAX request to delete message
                        fetch('${pageContext.request.contextPath}/MessageServlet', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: 'action=delete&id=' + messageId
                        })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                showNotification(data.message, 'success');
                                
                                // Redirect back to inbox/sent
                                setTimeout(() => {
                                    window.location.href = '${pageContext.request.contextPath}/MessageServlet?action=${messageType}';
                                }, 1000);
                            } else {
                                showNotification('Error: ' + data.message, 'error');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            showNotification('Error deleting message. Please try again.', 'error');
                        });
                    }
                });
            });
            
            // Set up reply button
            const replyButtons = document.querySelectorAll('.reply-message');
            replyButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    const recipient = this.getAttribute('data-recipient');
                    const subject = this.getAttribute('data-subject');
                    
                    // Open compose modal and pre-fill fields
                    document.getElementById('recipient').value = recipient;
                    document.getElementById('subject').value = subject;
                    newMessageModal.style.display = 'block';
                    
                    // Focus the message content
                    setTimeout(() => {
                        document.getElementById('messageContent').focus();
                    }, 100);
                });
            });
            
            // Message search functionality
            const searchInput = document.getElementById('messageSearch');
            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    const query = this.value.toLowerCase();
                    
                    messageItems.forEach(item => {
                        const searchText = item.getAttribute('data-search').toLowerCase();
                        if (searchText.includes(query)) {
                            item.style.display = '';
                        } else {
                            item.style.display = 'none';
                        }
                    });
                });
            }
            
            // =========== Students Module ===========
            // Setup student search functionality
            const studentSearch = document.getElementById('studentSearch');
            if (studentSearch) {
                studentSearch.addEventListener('keyup', function() {
                    const searchValue = this.value.toLowerCase();
                    const rows = document.querySelectorAll('#studentsTable tbody tr');
                    
                    rows.forEach(row => {
                        const username = row.cells[0].textContent.toLowerCase();
                        const name = row.cells[1].textContent.toLowerCase();
                        const email = row.cells[2].textContent.toLowerCase();
                        
                        if (username.includes(searchValue) || name.includes(searchValue) || email.includes(searchValue)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });
            }
            
            // Student filter tabs
            const filterTabs = document.querySelectorAll('.filter-tab');
            if (filterTabs.length > 0) {
                filterTabs.forEach(tab => {
                    tab.addEventListener('click', function() {
                        // Remove active class from all tabs
                        filterTabs.forEach(t => t.classList.remove('active'));
                        
                        // Add active class to clicked tab
                        this.classList.add('active');
                        
                        const filter = this.getAttribute('data-filter');
                        const rows = document.querySelectorAll('#studentsTable tbody tr');
                        
                        rows.forEach(row => {
                            if (filter === 'all') {
                                row.style.display = '';
                            } else {
                                const year = row.getAttribute('data-year');
                                if (year === filter) {
                                    row.style.display = '';
                                } else {
                                    row.style.display = 'none';
                                }
                            }
                        });
                    });
                });
            }
            
            // =========== Course Module ===========
            // Setup the add course modal
            const addCourseModal = document.getElementById('addCourseModal');
            const openAddCourseBtn = document.getElementById('openAddCourseModal');
            const saveCourseBtn = document.getElementById('saveCourseBtn');
            
            if (openAddCourseBtn) {
                openAddCourseBtn.addEventListener('click', function() {
                    addCourseModal.style.display = 'block';
                    // Reset form and validation states
                    const form = document.getElementById('addCourseForm');
                    form.reset();
                    
                    // Clear any previous validation styling
                    form.querySelectorAll('.is-invalid').forEach(field => {
                        field.classList.remove('is-invalid');
                    });
                });
            }
            
            if (saveCourseBtn) {
                saveCourseBtn.addEventListener('click', function() {
                    const form = document.getElementById('addCourseForm');
                    
                    // Validate required fields
                    const courseCode = document.getElementById('courseCode');
                    const courseTitle = document.getElementById('courseTitle');
                    const courseDay = document.getElementById('courseDay');
                    const courseTime = document.getElementById('courseTime');
                    
                    let isValid = true;
                    form.querySelectorAll('.is-invalid').forEach(field => {
                        field.classList.remove('is-invalid');
                    });
                    
                    if (!courseCode.value.trim()) {
                        courseCode.classList.add('is-invalid');
                        isValid = false;
                    }
                    
                    if (!courseTitle.value.trim()) {
                        courseTitle.classList.add('is-invalid');
                        isValid = false;
                    }
                    
                    if (!courseDay.value) {
                        courseDay.classList.add('is-invalid');
                        isValid = false;
                    }
                    
                    if (!courseTime.value) {
                        courseTime.classList.add('is-invalid');
                        isValid = false;
                    }
                    
                    if (isValid) {
                        form.submit();
                    } else {
                        showNotification('Please fill in all required fields', 'error');
                    }
                });
            }
            
            // =========== Student Management ===========
            // Setup the add student modal
            const addStudentModal = document.getElementById('addStudentModal');
            const openAddStudentBtn = document.getElementById('openAddStudentModal');
            const saveStudentBtn = document.getElementById('saveStudentBtn');
            
            if (openAddStudentBtn) {
                openAddStudentBtn.addEventListener('click', function() {
                    addStudentModal.style.display = 'block';
                    // Reset form and validation states
                    const form = document.getElementById('addStudentForm');
                    form.reset();
                    
                    // Set default department value
                    document.getElementById('studentDepartment').value = 'Computer Science';
                    
                    // Clear any previous validation styling
                    form.querySelectorAll('.is-invalid').forEach(field => {
                        field.classList.remove('is-invalid');
                    });
                });
            }
            
            if (saveStudentBtn) {
                saveStudentBtn.addEventListener('click', function() {
                    const form = document.getElementById('addStudentForm');
                    
                    // Basic validation
                    const studentName = document.getElementById('studentName');
                    const firstName = document.getElementById('studentFirstName');
                    const lastName = document.getElementById('studentLastName');
                    const email = document.getElementById('studentEmail');
                    const password = document.getElementById('studentPassword');
                    
                    let isValid = true;
                    form.querySelectorAll('.is-invalid').forEach(field => {
                        field.classList.remove('is-invalid');
                    });
                    
                    if (!studentName.value.trim()) {
                        studentName.classList.add('is-invalid');
                        isValid = false;
                    }
                    
                    if (!firstName.value.trim()) {
                        firstName.classList.add('is-invalid');
                        isValid = false;
                    }
                    
                    if (!lastName.value.trim()) {
                        lastName.classList.add('is-invalid');
                        isValid = false;
                    }
                    
                    if (!email.value.trim()) {
                        email.classList.add('is-invalid');
                        isValid = false;
                    }
                    
                    if (!password.value.trim() || password.value.length < 8) {
                        password.classList.add('is-invalid');
                        isValid = false;
                    }
                    
                    if (isValid) {
                        form.submit();
                    } else {
                        showNotification('Please fill in all required fields correctly', 'error');
                    }
                });
            }
            
            // Setup edit student functionality
            const editStudentButtons = document.querySelectorAll('.edit-student');
            const editStudentModal = document.getElementById('editStudentModal');
            const updateStudentBtn = document.getElementById('updateStudentBtn');
            
            editStudentButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const username = this.getAttribute('data-student-username');
                    const name = this.getAttribute('data-student-name');
                    const email = this.getAttribute('data-student-email');
                    const year = this.getAttribute('data-student-year');
                    
                    // Split the name into first and last name
                    const nameParts = name.split(' ');
                    const firstName = nameParts[0];
                    const lastName = nameParts.length > 1 ? nameParts.slice(1).join(' ') : '';
                    
                    // Fill in the form
                    document.getElementById('editStudentName').value = username;
                    document.getElementById('editStudentFirstName').value = firstName;
                    document.getElementById('editStudentLastName').value = lastName;
                    document.getElementById('editStudentEmail').value = email;
                    document.getElementById('editEnrollmentYear').value = year;
                    
                    // Clear any previous validation styling
                    document.getElementById('editStudentForm').querySelectorAll('.is-invalid').forEach(field => {
                        field.classList.remove('is-invalid');
                    });
                    
                    // Show the modal
                    editStudentModal.style.display = 'block';
                });
            });
            
            if (updateStudentBtn) {
                updateStudentBtn.addEventListener('click', function() {
                    const form = document.getElementById('editStudentForm');
                    
                    // Validate required fields
                    const firstName = document.getElementById('editStudentFirstName');
                    const lastName = document.getElementById('editStudentLastName');
                    const email = document.getElementById('editStudentEmail');
                    
                    let isValid = true;
                    form.querySelectorAll('.is-invalid').forEach(field => {
                        field.classList.remove('is-invalid');
                    });
                    
                    if (!firstName.value.trim()) {
                        firstName.classList.add('is-invalid');
                        isValid = false;
                    }
                    
                    if (!lastName.value.trim()) {
                        lastName.classList.add('is-invalid');
                        isValid = false;
                    }
                    
                    if (!email.value.trim()) {
                        email.classList.add('is-invalid');
                        isValid = false;
                    }
                    
                    if (isValid) {
                        form.submit();
                    } else {
                        showNotification('Please fill in all required fields', 'error');
                    }
                });
            }
            
            // Handle delete student functionality
            const deleteStudentButtons = document.querySelectorAll('.delete-student');
            
            deleteStudentButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const username = this.getAttribute('data-student-username');
                    
                    if (confirm(`Are you sure you want to delete student ${username}?`)) {
                        // Redirect to delete URL
                        window.location.href = `${pageContext.request.contextPath}/StudentActionServlet?action=delete&studentName=${username}`;
                    }
                });
            });
            
            // =========== Assignments Module ===========
            // Initialize assignments features
            function initializeAssignments() {
                // Set up assignment action buttons
                document.querySelectorAll('.action-btn').forEach(btn => {
                    btn.addEventListener('click', function() {
                        const assignmentId = this.getAttribute('data-assignment-id');
                        const assignmentTitle = this.getAttribute('data-assignment-title');
                        showAssignmentActions(assignmentId, assignmentTitle);
                    });
                });
                
                // Set up assignment filters
                setupAssignmentFilters();
            }
            
            // Function to show assignment actions modal
            function showAssignmentActions(assignmentId, assignmentTitle) {
                const modal = document.getElementById('assignmentActionModal');
                document.getElementById('selectedAssignmentTitle').textContent = assignmentTitle;
                document.getElementById('selectedAssignmentInfo').textContent = `Assignment ID: ${assignmentId}`;
                
                // Set up action buttons
                document.getElementById('viewAssignmentBtn').href = `AssignmentServlet?action=view&id=${assignmentId}`;
                document.getElementById('editAssignmentBtn').href = `editAssignment.jsp?id=${assignmentId}`;
                document.getElementById('gradeSubmissionsBtn').href = `gradeSubmissions.jsp?id=${assignmentId}`;
                
                // Delete button handler
                document.getElementById('deleteAssignmentBtn').onclick = function() {
                    if (confirm(`Are you sure you want to delete the assignment "${assignmentTitle}"?`)) {
                        window.location.href = `AssignmentServlet?action=delete&id=${assignmentId}`;
                    }
                };
                
                // Show modal
                modal.style.display = 'block';
            }
            
            // Function to setup assignment filters
            function setupAssignmentFilters() {
                const applyBtn = document.getElementById('applyFilters');
                const resetBtn = document.getElementById('resetFilters');
                
                if (applyBtn && resetBtn) {
                    applyBtn.addEventListener('click', function() {
                        const courseFilter = document.getElementById('coursesFilter').value;
                        const statusFilter = document.getElementById('statusFilter').value;
                        
                        console.log(`Filtering assignments - Course: ${courseFilter}, Status: ${statusFilter}`);
                        
                        // Redirect with filter parameters
                        window.location.href = `teacherDashboard.jsp?tab=assignments&courseCode=${courseFilter}&status=${statusFilter}`;
                    });
                    
                    resetBtn.addEventListener('click', function() {
                        document.getElementById('coursesFilter').value = '';
                        document.getElementById('statusFilter').value = '';
                        
                        window.location.href = 'teacherDashboard.jsp?tab=assignments';
                    });
                }
            }
            
            if (document.getElementById('assignments').classList.contains('active')) {
                initializeAssignments();
            }
            
            // =========== Mobile Navigation ===========
            // Mobile menu toggle
            const menuToggles = document.querySelectorAll('.menu-toggle');
            const sidebar = document.querySelector('.sidebar');
            
            menuToggles.forEach(toggle => {
                toggle.addEventListener('click', function() {
                    sidebar.classList.toggle('active');
                });
            });
            
            // =========== Helper Functions ===========
            // Helper function to show notifications
            window.showNotification = function(message, type = 'info') {
                let notification = document.getElementById('notification');
                if (!notification) {
                    notification = document.createElement('div');
                    notification.id = 'notification';
                    document.body.appendChild(notification);
                }
                
                // Set color based on type
                switch (type) {
                    case 'success':
                        notification.style.backgroundColor = '#2ecc71';
                        notification.style.color = 'white';
                        break;
                    case 'error':
                        notification.style.backgroundColor = '#e74c3c';
                        notification.style.color = 'white';
                        break;
                    case 'warning':
                        notification.style.backgroundColor = '#f39c12';
                        notification.style.color = 'white';
                        break;
                    default:
                        notification.style.backgroundColor = '#3498db';
                        notification.style.color = 'white';
                }
                
                notification.style.position = 'fixed';
                notification.style.top = '20px';
                notification.style.right = '20px';
                notification.style.padding = '15px 20px';
                notification.style.borderRadius = '5px';
                notification.style.boxShadow = '0 4px 8px rgba(0, 0, 0, 0.2)';
                notification.style.zIndex = '9999';
                notification.style.display = 'block';
                
                // Set message and show notification
                notification.textContent = message;
                notification.style.opacity = '1';
                notification.style.transform = 'translateY(0)';
                
                // Hide after 3 seconds
                setTimeout(() => {
                    notification.style.opacity = '0';
                    notification.style.transform = 'translateY(-20px)';
                    setTimeout(() => {
                        if (notification.parentNode) {
                            notification.style.display = 'none';
                        }
                    }, 500);
                }, 3000);
            };
            
            // Initialize features
            setupTabNavigation();
            
            // Auto hide success and error messages after 5 seconds
            const messages = document.querySelectorAll('.success-message, .error-message');
            if (messages.length > 0) {
                setTimeout(() => {
                    messages.forEach(msg => {
                        msg.style.opacity = '0';
                        msg.style.transition = 'opacity 0.5s ease';
                        setTimeout(() => {
                            msg.style.display = 'none';
                        }, 500);
                    });
                }, 5000);
            }
            
            // Update current date and time in sidebar
            document.querySelector('.currentDateTime').innerHTML = 
                `Current Date and Time:<br>${currentDateTime}<br>User: ${currentUserLogin}`;
            
            console.log("Teacher Dashboard initialized at " + currentDateTime);
        });
    </script>
</body>
</html>