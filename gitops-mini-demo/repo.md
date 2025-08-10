## Repositorio GitHub

Antes de entrar al detalle técnico, debemos crear un repositorio en GitHub y adecuarlo para poder integrarlo con nuestro clúster de K8s.

### 1. Creación del repo

El repositorio lo podemos crear de forma genérica. A modo de ejemplo, podríamos crearlo con la información mostrada en la Figura 1.

![](./images/repo.png)

Figura 1. Metadata del repo a crear.

### 2. Credenciales de GitHub

Como vamos a relacionar un repositorio GitHub con nuestro clúster, lo primero que necesitamos es un token válido con nuestras credenciales para que el clúster pueda acceder a la información contenida en el repo y definir el __estado deseado__ que genere el proceso de _reconciliación_ respecto al estado actual de nuestra infraestructura.

Una vez tengamos el token generado, lo almacenamos en un environment variable ejecutando el siguiente comando y reemplazando el `<gh-token>` por el token generado.

```bash
export GITHUB_TOKEN=<gh-token>
```{{copy}}

Para las automatizaciones consecuentes, necesitarás registrar tu usuario de GitHub de la siguiente forma:

```bash
export GITHUB_USERNAME=<gh-username>
```{{copy}}


## 3. Adecuación del repo

Ahora, para poder configurar Flux en nuestro proyecto debemos hacer una breve adecuación. 

Empezaremos por clonarlo con las credenciales de GitHub para poder realizar algunos cambios en el repo.

```bash
git clone https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/flux-demo
```{{exec}}

La idea es habilitar la siguiente estructura de carpetas:

```text
infra/
  ├── gitops/
  |     ├── gotk-components.yaml
  |     ├── gotk-sync.yaml
  |     ├── kustomization.yaml
```

Tanto `gotk-components.yaml` como `gotk-sync.yaml` son archivos informativos dentro del proceso de adecuación de Flux (también conocido como [Bootstrap](https://fluxcd.io/flux/installation/bootstrap/)). 

Sólo el `kustomization.yaml` nos interesará de aquí en adelante; ya que dentro de este archivo será donde relacionemos __todos__ los manifiestos que deseamos que se desplieguen, de forma automática, con nuestro agente GitOps.

#### 3.1. Adecuación de carpetas

Como vimos en la estructura propuesta, necesitamos crear dos carpetas: `infra` y `gitops` dentro de ella. Podemos hacerlo ejecutando el siguiente comando:

```bash
cd flux-demo
mkdir infra
cd infra
mkdir gitops
cd gitops
```{{copy}}

#### 3.2. Archivos de referencia

Como se mencionó al principio, Flux necesita dos archivos vaciós de referencia para configurar nuestro repo. Simplemente necesitamos ejecutar los siguientes comandos:

```bash
touch gotk-components.yaml
touch gotk-sync.yaml
```{{copy}}

### 3.3. `kustomization.yaml`

El archivo más importante para nosotros de aquí en adelante será `kustomization.yaml`. En este archivo, relacionaremos todos los manifiestos de la infraestructura que deseamos desplegar con GitOps. En un principio, será una lista vacía, pero veremos más adelante cómo configurarlo con Flux de manera declarativa.

Para adecuarlo dentro de nuestro proyecto, sólo necesitamos ejecutar el siguiente comando:

```bash
vim kustomization.yaml
```{{exec}}

Esto nos abrirá un editor de texto. Sólo debemos pegar y guardar el siguiente contenido:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources: []
```{{copy}}

#### 3.4. Subir cambios (push)

Ahora, sólo debemos guardar los cambios en el repositorio:

```bash
cd ~/flux-demo
git add .
git commit -m "adecuación del repositorio - gitops"
git config --global user.email "$GITHUB_USERNAME"
git config --global user.name "$GITHUB_USERNAME"
git branch -M main
git push -u origin main
```{{exec}}
