# CKAD Exam Simulation Exercise - v1

Pre-configuration: Run below code to set-up your environment

```bash
kubectl apply -f https://raw.githubusercontent.com/alain-guinto/Kubernetes/refs/heads/main/ckad-simulation-preconfig-v1.yaml
```

### 📌  Task 1: 
A new Pod needs to be created in the sa namespace to run a multi-container workload. Create a single Pod name multi-container-pod that includes two containers: one using the redis image and the other using the nginx image. 
> Ensure both containers run successfully in the same Pod.
<details>
<summary>🔒 show answer </summary>
<p>  

> Create a template pod yaml   
```bash
k -n sa run multi-container-pod --image=nginx --dry-run=client -oyaml > multi-container-pod.yaml #--- create a pod template
```
> Edit the created pod yaml template
```bash
vi multi-container-pod.yaml
```
> Updated yaml should look like
```yml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: multi-container-pod
  name: multi-container-pod
  namespace: sa
spec:
  containers:
  - image: nginx
    name: nginx-container   # modify
  - image: redis            # add
    name: redis-container   # add
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
> Apply the changes using the shortcut key commands define in aliases and verify
```bash
kaf multi-container-pod.yaml  # Apply

kgp multi-container-pod -n sa  # Verify

#output
NAME                  READY   STATUS    RESTARTS   AGE
multi-container-pod   2/2     Running   0          154m
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
  
> Verify if the deployment exists in data namespace  
  
```bash
kgd -n data

# output
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
webdeploy   3/3     3            3           167m
```
> Create service yaml template from webdeploy deployment
```bash
k expose deploy webdeploy -n data --name=webapp-service --type=NodePort --port=8080 --target-port=80 --dry-run=client -oyaml > webapp-service.yaml
```
> Edit the created service yaml template to add nodePort
```yml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: webdeploy
  name: webapp-service
  namespace: data
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 80
    nodePort: 30008     # Add
  selector:
    app: webdeploy
  type: NodePort
status:
  loadBalancer: {}
```

> Apply the changes using the shortcut key commands define in aliases

```bash
kaf webapp-service.yaml 
```
> Validate
```bash
kgs -n data  # expected output should be similar to below

NAME             TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
webapp-service   NodePort   10.109.200.158   <none>        8080:30008/TCP   72s
```
</p>
</details>

### 📌  Task 3:
There is an existing Pod named backend-pod in the default namespace. Your task is to modify this Pod to use environment variables sourced from a ConfigMap.  
> Create a ConfigMap named my-config-var that contains the following key-value pairs and update the Pod to reference it:
```bash
name: Alain
role: Solutions Architect
```
Ensure the environment variables are available inside the container at runtime.  
<details>
<summary>🔒 show answer </summary>
<p>  
  
> Verify if backend-pod exists in default namespace
```bash
kgp backend-pod  # expected outout  

NAME          READY   STATUS    RESTARTS   AGE
backend-pod   1/1     Running   0          25m
```
> Create a configmap
```bash
k create configmap my-config-var --from-literal=name=Alain --from-literal=role=Solutions-Architect

k get configmap my-config-var  # check if configmap created
```
> Copy the configuration of backend-pod
```bash
kgp backend-pod -oyaml > backend-pod.yaml  
```
> Updated yaml should look like this
```yml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: backend-pod
  name: backend-pod
  namespace: default
spec:
  containers:
  - image: redis
    imagePullPolicy: Always
    name: backend-pod
    resources: {}
    envFrom:                                 # Add
    - configMapRef:                          # Add
        name: my-config-var                  # Add
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
  dnsPolicy: ClusterFirst
  enableServiceLinks: true
  nodeName: node01
  preemptionPolicy: PreemptLowerPriority
  priority: 0
  restartPolicy: Always
  schedulerName: default-scheduler
  securityContext: {}
  serviceAccount: default
  serviceAccountName: default
  terminationGracePeriodSeconds: 30
  tolerations:
  - effect: NoExecute
    key: node.kubernetes.io/not-ready
    operator: Exists
    tolerationSeconds: 300
  - effect: NoExecute
    key: node.kubernetes.io/unreachable
    operator: Exists
    tolerationSeconds: 300 
```
> Apply changes
```bash
kaf backend-pod.yaml  
```
> Verify environment variables
```bash
kex backend-pod -- printenv | grep -E 'name|role'   # output should similar to below

name=Alain
role=Solutions-Architect
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
  
> Check if app pod exist in sa namespace  
  
```bash
kgp app -n sa --show-labels   # output should similar to below

NAME   READY   STATUS    RESTARTS   AGE   LABELS
app    1/1     Running   0          57m   run=app
```
> Create a replicaset yaml 
```bash
k -n sa create deploy app-rs --image=nginx --replicas=3 --dry-run=client -oyaml > app-rs.yaml
```
> Edit app-rs yaml and the final yaml should look like below
```yml
apiVersion: apps/v1
kind: ReplicaSet        # Modify from deployment to replicaset
metadata:
  creationTimestamp: null
  labels:
    run: app           # Modify to match the labels of app pod 
  name: app-rs
  namespace: sa
spec:
  replicas: 3
  selector:
    matchLabels:
      run: app          # Modify to match the labels of app pod
  #strategy: {}         # Removed
  template:
    metadata:
      creationTimestamp: null
      labels:
        run: app        # Modify to match the labels of app pod
    spec:
      containers:
      - image: nginx
        name: nginx
        resources: {}
status: {}
```
> Apply the changes 
```bash
kaf app-rs.yaml
```
> Verify 
```bash
kgp -n sa   # output should be similar below

NAME                  READY   STATUS    RESTARTS   AGE
app                   1/1     Running   0          71m
app-rs-6zbrl          1/1     Running   0          71s
app-rs-qqxdt          1/1     Running   0          71s
```
> Delete app and verify again 
```bash
kdel po app -n sa

kgp -n sa   # output should be similar below

NAME                  READY   STATUS    RESTARTS   AGE
app-rs-6zbrl          1/1     Running   0          3m28s
app-rs-qqxdt          1/1     Running   0          3m28s
app-rs-zwbs2          1/1     Running   0          35s
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
  
> Create test-env namespace:  
  
```bash
k create ns test-env
```
> Create pod yaml template:  
  
```bash
k -n test-env run webserver --image=httpd --dry-run=client -oyaml > webserver.yaml

vi webserver.yaml     # Edit the yaml file to add resources requirements
```
> Update created yaml and it should look like below:  
```yml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: webserver
  name: webserver
  namespace: test-env
spec:
  containers:
  - image: httpd
    name: webserver
    resources: 
      requests:                # Add
        cpu: "250m"            # Add
        memory: "512Mi"        # Add
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
> Apply the changes:  
  
```bash
kaf webserver.yaml 
```
> Validate:  
  
```bash
kd pod webserver -n test-env | grep -iA2 requests:  # output should look like below

 Requests:
      cpu:        250m
      memory:     512Mi 
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
  
> Check if busy pod exists in sit-env namepsace

```bash
kgp busy -n sit-env

# output
NAME   READY   STATUS    RESTARTS      AGE
busy   1/1     Running   1 (30m ago)   92m
```
> Check if busy pod is running a process a root

```bash
kex busy -n sit-env -- ps aux

# expected output
PID   USER     TIME  COMMAND
    1 root      0:00 sleep 1h
    7 root      0:00 ps aux
```

> Copy the pod configuration and edit

```bash
kgp busy -n sit-env -oyaml > busy-pod.yaml

vi busy-pod.yaml
```
> Update the yaml and it should look like below

```yml
apiVersion: v1
kind: Pod
metadata:
  name: busy
  namespace: sit-env
spec:
  securityContext:           # Add
    runAsUser: 2000          # Add
  containers:
  - command:
    - sh
    - -c
    - sleep 1h
    image: busybox
    imagePullPolicy: Always
    name: busy
    resources: {}
    securityContext:                  # Add
      allowPrivilegeEscalation: false # Add
  dnsPolicy: ClusterFirst
status: {}
```
> Delete the pod

```bash
kdel po busy -n sit-env
```
> Apply the changes

```bash
kdel po busy -n sit-env
```
> Verify

```bash
kex busy -n sit-env -- ps aux

# expected output
PID   USER     TIME  COMMAND
    1 2000      0:00 sleep 1h
    7 2000      0:00 ps aux
```
</p>
</details>

### 📌  Task 7:
A Pod named database is running in the dev namespace and requires access to sensitive credentials. Your task is to securely provide this data using a Kubernetes Secret.
> Create a Secret named db-secret with the following key-value pair:
```bash
password: my-db-pass
```
> Then, update the database Pod to mount this Secret at the path /db/credential.  
> After applying the changes, verify the setup by connecting to the Pod and checking the contents of the mounted path. The password must be visible from within the container.
<details>
<summary>🔒 show answer </summary>
<p>

> Check if database pod exists in dev namepsace

```bash
kgp database -n dev

# output
NAME       READY   STATUS    RESTARTS   AGE
database   1/1     Running   0          113m
```
> Create a secret

```bash
k -n dev create secret generic db-secret --from-literal=password=my-db-pass
```
> Copy the configuration yaml of database pod 

```bash
kgp database -n dev -oyaml > database.yaml

vi database.yaml
```

> Update the database.yaml and it should look like below.

```yml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: database
  name: database
  namespace: dev
spec:
  containers:
  - image: redis
    imagePullPolicy: Always
    name: database
    resources: {}
    volumeMounts:
    - mountPath: /db/credential     # Add
      name: my-db-secret            # Add
  dnsPolicy: ClusterFirst
  volumes:                          # Add
  - name: my-db-secret              # Add
    secret:                         # Add
      secretName: db-secret         # Add
status: {}
```
> Delete database pod

```bash
kdel pod database -n dev

```

> Apply changes

```bash
kaf database.yaml

```
> Verify

```bash
kex database -n dev -- ls /db/credential

#Output
password

kex database -n dev -- cat /db/credential/password

#Output
my-db-pass
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
Once the file is created, generate a ConfigMap named agent-data in the default from the text file.
> Modify the existing pod named spy-pod in the default namespace to mount the ConfigMap you just created at the path /etc/agent-secrets.
> -To check your work, SSH into the pod and navigate to the /etc/agent-secrets directory if you can see the data.
<details>
<summary>🔒 show answer </summary>
<p>  

> Create agent-data.txt file
```bash
echo -e "agent-id: A007\nmission: Operation-Midnight\nclearance-level: Top-secret" > agent-data.txt
```
> Create configmap from agent-data.txt file
```bash
k create configmap agent-data --from-file=agent-data.txt
```
> Create configmap from agent-data.txt file
```bash
k create configmap agent-data --from-file=agent-data.txt
```
> Check spy-pod in default namespace if exists and copy its configuration yaml 
```bash
kgp spy-pod

kgp spy-pod -oyaml > spy-pod.yaml

vi spy-pod # modify this yaml to add configmap
```
> Update spy-pod yaml and it should look like below
```yml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: spy-pod
  name: spy-pod
  namespace: default
spec:
  containers:
  - image: redis
    imagePullPolicy: Always
    name: spy-pod-container
    resources: {}
    volumeMounts:
    - mountPath: /etc/agent-secrets
      name: agent-config
      readOnly: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
  - name: agent-config
    configMap:
      name: agent-data
status: {}
```
> Delete spy-pod pod

```bash
kdel po spy-pod
```

> Apply changes

```bash
kaf spy-pod.yaml

```
> Verify

```bash
kex spy-pod -- ls /etc/agent-secrets

#Output
agent-data.txt

kex spy-pod -- cat /etc/agent-secrets/agent-data.txt

#Output
agent-id: A007
mission: Operation-Midnight
clearance-level: Top-secret
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

> Check webserver pod in rollout namespace
```bash
kgp webserver -n rollout  #--- check the pod in rollout namespace

#output
NAME        READY   STATUS             RESTARTS   AGE
webserver   0/1     ImagePullBackOff   0          152m

k -n rollout edit po webserver #--- directly edit the pod and change the mispelled image
```
> Update webserver pod should look like this
```yml
# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: webserver
  name: webserver
  namespace: rollout
spec:
  containers:
  - image: nginx               # Modified fron ngiinx to nginx
    imagePullPolicy: Always
    name: webserver
    resources: {}
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-lwtpp
      readOnly: true
  dnsPolicy: ClusterFirst
status: {}
```
> Verify
```bash
kgp webserver -n rollout  #--- check the pod in rollout namespace

NAME        READY   STATUS    RESTARTS   AGE
webserver   1/1     Running   0          157m
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

> Create a service account admin
```bash
k create sa admin

kgsa admin     # check newly created service account

# output
NAME    SECRETS   AGE
admin   0         11m
```
> Verify if sa-pod exists and running in default namespace
```bash
kgp sa-pod  # expected outout  

NAME          READY   STATUS    RESTARTS   AGE
sa-pod   1/1     Running   0          25m
```  
> Copy the configuration of backend-pod
```bash
kgp sa-pod -oyaml > sa-pod.yaml  
```
> Updated yaml should look like this
```yml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: sa-pod
  name: sa-pod
  namespace: default
spec:
  containers:
  - image: nginx
    imagePullPolicy: Always
    name: sa-pod
    resources: {}
    volumeMounts:
    - mountPath: /etc/secret
      name: my-admin-secret
      readOnly: true
  dnsPolicy: ClusterFirst
  serviceAccountName: admin
  volumes:
  - name: my-admin-secret
    projected:
      defaultMode: 420
      sources:
      - serviceAccountToken:
          path: token
          expirationSeconds: 3600
          audience: api
status: {}
```
> Delete sa-pod
```bash
kdel sa-pod
```

> Apply changes
```bash
kaf sa-pod.yaml  
```
> Verify secret is available in the path
```bash
kex sa-pod -- ls /etc/secret   # output should similar to below

kex sa-pod -- cat /etc/secret/token

# output
eyJhbGciOiJSUzI1NiIsImtpZCI6IkZMSGZEb3cxakNMX2NaY2dlYmU2M0xaRGRXNWtSMmVJRE54QjNzOGwxdzgifQ.eyJhdWQiOlsiYXBpIl0sImV4cCI6MTc0NzIxNDk2NSwiaWF0IjoxNzQ3MjExMzY1LCJpc3MiOiJodHRwczovL2t1YmVybmV0ZXMuZGVmYXVsdC5zdmMuY2x1c3Rlci5sb2NhbCIsImp0aSI6ImIyNTg5M2ViLTJlZjMtNDkxMy04MTYwLWUwN2U1MDJlMTgwYiIsImt1YmVybmV0ZXMuaW8iOnsibmFtZXNwYWNlIjoiZGVmYXVsdCIsIm5vZGUiOnsibmFtZSI6Im5vZGUwMSIsInVpZCI6ImI2ZDMyMTU2LTAyNWQtNDJmZS1hZWIxLTA0ZmEzNDBhMzE3MSJ9LCJwb2QiOnsibmFtZSI6InNhLXBvZCIsInVpZCI6ImFkMzg5NGY0LTA3NjAtNDAwOS05MjZjLTQwOTEwMjdiYTA2MyJ9LCJzZXJ2aWNlYWNjb3VudCI6eyJuYW1lIjoiYWRtaW4iLCJ1aWQiOiIyMTM3OTA0My00NTA4LTRhODctYTc4Yi1lYWZhNmEzODA0OWEifX0sIm5iZiI6MTc0NzIxMTM2NSwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OmRlZmF1bHQ6YWRtaW4ifQ.j5vsp83X42lhm5JOT8jfGCmr-KZFxvfCxU6RMKlJdspK7qtceqsMJ1oYht1C9iPe99ETMzBwAhcTGWSVIgamSUFHmVZNCmVit9vzN-PSvYX4Z2iOYRJY9xYe8du9W6tf6pZT15MQhxX62_FwOhOlv2eP94l29AGJeHsBCIJh--MdRNnabjcoJ0VvbJxNW5CyWYzq0x53hqWHweKNwYw_YdCDPY4r3s6SJeBbEwXxlfvKUvC_AOTCmkHRpCOR364sXpbMv3OkmcCgB46tZ1MQjwsdgD4_qDtReikWJPcbXz31vyg_wUFIVws2lt0NdUPNhryDh9uqOb89U8IvbuY
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

> Check if deployment rollout-app exists in rollout namespace
```bash
kgd rollout-app -n rollout

# output
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
rollout-app   3/3     3            3           28m

```
> Copy the deployment rollout-app and edit it to create a rollout-app-v2
```bash
kgd rollout-app -n rollout > rollout-app-v2.yaml  # expected outout  

vi rollout-app-v2.yaml  # Edit yaml file 
```
> Updated yaml should look like this
```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: server
  name: rollout-app-v2        # Modified
  namespace: rollout
spec:
  replicas: 2                 # Modified
  selector:
    matchLabels:
      app: server
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: server
    spec:
      containers:
      - image: nginx          # Modified
        name: nginx-container # Modified
        ports:
        - containerPort: 80
        resources: {}
status: {}
```
> Apply changes
```bash
kaf rollout-app-v2.yaml  
```  
> Create a service and make sure the selector is matched to deployment labels
```bash
k expose deploy rollout-app -n rollout --name=rollout-svc --port=80 --target-port=80 --selector=app=server
```
> Check service if it has endpoints 
```bash
k get endpoints rollout-svc -n rollout

# output
NAME          ENDPOINTS                                                     AGE
rollout-svc   192.168.1.27:80,192.168.1.28:80,192.168.1.29:80 + 2 more...   30m
```

> Check the pods in rollout namespaces
```bash
kgp -n rollout

# output
NAME                              READY   STATUS             RESTARTS   AGE
rollout-app-84fcf654c7-7hr92      1/1     Running            0          38m
rollout-app-84fcf654c7-gpn6q      1/1     Running            0          38m
rollout-app-84fcf654c7-zvgst      1/1     Running            0          38m
rollout-app-v2-58657f8767-ltmp5   1/1     Running            0          36m
rollout-app-v2-58657f8767-ltqbh   1/1     Running            0          36m
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
  
> Final network policy in netpol.yaml should look like this  
  
```yml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np
  namespace: rollout
spec:
  podSelector: {}  # Apply to all pods in rollout namespace
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          name: data
  - to:
    - ipBlock:
        cidr: 0.0.0.0/0
    ports:
    - protocol: UDP
      port: 53
    - protocol: TCP
      port: 53
```  
> Apply changes
```bash
kaf netpol.yaml  
```  
> Add label to data namespace
```bash
kubectl label namespace data name=data

k get ns data --show-labels  # verify

# output
NAME   STATUS   AGE    LABELS
data   Active   158m   kubernetes.io/metadata.name=data,name=data
```
> Get the IP of the pods in data namespace
```bash
kgp -n data -o wide

# output
NAME                         READY   STATUS    RESTARTS   AGE    IP            NODE     NOMINATED NODE   READINESS GATES
webdeploy-74bc5b78dc-c66bs   1/1     Running   0          162m   192.168.1.4   node01   <none>           <none>
webdeploy-74bc5b78dc-fz998   1/1     Running   0          162m   192.168.1.6   node01   <none>           <none>
webdeploy-74bc5b78dc-j6p95   1/1     Running   0          162m   192.168.1.5   node01   <none>           <none>
```
> Ping the IP from rollout namespace pod
```bash
kubectl run tester --rm -it --image=busybox --restart=Never -n rollout -- sh

# ping 192.168.1.4
```

</p>
</details>
