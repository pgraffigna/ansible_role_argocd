#!/bin/bash
# script para instalar argoCD e iniciar el dashboard

#Colores
greenColour="\e[0;32m\033[1m"
redColour="\e[0;31m\033[1m"
yellowColour="\e[0;33m\033[1m"
blueColour="\e[0;34m\033[1m"
purpleColour="\e[0;35m\033[1m"
endColour="\033[0m\e[0m"

#CTRL-C
trap ctrl_c INT
function ctrl_c(){
        echo -e "\n${redColour}Programa Terminado ${endColour}"
        exit 0
}

REPO=https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo -e "\n${yellowColour}Activando Ingress ${endColour}"
minikube addons enable ingress

echo -e "\n${yellowColour}Creando el namespace ${endColour}"
kubectl create namespace argocd

echo -e "\n${yellowColour}Instalando argo ${endColour}"
kubectl apply -n argocd -f "$REPO"

echo -e "\n${yellowColour}Esperando que terminen de levantar los pods ${endColour}"
export POD=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)
while [[ $(kubectl -n argocd get pods "$POD" -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo -e "${purpleColour}Esperando a los pods ${endColour}" && sleep 10; done

echo -e "\n${blueColour} ------ Para acceder al dashboard usar las siguientes credenciales...usuario:admin, pass:$POD ------${endColour}"

echo -e "\n${greenColour}Iniciando el dashboard ${endColour}"
kubectl port-forward svc/argocd-server -n argocd --address 0.0.0.0 8080:443


