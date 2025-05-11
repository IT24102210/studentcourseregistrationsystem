package com.StudentEnrollSystem.services;

import com.StudentEnrollSystem.model.Course;
import java.io.*;
import java.util.*;

public class CourseService {
    private static final String COURSES_FILE = "E:\\project1\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\courses.txt";
    private static final String ENROLLMENTS_FILE = "E:\\project1\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\enrollments.txt";
    
    public List<Course> getEnrolledCourses(String studentId) {
        List<Course> enrolledCourses = new ArrayList<>();
        try {
            // Read enrollments
            List<String> enrollments = readLines(ENROLLMENTS_FILE);
            Set<String> enrolledCourseIds = new HashSet<>();
            
            // Get course IDs for student
            for (String enrollment : enrollments) {
                String[] parts = enrollment.split(",");
                if (parts[0].equals(studentId)) {
                    enrolledCourseIds.add(parts[1]);
                }
            }
            
            // Get course details
            List<String> courses = readLines(COURSES_FILE);
            for (String course : courses) {
                String[] parts = course.split(",");
                if (enrolledCourseIds.contains(parts[0])) {
                    enrolledCourses.add(new Course(
                        parts[0], // courseId
                        parts[1], // courseName
                        parts[2], // instructor
                        parts[3], // schedule
                        Integer.parseInt(parts[4]) // credits
                    ));
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return enrolledCourses;
    }
    
    private List<String> readLines(String filename) throws IOException {
        List<String> lines = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(filename))) {
            String line;
            while ((line = reader.readLine()) != null) {
                lines.add(line);
            }
        }
        return lines;
    }
    
    public boolean enrollStudent(String studentId, String courseId) {
        try {
            try (FileWriter fw = new FileWriter(ENROLLMENTS_FILE, true);
                 BufferedWriter bw = new BufferedWriter(fw)) {
                bw.write(studentId + "," + courseId);
                bw.newLine();
                return true;
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}
