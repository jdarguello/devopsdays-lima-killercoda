# Introducción

En el presente demo, configuraremos un flujo de negocio de cuentas bancarias que pertence al ecosistema de un banco.

Para ello, crearemos tres microservicios:

1. _Micro Auth_: para gestión de protocolos de autenticación. Usaremos un enfoque de despliegue __manual__ desde el repositorio.
2. _Micro Cuentas_: gestión de cuentas bancarias de los clientes. Usaremos un __Custom CLI__, creado con _Devbox_ y _Nushell_.
3. _Micro Inversiones_: gestion de inversiones virtuales (CDTs). Usaremos __Backstage__ para la creación del microservicio.