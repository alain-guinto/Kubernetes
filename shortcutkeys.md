# Kubernets Command Aliases 
Customize your terminal during the exam
Run this command below to edit your shell config:
```bash
vi ~/.bashrc # or
vi ~/.bash_profile # or
vi ~/.bash_aliases
```
Then paste below aliases
```bash
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deployment'
alias kgn='kubectl get nodes'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias kaf='kubectl apply -f'
alias kex='kubectl exec -it'
alias kctx='kubectl config use-context'
alias kns='kubectl config set-context --current --namespace'
```
Then source the file
```bash
source ~/.bashrc
```
