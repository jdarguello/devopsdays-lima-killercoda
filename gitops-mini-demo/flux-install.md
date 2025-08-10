## Instalación de FluxCD

Lo primero que haremos será instalar FluxCD y relacionarlo con un repositorio GitHub, acorde a lo definido en la [documentación oficial](https://fluxcd.io/flux/installation/bootstrap/github/). 

### 1. Instalar el Flux CLI

El Flux CLI está disponible como un binario ejecutable. Sólo debemos ejecutar el siguiente comando:

````bash
curl -s https://fluxcd.io/install.sh | sudo bash
```{{exec}}

### 2. Flux Bootstrap

Flux CLI contiene un comando con el que podemos vincular cualquier repositorio. 