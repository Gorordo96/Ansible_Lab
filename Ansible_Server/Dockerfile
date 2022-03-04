FROM ubuntu:18.04
RUN  apt update && apt install -y software-properties-common && add-apt-repository --yes --update ppa:ansible/ansible
RUN apt install -y ansible
RUN ansible-inventory --list -y
RUN apt-get -y install sudo && apt -y install net-tools vim openssl
RUN useradd ansible-server -p $(openssl passwd -crypt "ansible") -s /bin/bash && usermod -aG sudo ansible-server
RUN mkdir /home/ansible-server && mkdir /home/ansible-server/.ssh && chmod 700 /home/ansible-server/.ssh
RUN chown -R ansible-server.ansible-server /home/ansible-server
USER ansible-server
CMD exec /bin/bash -c "chmod 600 /home/ansible-server/.ssh/id_rsa && chmod 600 /home/ansible-server/.ssh/id_rsa.pub && trap : TERM INT; sleep infinity & wait"