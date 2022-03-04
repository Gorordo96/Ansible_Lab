#!/bin/bash

# ===================== DEFINE VARIABLE =============================================
DIR_SERVER=$(pwd)/Ansible_Server
DIR_NODE=$(pwd)/Ansible_Node
PUBLIC_KEY=$DIR_SERVER/keys/id_rsa.pub
PRIVATE_KEY=$DIR_SERVER/keys/id_rsa

# ===================== CREATE KEY TO ACCESS WITH ANSIBLE ===========================

if [ ! -d "$DIR_SERVER/keys" ]; then
    echo "$(date) -- Create folder $DIR_SERVER/keys"
    mkdir "$DIR_SERVER/keys"
    echo "$(date) -- key generation"
    ssh-keygen -t rsa -N '' -f "$PRIVATE_KEY" <<< y
else
    if [ ! -f "$PUBLIC_KEY" ] || [ ! -f "$PRIVATE_KEY" ] ; then
        echo "$(date) -- You have problem with keys"
        rm "$PUBLIC_KEY" && echo "$(date) -- the public key has been deleted.." || echo "$(date) -- the public key cannot be deleted.."
        rm "$PRIVATE_KEY" && echo "$(date) -- the private key has been deleted.." || echo "$(date) -- the private key cannot be deleted.."
        echo "$(date) -- key generation"
        ssh-keygen -t rsa -N '' -f "$PRIVATE_KEY" <<< y
        else
        echo "$(date) -- You dont have problem with keys..."
    fi
fi

echo "$(date) -- Create a authorized_key in $DIR_NODE"
echo "#Ansible Server" > "$DIR_NODE"/authorized_key
cat "$PUBLIC_KEY" >> "$DIR_NODE"/authorized_key

# ==================================== RUN DOCKER =====================================
echo "$(date) -- Run docker-compose ..."
docker-compose up -d --build
echo "$(date) -- List of containers ..."
docker ps -f name=Ansible_Server
docker ps -f name=Ansible_Node

# ==================================== SUGGESTIONS =====================================
echo "$(date) -- if you want to access the ansible Server:"
echo "$(date) -- command: docker exec -it Ansible_Server /bin/bash"
echo "$(date) -- if you want to access the ansible Node:"
echo "$(date) -- command: docker exec -it Ansible_Node /bin/bash"

