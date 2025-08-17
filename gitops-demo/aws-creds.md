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



### 3. Acceso al EKS

Ya configuradas las credenciales de conexión a AWS, podemos conectarnos al clúster de EKS ejecutando el siguiente comando:

```bash
aws eks update-kubeconfig --region us-east-1 --name Cuentas-Cluster
```{{copy}}

Si ejecuta de forma exitosa, de aquí en adelante todos los comandos de K8s que ejecutes serán contra el clúster de __Cuentas-Cluster__ en AWS EKS. Por ejemplo, deberías poder listar los namespaces de la cuenta sin problema con `k get ns`{{exec}} y encontrar namesapces como `flux-system` o `crossplane-system`, que indican la instalación de estos componentes dentro del clúster.

### 4. Acceso a otros recursos

De aquí en adelante, tendremos acceso a la __consola de AWS__ para validar las operaciones que ejecutemos en nuestro paso a paso. Sólo tendremos que usar las credenciales recibidas, vía correo electrónico, para validar los recursos que se creen; principalmente: EKS, EC2 y RDS.
