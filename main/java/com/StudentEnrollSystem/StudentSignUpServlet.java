package com.StudentEnrollSystem.servlets;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.StudentEnrollSystem.model.Student;
import com.StudentEnrollSystem.services.UserValidator;

public class StudentSignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String FILE_PATH = "C:\\Users\\rasin\\Downloads\\project3\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\students.txt";
    
    @Override
    public void init() throws ServletException {
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
            // Debug - log start of processing
            getServletContext().log("Processing student signup request");
            
            // Get parameters from the form
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String studentName = request.getParameter("studentName");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String email = request.getParameter("email");
            String department = request.getParameter("department");
            String enrollmentYear = request.getParameter("enrollmentYear");
            
            // Debug - log received parameters
            getServletContext().log("Received parameters: " + 
                "firstName=" + firstName + 
                ", lastName=" + lastName +
                ", studentName=" + studentName +
                ", email=" + email +
                ", department=" + department +
                ", enrollmentYear=" + enrollmentYear);
            
            // Validate required fields
            if (firstName == null || lastName == null || studentName == null || password == null || 
                email == null || department == null || enrollmentYear == null ||
                firstName.trim().isEmpty() || lastName.trim().isEmpty() || studentName.trim().isEmpty() || 
                password.trim().isEmpty() || email.trim().isEmpty()) {
                
                request.setAttribute("errorMessage", "All fields are required");
                request.getRequestDispatcher("studentDashboard.jsp").forward(request, response);
                return;
            }
            
            // Check if passwords match
            if (confirmPassword != null && !password.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Passwords do not match");
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }
            
            // Create student object
            Student student = new Student(studentName, firstName, lastName, email, password, department, enrollmentYear);
            
            // Write to file with explicit error handling
            FileWriter writer = null;
            try {
                writer = new FileWriter(FILE_PATH, true);
                String studentData = student.toString();
                writer.write(studentData + System.lineSeparator());
                getServletContext().log("Successfully wrote to file: " + studentData);
            } catch (IOException e) {
                getServletContext().log("Error writing to file: " + e.getMessage());
                throw e; // Rethrow to be caught by outer catch block
            } finally {
                if (writer != null) {
                    try {
                        writer.close();
                    } catch (IOException e) {
                        getServletContext().log("Error closing FileWriter: " + e.getMessage());
                    }
                }
            }
            
            // Set success message
            request.setAttribute("successMessage", "Registration successful! Please login to continue.");
            // Redirect to login page
            request.getRequestDispatcher("studentDashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            getServletContext().log("Error in StudentSignupServlet: " + e.getMessage());
            // Forward to error page with error message
            request.setAttribute("errorMessage", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    private boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }

        // Check for @ symbol and proper domain format
        int atIndex = email.indexOf('@');
        if (atIndex == -1 || atIndex == 0 || atIndex == email.length() - 1) {
            return false;
        }

        // Check for domain with at least one dot
        String domain = email.substring(atIndex + 1);
        return domain.contains(".") && domain.indexOf(".") < domain.length() - 1;
    }
}
