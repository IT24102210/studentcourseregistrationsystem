package com.StudentEnrollSystem.model;

public class Teacher {
    private String teacherId;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String department;
    private String joiningYear;
    
    public Teacher() {
    }
    
    public Teacher(String teacherId, String firstName, String lastName, String email, String password, String department, String joiningYear) {
        this.teacherId = teacherId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.department = department;
        this.joiningYear = joiningYear;
    }
    
    // Getters and setters
    public String getTeacherId() {
        return teacherId;
    }
    
    public void setTeacherId(String teacherId) {
        this.teacherId = teacherId;
    }
    
    public String getFirstName() {
        return firstName;
    }
    
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    
    public String getLastName() {
        return lastName;
    }
    
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getDepartment() {
        return department;
    }
    
    public void setDepartment(String department) {
        this.department = department;
    }
    
    public String getJoiningYear() {
        return joiningYear;
    }
    
    public void setJoiningYear(String joiningYear) {
        this.joiningYear = joiningYear;
    }
    
    // Add toString method for file writing
    @Override
    public String toString() {
        return firstName + " " + lastName + ", " + 
                teacherId + ", " + 
                password + ", " + 
                email + ", " + 
                department + ", " + 
                joiningYear;
    }
}