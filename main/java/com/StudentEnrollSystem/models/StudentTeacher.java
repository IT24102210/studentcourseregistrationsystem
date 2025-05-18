package com.StudentEnrollSystem.model;

import java.io.Serializable;

/**
 * Represents a student in the Student Enrollment System
 */
public class StudentTeacher implements Serializable {
    private String studentId;
    private String name;
    private String email;
    private String coursesEnrolled;
    private String department;
    private String registrationTime;
    
    public StudentTeacher() {
        // Default constructor
    }
    
    public StudentTeacher(String studentId, String name, String email, String coursesEnrolled) {
        this.studentId = studentId;
        this.name = name;
        this.email = email;
        this.coursesEnrolled = coursesEnrolled;
    }
    
    public StudentTeacher(String studentId, String name, String email, String coursesEnrolled, 
                  String department, String registrationTime) {
        this.studentId = studentId;
        this.name = name;
        this.email = email;
        this.coursesEnrolled = coursesEnrolled;
        this.department = department;
        this.registrationTime = registrationTime;
    }
    
    // Getters and setters
    public String getStudentId() {
        return studentId;
    }
    
    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getCoursesEnrolled() {
        return coursesEnrolled;
    }
    
    public void setCoursesEnrolled(String coursesEnrolled) {
        this.coursesEnrolled = coursesEnrolled;
    }
    
    public String getDepartment() {
        return department;
    }
    
    public void setDepartment(String department) {
        this.department = department;
    }
    
    public String getRegistrationTime() {
        return registrationTime;
    }
    
    public void setRegistrationTime(String registrationTime) {
        this.registrationTime = registrationTime;
    }
    
    /**
     * Formats the student data as a string to be stored in a text file
     */
    public String toFileString() {
        return studentId + "|" + name + "|" + email + "|" + coursesEnrolled + "|" 
               + registrationTime + "|" + department;
    }
    
    @Override
    public String toString() {
        return "Student{" +
                "studentId='" + studentId + '\'' +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", coursesEnrolled='" + coursesEnrolled + '\'' +
                ", department='" + department + '\'' +
                ", registrationTime='" + registrationTime + '\'' +
                '}';
    }
}