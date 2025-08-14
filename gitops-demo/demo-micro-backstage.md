## Platform-engineering con Backstage

En la presente sección, usaremos un IdP ("Internal Developer Platform"_) basado en Backstage para la gestión de nuevos microservicios. Backstage se configurará de manera automática mientras lees estas instrucciones. 

__Nota:__ si deseas saber si Backstage ya está listo para ser utilizado, sólo debes ejecutar el siguiente comando y ver si el estado del pod está en __running__.

```bash
export current_context=$(k config current-context)
k config set-context kubernetes-admin@kubernetes
k get pods
k config set-context $current_context
```{{exec}}

### 1. Abrir Backstage

Primero, debemos averiguar cuál es el puerto expuesto por el _ingress controller_ (Nginx). Este puerto varía de una sesión a otra, por lo que deberás averiguarlo ejecutando el siguiente comando.

```bash
export current_context=$(k config current-context)
k config set-context kubernetes-admin@kubernetes
export node_port=$(k get -n ingress-nginx svc/ingress-nginx-controller -o jsonpath="{.spec.ports[0].nodePort}")
echo "Puerto = $node_port"
k config set-context $current_context
```{{exec}}

Para abrir Backstage, debes abrir la opción de __"Traffic / Ports"__ en la sección de configuración, como se muestra en la Figura 1.

[](https://killercoda.com/assets/network-traffic-CK8NkBtY.png)

Figura 1. 
