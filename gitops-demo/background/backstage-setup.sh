pwd

#Obtener el cluster actual
export current_context=$(k config current-context)

#Cambio al cluster local
k config set-context kubernetes-admin@kubernetes

#Pod creation
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: backstage
  name: backstage
spec:
  containers:
  - image: ghcr.io/jdarguello/cloudmanager:0.3
    name: backstage
    ports:
    - name: http
      containerPort: 7007
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
EOF

#Svc creation
k create -f - << 'EOF'
apiVersion: v1
kind: Service
metadata:
  labels:
    run: backstage
  name: backstage
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 7007
  selector:
    run: backstage
status:
  loadBalancer: {}
EOF

#Ingress creation
k create -f - << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: backstage
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - backend:
          service:
            name: backstage
            port:
              number: 80
        path: /
        pathType: Prefix
status:
  loadBalancer: {}
EOF

#Retornar al cluster del usuario
k config set-context $current_context