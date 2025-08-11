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
mkdir backend
cd ../backend/
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

### 3. Desarrollo backend

Para el desarrollo backend