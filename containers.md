# Containers - Docker/Podman

### 📌 Question 1: Fix Broken Dockerfile and Push Image
> You’ve been given a Dockerfile in /opt/course/1/image that fails to build due to a missing flag in the CMD instruction. The application should output the response body of https://example.com to stdout.

- ***Fix the Dockerfile***: Modify the CMD to use -s (silent mode) with curl.
- ***Build and push***:
- Use sudo docker to build the image, tag it as registry.killer.sh:5000/optimus-curl:v1-docker, and push it.
- Use sudo podman to build the same image, tag it as registry.killer.sh:5000/optimus-curl:v1-podman, and push it.
- ***Test:*** Run a detached Podman container named optimus-curl using the pushed image and save its logs to /opt/course/1/logs.

<details>
<summary style="font-weight: bold; color: green;" >🔒 Show answer </summary>
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
<summary style="font-weight: bold; color: green;" >🔒 Show answer </summary>
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
<summary style="font-weight: bold; color: green;" >🔒 Show answer </summary>
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
<summary style="font-weight: bold; color: green;" >🔒 Show answer </summary>
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
<summary style="font-weight: bold; color: green;" >🔒 Show answer </summary>
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
<summary style="font-weight: bold; color: green;" >🔒 Show answer </summary>
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
<summary style="font-weight: bold; color: green;" >🔒 Show answer </summary>
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
<summary style="font-weight: bold; color: green;" >🔒 Show answer </summary>
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
<summary style="font-weight: bold; color: green;" >🔒 Show answer </summary>
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
<summary style="font-weight: bold; color: green;" >🔒 Show answer </summary>
<p>  
  
  ```bash  
  >> Try to solve it on your own first.
  ```
</p>
</details>

