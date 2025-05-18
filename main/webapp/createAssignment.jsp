<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.StudentEnrollSystem.model.Teacher" %>
<%@ page import="com.StudentEnrollSystem.model.Course" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.*, java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%    
    // Check if teacher is logged in
    Teacher teacher = (Teacher) session.getAttribute("teacher");
    if (teacher == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Current date time and user login
    String currentDateTime = "2025-05-16 21:49:16"; // Updated UTC time
    String currentUserLogin = "IT24103866"; // Updated user login
    
    // Get teacher's full name
    String teacherFullName = teacher.getFirstName() + " " + teacher.getLastName();
    
    // Read all courses for the dropdown menu
    String coursesFilePath = ("C:\\Users\\user\\Downloads\\uthtara\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\data\\courses.txt");
    List<Map<String, Object>> courses = new ArrayList<>();
    
    try (BufferedReader reader = new BufferedReader(new FileReader(coursesFilePath))) {
        String line;
        while ((line = reader.readLine()) != null) {
            line = line.trim();
            if (line.isEmpty()) continue;
            String[] parts = line.split("\\|");
            if (parts.length >= 2) {
                Map<String, Object> course = new HashMap<>();
                course.put("courseCode", parts[0].trim());
                course.put("title", parts[1].trim());
                courses.add(course);
            }
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
    
    pageContext.setAttribute("courses", courses);
    
    // Get success/error messages
    String successMessage = request.getParameter("successMessage");
    String errorMessage = request.getParameter("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Assignment - EduEnroll</title>
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
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
            background-color: #f5f7fa;
            color: #333;
            line-height: 1.6;
        }
        
        .container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .card {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            margin-bottom: 20px;
            overflow: hidden;
        }
        
        .card-header {
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            background-color: #f8f9fa;
        }
        
        .card-header h2 {
            margin: 0;
            font-size: 18px;
            color: var(--dark-color);
        }
        
        .card-body {
            padding: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .form-control {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: var(--border-radius);
            cursor: pointer;
            font-weight: 500;
            display: inline-block;
            text-decoration: none;
            transition: background-color 0.3s;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--secondary-color);
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        
        .btn-group {
            margin-top: 20px;
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }
        
        .success-message {
            color: var(--success-color);
            padding: 10px;
            background-color: #e3f7eb;
            border-left: 4px solid var(--success-color);
            margin-bottom: 20px;
            border-radius: var(--border-radius);
        }
        
        .error-message {
            color: var(--danger-color);
            padding: 10px;
            background-color: #fdecea;
            border-left: 4px solid var(--danger-color);
            margin-bottom: 20px;
            border-radius: var(--border-radius);
        }
        
        .is-invalid {
            border-color: var(--danger-color);
        }
        
        .invalid-feedback {
            color: var(--danger-color);
            font-size: 80%;
            margin-top: 5px;
            display: none;
        }
        
        .is-invalid + .invalid-feedback {
            display: block;
        }
        
        .text-danger {
            color: var(--danger-color);
        }
        
        .breadcrumbs {
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .breadcrumbs a {
            color: var(--primary-color);
            text-decoration: none;
        }
        
        .breadcrumbs a:hover {
            text-decoration: underline;
        }
        
        .checkbox-group {
            margin-top: 10px;
        }
        
        .checkbox-group label {
            display: flex;
            align-items: center;
            font-weight: normal;
            cursor: pointer;
            margin-bottom: 5px;
        }
        
        .checkbox-group input[type="checkbox"] {
            margin-right: 10px;
        }
        
        .md-editor {
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            margin-bottom: 20px;
            overflow: hidden;
        }
        
        .md-toolbar {
            background-color: #f8f9fa;
            padding: 10px;
            border-bottom: 1px solid #ddd;
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
        }
        
        .md-toolbar button {
            background: none;
            border: 1px solid #ddd;
            border-radius: 3px;
            padding: 5px 10px;
            cursor: pointer;
            font-size: 14px;
        }
        
        .md-toolbar button:hover {
            background-color: #e9ecef;
        }
        
        .md-content {
            min-height: 200px;
            padding: 10px;
        }
        
        /* File uploader styles */
        .file-upload {
            margin-top: 10px;
            position: relative;
        }
        
        .file-upload-label {
            display: block;
            padding: 12px 20px;
            background-color: #f8f9fa;
            border: 1px dashed #ddd;
            border-radius: var(--border-radius);
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .file-upload-label:hover {
            background-color: #e9ecef;
        }
        
        .file-upload input[type="file"] {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }
        
        .file-list {
            margin-top: 10px;
        }
        
        .file-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 10px;
            background-color: #f8f9fa;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            margin-bottom: 5px;
        }
        
        .file-item button {
            background: none;
            border: none;
            color: var(--danger-color);
            cursor: pointer;
        }
        
        .header-back-btn {
            font-size: 14px;
            color: var(--primary-color);
            display: flex;
            align-items: center;
            text-decoration: none;
        }
        
        .header-back-btn i {
            margin-right: 5px;
        }
        
        .header-back-btn:hover {
            text-decoration: underline;
        }
        
        .datetime-info {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
            text-align: right;
        }
        
        .row {
            display: flex;
            flex-wrap: wrap;
            margin: 0 -15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <a href="teacherDashboard.jsp?tab=assignments" class="header-back-btn">
                    <i class="fas fa-arrow-left"></i> Back to Assignments
                </a>
                <h1>Create New Assignment</h1>
                <div class="breadcrumbs">
                    <a href="teacherDashboard.jsp">Dashboard</a> &gt; 
                    <a href="teacherDashboard.jsp?tab=assignments">Assignments</a> &gt; 
                    <span>Create New Assignment</span>
                </div>
            </div>
            <div class="datetime-info">
                <div><%= currentDateTime %></div>
                <div>User: <%= currentUserLogin %></div>
            </div>
        </div>
        
        <!-- Success and Error Messages -->
        <% if (successMessage != null && !successMessage.isEmpty()) { %>
        <div class="success-message">
            <i class="fas fa-check-circle"></i> <%= successMessage %>
        </div>
        <% } %>
        
        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
        <div class="error-message">
            <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
        </div>
        <% } %>
        
        <div class="card">
            <div class="card-header">
                <h2>Assignment Details</h2>
            </div>
            <div class="card-body">
                <form id="assignmentForm" action="${pageContext.request.contextPath}/AssignmentServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="create">
                    <!-- Fixed: Using currentUserLogin instead of teacher.getId() -->
                    <input type="hidden" name="teacherId" value="<%= currentUserLogin %>">
                    <input type="hidden" name="teacherName" value="<%= teacherFullName %>">
                    <input type="hidden" name="createdDate" value="<%= currentDateTime %>">
                    
                    <div class="form-group">
                        <label for="course">Course <span class="text-danger">*</span></label>
                        <select class="form-control" id="course" name="courseCode" required>
                            <option value="">-- Select Course --</option>
                            <c:forEach items="${courses}" var="course">
                                <option value="${course.courseCode}">${course.courseCode}: ${course.title}</option>
                            </c:forEach>
                        </select>
                        <div class="invalid-feedback">Please select a course</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="title">Assignment Title <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="title" name="title" placeholder="Enter a descriptive title" required>
                        <div class="invalid-feedback">Please enter an assignment title</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Description <span class="text-danger">*</span></label>
                        <div class="md-editor">
                            <div class="md-toolbar">
                                <button type="button" data-action="bold"><i class="fas fa-bold"></i></button>
                                <button type="button" data-action="italic"><i class="fas fa-italic"></i></button>
                                <button type="button" data-action="list-ul"><i class="fas fa-list-ul"></i></button>
                                <button type="button" data-action="list-ol"><i class="fas fa-list-ol"></i></button>
                                <button type="button" data-action="link"><i class="fas fa-link"></i></button>
                            </div>
                            <textarea class="form-control md-content" id="description" name="description" rows="6" placeholder="Provide detailed instructions for the assignment..." required></textarea>
                        </div>
                        <div class="invalid-feedback">Please enter a description</div>
                    </div>
                    
                    <div class="row" style="display: flex; gap: 20px;">
                        <div class="form-group" style="flex: 1;">
                            <label for="dueDate">Due Date <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" id="dueDate" name="dueDate" required>
                            <div class="invalid-feedback">Please select a due date</div>
                        </div>
                        
                        <div class="form-group" style="flex: 1;">
                            <label for="dueTime">Due Time <span class="text-danger">*</span></label>
                            <input type="time" class="form-control" id="dueTime" name="dueTime" required>
                            <div class="invalid-feedback">Please select a due time</div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="maxPoints">Maximum Points <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="maxPoints" name="maxPoints" min="1" max="1000" value="100" required>
                        <div class="invalid-feedback">Please enter valid maximum points (1-1000)</div>
                    </div>
                    
                    <div class="form-group">
                        <label>Assignment Files (Optional)</label>
                        <div class="file-upload">
                            <label class="file-upload-label">
                                <i class="fas fa-cloud-upload-alt"></i> Click to upload files or drag and drop files here
                                <input type="file" id="assignmentFiles" name="assignmentFiles" multiple>
                            </label>
                        </div>
                        <div class="file-list" id="fileList"></div>
                        <small class="text-muted">Allowed file types: PDF, DOC, DOCX, PPT, PPTX, XLS, XLSX, ZIP, RAR, JPG, PNG (Max 10MB per file)</small>
                    </div>
                    
                    <div class="form-group">
                        <label>Assignment Options</label>
                        <div class="checkbox-group">
                            <label>
                                <input type="checkbox" name="allowLateSubmissions"> Allow late submissions
                            </label>
                            <label>
                                <input type="checkbox" name="visibleToStudents" checked> Visible to students
                            </label>
                            <label>
                                <input type="checkbox" name="groupAssignment"> Group assignment
                            </label>
                            <label>
                                <input type="checkbox" name="requireRubric"> Use grading rubric
                            </label>
                        </div>
                    </div>
                    
                    <div class="btn-group">
                        <button type="button" class="btn btn-secondary" onclick="window.location.href='teacherDashboard.jsp?tab=assignments'">Cancel</button>
                        <button type="submit" class="btn btn-primary" id="createAssignmentBtn">Create Assignment</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('assignmentForm');
            const fileInput = document.getElementById('assignmentFiles');
            const fileList = document.getElementById('fileList');
            const createAssignmentBtn = document.getElementById('createAssignmentBtn');
            
            // Current date time constant
            const currentDateTime = "<%= currentDateTime %>";
            
            // Set minimum date for due date (today)
            const today = new Date();
            const yyyy = today.getFullYear();
            const mm = String(today.getMonth() + 1).padStart(2, '0');
            const dd = String(today.getDate()).padStart(2, '0');
            const todayFormatted = `${yyyy}-${mm}-${dd}`;
            document.getElementById('dueDate').min = todayFormatted;
            
            // Format and display selected files
            fileInput.addEventListener('change', function() {
                fileList.innerHTML = '';
                
                if (this.files.length > 0) {
                    for (let i = 0; i < this.files.length; i++) {
                        const file = this.files[i];
                        const fileSize = (file.size / 1024 / 1024).toFixed(2); // size in MB
                        
                        // Check file size
                        if (file.size > 10 * 1024 * 1024) { // 10MB
                            alert(`File "${file.name}" exceeds the 10MB size limit.`);
                            continue;
                        }
                        
                        // Create file item element
                        const fileItem = document.createElement('div');
                        fileItem.className = 'file-item';
                        fileItem.innerHTML = `
                            <span>${file.name} (${fileSize} MB)</span>
                            <button type="button" class="remove-file" data-index="${i}">
                                <i class="fas fa-times"></i>
                            </button>
                        `;
                        fileList.appendChild(fileItem);
                    }
                    
                    // Add event listeners to remove buttons
                    document.querySelectorAll('.remove-file').forEach(button => {
                        button.addEventListener('click', function() {
                            const index = parseInt(this.getAttribute('data-index'));
                            // Note: We can't directly modify the FileList, so we'll just update the UI
                            this.parentElement.remove();
                        });
                    });
                }
            });
            
            // Markdown editor simplified functionality
            document.querySelectorAll('.md-toolbar button').forEach(button => {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    const action = this.getAttribute('data-action');
                    const textarea = document.getElementById('description');
                    const selectionStart = textarea.selectionStart;
                    const selectionEnd = textarea.selectionEnd;
                    const selectedText = textarea.value.substring(selectionStart, selectionEnd);
                    
                    let markdown = '';
                    switch (action) {
                        case 'bold':
                            markdown = `**${selectedText}**`;
                            break;
                        case 'italic':
                            markdown = `*${selectedText}*`;
                            break;
                        case 'list-ul':
                            markdown = `\n- ${selectedText}`;
                            break;
                        case 'list-ol':
                            markdown = `\n1. ${selectedText}`;
                            break;
                        case 'link':
                            markdown = `[${selectedText}](url)`;
                            break;
                    }
                    
                    textarea.value = textarea.value.substring(0, selectionStart) + markdown + textarea.value.substring(selectionEnd);
                    textarea.focus();
                    textarea.selectionStart = selectionStart + markdown.length;
                    textarea.selectionEnd = selectionStart + markdown.length;
                });
            });
            
            // Form submission with validation
            form.addEventListener('submit', function(e) {
                let isValid = true;
                
                // Clear previous validation states
                form.querySelectorAll('.is-invalid').forEach(field => {
                    field.classList.remove('is-invalid');
                });
                
                // Validate required fields
                const requiredFields = ['course', 'title', 'description', 'dueDate', 'dueTime', 'maxPoints'];
                requiredFields.forEach(fieldId => {
                    const field = document.getElementById(fieldId);
                    if (!field.value.trim()) {
                        field.classList.add('is-invalid');
                        isValid = false;
                    }
                });
                
                // Validate max points range
                const maxPoints = document.getElementById('maxPoints');
                if (parseInt(maxPoints.value) < 1 || parseInt(maxPoints.value) > 1000) {
                    maxPoints.classList.add('is-invalid');
                    isValid = false;
                }
                
                if (!isValid) {
                    e.preventDefault();
                    window.scrollTo(0, 0);
                    const errorMessage = document.querySelector('.error-message') || document.createElement('div');
                    errorMessage.className = 'error-message';
                    errorMessage.innerHTML = '<i class="fas fa-exclamation-circle"></i> Please fill in all required fields correctly';
                    
                    if (!document.querySelector('.error-message')) {
                        form.parentNode.insertBefore(errorMessage, form);
                    }
                } else {
                    // Show loading state
                    createAssignmentBtn.disabled = true;
                    createAssignmentBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating...';
                }
            });
            
            // Drag and drop file upload
            const dropZone = document.querySelector('.file-upload-label');
            
            ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
                dropZone.addEventListener(eventName, preventDefaults, false);
            });
            
            function preventDefaults(e) {
                e.preventDefault();
                e.stopPropagation();
            }
            
            ['dragenter', 'dragover'].forEach(eventName => {
                dropZone.addEventListener(eventName, highlight, false);
            });
            
            ['dragleave', 'drop'].forEach(eventName => {
                dropZone.addEventListener(eventName, unhighlight, false);
            });
            
            function highlight() {
                dropZone.style.backgroundColor = '#e3f7eb';
                dropZone.style.borderColor = '#2ecc71';
            }
            
            function unhighlight() {
                dropZone.style.backgroundColor = '#f8f9fa';
                dropZone.style.borderColor = '#ddd';
            }
            
            dropZone.addEventListener('drop', handleDrop, false);
            
            function handleDrop(e) {
                const dt = e.dataTransfer;
                const files = dt.files;
                fileInput.files = files;
                
                // Trigger change event to update file list
                const event = new Event('change');
                fileInput.dispatchEvent(event);
            }
        });
    </script>
</body>
</html>