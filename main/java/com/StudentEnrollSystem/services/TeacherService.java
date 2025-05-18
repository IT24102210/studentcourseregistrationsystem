package com.StudentEnrollSystem.services;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.StudentEnrollSystem.model.Teacher;

public class TeacherService {
    private static final String FILE_PATH = "C:\\Users\\user\\Downloads\\uthtara\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\data\\teacher.txt";

    /**
     * Authenticates a teacher using linear search on a list of teachers
     * @param teacherId teacher ID
     * @param password teacher's password
     * @return Teacher object if authenticated, null otherwise
     */
    public Teacher authenticateTeacher(String teacherId, String password) {
        List<Teacher> teachers = loadTeachersFromFile();
        return findTeacher(teachers, teacherId, password);
    }

    /**
     * Loads all teachers from teachers.txt into a list
     * @return List of Teacher objects
     */
    private List<Teacher> loadTeachersFromFile() {
        List<Teacher> teachers = new ArrayList<>(); 
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(", ");
                if (parts.length >= 6) {
                    // Format: firstName lastName, teacherId, password, email, department, joiningYear
                    String[] names = parts[0].split(" ", 2);
                    String firstName = names[0];
                    String lastName = names.length > 1 ? names[1] : "";
                    String teacherId = parts[1];
                    String password = parts[2];
                    String email = parts[3];
                    String department = parts[4];
                    String joiningYear = parts[5];

                    Teacher teacher = new Teacher(teacherId, firstName, lastName, email, password, department, joiningYear);
                    teachers.add(teacher);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return teachers;
    }

    /**
     * Linear search to find a teacher with matching credentials
     * @param teachers list of teachers
     * @param teacherId teacher ID
     * @param password teacher's password
     * @return Teacher object if found and authenticated, null otherwise
     */
    private Teacher findTeacher(List<Teacher> teachers, String teacherId, String password) {
        for (Teacher teacher : teachers) {
            if (isMatchingTeacher(teacher, teacherId, password)) {
                return teacher;
            }
        }
        return null; // Teacher not found or credentials don't match
    }

    /**
     * Checks if a teacher matches the provided credentials
     * @param teacher Teacher object
     * @param teacherId teacher ID
     * @param password teacher's password
     * @return true if matching, false otherwise
     */
    private boolean isMatchingTeacher(Teacher teacher, String teacherId, String password) {
        return (teacher.getTeacherId().equals(teacherId) ||
                teacher.getEmail().equals(teacherId)) &&
               teacher.getPassword().equals(password);
    }
}