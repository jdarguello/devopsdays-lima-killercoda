## Platform-engineering con Backstage

En la presente sección, usaremos un IdP ("Internal Developer Platform"_) basado en Backstage para la gestión de nuevos microservicios. Backstage se configurará de manera automática mientras lees estas instrucciones. 

__Nota:__ si deseas saber si Backstage ya está listo para ser utilizado, sólo debes ejecutar el siguiente comando y ver si el estado del pod está en __running__.

```bash
export current_context=$(kubectl config current-context)
kubectl config use-context kubernetes-admin@kubernetes
kubectl get pods
kubectl config use-context $current_context
```{{exec}}

### 1. Abrir Backstage

Primero, debemos averiguar cuál es el puerto expuesto por el _ingress controller_ (Nginx). Este puerto varía de una sesión a otra, por lo que deberás averiguarlo ejecutando el siguiente comando (el resultado está expuesto en __Puerto = <node_port>__).

```bash
export current_context=$(kubectl config current-context)
kubectl config use-context kubernetes-admin@kubernetes
export node_port=$(kubectl get -n ingress-nginx svc/ingress-nginx-controller -o jsonpath="{.spec.ports[0].nodePort}")
echo "Puerto = $node_port"
kubectl config use-context $current_context
```{{exec}}

Para abrir Backstage, debemos ir a la sección de configuración de __"Traffic / Ports"__ que puedes acceder haciendo click aquí: {{TRAFFIC_SELECTOR}}.

Ahora, lo único que debes hacer es pegar el puerto, obtenido al principio de este capítulo, en la sección de __Custom Ports__ y dar click en _Access_. Con ello, te abrirá la aplicación de Backstage.

### 2. Interacción con Backstage

En este punto, ya tienes acceso a Backstage y puedes interactuar con la plataforma a voluntad. La recomendación es que te enfoques en la edición de los templates expuestos para la creación del microservicio, a través del tempalte __"Service Back DB"__, que habilitaría la generación de un `deployment`, un `service` y una AWS RDS con PostgreSQL.

Otra opción a la que también tienes acceso es a la de generar un nuevo flujo de negocio (a través del template: _"Flujo de Negocio"_). Sin embargo, te recomiendo usar la primera opción y familiarizarte con ella primero antes de adentrarte con esta alternativa.

Independientemente de la opción que prefieras, para que se ejecute correctamente, tendrás que compartirle las credenciales de AWS y de GitHub para que funcione correctamente. Esas credenciales ya fueron configuradas en la primera sección de este demo y puedes obtener esa información ejecutando el siguiente comando:

```bash
export current_context=$(kubectl config current-context)
kubectl config use-context kubernetes-admin@kubernetes
kubectl get secrets backstage-secrets -o jsonpath="{.data}" | jq 'walk(
  if type == "string" then
    try (. | @base64d) catch .
  else .
  end
)'
kubectl get secrets awssm-secret -o jsonpath="{.data}" | jq 'walk(
  if type == "string" then
    try (. | @base64d) catch .
  else .
  end
)'
kubectl config use-context $current_context
```{{exec}}


