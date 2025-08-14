pwd

#Obtener el cluster actual
export current_context=$(k config current-context)

#Cambio al cluster local
k config set-context kubernetes-admin@kubernetes

#Pod, svc and ingress creation
k create -f k8s/pod.yaml
k create -f k8s/svc.yaml
k create -f k8s/ingress.yaml

#Retornar al cluster del usuario
k config set-context $current_context