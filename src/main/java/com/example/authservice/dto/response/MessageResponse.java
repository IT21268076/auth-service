package com.example.authservice.dto.response;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class MessageResponse {
    // Getter and setter
    private String message;

    // Default constructor
    public MessageResponse() {
    }

    // Constructor with message parameter
    public MessageResponse(String message) {
        this.message = message;
    }

}