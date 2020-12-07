# ansible_role_argocd

Playbook role para crear un cluster kubernetes local con minikube + instalación de argo para continuos deployment.

Testeado con Vagrant + Virtualbox

roles:
- docker	
- kubectl
- minikube 

script:
- 01-argo_dash
