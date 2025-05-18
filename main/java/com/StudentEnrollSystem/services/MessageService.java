package com.StudentEnrollSystem.services;

import com.StudentEnrollSystem.model.Message;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import javax.servlet.ServletContext;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Service class to handle message operations
 */
public class MessageService {
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private final String messagesFilePath;
    private final Gson gson;
    
    /**
     * Constructor - initializes the service with a file path
     */
    public MessageService(ServletContext context) {
        gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd HH:mm:ss")
                .setPrettyPrinting()
                .create();
                
        messagesFilePath = ("C:\\Users\\user\\Downloads\\uthtara\\StudentEnrollSystem\\src\\main\\webapp\\WEB-INF\\lib\\data\\messages.txt");
        
        // Ensure data directory exists
        File file = new File(messagesFilePath);
        if (!file.exists()) {
            file.getParentFile().mkdirs();
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.err.println("Error creating messages file: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Get all messages
     */
    public List<Message> getAllMessages() {
        List<Message> messages = new ArrayList<>();
        
        try (BufferedReader reader = new BufferedReader(new FileReader(messagesFilePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;
                
                try {
                    Message message = Message.fromFileString(line);
                    messages.add(message);
                } catch (Exception e) {
                    System.err.println("Error parsing message line: " + line);
                    e.printStackTrace();
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading messages: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Sort messages by timestamp (most recent first)
        messages.sort((m1, m2) -> m2.getTimestamp().compareTo(m1.getTimestamp()));
        
        return messages;
    }
    
    /**
     * Get messages for a specific user (sent to them)
     */
    public List<Message> getUserInbox(String username) {
        List<Message> allMessages = getAllMessages();
        return allMessages.stream()
                .filter(message -> username.equals(message.getRecipient()))
                .collect(Collectors.toList());
    }
    
    /**
     * Get messages sent by a specific user
     */
    public List<Message> getUserSentMessages(String username) {
        List<Message> allMessages = getAllMessages();
        return allMessages.stream()
                .filter(message -> username.equals(message.getSender()))
                .collect(Collectors.toList());
    }
    
    /**
     * Find a message by its ID
     */
    public Message getMessageById(String id) {
        List<Message> allMessages = getAllMessages();
        return allMessages.stream()
                .filter(message -> id.equals(message.getId()))
                .findFirst()
                .orElse(null);
    }
    
    /**
     * Create a new message
     */
    public Message createMessage(String sender, String recipient, String subject, 
                                String content, String category, boolean important) {
        
        Message message = new Message(sender, recipient, subject, content);
        message.setCategory(category);
        message.setImportant(important);
        
        // Add to messages list and save
        List<Message> messages = getAllMessages();
        messages.add(message);
        saveMessages(messages);
        
        return message;
    }
    
    /**
     * Update a message (typically to mark as read)
     */
    public boolean updateMessage(Message message) {
        List<Message> messages = getAllMessages();
        
        for (int i = 0; i < messages.size(); i++) {
            if (messages.get(i).getId().equals(message.getId())) {
                messages.set(i, message);
                saveMessages(messages);
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Mark a message as read
     */
    public boolean markAsRead(String messageId) {
        Message message = getMessageById(messageId);
        if (message != null && !message.isRead()) {
            message.setRead(true);
            return updateMessage(message);
        }
        return false;
    }
    
    /**
     * Delete a message
     */
    public boolean deleteMessage(String id) {
        List<Message> messages = getAllMessages();
        boolean removed = messages.removeIf(m -> m.getId().equals(id));
        
        if (removed) {
            saveMessages(messages);
        }
        
        return removed;
    }
    
    /**
     * Get unread message count for a user
     */
    public int getUnreadCount(String username) {
        List<Message> inbox = getUserInbox(username);
        return (int) inbox.stream().filter(m -> !m.isRead()).count();
    }
    
    /**
     * Save all messages to the file
     */
    private synchronized void saveMessages(List<Message> messages) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(messagesFilePath))) {
            for (Message message : messages) {
                writer.write(message.toFileString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error saving messages: " + e.getMessage());
            e.printStackTrace();
        }
    }
}