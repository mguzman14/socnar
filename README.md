# SOCNAR

<div align="center">

[![Ansible](https://img.shields.io/badge/Deployment-Ansible-informational?style=flat&logo=ansible)](https://www.ansible.com/) [![Docker](https://img.shields.io/badge/Container%20Runtime-Docker-2496ED?style=flat&logo=docker&logoColor=white)](https://www.docker.com/)

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/mguzman14/socnar?color=green)](https://github.com/mguzman14/socnar/releases)

</div>

---

## Introducción

SOCNAR es un lab para el despligue automatizado de un SOC.


## Características

La arquitectura la conforman un conjunto de contenedores en una misma network y realizan tareas de recolección de eventos, gestión de alertas y obtención de activos de información.

Estos contenedores agrupados según la función que hacen en esta infrastructura:

- Monitorizar recursos de la máquina:
    - Portainer
    - Weavescope

- Personalizar DNS de los contenedores y filtrado de rastreadores:
    - Aguard

- Primera defensa:
    - Crowdsec: reporta alertas y hace de base de conocimiento de comportamientos raros.
    - Traefik: recibe peticiones HTTP/S y las dirige al servicio que toca. Hace un primer filtro con middlewares suyos (IpAllow) y con el Bouncer de Crowdsec. Este último es el que dice si esa IP entra o no entra según lo que diga Crowdsec.
    
- Centralizar y gestionar alertas:
    - Wazuh (los 3 contenedores del single-node deployment): mira los eventos (logs) de varios archivos del sistema y genera alertas. Previamente, se han tenido que configurar alertas y decirle qué archivos tiene que leer.

- Orquestración:
    - n8n: recibir alertas y realizar acciones. En este caso, enviar alerta por chat de Discord y generar IOC para MISP

- Base de datos de conocimiento sobre IOCs:
    - MISP: recibir IOCs basados en alertas recibidas a través de wazuh

- Web vulnerable
    - Juice-Shop: una web deliberadamente vulnerable para testear el funcionamiento de toda la infrastructura.



## Requisitos previos

- Tailscale
- Docker
- Ansible


## Estructura del repositorio

### Hosts (*inventory.yml*)
Es donde se guarda el nombre de los hosts y toma las variables del archivo `.env`. 

En el repo hay 2 hosts (`debian-whale` y `debian_shark`) que pertenecen a 2 grupos: `wazuh_manager` y `wazuh_agent`. Los nombres de debian-whale y debian-shark son inventados y se puede cambiar. Si cambias el nombre de los grupos de hosts, debes cambiar las referencias.

Si decides desplegar Wazuh con más de 1 manager, adapta las referencias del playbook.

### Roles
Hay 1 rol para cada servicio.


## Configuración

En la configuración intervienen 2 archivos:
- `.env`: contiene las variables de entorno. Hay un `.env.example` en la raíz del proyecto que puedes adaptar.
- `inventory.yml`: contiene el inventario de hosts para los que se ejecuta el playbook. También puedes ejecutar el playbook en tu máquina local si añades la variable `ansible_connection: local` (está comentada en inventory.yml).


## Guía de Uso

### 1. Instala Wazuh desde Docker

Ve al repo oficial e instala la versión `single-node`. 
> [!CAUTION]
> Tienes que ser ROOT y guardar el repo en un directorio de ROOT.

Si no eres *root*, en algún momento se romperá y no sabrás por qué...

```
git clone https://github.com/wazuh/wazuh-docker/tree/main/single-node

cd wazuh-docker/single-node

docker compose up -d
```
Antes de ejecutar el playbook, hay que hacer un par de cosas:

### 2. Prepara el entorno para lanzar Ansible

- Configura el archivo `inventory.yml` con los hosts que quieras.
- Configura el archivo `.env`. Si ejecutas el playbook desde un WSL, formatea el archivo `.env`:
```
dos2unix .env
```
- Exporta las variables de entorno (o añade este comando a la ejecución del playbook):
```
export $(xargs < .env)
```

### 3. Lanza Ansible

Se ejecuta el playbook *site.yml* pasándole los hosts del *inventory.yml*:
```
export $(xargs < .env) && ansible-playbook -i inventory.yml site.yml -K -l
```

#### Ejemplos
Mediante *tags* y hosts, aquí se muestran algunos ejemplos útiles que se pueden realizar:

- Levantar toda la infrastructura y configuración para todos los hosts indicados en el inventory.yml:
```
export $(xargs < .env) && ansible-playbook -i inventory.yml site.yml
```
- Levantar toda la infrastructura adecuada para el host "debian-whale". Esto incluye las tasks específicas de debian-whale y las tasks para todos los hosts:
```
export $(xargs < .env) && ansible-playbook -i inventory.yml site.yml -K -l debian-whale
```
- Desplegar un **agente de Wazuh** en el host "debian-whale":
```
export $(xargs < .env) && ansible-playbook -i inventory.yml site.yml -K -l wazuh_agents -t wazuh-agent
```
- Levantar **n8n** en el host "debian-whale":
```
export $(xargs < .env) && ansible-playbook -i inventory.yml site.yml -K -l debian-whale -t n8n
```
- Ejecutar **tests de validación** sobre el host "debian-whale" para verificar el funcionamiento de las herramientas:
```
export $(xargs < .env) && ansible-playbook -i inventory.yml site.yml -K -l debian-whale -t audit
```

## Roadmap ![GitHub issues](https://img.shields.io/github/issues/mguzman14/socnar)



En este enlace se irán añadiendo las próximas tareas: [projects/socnar-core](https://github.com/users/mguzman14/projects/2/views/1)

## Licencia

GNU GENERAL PUBLIC LICENSE