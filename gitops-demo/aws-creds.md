## Acceso a recursos de AWS

Las definiciones GitOps que trabajaremos a continuación están en clúster de K8s expuestas en AWS EKS. A partir de aquí, tendremos que tener acceso a la cuenta de AWS provista para sacarle el máximo provecho al presente demo.

### 1. Gestión de credenciales

Iniciaremos con configurar el CLI de AWS para permitir la gestión con el clúster de EKS. Para ello, ejecutaremos el siguiente comando:

```bash
aws configure
```

La terminal pedirá las credenciales de AWS en formato `AWS Access Key ID` y el `AWS Secret Access Key` que podrás obtener desde el correo electrónico compartido. También, te solicitará la región desde donde están configuradas las credenciales (`region`), la cual es: __`us-east-1`__. Finalmente, para el _output format_ puedes escoger `json`.

### 2. Configuración del _External-Secrets_

El __External-Secrets__ se trata de un operador de K8s que permite la ingesta de secretos dentro de un clúster, acorde a como se aprecia en la Figura 1.

![](https://external-secrets.io/latest/pictures/diagrams-high-level-simple.png)

Figura 1. Funcionamiento base del _External-Secrets_.

En este caso, lo usaremos para importar los secretos desplegados en AWS Secrets Manager para la configuración de Backstage, que usaremos más adelante.

#### 2.1. Credenciales de AWS como secretos de K8s

Para importar los secretos de AWS, primero necesitamos brindarle al controlador del _External-Secrets_ las credenciales de la cuenta de AWS para que pueda conectarse a ella e importar los otros secretos respectivos. Sólo debes reemplazar las credenciales de AWS en las secciones respectivas del siguiente comando y ejecutarlo.

```bash
k create secret generic awssm-secret --from-literal=access-key=<aws_access_key_id> --from-literal=secret-access-key=<aws_secret_access_key>
```{{copy}}

#### 2.2. Definición del `SecretStore`

El `SecretStore` se trata de un CRD (_"Custom-Resource Definition"_) en K8s empleado para configurar el controlador del _External-Secrets_ y que entienda a cuál cuenta de AWS debe conectarse para buscar los secretos.

```bash
k create -f - <<EOF
apiVersion: external-secrets.io/v1
kind: SecretStore
metadata:
  name: aws-secretstore
spec:
  provider:
    aws:
      service: SecretsManager
      region: us-east-1
      auth:
        secretRef:
          accessKeyIDSecretRef:
            name: awssm-secret
            key: access-key
          secretAccessKeySecretRef:
            name: awssm-secret
            key: secret-access-key
EOF
```{{exec}}

#### 2.3. Vinculación de secretos via `ExternalSecret`

Finalmente, procedemos a obtener los secretos desde el AWS Secrets Manager ejecutando:

```bash
k create -f - << EOF
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: github-external-secrets
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secretstore
    kind: SecretStore
  target:
    name: github-secrets
    creationPolicy: Owner
  dataFrom:
  - extract:
      key: github-creds
EOF
```{{exec}}

### 3. Acceso al EKS

Ya configuradas las credenciales de conexión a AWS, podemos conectarnos al clúster de EKS ejecutando el siguiente comando:

```bash
aws eks update-kubeconfig --region us-east-1 --name Cuentas-Cluster
```{{copy}}

Si ejecuta de forma exitosa, de aquí en adelante todos los comandos de K8s que ejecutes serán contra el clúster de __Cuentas-Cluster__ en AWS EKS. Por ejemplo, deberías poder listar los namespaces de la cuenta sin problema con `k get ns`{{exec}} y encontrar namesapces como `flux-system` o `crossplane-system`, que indican la instalación de estos componentes dentro del clúster.

### 4. Acceso a otros recursos

De aquí en adelante, tendremos acceso a la __consola de AWS__ para validar las operaciones que ejecutemos en nuestro paso a paso. Sólo tendremos que usar las credenciales recibidas, vía correo electrónico, para validar los recursos que se creen; principalmente: EKS, EC2 y RDS.
