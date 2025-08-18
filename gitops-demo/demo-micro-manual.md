## Despliegue Manual

Iniciaremos la definición de nuestra línea de negocio al crear un microservicio de forma "manual". Es decir, simplemente definiremos los manifiestos necesarios para registrar el microservicio en el repositorio de nuestra línea de negocio.

### 1. Clonar repo

Para clonar el repo que te corresponde, sólo debes definirlo como variable de entorno copiando el siguiente comando.

```bash
export GITHUB_REPO=<repo_businessflow>
```{{copy}}

Ahora, procedemos a clonarlo a través del siguiente comando.

```bash
export current_context=$(k config current-context)
k config set-context kubernetes-admin@kubernetes

export GITHUB_USERNAME="lima-demos-days"
export GITHUB_TOKEN=$(k get secrets backstage-secrets -o jsonpath="{.data.GITHUB_TOKEN}" | base64 -d) 
git clone https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$GITHUB_REPO

k config set-context $current_context
```{{exec}}

### 2. Manifiestos de K8s

Para la creación del microservicio, disponemos de un CRD (_"Custom-Reource Definition"_) de K8s habilitado con Crossplane. Este CRD creará un `deployment`, un `service` y una AWS RDS con PostgreSQL por nostros. Toda esta lógica está abstraida a través de objetos tipo `Micro`.

Para definir nuestro microservicio, sólo debemos crear el siguiente manifiesto de K8s.

```yaml
apiVersion: bancolombia.businessflows/v1
kind: Micro
metadata:
  namespace: auth
  name: auth-backdb
spec:
  image: nginx
  replicas: 2
  aws-resources:
    region: us-east-1
    db-name: authbackdb
```{{copy}}


#### 2.1. Estructura de un Flujo de Negocio

Ahora que sabemos cómo es el manifiesto principal que debemos crear, es importante conocer también la estructura base de un flujo de negocio (_businessflow_). 

```text
<repo>/
  ├── infra/
  |     ├── gitops/
  |     ├── kubernetes/
  |     |       ├── auth/
  |     |       |   ├── ns.yaml
  |     |       |   ├── micro.yaml
  |     |       |   ├── kustomization.yaml
  |     |       ├── README.md
  |     |       ├── kustomization.yaml       
  |     ├── platform-engineering/
LICENSE
README.md
```

* `infra`: carpeta que contiene todas las definiciones dinámicas de infraestructura. 
* `gitops`: configuraciones base de FluxCD.
* `kubernetes`: habilita configuraciones manuales de despliegue mediante manifiestos de K8s. __Aquí__ es donde desplegaremos nuestro Micro de Auth.
* `platform-engineering`: contiene las configuraciones ejecutadas desde el _Custom CLI_ y _Backstage_.

Para el despliegue de nuestro microservicio, empezaremos por crear la carpeta `auth` en la dirección mostrada. Luego, modificaremos el `infra/kubernetes/kustomization.yaml` para agregar el nuevo micro, así:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- auth/     #<- registro del micro 'auth'
```{{copy}}

Luego, procederemos a registrar los manifiestos en el `infra/kubernetes/auth/kustomization.yaml` de la siguiente forma:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- ns.yaml
- auth.yaml
```{{copy}}

Después, procederemos a crear el namespace de nuestro micro (`infra/kubernetes/auth/ns.yaml`):

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: auth
spec: {}
status: {}
```{{copy}}

Finalmente, definimos el microservicio en `infra/kubernetes/auth/micro.yaml`:

```yaml
apiVersion: bancolombia.businessflows/v1
kind: Micro
metadata:
  namespace: auth
  name: auth-backdb
spec:
  image: nginx
  replicas: 2
  aws-resources:
    region: us-east-1
    db-name: authbackdb
```{{copy}}


#### 2.2. Subir cambios

Una vez agregado el microservicio, procedemos a subir los cambios ejecutando el siguiente comando:

```bash
cd ~/$GITHUB_REPO
git pull
git add .
git commit -m "micro de autenticación"
git push
```{{exec}}