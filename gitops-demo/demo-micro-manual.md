## Despliegue Manual

Iniciaremos la definición de nuestra línea de negocio al crear un microservicio de forma "manual". Es decir, simplemente definiremos los manifiestos necesarios para registrar el microservicio en el repositorio de nuestra línea de negocio.

### 1. Clonar repo

Para clonar el repo que te corresponde, sólo debes definirlo como variable de entorno copiando el siguiente comando.

```bash
export GITHUB_REPO=<tu_repo>
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



#### 2.1. Subir cambios

Finalmente, subimos los cambios ejecutando el siguiente comando:

```bash
cd ~/$GITHUB_REPO
git pull
git add .
git commit -m "micro de autenticación"
git push
```{{exec}}