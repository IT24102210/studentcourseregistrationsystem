package com.StudentEnrollSystem.model;

public class Student {
    private String studentName;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String department;
    private String enrollmentYear;
    private String registrationTimestamp;
    
    public Student() {
    }
    
    public Student(String studentName, String firstName, String lastName, String email, String password, String department, String enrollmentYear, String registrationTimestamp) {
        this.studentName = studentName;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.department = department;
        this.enrollmentYear = enrollmentYear;
        this.registrationTimestamp = registrationTimestamp;
    }
    
    public Student(String studentName, String firstName, String lastName, String email, String password, String department, String enrollmentYear) {
        this(studentName, firstName, lastName, email, password, department, enrollmentYear, null);
    }
    
    // Getters and setters
    public String getStudentName() {
        return studentName;
    }
    
    public void setStudentName(String studentName) {
        this.studentName = studentName;
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
    
    public String getEnrollmentYear() {
        return enrollmentYear;
    }
    
    public void setEnrollmentYear(String enrollmentYear) {
        this.enrollmentYear = enrollmentYear;
    }
    
    public String getRegistrationTimestamp() {
        return registrationTimestamp;
    }
    
    public void setRegistrationTimestamp(String registrationTimestamp) {
        this.registrationTimestamp = registrationTimestamp;
    }
    
    @Override
    public String toString() {
        return firstName + " " + lastName + ", " + 
               studentName + ", " + 
               password + ", " + 
               email + ", " + 
               department + ", " + 
               enrollmentYear + 
               (registrationTimestamp != null ? ", " + registrationTimestamp : "");
    }
}