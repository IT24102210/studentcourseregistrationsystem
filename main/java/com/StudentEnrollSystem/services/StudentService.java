package com.StudentEnrollSystem.services;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.StudentEnrollSystem.model.Student;

public class StudentService {
    private static final String FILE_PATH = "C:\\Users\\rasin\\Downloads\\uththara\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\data\\students.txt";

    /**
     * Authenticates a user using linear search on a list of users
     * @param userIdentifier username or email
     * @param password user's password
     * @return User object if authenticated, null otherwise
     */
    public Student authenticateUser(String userIdentifier, String password) {
        List<Student> students = loadUsersFromFile();
        return findUser(students, userIdentifier, password);
    }

    /**
     * Loads all users from students.txt into a list
     * @return List of Student objects
     */
    private List<Student> loadUsersFromFile() {                       //READ
        List<Student> students = new ArrayList<>(); 
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue; // Skip empty lines
                }
                
                String[] parts = line.split(", ");
                if (parts.length >= 6) {
                    // Format: firstName lastName, studentName, password, email, department, enrollmentYear, [registrationTimestamp]
                    String[] names = parts[0].split(" ", 2);
                    String firstName = names[0];
                    String lastName = names.length > 1 ? names[1] : "";
                    String studentName = parts[1];
                    String password = parts[2];
                    String email = parts[3];
                    String department = parts[4];
                    String enrollmentYear = parts[5];
                    
                    // Check if registration timestamp exists
                    String registrationTimestamp = (parts.length >= 7) ? parts[6] : null;

                    // Create student with or without timestamp
                    Student student;
                    if (registrationTimestamp != null && !registrationTimestamp.trim().isEmpty()) {
                        student = new Student(studentName, firstName, lastName, email, password, department, enrollmentYear, registrationTimestamp);
                    } else {
                        student = new Student(studentName, firstName, lastName, email, password, department, enrollmentYear);
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
     * Linear search to find a user with matching credentials
     */
    private Student findUser(List<Student> students, String userIdentifier, String password) {
        for (Student student : students) {
            if (isMatchingUser(student, userIdentifier, password)) {
                return student;
            }
        }
        return null; // User not found or credentials don't match
    }

    /**
     * Checks if a user matches the provided credentials
     */
    private boolean isMatchingUser(Student student, String userIdentifier, String password) {
        return (student.getStudentName().equals(userIdentifier) ||
                student.getEmail().equals(userIdentifier)) &&
               student.getPassword().equals(password);
    }
}
