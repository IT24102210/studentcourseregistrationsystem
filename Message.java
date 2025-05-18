package com.StudentEnrollSystem.model;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Model class for messages in the system
 */
public class Message {
    private String id;
    private String sender;
    private String recipient;
    private String subject;
    private String content;
    private Date timestamp;
    private boolean read;
    private String category; // "notification", "personal", "course", etc.
    private boolean important;
    
    // Default constructor
    public Message() {
        this.timestamp = new Date();
        this.read = false;
        this.important = false;
        this.id = generateMessageId();
    }
    
    // Constructor with basic fields
    public Message(String sender, String recipient, String subject, String content) {
        this();
        this.sender = sender;
        this.recipient = recipient;
        this.subject = subject;
        this.content = content;
    }
    
    // Generate a unique message ID based on timestamp and hashcode
    private String generateMessageId() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
        String timeComponent = sdf.format(timestamp);
        int hashComponent = Math.abs((sender + recipient + System.nanoTime()).hashCode() % 10000);
        return "MSG" + timeComponent + hashComponent;
    }

    // Getters and setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSender() {
        return sender;
    }

    public void setSender(String sender) {
        this.sender = sender;
    }

    public String getRecipient() {
        return recipient;
    }

    public void setRecipient(String recipient) {
        this.recipient = recipient;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public boolean isRead() {
        return read;
    }

    public void setRead(boolean read) {
        this.read = read;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public boolean isImportant() {
        return important;
    }

    public void setImportant(boolean important) {
        this.important = important;
    }
    
    /**
     * Convert message to a string format for storage in text file
     * Format: id|sender|recipient|subject|content|timestamp|read|category|important
     */
    public String toFileString() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        StringBuilder sb = new StringBuilder();
        
        sb.append(id).append("|")
          .append(sender).append("|")
          .append(recipient).append("|")
          .append(subject).append("|")
          .append(content.replace("\n", "\\n").replace("|", "\\|")).append("|")
          .append(sdf.format(timestamp)).append("|")
          .append(read ? "1" : "0").append("|")
          .append(category == null ? "" : category).append("|")
          .append(important ? "1" : "0");
          
        return sb.toString();
    }
    
    /**
     * Parse message from string representation in file
     */
    public static Message fromFileString(String line) throws Exception {
        String[] parts = line.split("\\|", 9); // Split into 9 parts max
        if (parts.length < 6) {
            throw new IllegalArgumentException("Invalid message format");
        }
        
        Message message = new Message();
        message.setId(parts[0]);
        message.setSender(parts[1]);
        message.setRecipient(parts[2]);
        message.setSubject(parts[3]);
        
        // Handle escaped content
        String content = parts[4].replace("\\n", "\n").replace("\\|", "|");
        message.setContent(content);
        
        // Parse timestamp
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        message.setTimestamp(sdf.parse(parts[5]));
        
        // Parse read status
        if (parts.length > 6) {
            message.setRead("1".equals(parts[6]));
        }
        
        // Parse category
        if (parts.length > 7 && !parts[7].isEmpty()) {
            message.setCategory(parts[7]);
        }
        
        // Parse important flag
        if (parts.length > 8) {
            message.setImportant("1".equals(parts[8]));
        }
        
        return message;
    }

    @Override
    public String toString() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return "Message{" +
                "id='" + id + '\'' +
                ", sender='" + sender + '\'' +
                ", recipient='" + recipient + '\'' +
                ", subject='" + subject + '\'' +
                ", content='" + (content.length() > 20 ? content.substring(0, 20) + "..." : content) + '\'' +
                ", timestamp=" + sdf.format(timestamp) +
                ", read=" + read +
                ", category='" + category + '\'' +
                ", important=" + important +
                '}';
    }
}