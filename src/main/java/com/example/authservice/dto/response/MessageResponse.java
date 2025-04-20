package com.example.authservice.dto.response;

public class MessageResponse {
    private String message;

    // Default constructor
    public MessageResponse() {
    }

    // Constructor with message parameter
    public MessageResponse(String message) {
        this.message = message;
    }

    // Getter and setter
    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}