package com.StudentEnrollSystem.servlets;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.StudentEnrollSystem.model.Student;

public class StudentSignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String FILE_PATH = "C:\\Users\\rasin\\Downloads\\project3\\StudentEnrollSystem\\src (9)\\src\\main\\webapp\\WEB-INF\\lib\\data\\students.txt";
    
    @Override
    public void init() throws ServletException {  //CREATE
        super.init();
        // Ensure the directory exists
        try {
            File file = new File(FILE_PATH);
            File directory = file.getParentFile();
            if (!directory.exists()) {
                directory.mkdirs();
            }
            if (!file.exists()) {
                file.createNewFile();
            }
        } catch (IOException e) {
            getServletContext().log("Error creating students.txt file: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get parameters from the form
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String studentName = request.getParameter("studentName");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String email = request.getParameter("email");
            String department = request.getParameter("department");
            String enrollmentYear = request.getParameter("enrollmentYear");
            String registrationTimestamp = request.getParameter("registrationTimestamp");
            
            // Validate required fields
            if (firstName == null || lastName == null || studentName == null || password == null || 
                email == null || department == null || enrollmentYear == null ||
                firstName.trim().isEmpty() || lastName.trim().isEmpty() || studentName.trim().isEmpty() || 
                password.trim().isEmpty() || email.trim().isEmpty()) {
                
                request.setAttribute("errorMessage", "All fields are required");
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }
            
            // Check if passwords match
            if (confirmPassword != null && !password.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Passwords do not match");
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }
            
            // If timestamp is missing, use the current time
            if (registrationTimestamp == null || registrationTimestamp.trim().isEmpty()) {
                java.time.LocalDateTime now = java.time.LocalDateTime.now();
                java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                registrationTimestamp = now.format(formatter);
            }
            
            // Create student object with timestamp
            Student student = new Student(studentName, firstName, lastName, email, password, department, enrollmentYear, registrationTimestamp); //session
            
            // Save student in session to allow accessing the dashboard immediately
            HttpSession session = request.getSession();
            session.setAttribute("student", student);
            
            // Write to file with explicit error handling
            FileWriter writer = null;
            try {
                writer = new FileWriter(FILE_PATH, true);
                String studentData = student.toString();
                writer.write(studentData + System.lineSeparator());
            } catch (IOException e) {
                getServletContext().log("Error writing to file: " + e.getMessage());
                throw e;
            } finally {
                if (writer != null) {
                    try {
                        writer.close();
                    } catch (IOException e) {
                        getServletContext().log("Error closing FileWriter: " + e.getMessage());
                    }
                }
            }
            
            // Redirect to the dashboard
            response.sendRedirect("studentDashboard.jsp");
            
        } catch (Exception e) {
            getServletContext().log("Error in StudentSignupServlet: " + e.getMessage());
            request.setAttribute("errorMessage", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}
