## Platform-engineering con Backstage

En la presente sección, usaremos un IdP ("Internal Developer Platform"_) basado en Backstage para la gestión de nuevos microservicios. Backstage se configurará de manera automática mientras lees estas instrucciones. 

__Nota:__ si deseas saber si Backstage ya está listo para ser utilizado, sólo debes ejecutar el siguiente comando y ver si el estado del pod está en __running__.

```bash
export current_context=$(k config current-context)
k config set-context kubernetes-admin@kubernetes
k get pods
k config set-context $current_context
```
{{exec}}

### 1. Abrir Backstage

Primero, debemos averiguar cuál es el puerto expuesto por el _ingress controller_ (Nginx). Este puerto varía de una sesión a otra, por lo que deberás averiguarlo ejecutando el siguiente comando (el resultado está expuesto en __Puerto = <node_port>__).

```bash
export current_context=$(k config current-context)
k config set-context kubernetes-admin@kubernetes
export node_port=$(k get -n ingress-nginx svc/ingress-nginx-controller -o jsonpath="{.spec.ports[0].nodePort}")
echo "Puerto = $node_port"
k config set-context $current_context
```
{{exec}}

Para abrir Backstage, debemos ir a la sección de configuración de __"Traffic / Ports"__ que puedes acceder haciendo click aquí: {{TRAFFIC_SELECTOR}}.

Una vez hagas click en esa opción, te abrirá la ventana de la Figura 2. Lo único que debes hacer es pegar el puerto, obtenido al principio de este capítulo, en la sección de __Custom Ports__ y dar click en _Access_. Con ello, te abrirá la aplicación de Backstage.

[](./images/traffic.png)

Figura 2. Configuración del puerto de acceso.

### 2. Interacción con Backstage

En este punto, ya tienes acceso a Backstage y puedes interactuar con la plataforma a voluntad. La recomendación es que te enfoques en la edición de los templates expuestos para la creación del microservicio.
