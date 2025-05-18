package com.StudentEnrollSystem.servlets;

import com.StudentEnrollSystem.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet to handle student delete and edit actions with animations
 */
@WebServlet("/StudentActionServlet")
public class StudentActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Current system timestamp and user login
    private static final String CURRENT_TIMESTAMP = "2025-05-16 18:46:27";
    private static final String CURRENT_USER = "IT24103866";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Handle AJAX requests for student info
        String action = request.getParameter("action");
        
        if ("getStudent".equals(action)) {
            String studentName = request.getParameter("studentName");
            Student student = findStudentByUsername(studentName);
            
            if (student != null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                // Create a simple JSON response with student data
                String jsonResponse = String.format(
                    "{\"success\":true,\"studentName\":\"%s\",\"firstName\":\"%s\",\"lastName\":\"%s\"," +
                    "\"email\":\"%s\",\"department\":\"%s\",\"enrollmentYear\":\"%s\",\"registrationTimestamp\":\"%s\"}",
                    student.getStudentName(), 
                    student.getFirstName(), 
                    student.getLastName(),
                    student.getEmail(),
                    student.getDepartment(),
                    student.getEnrollmentYear(),
                    student.getRegistrationTimestamp()
                );
                
                response.getWriter().write(jsonResponse);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"success\":false,\"message\":\"Student not found\"}");
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Invalid action\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            sendJsonError(response, "Action is required", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        switch (action) {
            case "delete":
                deleteStudent(request, response);
                break;
            case "edit":
                editStudent(request, response);
                break;
            default:
                sendJsonError(response, "Unknown action: " + action, HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    /**
     * Delete a student with animation effect
     */
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentName = request.getParameter("studentName");
        String animationEffect = request.getParameter("animationEffect"); // e.g., "fade", "slide"
        
        if (studentName == null || studentName.trim().isEmpty()) {
            sendJsonError(response, "Student username is required", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        // Get all students
        List<Student> students = getAllStudents();
        boolean studentFound = false;
        Student removedStudent = null;
        
        // Find and remove the student
        for (int i = 0; i < students.size(); i++) {
            if (students.get(i).getStudentName().equals(studentName)) {
                removedStudent = students.remove(i);
                studentFound = true;
                break;
            }
        }
        
        if (!studentFound) {
            sendJsonError(response, "Student not found: " + studentName, HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Log the operation with animation effect
        System.out.println(CURRENT_USER + " is deleting student: " + studentName + 
                          " with " + (animationEffect != null ? animationEffect : "default") + 
                          " animation at " + CURRENT_TIMESTAMP);
        
        // Save remaining students
        boolean success = saveAllStudents(students);
        
        if (success) {
            // Send JSON success response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String jsonResponse = String.format(
                "{\"success\":true,\"message\":\"Student %s deleted successfully\",\"timestamp\":\"%s\",\"animationEffect\":\"%s\"}",
                studentName, 
                CURRENT_TIMESTAMP,
                animationEffect != null ? animationEffect : "fade"
            );
            response.getWriter().write(jsonResponse);
        } else {
            sendJsonError(response, "Failed to delete student: " + studentName, HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    /**
     * Edit a student with animation effect
     */
    private void editStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get parameters from the form
        String studentName = request.getParameter("studentName");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String department = request.getParameter("department");
        String enrollmentYear = request.getParameter("enrollmentYear");
        String animationEffect = request.getParameter("animationEffect"); // e.g., "pulse", "highlight"
        
        if (studentName == null || studentName.trim().isEmpty()) {
            sendJsonError(response, "Student username is required", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        // Get all existing students
        List<Student> students = getAllStudents();
        Student studentToUpdate = null;
        int studentIndex = -1;
        
        // Find the student to update
        for (int i = 0; i < students.size(); i++) {
            if (students.get(i).getStudentName().equals(studentName)) {
                studentToUpdate = students.get(i);
                studentIndex = i;
                break;
            }
        }
        
        if (studentToUpdate == null) {
            sendJsonError(response, "Student not found: " + studentName, HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Keep original values for comparison
        String originalFirstName = studentToUpdate.getFirstName();
        String originalLastName = studentToUpdate.getLastName();
        String originalEmail = studentToUpdate.getEmail();
        String originalDepartment = studentToUpdate.getDepartment();
        String originalYear = studentToUpdate.getEnrollmentYear();
        
        // Update student fields if provided
        boolean hasChanges = false;
        
        if (firstName != null && !firstName.trim().isEmpty() && !firstName.equals(originalFirstName)) {
            studentToUpdate.setFirstName(firstName.trim());
            hasChanges = true;
        }
        
        if (lastName != null && !lastName.trim().isEmpty() && !lastName.equals(originalLastName)) {
            studentToUpdate.setLastName(lastName.trim());
            hasChanges = true;
        }
        
        if (email != null && !email.trim().isEmpty() && !email.equals(originalEmail)) {
            studentToUpdate.setEmail(email.trim());
            hasChanges = true;
        }
        
        if (department != null && !department.equals(originalDepartment)) {
            studentToUpdate.setDepartment(department.trim());
            hasChanges = true;
        }
        
        if (enrollmentYear != null && !enrollmentYear.trim().isEmpty() && !enrollmentYear.equals(originalYear)) {
            studentToUpdate.setEnrollmentYear(enrollmentYear.trim());
            hasChanges = true;
        }
        
        if (!hasChanges) {
            // No changes were made
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\":true,\"message\":\"No changes were made\",\"changed\":false}");
            return;
        }
        
        // Log the operation with animation effect
        System.out.println(CURRENT_USER + " is updating student: " + studentName + 
                          " with " + (animationEffect != null ? animationEffect : "default") + 
                          " animation at " + CURRENT_TIMESTAMP);
        
        // Update the student in the list
        students.set(studentIndex, studentToUpdate);
        
        // Save all students
        boolean success = saveAllStudents(students);
        
        if (success) {
            // Send JSON success response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String jsonResponse = String.format(
                "{\"success\":true,\"message\":\"Student %s updated successfully\",\"timestamp\":\"%s\"," +
                "\"animationEffect\":\"%s\",\"changed\":true,\"firstName\":\"%s\",\"lastName\":\"%s\"," +
                "\"email\":\"%s\",\"department\":\"%s\",\"enrollmentYear\":\"%s\"}",
                studentName, 
                CURRENT_TIMESTAMP,
                animationEffect != null ? animationEffect : "highlight",
                studentToUpdate.getFirstName(),
                studentToUpdate.getLastName(),
                studentToUpdate.getEmail(),
                studentToUpdate.getDepartment(),
                studentToUpdate.getEnrollmentYear()
            );
            response.getWriter().write(jsonResponse);
        } else {
            sendJsonError(response, "Failed to update student: " + studentName, HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    /**
     * Get all students from the file
     */
    private List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String studentsFilePath = ("C:\\Users\\user\\Downloads\\uthtara\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\data\\students.txt");
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
     * Save all students to file
     */
    private boolean saveAllStudents(List<Student> students) {
        String studentsFilePath = ("C:\\Users\\user\\Downloads\\uthtara\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\data\\students.txt");
        
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
     * Send a JSON error response
     */
    private void sendJsonError(HttpServletResponse response, String message, int status) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(status);
        response.getWriter().write(String.format(
            "{\"success\":false,\"message\":\"%s\",\"timestamp\":\"%s\"}",
            message, CURRENT_TIMESTAMP
        ));
    }
}