# Kubernets Command Aliases 
Customize your terminal during the exam,
run below command to edit your shell config:
```bash
vi ~/.bashrc # or
vi ~/.bash_profile # or
vi ~/.bash_aliases
```
Then paste below aliases
```bash
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgd='kubectl get deployment'
alias kgs='kubectl get svc'
alias kgrs='kubectl get rs'
alias kgn='kubectl get nodes'
alias kgcm='kubectl get configmap'
alias kgsec='kubectl get secret'
alias kgj='kubectl get job'
alias kgcj='kubectl get cj'        # cronjob
alias kgsa='kubectl get sa'
alias kgnp='kubectl get netpol'    # network polocy
alias kgpv='kubectl get pv'        # persistent volume
alias kgpvc='kubectl get pvc'      # persistent volume claim
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias kaf='kubectl apply -f'
alias kexp='kubectl explain'
alias kex='kubectl exec -it'
alias kctx='kubectl config use-context'
alias kns='kubectl config set-context --current --namespace'
```
Then source the file
```bash
source ~/.bashrc
```
