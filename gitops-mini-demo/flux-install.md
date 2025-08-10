## Instalación de FluxCD

Lo primero que haremos será instalar FluxCD y relacionarlo con un repositorio GitHub, acorde a lo definido en la [documentación oficial](https://fluxcd.io/flux/installation/bootstrap/github/). 

### 1. Instalar el Flux CLI

El Flux CLI está disponible como un binario ejecutable. Sólo debemos ejecutar el siguiente comando:

```bash
curl -s https://fluxcd.io/install.sh | sudo bash
```{{exec}}

### 2. Flux Bootstrap

Flux CLI contiene un comando con el que podemos vincular cualquier repositorio para vincularlo al clúster. Para nuestra demo, podremos vincular el repositorio que gestionamos (`flux-demo`) ejecutando el siguiente comando:

```bash
flux bootstrap github \
  --token-auth \
  --owner=$GITHUB_USERNAME \
  --repository=flux-demo \
  --branch=main \
  --path=infra/gitops \
  --personal
```{{copy}}

