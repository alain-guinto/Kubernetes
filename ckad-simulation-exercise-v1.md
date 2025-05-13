# CKAD Exam Simulation Exercise - v1

Pre-configuration: Run below code to set-up your environment

```bash
kubectl apply -f https://raw.githubusercontent.com/alain-guinto/Kubernetes/6a618512f3318a128303b8d370b5ce302b64d3e1/ckad-simulation-preconfig-v1.yaml
```

### 📌  Task 1: 
A new Pod needs to be created in the sa namespace to run a multi-container workload. Create a single Pod that includes two containers: one using the redis image and the other using the nginx image. 
> Ensure both containers run successfully in the same Pod.
<details>
<summary>🔒 show answer </summary>
<p>

```bash
TBD
```

</p>
</details>

### 📌  Task 2:
There is an existing Deployment in the data namespace. Your task is to expose this Deployment by creating a Service that meets the following configuration requirements.  
> Make sure the Service is accessible within the cluster and correctly targets the existing Pods.

```yml
name: webapp-service
type: NodePort
port: 8080
targetPort: 80
nodePort: 30008
```
<details>
<summary>🔒 show answer </summary>
<p>

```bash
TBD
```

</p>
</details>

### 📌  Task 3:
There is an existing Pod named backend-pod in the default namespace. Your task is to modify this Pod to use environment variables sourced from a ConfigMap.  
> Create a ConfigMap that contains the following key-value pairs and update the Pod to reference it:
```bash
name: Alain
role: Solutions Architect
```
Ensure the environment variables are available inside the container at runtime.  
<details>
<summary>🔒 show answer </summary>
<p>

```bash
TBD
```

</p>
</details>

### 📌  Task 4:
In the sa namespace, there is an existing Pod named app. Your task is to create a ReplicaSet in the same namespace to manage a replicated version of this application.
> The ReplicaSet should meet the following requirements:
```bash
name: app-rs 
image: nginx 
replicas: 3
```
> Ensure the already existing app pod will be attached to the Replica Set.
> Once the Replica Set is created, delete the app pod and check if the pod will be automatically replaced.
<details>
<summary>🔒 show answer </summary>
<p>

```bash
TBD
```

</p>
</details>

### 📌  Task 5:
You’ve been asked to set up a test environment for a lightweight web server. Create a new namespace named test-env, and then deploy a single Pod named webserver in that namespace using the httpd image.
> The Pod must meet the following resource requirements:
```bash
CPU request: 250m
Memory request: 512Mi
```
> Ensure the Pod is scheduled successfully within the resource constraints.
<details>
<summary>🔒 show answer </summary>
<p>

```bash
TBD
```

</p>
</details>

### 📌  Task 6:
In the sit-env namespace, there is a Pod named busy running a process as the root user. Your task is to modify the Pod configuration to enhance security.
> Replace the existing Pod with a new one that runs the container as user ID 2000, and ensure privilege escalation is not allowed.
> After updating the Pod, verify the changes by running the following command inside the Pod:
```bash
ps aux
```
> The output should show that the process is running under user ID 2000 instead of root.
<details>
<summary>🔒 show answer </summary>
<p>

```bash
TBD
```

</p>
</details>

### 📌  Task 7:
A Pod named database is running in the dev namespace and requires access to sensitive credentials. Your task is to securely provide this data using a Kubernetes Secret.
> Create a Secret named super-secret with the following key-value pair:
```bash
password: SolArch@2024
```
> Then, update the database Pod to mount this Secret at the path /db/credential.
> After applying the changes, verify the setup by connecting to the Pod and checking the contents of the mounted path. The password must be visible from within the container.
<details>
<summary>🔒 show answer </summary>
<p>

```bash
TBD
```

</p>
</details>

### 📌  Task 8: 
Create a file named agent-data.txt with the following value

```bash
agent-id: A007  
mission: Operation Midnight  
clearance-level: TopSecret  
```
Once the file is created, generate a ConfigMap named agent-config in the default from the text file.
> Modify the existing pod named spy-pod in the default namespace to mount the ConfigMap you just created at the path /etc/agent-secrets.
> -To check your work, SSH into the pod and navigate to the /etc/agent-secrets directory if you can see the data.
<details>
<summary>🔒 show answer </summary>
<p>

```bash
TBD
```

</p>
</details>

### 📌  Task 9:
A Pod named webserver in the rollout namespace is not in a running state. Your task is to investigate the issue and apply the appropriate fix.
> Identify the root cause preventing the Pod from running, resolve the problem, and ensure the Pod transitions to a Running state.
> You may use standard Kubernetes troubleshooting commands such as kubectl describe and kubectl logs to assist with your investigation.
<details>
<summary>🔒 show answer </summary>
<p>

```bash
kubectl -n rollout get po webserver  #--- check the pod in rollout namespace
kubectl -n rollout edit po webserver #--- directly edit the pod and change the mispelled image
```

</p>
</details>

### 📌  Task 10:
A Pod named sa-pod is running in the default namespace and requires access to a ServiceAccount token. Your task is to create a ServiceAccount named admin and mount its token into the Pod as a volume.  
> Mount the token at the path /etc/secret inside the Pod.  
> Ensure the Pod is updated correctly so that it can access the ServiceAccount credentials through the specified mount path.  
<details>
<summary>🔒 show answer </summary>
<p>

```bash
TBD
```

</p>
</details>  

### 📌  Task 11:
There is an existing deployment in the rollout namespace. Your task is to create a new version of this deployment named rollout-app-v2 using the nginx image. Implement a canary deployment strategy where the new version receives 40% of the traffic.  
> Ensure that the canary deployment is configured to gradually roll out the new version with 40% of the traffic directed to rollout-app-v2.  
> Verify the deployment configuration to confirm the traffic distribution and that the application is running successfully.
<details>
<summary>🔒 show answer </summary>
<p>

```bash
TBD
```

</p>
</details>

### 📌  Task 12:
Your team needs to restrict egress traffic from applications in the rollout namespace. Create a NetworkPolicy named np that limits all outgoing traffic from Pods in the rollout namespace to only allow connections to Pods in the data namespace.  
> Ensure that DNS resolution continues to work by allowing egress traffic on port 53 for both TCP and UDP protocols.  
> Incoming traffic to the Pods in rollout should not be affected.  
<details>
<summary>🔒 show answer </summary>
<p>

```bash
TBD
```

</p>
</details>
