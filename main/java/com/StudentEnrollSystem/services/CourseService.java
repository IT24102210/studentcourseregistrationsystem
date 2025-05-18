package com.StudentEnrollSystem.services;

import com.StudentEnrollSystem.model.Course;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import java.io.*;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Service class to handle operations related to courses
 */
public class CourseService {
    private final String coursesFilePath;
    private final Gson gson;
    
    public CourseService(String coursesFilePath) {
        this.coursesFilePath = coursesFilePath;
        this.gson = new GsonBuilder().setPrettyPrinting().create();
        
        // Ensure the parent directory exists
        File file = new File(coursesFilePath);
        if (!file.exists()) {
            file.getParentFile().mkdirs();
            try {
                file.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Add a new course to the system
     * @param course The course to add
     * @return true if successful, false otherwise
     */
    public boolean addCourse(Course course) {
        List<Course> courses = getAllCourses();
        
        // Check if course already exists
        if (courses.stream().anyMatch(c -> c.getCourseCode().equals(course.getCourseCode()))) {
            return false; // Course with same code already exists
        }
        
        courses.add(course);
        return saveCoursesToFile(courses);
    }
    
    /**
     * Get all courses from the system
     * @return List of all courses
     */
    public List<Course> getAllCourses() {
        List<Course> courses = new ArrayList<>();
        File file = new File(coursesFilePath);
        
        if (!file.exists() || file.length() == 0) {
            return courses; // Return empty list if file doesn't exist or is empty
        }
        
        try (BufferedReader reader = new BufferedReader(new FileReader(coursesFilePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;
                
                String[] parts = line.split("\\|");
                if (parts.length >= 4) {
                    Course course = new Course();
                    course.setCourseCode(parts[0].trim());
                    course.setTitle(parts[1].trim());
                    course.setDay(parts[2].trim());
                    course.setTime(parts[3].trim());
                    
                    if (parts.length > 4) {
                        try {
                            course.setEnrolledStudents(Integer.parseInt(parts[4].trim()));
                        } catch (NumberFormatException e) {
                            course.setEnrolledStudents(0);
                        }
                    }
                    
                    if (parts.length > 5) {
                        try {
                            course.setSessionsCount(Integer.parseInt(parts[5].trim()));
                        } catch (NumberFormatException e) {
                            course.setSessionsCount(0);
                        }
                    }
                    
                    courses.add(course);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        return courses;
    }
    
    /**
     * Get a course by its code
     * @param courseCode The course code to look for
     * @return Optional containing the course if found
     */
    public Optional<Course> getCourseByCode(String courseCode) {
        return getAllCourses().stream()
                .filter(c -> c.getCourseCode().equals(courseCode))
                .findFirst();
    }
    
    /**
     * Update an existing course
     * @param updatedCourse The course with updated information
     * @return true if successful, false otherwise
     */
    public boolean updateCourse(Course updatedCourse) {
        List<Course> courses = getAllCourses();
        
        for (int i = 0; i < courses.size(); i++) {
            if (courses.get(i).getCourseCode().equals(updatedCourse.getCourseCode())) {
                courses.set(i, updatedCourse);
                return saveCoursesToFile(courses);
            }
        }
        
        return false; // Course not found
    }
    
    /**
     * Delete a course by its code
     * @param courseCode The course code to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteCourse(String courseCode) {
        List<Course> courses = getAllCourses();
        List<Course> updatedCourses = courses.stream()
                .filter(c -> !c.getCourseCode().equals(courseCode))
                .collect(Collectors.toList());
        
        if (updatedCourses.size() < courses.size()) {
            return saveCoursesToFile(updatedCourses);
        }
        
        return false; // Course not found
    }
    
    /**
     * Save the courses list to file
     * @param courses The list of courses to save
     * @return true if successful, false otherwise
     */
    private boolean saveCoursesToFile(List<Course> courses) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(coursesFilePath))) {
            for (Course course : courses) {
                writer.write(course.toFileString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Exports courses to JSON format
     * @return JSON string representation of all courses
     */
    public String exportCoursesToJson() {
        List<Course> courses = getAllCourses();
        return gson.toJson(courses);
    }
    
    /**
     * Imports courses from JSON format
     * @param json JSON string containing courses
     * @return true if successful, false otherwise
     */
    public boolean importCoursesFromJson(String json) {
        Type listType = new TypeToken<List<Course>>(){}.getType();
        List<Course> courses = gson.fromJson(json, listType);
        return saveCoursesToFile(courses);
    }
}