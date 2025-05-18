package com.StudentEnrollSystem.model;

import java.io.Serializable;

/**
 * Represents a course in the Student Enrollment System
 */
public class Course implements Serializable {
    private String courseCode;
    private String title;
    private String description;
    private String day;
    private String time;
    private int enrolledStudents;
    private int sessionsCount;
    
    public Course() {
        // Default constructor
        this.enrolledStudents = 0;
        this.sessionsCount = 0;
    }
    
    public Course(String courseCode, String title, String day, String time) {
        this.courseCode = courseCode;
        this.title = title;
        this.day = day;
        this.time = time;
        this.enrolledStudents = 0;
        this.sessionsCount = 0;
    }
    
    public Course(String courseCode, String title, String description, String day, String time, 
                  int enrolledStudents, int sessionsCount) {
        this.courseCode = courseCode;
        this.title = title;
        this.description = description;
        this.day = day;
        this.time = time;
        this.enrolledStudents = enrolledStudents;
        this.sessionsCount = sessionsCount;
    }
    
    // Getters and setters
    public String getCourseCode() {
        return courseCode;
    }
    
    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getDay() {
        return day;
    }
    
    public void setDay(String day) {
        this.day = day;
    }
    
    public String getTime() {
        return time;
    }
    
    public void setTime(String time) {
        this.time = time;
    }
    
    public int getEnrolledStudents() {
        return enrolledStudents;
    }
    
    public void setEnrolledStudents(int enrolledStudents) {
        this.enrolledStudents = enrolledStudents;
    }
    
    public int getSessionsCount() {
        return sessionsCount;
    }
    
    public void setSessionsCount(int sessionsCount) {
        this.sessionsCount = sessionsCount;
    }
    
    /**
     * Formats the course data as a string to be stored in a text file
     */
    public String toFileString() {
        return courseCode + "|" + title + "|" + day + "|" + time + "|" 
               + enrolledStudents + "|" + sessionsCount;
    }
    
    @Override
    public String toString() {
        return "Course{" +
                "courseCode='" + courseCode + '\'' +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", day='" + day + '\'' +
                ", time='" + time + '\'' +
                ", enrolledStudents=" + enrolledStudents +
                ", sessionsCount=" + sessionsCount +
                '}';
    }
}