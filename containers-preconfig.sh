#---1
mkdir -p /opt/course/1/image
cd /opt/course/1/image
cat <<EOF > Dockerfile
# Dockerfile (intentionally broken)
FROM alpine:3.15
RUN apk add --no-cache curl
ENV APP_VERSION=1.0
CMD ["curl", "https://example.com"]
EOF

#----2
mkdir -p /app/course/2/app
cd /app/course/2/app
cat <<EOF> app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from Flask!"
EOF
#--
cat <<EOF > Dockerfile
# Dockerfile (failing multi-stage build)
FROM golang:1.18 as builder
WORKDIR /app
COPY . .
RUN go build -o /app/bin

FROM alpine:3.15
COPY --from=builder /app/bin /bin
CMD ["/bin"]
EOF

#----3
mkdir -p /opt/course/5/image
cd /opt/course/5/image
cat <<EOF > Dockerfile
# Dockerfile
FROM nginx:1.21
COPY index.html /usr/share/nginx/html/
RUN chmod 444 /usr/share/nginx/html/index.html
USER 1001
EOF

#----4
mkdir -p /opt/course/5/image
cd /opt/course/5/image
cat <<EOF > Dockerfile
# Dockerfile (bloated image)
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y wget git python3
RUN wget https://example.com/large-file.tar.gz
RUN rm large-file.tar.gz
CMD ["python3", "--version"]
EOF

#----5
mkdir -p /opt/course/5/image
cd /opt/course/5/image
cat <<EOF > Dockerfile
# Dockerfile (crashes on startup)
FROM busybox
ENV PORT=8080
CMD ["echo", "Listening on $PORT"]
EOF

#----6
mkdir -p /opt/course/6/image
cd /opt/course/6/image
cat <<EOF > Dockerfile
# Dockerfile (exposes secrets)
FROM alpine:3.15
ENV DB_PASSWORD=SuperSecret123
CMD ["sh", "-c", "echo $DB_PASSWORD"]
EOF

#----7
mkdir -p /opt/course/7/image
cd /opt/course/7/image
cat <<EOF > Dockerfile
# Dockerfile (fails to persist data)
FROM postgres:13
VOLUME /var/lib/postgresql/data

EOF

#----8
mkdir -p /opt/course/8/image
cd /opt/course/8/image
cat <<EOF > Dockerfile
# Dockerfile (slow startup)
FROM python:3.9
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "app.py"]
EOF

#----9
mkdir -p /opt/course/9/image
cd /opt/course/9/image
cat <<EOF > Dockerfile
# Dockerfile (missing health check)
FROM nginx:1.23
COPY index.html /usr/share/nginx/html/
EXPOSE 80
EOF

#----10
mkdir -p /opt/course/10/image
cd /opt/course/10/image
cat <<EOF > Dockerfile
# Dockerfile (fails to handle SIGTERM)
FROM python:3.9
COPY app.py .
CMD ["python", "app.py"]
EOF

#----11
mkdir -p /opt/course/11/app
cd /opt/course/11/app
cat <<EOF > main.go
package main
import (
    "fmt"
    "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, "Hello from Go!")
}

func main() {
    http.HandleFunc("/", handler)
    http.ListenAndServe(":8080", nil)
}
EOF

cat <<EOF > Dockerfile
FROM golang:1.20
WORKDIR /app
COPY main.go .
RUN go build -o server main.go
CMD ["./server"]
EOF

#----12
mkdir -p /opt/course/12/app
cd /opt/course/12/app
cat <<EOF > app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from Flask!"
EOF

cat <<EOF > Dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY app.py .
RUN pip install flask
CMD ["python", "app.py"]
EOF

#----13
mkdir -p /opt/course/13/node-app
cd /opt/course/13/node-app
cat <<EOF > index.js
const http = require('http');

const server = http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello from Node.js inside Docker!\n');
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
EOF

cat <<EOF > package.json
{
  "name": "node-docker-app",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  }
}
EOF

cat <<EOF > Dockerfile
# Base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy files
COPY package*.json ./
RUN npm install

COPY . .

# Expose port and start app
EXPOSE 3000
CMD ["npm", "start"]
EOF

#----14
mkdir -p /opt/course/14/app
cd /opt/course/14/app
cat <<EOF > HelloWorld.java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello from Java!");
    }
}
EOF

cat <<EOF > Dockerfile
FROM openjdk:17
COPY HelloWorld.java .
RUN javac HelloWorld.java
CMD ["java", "HelloWorld"]
EOF

#----15
mkdir -p /opt/course/15/app
cd /opt/course/15/app
cat <<EOF > main.go
package main
import (
    "fmt"
    "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, "Hello from Go!")
}

func main() {
    http.HandleFunc("/", handler)
    http.ListenAndServe(":8080", nil)
}
EOF

cat <<EOF > Dockerfile
FROM golang:1.20
WORKDIR /app
COPY main.go .
RUN go build -o server main.go
CMD ["./server"]
EOF

#----16
mkdir -p /opt/course/16/app
cd /opt/course/16/app
cat <<EOF > hello.sh
#!/bin/bash
echo "Hello, World from Bash in Docker!"
EOF
chmod +x hello.sh
cat <<EOF > Dockerfile
# Use a minimal base image
FROM alpine:3.18

# Set working directory
WORKDIR /app

# Copy the script into the container
COPY hello.sh .

# Make sure it has execute permissions
RUN chmod +x hello.sh

# Run the script
CMD ["./hello.sh"]
EOF

#----17
mkdir -p /opt/course/17/app
cd /opt/course/17/app
cat <<EOF > app.sh
#!/bin/sh
echo "Environment is: $APP_ENV"
tail -f /dev/null
EOF
chmod +x app.sh
cat <<EOF > Dockerfile
# Base image
FROM alpine:3.18

# Accept a build argument with default
ARG APP_ENV=production

# Set environment variable from build arg
ENV APP_ENV=$APP_ENV

# Copy app
COPY app.sh /app.sh
RUN chmod +x /app.sh

CMD ["/app.sh"]
EOF

#----18
mkdir -p /opt/course/18/app
cd /opt/course/18/app
cat <<EOF > config.json
{
  "appName": "ConfigApp",
  "version": "1.0.0"
}

EOF
cat <<EOF > app.sh
#!/bin/sh

echo "Reading config from /app/config/config.json..."
if [ -f /app/config/config.json ]; then
  cat /app/config/config.json
  echo "✅ Config loaded successfully"
else
  echo "❌ config.json not found!"
  exit 1
fi
# Keep the container running for observation
tail -f /dev/null
EOF
chmod +x app.sh
cat <<EOF > Dockerfile
FROM alpine:3.18

# Install minimal tools
RUN apk add --no-cache jq

# Set work directory
WORKDIR /app

# Copy script only (config will be mounted later)
COPY app.sh .

RUN chmod +x app.sh

CMD ["./app.sh"]
EOF

#----19
mkdir -p /opt/course/19/app
cd /opt/course/19/app
cat <<EOF > app.sh
#!/bin/sh
echo "🟢 resource-app started"
echo "🧠 Memory limit test: Checking /sys/fs/cgroup/memory/memory.limit_in_bytes"
cat /sys/fs/cgroup/memory/memory.limit_in_bytes 2>/dev/null || echo "Memory limit not available"
echo "🧮 CPU quota: $(cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us 2>/dev/null)"
tail -f /dev/null
EOF
chmod +x app.sh
cat <<EOF > Dockerfile
FROM alpine:3.18

WORKDIR /app

COPY app.sh .
RUN chmod +x app.sh

CMD ["./app.sh"]
EOF

#----20
mkdir -p /opt/course/20/app
cd /opt/course/20/app
cat <<EOF > app.sh
#!/bin/sh

echo "Starting crash-app..."
# Intentional error: command not found
bad_command_that_does_not_exist
EOF
chmod +x app.sh
cat <<EOF > Dockerfile
FROM alpine:3.18

WORKDIR /app

COPY app.sh .
RUN chmod +x app.sh

CMD ["./app.sh"]
EOF
