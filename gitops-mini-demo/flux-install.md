## Instalación de FluxCD

En este punto,ya tenemos nuestro repositorio listo. A continuación, instalaremos Flux CLI para relacionar nuestro clúster de K8s con el repositorio GitHub, acorde a lo definido en la [documentación oficial](https://fluxcd.io/flux/installation/bootstrap/github/). 

### 1. Instalar Flux CLI

El Flux CLI está disponible como un binario que podemos instalar ejecutando el siguiente comando:

```bash
curl -s https://fluxcd.io/install.sh | sudo bash
```{{exec}}

### 2. Flux Bootstrap

Flux CLI contiene un comando con el que podemos vincular cualquier repositorio con nuestro clúster. Para nuestra demo, podremos vincular el repositorio que gestionamos (`flux-demo`) a través del siguiente comando:

```bash
flux bootstrap github \
  --token-auth \
  --owner=$GITHUB_USERNAME \
  --repository=flux-demo \
  --branch=main \
  --path=infra/gitops \
  --personal
```{{copy}}

Esperamos a que finalice la reconciliación. Si finalizó de manera exitosa, nos aparecerá el mensaje `✔ all components are healthy`. Adicional, si ejecutas `k get ns`{{exec}} deberías ver un namespace de K8s con el nombre: `flux-system`.

En este punto, ya tenemos sincronizado nuestro clúster con el repositorio GitHub que bautizamos como __`flux-demo`__ ✌🏻