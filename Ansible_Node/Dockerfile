FROM ubuntu:18.04
RUN apt update && apt install -y openssh-server vim openssl net-tools sudo
RUN useradd ansible-node -p $(openssl passwd -crypt "ansible") -s /bin/bash && usermod -aG sudo ansible-node
RUN mkdir /home/ansible-node && mkdir /home/ansible-node/.ssh && chmod 700 /home/ansible-node/.ssh
RUN chown -R ansible-node.ansible-node /home/ansible-node
CMD exec /bin/bash -c "service ssh start && trap : TERM INT; sleep infinity & wait"