## Acceso a clúster en EKS

Las definiciones GitOps que trabajaremos a continuación están en clúster de K8s expuestas en AWS EKS. Para ello, necesitaremos las credenciales de las cuentas de AWS enviadas vía correo electrónico.

Para la conexión, deberemos ejecutar el siguiente comando:

```bash
aws configure
```{{exec}}

La terminal pedirá las credenciales de AWS en formato `AWS Access Key ID` y el `AWS Secret Access Key` que podrás obtener desde el correo electrónico compartido. También, te solicitará la región desde donde están configuradas las credenciales (`region`), la cual es: __`us-east-1`__. Finalmente, para el _output format_ puedes escoger `json`.

Una vez tengas configuradas las credenciales de conexión a AWS, podemos conectarnos al clúster de EKS ejecutando el siguiente comando:

```bash
aws eks update-kubeconfig --region us-east-1 --name Cuentas-Cluster
```{{copy}}

Si ejecuta de forma exitosa, de aquí en adelante todos los comandos de K8s que ejecutes serán contra el clúster de __Cuentas-Cluster__ en AWS EKS. Por ejemplo, deberías poder listar los namespaces de la cuenta sin problema con `k get ns`{{exec}}.