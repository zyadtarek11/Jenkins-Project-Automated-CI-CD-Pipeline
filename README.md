# Jenkins-Project: Automated CI/CD Pipeline

![Jenkins Project Illustration](/Jenkins-project-illustration.svg)

This project sets up a fully automated Jenkins pipeline for Continuous Integration and Continuous Deployment (CI/CD). Jenkins will clone a repository containing Dockerfiles and deployment files, build the Docker images, push them to DockerHub, and deploy the application. The pipeline also configures a reverse proxy, backend, and connects to a database, ensuring seamless integration and deployment.

## Features

- **Automated Docker image builds** from Dockerfiles.
- **Pushing Docker images to DockerHub**.
- **Deploying services on Kubernetes**.
- **Proxy setup and database connection** for a complete CI/CD workflow.

## Prerequisites

Before starting, make sure you have the following:

- **Jenkins** installed and running.
- **Docker** installed on the Jenkins machine.
- **DockerHub account** with repository access.
- **Kubernetes cluster** to deploy the application.

## Pipeline Setup

1. **Install the Docker Pipeline Plugin** in Jenkins:
   - Go to **Manage Jenkins** > **Manage Plugins** > **Available Plugins**.
   - Search for and install **Docker Pipeline Plugin**.

2. **Create DockerHub Credentials** in Jenkins:
   - Go to **Manage Jenkins** > **Manage Credentials** > **Add Credentials**.
   - Use your DockerHub username and password.
   - Set the ID to `dockerhub-credentials` (or use a custom ID, but remember to update your pipeline).

3. **Set up the Jenkins Pipeline**:
   - In Jenkins, create a new pipeline job.
   - Use this repository's URL to pull the Jenkinsfile.

4. **Build and Deploy**:
   - Once the pipeline is created, trigger a build.
   - Jenkins will:
     1. Clone this repository.
     2. Build Docker images.
     3. Push them to DockerHub.
     4. Create a Kubernetes deployment using the generated images.

## Usage

1. Fork or clone this repository to your local machine.
2. Update any necessary deployment configurations (e.g., DockerHub repository names).
3. Create the pipeline in Jenkins and point it to this repository.
4. Monitor the pipeline as it builds, pushes images, and deploys your application.

## Accessing Jenkins

You can access Jenkins at the following URL: `http://192.168.49.2:32000/`

### Key Points to Consider

- Ensure you have the correct DockerHub credentials set in Jenkins.
- You can modify the `dockerhub-credentials` ID in the Jenkinsfile if needed.
- Make sure to make the scripts executable by running the following command:

   ```bash
   chmod +x start.sh destroy.sh
   ```

- Enjoy a smooth CI/CD pipeline setup for your project!
