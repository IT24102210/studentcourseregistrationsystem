package com.StudentEnrollSystem.servlets;

import java.io.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class StudentSortServlet that handles
 * server-side sorting of students using insertion sort
 */
@WebServlet("/StudentSortServlet")
public class StudentSortServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Current system timestamp
    private static final String CURRENT_TIMESTAMP = "2025-05-16 18:27:40";
    
    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get sort order parameter
        String sortOrder = request.getParameter("sortOrder");
        if (sortOrder == null || (!sortOrder.equals("asc") && !sortOrder.equals("desc"))) {
            sortOrder = "desc"; // Default to newest first
        }
        
        // Get tab parameter for redirect
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "students";
        }
        
        // Read students from file
        String studentsFilePath = ("C:\\Users\\rasin\\Downloads\\uththara\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\data\\students.txt");
        List<StudentRecord> students = readStudentsFromFile(studentsFilePath);
        
        // Sort students using insertion sort
        insertionSort(students, sortOrder);
        
        // Write sorted students back to file
        writeStudentsToFile(students, studentsFilePath);
        
        // Redirect back to dashboard with sorting parameters
        response.sendRedirect(request.getContextPath() + 
                             "/teacherDashboard.jsp?tab=" + tab + 
                             "&sort=" + sortOrder +
                             "&timestamp=" + CURRENT_TIMESTAMP);
    }
    
    /**
     * Implementation of insertion sort algorithm for student records
     * Time Complexity: O(n²) where n is the number of records
     * Space Complexity: O(1) as it sorts in-place
     */
    private void insertionSort(List<StudentRecord> students, String sortOrder) {
        int n = students.size();
        
        for (int i = 1; i < n; i++) {
            StudentRecord key = students.get(i);
            int j = i - 1;
            
            // Compare based on sort direction
            while (j >= 0) {
                boolean shouldSwap;
                if ("asc".equals(sortOrder)) {
                    // Ascending: older registrations first
                    shouldSwap = key.registrationTimestamp.compareTo(students.get(j).registrationTimestamp) < 0;
                } else {
                    // Descending: newer registrations first
                    shouldSwap = key.registrationTimestamp.compareTo(students.get(j).registrationTimestamp) > 0;
                }
                
                if (shouldSwap) {
                    students.set(j + 1, students.get(j));
                    j--;
                } else {
                    break;
                }
            }
            students.set(j + 1, key);
        }
    }
    
    /**
     * Reads all students from the file
     */
    private List<StudentRecord> readStudentsFromFile(String filePath) throws IOException {
        List<StudentRecord> students = new ArrayList<>();
        
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;
                
                String[] parts = line.split(",\\s*");
                if (parts.length >= 6) {
                    StudentRecord student = new StudentRecord();
                    student.originalLine = line;
                    student.name = parts[0].trim();
                    student.username = parts[1].trim();
                    student.email = parts[3].trim();
                    student.department = parts[4].trim();
                    student.enrollmentYear = parts[5].trim();
                    
                    // Registration timestamp
                    if (parts.length > 6) {
                        student.registrationTimestamp = parts[6].trim();
                    } else {
                        student.registrationTimestamp = CURRENT_TIMESTAMP;
                    }
                    
                    students.add(student);
                }
            }
        }
        
        return students;
    }
    
    /**
     * Writes students back to the file
     */
    private void writeStudentsToFile(List<StudentRecord> students, String filePath) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (StudentRecord student : students) {
                writer.write(student.originalLine);
                writer.newLine();
            }
        }
    }
    
    /**
     * Helper class to represent a student record
     */
    private static class StudentRecord {
        String originalLine;
        String name;
        String username;
        String email;
        String department;
        String enrollmentYear;
        String registrationTimestamp;
    }
}