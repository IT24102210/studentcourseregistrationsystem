package com.StudentEnrollSystem.model;

public class Course {
    private String courseId;
    private String courseName;
    private String instructor;
    private String schedule;
    private int credits;
    
    public Course(String courseId, String courseName, String instructor, String schedule, int credits) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.instructor = instructor;
        this.schedule = schedule;
        this.credits = credits;
    }
    
    // Getters and Setters
    public String getCourseId() { return courseId; }
    public void setCourseId(String courseId) { this.courseId = courseId; }
    
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    
    public String getInstructor() { return instructor; }
    public void setInstructor(String instructor) { this.instructor = instructor; }
    
    public String getSchedule() { return schedule; }
    public void setSchedule(String schedule) { this.schedule = schedule; }
    
    public int getCredits() { return credits; }
    public void setCredits(int credits) { this.credits = credits; }
}
