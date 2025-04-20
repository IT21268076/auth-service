# Auth Service Microservice

This is a secure, microservice-based authentication component deployed on AWS with DevOps and DevSecOps best practices.

## Overview

The Auth Service provides user authentication and authorization capabilities as a standalone microservice. It offers:

- User registration
- User authentication with JWT tokens
- Role-based access control
- Secure user data management

## Architecture

![Architecture Diagram](architecture-diagram.png)

## Technologies Used

- **Backend**: Spring Boot with Spring Security
- **Database**: Amazon RDS (MySQL)
- **Containerization**: Docker
- **CI/CD**: Jenkins
- **Cloud Provider**: AWS (ECS, ECR, RDS)
- **Security**: SonarCloud, OWASP Dependency Check

## API Endpoints

- **POST /api/auth/register**: Register a new user
- **POST /api/auth/login**: Authenticate and get JWT token
- **GET /api/users/me**: Get current user profile
- **GET /api/test/all**: Public endpoint
- **GET /api/test/user**: Protected endpoint (requires USER role)
- **GET /api/test/admin**: Admin endpoint (requires ADMIN role)

## Development Setup

### Prerequisites

- Java 17
- Maven
- Docker
- Docker Compose

### Local Development

1. Clone the repository
   git clone https://github.com/yourusername/auth-service.git
   cd auth-service

2. Start the database and application using Docker Compose
   docker-compose up -d

3. The service will be available at http://localhost:8080

### Running Tests
./mvnw test

## Deployment

The application is automatically deployed to AWS ECS through the Jenkins CI/CD pipeline.

### Manual Deployment

1. Build and push the Docker image to ECR
   ./scripts/build-and-push.sh

2. Deploy AWS resources
   ./scripts/deploy-aws.sh

## Security Features

- Password hashing with BCrypt
- JWT token authentication
- Role-based access control
- Input validation and sanitization
- HTTPS for encryption in transit
- Database encryption at rest
- AWS IAM with least privilege
- SonarCloud code analysis
- OWASP Dependency Check

## CI/CD Pipeline

The Jenkins pipeline includes:
1. Code checkout
2. Build and test
3. SonarCloud analysis
4. OWASP dependency check
5. Docker image build
6. Push to Amazon ECR
7. Deployment to ECS

## License

This project is licensed under the MIT License - see the LICENSE file for details.

[//]: # (7. Create a Simple Architecture Diagram)

[//]: # (   You can create a simple architecture diagram to include in your documentation. Save it as architecture-diagram.png in the root directory.)