# Containers - Docker/Podman  
**Pre-configuration:** Run below code to set-up your environment

```bash
sh https://raw.githubusercontent.com/alain-guinto/Kubernetes/refs/heads/main/containers-preconfig.sh
```

### 📌 Question 1: Fix Broken Dockerfile and Push Image
> You’ve been given a Dockerfile in /opt/course/1/image that fails to build due to a missing flag in the CMD instruction. The application should output the response body of https://example.com to stdout.

- ***Fix the Dockerfile***: Modify the CMD to use -s (silent mode) with curl.
- ***Build and push***:
- Use sudo docker to build the image, tag it as registry.killer.sh:5000/optimus-curl:v1-docker, and push it.
- Use sudo podman to build the same image, tag it as registry.killer.sh:5000/optimus-curl:v1-podman, and push it.
- ***Test:*** Run a detached Podman container named optimus-curl using the pushed image and save its logs to /opt/course/1/logs.

<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>
  
### 📌 Question 2: Debug Multi-Stage Build Failure
> A multi-stage Dockerfile in /opt/course/2/image fails because the source code (main.go) is missing. The final image should run a Go app that prints "Bumblebee API Online".
Fix the issue:
- Create a main.go file with the correct output.
- Ensure the COPY . . in the builder stage includes it.
- Build and push:
- Tag the Docker image as registry.killer.sh:5000/bumblebee-api:v1.
- Verify: Run the container and ensure the output matches the expected message. Save logs to /opt/course/2/logs.

<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

### 📌 Question 3: Resolve Image Permission Denied
>The Dockerfile in /opt/course/3/image results in a permission error when the container runs because NGINX can’t read index.html.
- ***Troubleshoot:***
  - Modify the RUN instruction to set correct permissions (e.g., 644).
  - Ensure the USER directive doesn’t break NGINX.
- ***Build and push:***
  - Tag the image as registry.killer.sh:5000/ironhide-nginx:v1.
- ***Test:*** Run the container and verify NGINX serves the page. Capture logs to /opt/course/3/logs.



<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

### 📌 Question 4: Optimize Image Size
> The Dockerfile in /opt/course/4/image produces an unnecessarily large image. Optimize it to minimize layers and remove unused dependencies.
- ***Fix:***  
  - Combine RUN commands.
  - Remove unnecessary packages (git).
- ***Build and push:***
  - Tag as registry.killer.sh:5000/ratchet-python:v1.
- ***Verify:*** Check the image size with sudo docker images and confirm Python runs.
  
<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

### 📌 Question 5: Fix Container CrashLoopBackOff
> A Pod named jazz-app in the jazz namespace crashes because the CMD doesn’t evaluate the PORT env variable.
- ***Debug:***
  - Rewrite the CMD to use sh -c for variable expansion.
- ***Build and push:***
  - Tag as registry.killer.sh:5000/jazz-app:v1.
- ***Deploy:***
  - Create a Pod using the fixed image and verify it stays running. Save logs to /opt/course/5/logs.
    
<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

### 📌 Question 6: Secure Environment Variables
> The Dockerfile in /opt/course/6/image hardcodes a sensitive password. Refactor it to pass the password securely at runtime.
- ***Fix:***
  - Remove the hardcoded ENV.
  - Modify the CMD to expect DB_PASSWORD as an env variable.
- ***Build and push:***
  - Tag as registry.killer.sh:5000/wheeljack-db:v1.
- ***Test:*** Run the container with -e DB_PASSWORD=NewPass123 and verify output.

<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

### 📌 Question 7: Resolve Missing Volume Mount
> A Pod using this image loses data on restart because the volume isn’t mounted correctly.
- ***Fix:***
  - Ensure the VOLUME directive is correct.
  - Document how to mount it in a Pod (hostPath or PVC).
- ***Build and push:***
  - Tag as registry.killer.sh:5000/prowl-db:v1.
- ***Test:*** Deploy a Pod with a volume mount and verify data persistence.


<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

### 📌 Question 8: Debug Slow Container Startup
> The container takes too long to start because requirements.txt includes unused packages.
- ***Optimize:***
  - Audit requirements.txt and remove unused dependencies.
- ***Build and push:***
  - Tag as registry.killer.sh:5000/cliffjumper-python:v1.
- ***Test:*** Measure startup time before/after fixes.

<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

### 📌 Question 9: Implement Health Checks in Dockerfile
> A Pod running this image occasionally becomes unresponsive but remains in a "Running" state. You need to add a health check to ensure traffic is only routed to healthy containers.
- ***Modify the Dockerfile:***
  - Add a HEALTHCHECK instruction that uses curl -f http://localhost/ || exit 1 every 30 seconds.
- ***Build and push:***
  - Tag as registry.killer.sh:5000/optimus-nginx-health:v1.
- ***Test:***
  - Deploy the image in a Pod and simulate failure by deleting index.html inside the container.
  - Verify the health status changes to Unhealthy after 30 seconds.
  - Save the health check logs to /opt/course/9/health.log.


<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

### 📌 Question 10: Custom Entrypoint Script 
> The containerized Python app (app.py) ignores SIGTERM, causing Pods to terminate forcefully during scaling events.
- ***Fix the issue:***
  - Create an entrypoint.sh script that traps SIGTERM and gracefully stops the app.
  - Modify the Dockerfile to use ENTRYPOINT ["/entrypoint.sh"].
- ***Build and push:***
  - Tag as registry.killer.sh:5000/bumblebee-python-graceful:v1.
- ***Test:***
  - Run the container and send SIGTERM with sudo podman kill --signal TERM <container-id>.
  - Confirm the app exits gracefully (check logs in /opt/course/10/termination.log).


<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

### 📌 Question 11: Build and Push with Docker and Podman
> Tasks:
  - Modify the Dockerfile to set the environment variable SUN_CIPHER_ID to 5b9c1065-e39d-4a43-a04a-e59bcea3e03f.  
  - Build the image using sudo docker, tag it as registry.killer.sh:5000/sun-cipher:v1-docker, and push it to the registry.  
  - Build the image using sudo podman, tag it as registry.killer.sh:5000/sun-cipher:v1-podman, and push it to the registry.
  - Run a container using sudo podman in detached mode named sun-cipher using the image registry.killer.sh:5000/sun-cipher:v1-podman.
  - Redirect the logs produced by the sun-cipher container into /opt/course/11/logs.

<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

### 📌 Question 12: 
> Tasks:
  - The current Dockerfile fails during the build process due to a missing requirements.txt file.
  - Create a requirements.txt file with the necessary dependencies.
  - Modify the Dockerfile to copy requirements.txt and install dependencies using pip.
  - Build the image using sudo docker, tag it as registry.killer.sh:5000/python-app:v1, and push it to the registry.
  - Run a container using sudo docker in detached mode named python-app using the image registry.killer.sh:5000/python-app:v1.
  - Verify that the application starts successfully by checking the container logs.


<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details> 

### 📌 Question 13: 
> Task:
  -  The existing Dockerfile builds a large image due to unnecessary build tools being included.
  -  Refactor the Dockerfile to use a multi-stage build:
  -  First stage: Use node:14 to build the application.
  -  Second stage: Use node:14-alpine to run the application.
  -  Build the image using sudo podman, tag it as registry.killer.sh:5000/node-app:v2, and push it to the registry.
  -  Run a container using sudo podman in detached mode named node-app using the image registry.killer.sh:5000/node-app:v2.
  -  Confirm that the image size is reduced compared to the previous version.
    
<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

### 📌 Question 14: 
> Task:
  - The current Dockerfile uses an incorrect base image openjdk:8-jre which lacks necessary tools.
  - Modify the Dockerfile to use openjdk:8-jdk as the base image.
  - Build the image using sudo docker, tag it as registry.killer.sh:5000/java-app:v1, and push it to the registry.
  - Run a container using sudo docker in detached mode named java-app using the image registry.killer.sh:5000/java-app:v1.
  - Verify that the application runs successfully by checking the container logs.

<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

### 📌 Question 15: 
> Task:
  -  Modify the Dockerfile to include a HEALTHCHECK instruction that checks if the application is responding on port 8080.
  -  Build the image using sudo podman, tag it as registry.killer.sh:5000/go-app:v1, and push it to the registry.
  -  Run a container using sudo podman in detached mode named go-app using the image registry.killer.sh:5000/go-app:v1.
  -  Use podman inspect to verify that the health check is configured correctly.
    
<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

### 📌 Question 16:
> Task:
  -  Modify the Dockerfile to copy start.sh into the image and set it as the entrypoint.
  -  Ensure that start.sh has executable permissions.
  -  Build the image using sudo docker, tag it as registry.killer.sh:5000/bash-app:v1, and push it to the registry.
  -  Run a container using sudo docker in detached mode named bash-app using the image registry.killer.sh:5000/bash-app:v1.
  -  Verify that the application starts correctly by checking the container logs.
    
<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

### 📌 Question 17:
> Task:
  -  Modify the Dockerfile to accept a build argument APP_ENV with a default value of production.
  -  Use the APP_ENV argument to set an environment variable inside the image.
  -  Build the image using sudo podman, passing APP_ENV=staging, tag it as registry.killer.sh:5000/env-app:v1, and push it to the registry.
  -  Run a container using sudo podman in detached mode named env-app using the image registry.killer.sh:5000/env-app:v1.
  -  Inside the container, verify that the APP_ENV environment variable is set to staging.


<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

### 📌 Question 18
> Task:
-  Run a container using sudo docker in detached mode named config-app using the image registry.killer.sh:5000/config-app:v1.
-  Mount the host directory /opt/course/18/data to /app/config inside the container.
-  Ensure that the application reads configuration from /app/config/config.json.
-  Verify that the application starts successfully by checking the container logs.


<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

### 📌 Question 19
> Task:
  -  Build the image using sudo docker, tag it as registry.killer.sh:5000/resource-app:v1, and push it to the registry.
  -  Run a container using sudo docker in detached mode named resource-app using the image registry.killer.sh:5000/resource-app:v1.
  -  Set the container's CPU limit to 0.5 and memory limit to 256m.
  -  Verify the resource limits are applied by inspecting the container's configuration.


<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

### 📌 Question 20
> Task:
  -  Build the image using sudo podman, tag it as registry.killer.sh:5000/crash-app:v1, and push it to the registry.
  -  Run a container using sudo podman in detached mode named crash-app using the image registry.killer.sh:5000/crash-app:v1.
  -  The container enters a crash loop upon starting.
  -  Investigate the issue by checking the container logs and inspecting the Dockerfile.
  -  Identify and fix the issue causing the crash, rebuild the image, and redeploy the container.
  -  Verify that the application starts successfully after the fix.
    
<details>
<summary>🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>
