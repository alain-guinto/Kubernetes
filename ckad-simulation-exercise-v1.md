# CKAD Simulation Exercise - v1

Pre-configuration: Run below code to set-up your environment

```bash
kubectl apply -f https://raw.githubusercontent.com/alain-guinto/Kubernetes/6a618512f3318a128303b8d370b5ce302b64d3e1/ckad-simulation-preconfig-v1.yaml
```

### Task 1: 
Check why the pod webserver is not running in the rollout namespace, then apply the fix.

<details><summary>show answer</summary>
<p>

```bash
kubectl -n rollout get po webserver  #--- check the pod in rollout namespace
kubectl -n rollout edit po webserver #--- directly edit the pod and change the mispelled image
```

</p>
</details>

### Task 2:
Check the deployment in the data namespace and expose it by creating a service with the following service configuration

```yml
name: webapp-service
type: NodePort
port: 8080
targetPort: 80
nodePort: 30008
```

### Task 3:
There is a pod in the default namespace named backend-pod. You must modify the pod and add the following environment variable using configmap.

```bash
name: Alain
role: Solutions Architect
```

### Task 4:
In the sa namespace, and there is a pod named app, create a Replica Set in the same namespace with the following configuration
```bash
name: app-rs 
image: nginx 
replicas: 3
```
Ensure the already existing app pod will be attached to the Replica Set.
Once the Replica Set is created, delete the app pod and check if the pod will be automatically replaced.

### Task 5:
Create a namespace named tech-academy and then create a single pod named webserver using the httpd image inside the tech-academy namespace. The Pod must have a resource request of 0.5 vCPU and 512 MiB memory.

### Task 6:
SSH into the pod named busy in the apper namespace, then run this command: ps aux
It shows that the process is running on the root user. Replace the pod to use the user 2000 instead of root, and don’t allow privilege escalation
To check your work, run: ps aux
It should show the user ID 2000 instead of the root.

### Task 7:
Update the pod named database in the dev namespace by mounting a secret named super-secret with the following key-value pair:
```bash
password: SolArch@2024
```
Once you have created the secret, mount it to the database pod. Use the mount path:
/db/credential
To test your work, SSH to the pod and navigate to the mount path. You must be able to view the password.

### Task 8: 
Create a file named agent-data.txt with the following value

```bash
agent-id: A007  
mission: Operation Midnight  
clearance-level: TopSecret  
```
Once the file is created, generate a ConfigMap named agent-config in the default from the text file.
Modify the existing pod named spy-pod in the default namespace to mount the ConfigMap you just created at the path /etc/agent-secrets.
-To check your work, SSH into the pod and navigate to the /etc/agent-secrets directory if you can see the data.

### Task 9:
Create a single pod with 2 containers on the sa namespace, use the Redis and Nginx container images.

### Task 10:
Configure a service account and name it admin.
Once the service account is created, mount it to the pod named sa-pod as a volume in the default namespace, use the mount path /etc/secret directory

### Task 11:
Check the deployment in the rollout namespace and roll out a rollout-app-v2 deployment with an Nginx image using the canary deployment. The new deployment must receive 40% of the traffic.

### Task 12:
Create a new NetworkPolicy named np that restricts all Pods in Namespace rollout to only have outgoing traffic to Pods in Namespace data. Incoming traffic is not affected.
The NetworkPolicy should still allow outgoing DNS traffic on port 53 TCP and UDP.
