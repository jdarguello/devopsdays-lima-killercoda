#Obtener el cluster actual
export current_context=$(k config current-context)

#Cambio al cluster local
k config set-context kubernetes-admin@kubernetes

#Pod creation
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: backstage
  name: backstage
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backstage
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: backstage
    spec:
      containers:
      - image: ghcr.io/jdarguello/cloudmanager:0.11
        name: backstage
        ports:
        - name: http
          containerPort: 7007
        resources: {}
        env:
        - name: GITHUB_TOKEN
          valueFrom:
            secretKeyRef:
              name: backstage-secrets
              key: GITHUB_TOKEN
        - name: AUTH_GITHUB_CLIENT_ID
          valueFrom:
            secretKeyRef:
              name: backstage-secrets
              key: AUTH_GITHUB_CLIENT_ID
        - name: AUTH_GITHUB_CLIENT_SECRET
          valueFrom:
            secretKeyRef:
              name: backstage-secrets
              key: AUTH_GITHUB_CLIENT_SECRET
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
    app: backstage
  name: backstage
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 7007
  selector:
    app: backstage
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