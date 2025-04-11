package com.example.authservice.exception;

import java.util.Date;

public class ErrorDetails {
    private Date timestamp;
    private String error;
    private String message;
    private String details;

    public ErrorDetails(Date timestamp, String error, String message, String details) {
        this.timestamp = timestamp;
        this.error = error;
        this.message = message;
        this.details = details;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public String getError() {
        return error;
    }

    public String getMessage() {
        return message;
    }

    public String getDetails() {
        return details;
    }
}