# Fargate Demo
This project consists of three main components: a React frontend, a Node.js (Express) backend, and a Locust stress test. The project is designed to be run using Docker Compose, which allows easy deployment and management of the different components.

## Components

### Frontend
The frontend component is a React application responsible for providing the user interface. It communicates with the backend to retrieve user data and perform operations such as creating new users. The frontend component is containerized using a Dockerfile specific to the frontend.

The frontend relies on environment variables to determine the backend URL, making it flexible and easily configurable. This allows you to deploy the frontend to different environments without modifying the code. The frontend Docker image is built as part of the Docker Compose setup.

### Backend
The backend component is built with Node.js and Express, serving as the server-side application. It exposes a set of endpoints for managing users and performing health checks. The backend component interacts with an external MongoDB to store and retrieve user data.

It exposes the following endpoints:
  - /api/users **(GET)**: Retrieves all available users from an external MongoDB.
  - /api/users **(POST)**: Creates a new user with the specified attributes (username and email).
  - /api/health **(GET)**: A health check endpoint that verifies the connection to the MongoDB is working.
  - /api/fibo/:number **(GET)**: Calculates and returns the Fibonacci number for the requested index.
  
Similar to the frontend, the backend also utilizes environment variables to configure the connection to the MongoDB. This ensures flexibility and adaptability across different environments. The backend is containerized using a Dockerfile specific to the backend.

### Locust Stress Test
The Locust stress test component is included to evaluate the system's performance under load. It uses the Locust library, a popular open-source load testing tool, to simulate multiple concurrent users accessing the system. The stress test is defined in a Locustfile, which specifies the endpoints to target and the desired load pattern.

The Locust stress test is run as a container within the Docker Compose setup. It utilizes the [locustio/locust](https://hub.docker.com/r/locustio/locust) Docker image, which contains the necessary dependencies to execute the stress test. This allows you to easily incorporate and manage the stress test within the overall application stack.

## Docker Compose
The project utilizes Docker Compose, which allows the deployment and orchestration of multiple containers. The docker-compose.yml file is provided to easily spin up the entire application stack. It defines the necessary services for the frontend, backend, and Locust stress test, along with their respective configurations.

## Docker Images
The frontend and backend components each have their own Dockerfile, which specifies how to build their respective Docker images. These images can be created using the Dockerfile and used in the Docker Compose configuration.



# Running the Application
## Configuration
- The **backend** component uses environment variables to retrieve the MongoDB URI. Make sure to set the MONGO_URI environment variable accordingly before running the backend container.

- The **frontend** component uses environment variables to specify the backend URL. Ensure that the REACT_APP_BACKEND_URL environment variable is set to the correct URL before starting the frontend container.
To run the application, follow these steps:

## To run this project, follow these steps:

1. Clone the repository: `git clone <repository_url>`
2. Navigate to the project directory: `cd fargate-demo`
3. Install Docker and Docker Compose if not already installed.
4. Set the necessary environment variables in the docker-compose file:
   1. For the backend: `MONGO_URL=<mongodb_connection_url>`
   2. For the frontend: `REACT_APP_BACKEND_URL=http://localhost:8000`
5. Build and start the containers using Docker Compose: 
   `docker-compose up --build`
6. Access the application through your web browser at http://localhost:3000

# Conclusion
This project provides a scalable and easily deployable solution that integrates a frontend, backend, and Locust stress test. With Docker Compose, you can quickly spin up the entire application stack, allowing for efficient development, testing, and deployment. The containerized components and the use of environment variables ensure flexibility and adaptability, making it straightforward to deploy the application to different environments.

Feel free to reach out if you have any questions or need further assistance!