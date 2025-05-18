package com.StudentEnrollSystem.services;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class UserValidator {
    private static final String FILE_PATH = "C:\\Users\\rasin\\Downloads\\project3\\StudentEnrollSystem\\src (9)\\src\\main\\webapp\\WEB-INF\\lib\\data\\students.txt";
    
    /**
     * Validates if a username already exists in the system
     * @param username the username to check
     * @return true if username exists, false otherwise
     */
    public static boolean usernameExists(String username) {
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue;
                }
                
                String[] parts = line.split(", ");
                if (parts.length >= 2) {
                    String existingUsername = parts[1].trim();
                    if (existingUsername.equals(username)) {
                        return true;
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Validates if an email already exists in the system
     * @param email the email to check
     * @return true if email exists, false otherwise
     */
    public static boolean emailExists(String email) {
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue;
                }
                
                String[] parts = line.split(", ");
                if (parts.length >= 4) {
                    String existingEmail = parts[3].trim();
                    if (existingEmail.equals(email)) {
                        return true;
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }
}