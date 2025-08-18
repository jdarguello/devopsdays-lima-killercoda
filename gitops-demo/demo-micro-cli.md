## Despliegue de microservicio vía Custom CLI

En la presente sección, desplegaremos el microservicio de cuentas vía __Custom CLI__. El CLI que usaremos a continuación ha sido construido con __Devbox__ y __Nushell__.

### 1. Instalación de pre-requisitos

Iniciaremos con la instalación de Devbox a través del siguiente comando:

```bash
curl -fsSL https://get.jetify.com/devbox | sudo bash
```

Instalaremos Nushell de la siguiente forma:

```bash
curl -fsSL https://apt.fury.io/nushell/gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/fury-nushell.gpg
echo "deb https://apt.fury.io/nushell/ /" | sudo tee /etc/apt/sources.list.d/fury.list
sudo apt update
sudo apt install nushell
```

### 2. Acceso a la CLI

Ahora, instalaremos las dependencias base de la CLI con Devbox, ejecutando el siguiente comando.

```bash
cd ~/CloudManager/platform-engineering/CLI/
devbox shell
```

Con ello, ya podemos acceder a la CLI ejecutando:

```bash
cd ~/CloudManager/platform-engineering/CLI/
nu
```

### 3. Creación del microservicio

Para crear el nuevo microservicio de cuentas bancarias, lo único que tendremos que hacer es ejecutar el siguiente comando:

```bash
bancli service back-db new --businessflow-name=Inversiones --micro-name=CuentasBancarias --image=nginx --replicas=2
```{{copy}}