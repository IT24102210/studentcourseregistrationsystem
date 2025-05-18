package com.StudentEnrollSystem.servlets;

import com.StudentEnrollSystem.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Servlet to handle all student-related operations
 * Direct implementation without DAO or utility classes
 */
@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Current system timestamp and user login
    private static final String CURRENT_TIMESTAMP = "2025-05-16 18:39:28";
    private static final String CURRENT_USER = "IT24103866";
    
    // Email validation regex
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$");
    
    // Username validation regex (alphanumeric and underscores)
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_]+$");
    
    /**
     * Handle GET requests for student data
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list"; // Default action
        }
        
        switch (action) {
            case "list":
                listStudents(request, response);
                break;
            case "get":
                getStudentByUsername(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
        }
    }
    
    /**
     * Handle POST requests for student operations
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action is required");
            return;
        }
        
        switch (action) {
            case "add":
                addStudent(request, response);
                break;
            case "update":
                updateStudent(request, response);
                break;
            case "delete":
                deleteStudent(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
        }
    }
    
    /**
     * List all students and forward to the students page
     */
    private void listStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Student> students = getAllStudents();
        request.setAttribute("students", students);
        request.setAttribute("studentCount", students.size());
        
        // Forward to the students JSP page
        request.getRequestDispatcher("/teacherDashboard.jsp?tab=students").forward(request, response);
    }
    
    /**
     * Get a specific student by username
     */
    private void getStudentByUsername(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentName = request.getParameter("studentName");
        if (studentName == null || studentName.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Student username is required");
            return;
        }
        
        Student student = findStudentByUsername(studentName);
        if (student != null) {
            request.setAttribute("student", student);
            request.getRequestDispatcher("/studentDetails.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Student not found: " + studentName);
        }
    }
    
    /**
     * Add a new student from form data
     */
    private void addStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get parameters from the form
        String studentName = request.getParameter("studentName");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String department = request.getParameter("department");
        String enrollmentYear = request.getParameter("enrollmentYear");
        String registrationTimestamp = CURRENT_TIMESTAMP; // Use our constant
        
        // Validate required parameters
        if (studentName == null || studentName.trim().isEmpty() || 
            firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            enrollmentYear == null || enrollmentYear.trim().isEmpty()) {
            
            String errorMessage = "All required fields must be completed";
            response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=students&errorMessage=" + errorMessage);
            return;
        }
        
        // Validate username format (alphanumeric only)
        if (!USERNAME_PATTERN.matcher(studentName).matches()) {
            String errorMessage = "Username must contain only letters, numbers, and underscores";
            response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=students&errorMessage=" + errorMessage);
            return;
        }
        
        // Validate email format
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            String errorMessage = "Please enter a valid email address";
            response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=students&errorMessage=" + errorMessage);
            return;
        }
        
        // Validate password length
        if (password.length() < 8) {
            String errorMessage = "Password must be at least 8 characters long";
            response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=students&errorMessage=" + errorMessage);
            return;
        }
        
        // Check if student already exists
        if (findStudentByUsername(studentName) != null) {
            String errorMessage = "A student with that username already exists";
            response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=students&errorMessage=" + errorMessage);
            return;
        }
        
        // Hash the password for security
        String hashedPassword = hashPassword(password);
        
        // Create a new Student object
        Student newStudent = new Student();
        newStudent.setStudentName(studentName.trim());
        newStudent.setFirstName(firstName.trim());
        newStudent.setLastName(lastName.trim());
        newStudent.setEmail(email.trim());
        newStudent.setPassword(hashedPassword);
        newStudent.setDepartment(department != null ? department.trim() : "Computer Science");
        newStudent.setEnrollmentYear(enrollmentYear.trim());
        newStudent.setRegistrationTimestamp(registrationTimestamp);
        
        // Log the operation
        System.out.println(CURRENT_USER + " is adding student: " + studentName + " at " + CURRENT_TIMESTAMP);
        
        // Try to add the student
        boolean success = addStudentToFile(newStudent);
        
        if (success) {
            String successMessage = "Student " + studentName + " added successfully";
            response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=students&successMessage=" + successMessage);
        } else {
            String errorMessage = "Failed to add student due to a system error";
            response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=students&errorMessage=" + errorMessage);
        }
    }
    
    /**
     * Update an existing student
     */
    private void updateStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get parameters from the form
        String studentName = request.getParameter("studentName");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String department = request.getParameter("department");
        String enrollmentYear = request.getParameter("enrollmentYear");
        
        // Validate required parameters
        if (studentName == null || studentName.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Student username is required");
            return;
        }
        
        // Get all existing students
        List<Student> students = getAllStudents();
        Student studentToUpdate = null;
        
        // Find the student to update
        for (Student student : students) {
            if (student.getStudentName().equals(studentName)) {
                studentToUpdate = student;
                break;
            }
        }
        
        if (studentToUpdate == null) {
            String errorMessage = "Student not found: " + studentName;
            response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=students&errorMessage=" + errorMessage);
            return;
        }
        
        // Update student fields if provided
        if (firstName != null && !firstName.trim().isEmpty()) {
            studentToUpdate.setFirstName(firstName.trim());
        }
        
        if (lastName != null && !lastName.trim().isEmpty()) {
            studentToUpdate.setLastName(lastName.trim());
        }
        
        if (email != null && !email.trim().isEmpty()) {
            // Validate email
            if (!EMAIL_PATTERN.matcher(email).matches()) {
                String errorMessage = "Please enter a valid email address";
                response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=students&errorMessage=" + errorMessage);
                return;
            }
            studentToUpdate.setEmail(email.trim());
        }
        
        if (department != null) {
            studentToUpdate.setDepartment(department.trim());
        }
        
        if (enrollmentYear != null && !enrollmentYear.trim().isEmpty()) {
            studentToUpdate.setEnrollmentYear(enrollmentYear.trim());
        }
        
        // Log the operation
        System.out.println(CURRENT_USER + " is updating student: " + studentName + " at " + CURRENT_TIMESTAMP);
        
        // Save all students
        boolean success = saveAllStudents(students);
        
        if (success) {
            String successMessage = "Student " + studentName + " updated successfully";
            response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=students&successMessage=" + successMessage);
        } else {
            String errorMessage = "Failed to update student: " + studentName;
            response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=students&errorMessage=" + errorMessage);
        }
    }
    
    /**
     * Delete a student
     */
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentName = request.getParameter("studentName");
        
        if (studentName == null || studentName.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Student username is required");
            return;
        }
        
        // Get all students
        List<Student> students = getAllStudents();
        boolean studentFound = false;
        
        // Find and remove the student
        for (int i = 0; i < students.size(); i++) {
            if (students.get(i).getStudentName().equals(studentName)) {
                students.remove(i);
                studentFound = true;
                break;
            }
        }
        
        if (!studentFound) {
            String errorMessage = "Student not found: " + studentName;
            response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=students&errorMessage=" + errorMessage);
            return;
        }
        
        // Log the operation
        System.out.println(CURRENT_USER + " is deleting student: " + studentName + " at " + CURRENT_TIMESTAMP);
        
        // Save remaining students
        boolean success = saveAllStudents(students);
        
        if (success) {
            String successMessage = "Student " + studentName + " deleted successfully";
            response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=students&successMessage=" + successMessage);
        } else {
            String errorMessage = "Failed to delete student: " + studentName;
            response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp?tab=students&errorMessage=" + errorMessage);
        }
    }
    
    /**
     * Get all students from the file
     */
    private List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String studentsFilePath = getServletContext().getRealPath("/WEB-INF/data/students.txt");
        File file = new File(studentsFilePath);
        
        // Create file and directories if they don't exist
        if (!file.exists()) {
            file.getParentFile().mkdirs();
            try {
                file.createNewFile();
                return students; // Return empty list for new file
            } catch (IOException e) {
                e.printStackTrace();
                return students;
            }
        }
        
        // Read students from file
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;
                
                String[] parts = line.split(",\\s*");
                if (parts.length >= 6) {
                    Student student = new Student();
                    
                    // Parse name (which might contain spaces)
                    String[] nameParts = parts[0].trim().split("\\s+");
                    student.setFirstName(nameParts[0]);
                    
                    if (nameParts.length > 1) {
                        StringBuilder lastName = new StringBuilder();
                        for (int i = 1; i < nameParts.length; i++) {
                            lastName.append(nameParts[i]).append(" ");
                        }
                        student.setLastName(lastName.toString().trim());
                    } else {
                        student.setLastName("");
                    }
                    
                    student.setStudentName(parts[1].trim());
                    student.setPassword(parts[2].trim());
                    student.setEmail(parts[3].trim());
                    student.setDepartment(parts[4].trim());
                    student.setEnrollmentYear(parts[5].trim());
                    
                    // Registration timestamp if available
                    if (parts.length > 6) {
                        student.setRegistrationTimestamp(parts[6].trim());
                    } else {
                        student.setRegistrationTimestamp(CURRENT_TIMESTAMP);
                    }
                    
                    students.add(student);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        return students;
    }
    
    /**
     * Find a student by username
     */
    private Student findStudentByUsername(String username) {
        List<Student> students = getAllStudents();
        
        for (Student student : students) {
            if (student.getStudentName().equals(username)) {
                return student;
            }
        }
        
        return null;
    }
    
    /**
     * Add a student to the file
     */
    private boolean addStudentToFile(Student student) {
        List<Student> students = getAllStudents();
        students.add(student);
        return saveAllStudents(students);
    }
    
    /**
     * Save all students to file
     */
    private boolean saveAllStudents(List<Student> students) {
        String studentsFilePath = getServletContext().getRealPath("/WEB-INF/data/students.txt");
        
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(studentsFilePath))) {
            for (Student student : students) {
                // Format: name, username, password, email, department, enrollmentYear, registrationTimestamp
                writer.write(String.format("%s %s, %s, %s, %s, %s, %s, %s",
                        student.getFirstName(),
                        student.getLastName(),
                        student.getStudentName(),
                        student.getPassword(),
                        student.getEmail(),
                        student.getDepartment(),
                        student.getEnrollmentYear(),
                        student.getRegistrationTimestamp()));
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Hash a password using SHA-256
     */
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return password; // Fallback if hashing fails
        }
    }
}