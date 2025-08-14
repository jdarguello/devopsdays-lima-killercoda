## Platform-engineering con Backstage

En la presente sección, usaremos un IdP ("Internal Developer Platform"_) con Backstage para la gestión de nuevos microservicios. Backstage se configurará de manera automática mientras lees estas instrucciones. 

__Nota:__ si deseas saber si Backstage ya está listo para ser utilizado, sólo debes ejecutar el siguiente comando y ver si el estado del pod está en __running__.

```bash
export current_context=$(k config current-context)
k config set-context kubernetes-admin@kubernetes
k get pods
k config set-context $current_context
```{{exec}}

### 1. Abrir Backstage


