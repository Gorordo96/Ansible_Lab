# Ansible Docker

## ¿De que se trata este repositorio?

Este proyecto tiene como finalidad proporcionar un entorno seguro y controlado sobre el cual se puedan realizar pruebas con ansible. Se utiliza docker tanto para el servidor de aprovisionamiento, como para el nodo gestionado, utilizando un red dedicada (192.168.100.0/24)

## Instalacion 

Ejecutar los siguientes comandos:

```
chmod u+x install.sh
./install.sh
```

Este script debe ejecutarse por unica vez cuando clone el repositorio. Para trabajar en instancias posteriores, solo debe ejecutar:

*Levantar estructura dockerizada*

``docker-compose up -d ``

*Frenar estructura dockerizada*

``docker-compose up down ``

## Ejecucion de pruebas

Una vez finalizada la instalacion, puede observar por medio de docker los nuevos contenedores:

```
docker ps
docker ps -f name="Ansible_Server"
docker ps -f name="Ansible_Node"
```
Para ejecutar una prueba sencilla, ingrese al contenedor **Ansible_Server** y cree un archivo de inventario **hosts.txt** como se indica a continuacion:

*Ingresar a Ansible_Server*

``docker exec -it Ansible_Server /bin/bash``

*Creacion de Inventario*

``cd /home/ansible-server``

``vim hosts.txt``

```
[node]
192.168.10.11
```

*Ejecucion de pruebas sencillas*

**Prueba - ping**

```
ansible node -i hosts.txt -m ping -u ansible-node --private-key /home/ansible-server/.ssh/id_rsa

192.168.10.11 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    }, 
    "changed": false, 
    "ping": "pong"
}

```

**Prueba - Comando bash remoto "df -h"**

```
ansible node -i hosts.txt -a 'df -h' -u ansible-node --private-key /home/ansible-server/.ssh/id_rsa
192.168.10.11 | CHANGED | rc=0 >>
Filesystem      Size  Used Avail Use% Mounted on
overlay          89G   64G   21G  76% /
tmpfs            64M     0   64M   0% /dev
tmpfs           2.9G     0  2.9G   0% /sys/fs/cgroup
shm              64M     0   64M   0% /dev/shm
/dev/sda7        89G   64G   21G  76% /etc/hosts
tmpfs           2.9G     0  2.9G   0% /proc/asound
tmpfs           2.9G     0  2.9G   0% /proc/acpi
tmpfs           2.9G     0  2.9G   0% /proc/scsi
tmpfs           2.9G     0  2.9G   0% /sys/firmware
```

**Prueba - Comando bash remoto "ls -la"**

```
ansible node -i hosts.txt -a 'ls -la' -u ansible-node --private-key /home/ansible-server/.ssh/id_rsa
192.168.10.11 | CHANGED | rc=0 >>
total 32
drwxr-xr-x 1 ansible-node ansible-node 4096 Mar  3 02:30 .
drwxr-xr-x 1 root         root         4096 Mar  3 02:21 ..
drwx------ 3 ansible-node ansible-node 4096 Mar  3 02:30 .ansible
-rw------- 1 ansible-node ansible-node   13 Mar  3 02:29 .bash_history
drwx------ 2 ansible-node ansible-node 4096 Mar  3 02:30 .cache
drwx------ 1 ansible-node ansible-node 4096 Mar  3 02:22 .ssh
-rw-r--r-- 1 ansible-node ansible-node    0 Mar  3 02:29 .sudo_as_admin_successful
```
**Prueba - Comando bash remoto "pwd"**

```
ansible node -i hosts.txt -a 'pwd' -u ansible-node --private-key /home/ansible-server/.ssh/id_rsa
192.168.10.11 | CHANGED | rc=0 >>
/home/ansible-node

```

## Ejecucion de pruebas con Playbook

Para ejecutar pruebas con ansible utilizando playbook, debe copiar los ficheros necesarios (playbook.yaml) al contenedor "Ansible_Server". 

``docker cp <<file>> Ansible_Server:/home/ansible-server/<<file>>``

Puedes guiarte de la siguiente documentacion: https://atareao.es/tutorial/ansible/playbooks-de-ansible/ 