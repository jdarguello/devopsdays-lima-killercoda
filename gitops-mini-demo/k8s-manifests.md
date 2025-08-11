## Desplegando artefactos de K8s

Llegados a este punto, ya tenemos nuestro repositorio listo y vinculado con nuestro clúster. Ahora, veremos un par de ejemplos para desplegar un `pod` y un `deployment` en nuestro clúster a través de nuestro repositorio GitHub de forma declarativa.

En esta sección, se recomienda usar el __editor__ habilitado con VSCode para facilitar la experiencia. __Nota:__ como no contamos (en este demo en específico) con imágenes pre-definidas, haremos nuestras pruebas con una imagen Docker genérica: __`nginx`__.

### 1. Adecuación del proyecto

Antes de iniciar a definir nuestros recursos de infraestructura, vamos a redefinir la estructura de nuestro proyecto de la siguiente forma:

```text
infra/
  ├── gitops/
  |     ├── gotk-components.yaml
  |     ├── gotk-sync.yaml
  |     ├── kustomization.yaml
  ├── frontend/
  |     ├── kustomization.yaml
  |     ├── frontend-pod.yaml
  ├── backend/
  |     ├── kustomization.yaml
  |     ├── auth-deploy.yaml
  |     ├── auth-service.yaml
README.md
LICENSE
```

Como se aprecia, se propone reajustar la estructura para incluir un desarrollo `frontend` y otro `backend`. Sin embargo, para hacer efectivo los cambios y que el agente GitOps pueda reconocerlos, debemos registrarlos en __`infra/gitops/kustomization.yaml`__ de la siguiente forma:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources: 
- ../frontend/
- ../backend
```{{copy}}

Para los desarrollos `frontend` y `backend`, basta en este punto con crear los manifiestos de K8s vacíos. En las secciones posteriores, analizaremos en detalle qué debe incluir cada uno. Esta estructura se puede crear ejecutando los siguientes comandos.

```bash
cd ~/flux-demo/infra
mkdir frontend
cd frontend/
touch kustomization.yaml
touch frontend-pod.yaml
cd ..
mkdir backend
cd backend/
touch kustomization.yaml
touch auth-deploy.yaml
touch auth-service.yaml
cd ~/flux-demo
```{{copy}}

### 2. Despliegue del `frontend-pod`

Iniciaremos definiendo el el `kustomization.yaml` ubicado en __`infra/frontend`__. Este archivo debe declarar los manifiestos de K8s que deseamos sean desplegados via GitOps; y esto lo podemos conseguir de la siguiente manera:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources: 
- frontend-pod.yaml
```{{copy}}

Ahora, desplegaremos nuestro primer pod de prueba definido de forma declarativa en nuestro repo de pruebas, añadiendo el siguiente contenido en el `frontend-pod.yaml`.

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: frontend
  name: frontend
spec:
  containers:
  - image: nginx
    name: frontend
```{{copy}}

#### 2.1. Subida de cambios

En este punto, podemos empezar a hacer trazabilidad de los cambios. Sólo debemos hacer `push` de lo que llevamos hasta ahora ejecutando los siguientes comandos:

```bash
cd ~/flux-demo
git add .
git commit -m "definición de desarrollo frontend"
git push
```{{exec}}

En teoría, si ejecutamos `k get pods`{{copy}} deberíamos ser capaces de ver el pod que acabamos de definir y subir al repo. Si todavía no está disponible, significa que FluxCD aún no ha hecho el proceso de reconciliación (proceso que lleva a cabo cada 5 minutos). Es posible forzar a Flux a realizar dicho proceso ejecutando el siguiente comando:

```bash
flux reconcile source git flux-system -n flux-system
```{{copy}}

### 3. Desarrollo backend

Para el desarrollo backend, vamos a craer un `deployment` y desplegarlo con un `service`. Para este caso, supondremos que se trata de un microservicio de autenticación/autorización (auth). 

De manera similar al frontend, empezaremos por definir el `kustomization.yaml` para declarar los manifiestos de K8s que deseamos desplegar con GitOps.

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources: 
- auth-deploy.yaml
- auth-service.yaml
```{{copy}}

Ahora, definiremos el `deployment`, modificando el archivo __`auth-deploy.yaml`__ de la siguiente forma:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: auth-micro
  name: auth-micro
spec:
  replicas: 2
  selector:
    matchLabels:
      app: auth-micro
  template:
    metadata:
      labels:
        app: auth-micro
    spec:
      containers:
      - image: nginx
        name: nginx
```{{copy}}

Para el `service`, modificaremos el archivo __`auth-service.yaml`__ de la siguiente forma:

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: auth-micro
  name: auth-micro
  namespace: default
spec:
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    app: auth-micro
  sessionAffinity: None
  type: ClusterIP
```{{copy}}

#### 3.1. Subida de cambios

En este punto, podemos empezar a hacer trazabilidad de los cambios. Sólo debemos hacer `push` de lo que llevamos hasta ahora ejecutando los siguientes comandos:

```bash
cd ~/flux-demo
git add .
git commit -m "definición de desarrollo backend"
git push
```{{exec}}

En teoría, si ejecutamos `k get all`{{copy}} deberíamos ser capaces de ver los pods, deployments y services que acabamos de definir y subir al repo. Si todavía no están disponibles, significa que FluxCD aún no ha hecho el proceso de reconciliación (proceso que lleva a cabo cada 5 minutos). Es posible forzar a Flux a realizar dicho proceso ejecutando el siguiente comando:

```bash
flux reconcile source git flux-system -n flux-system
```{{copy}}