package com.example.authservice.exception;

import java.util.Date;
import java.util.Map;

public class ValidationError extends ErrorDetails {
    private Map<String, String> fieldErrors;

    public ValidationError(Date timestamp, String error, String message, Map<String, String> fieldErrors) {
        super(timestamp, error, message, null);
        this.fieldErrors = fieldErrors;
    }

    public Map<String, String> getFieldErrors() {
        return fieldErrors;
    }
}