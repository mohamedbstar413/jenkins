#Docker file for initializing an agent as a docker container
FROM ubuntu 
RUN apt-get update -qy && apt-get install openjdk-17-jdk -qy && \
apt-get install openssh-server -qy && apt-get install -qy maven

RUN apt-get install -qy git && sed -i 's|session    required   pam_loginuid.so|session    optional   pam_loginuid.so|g' /etc/pam.d/sshd && \ 
mkdir -p /var/run/sshd

RUN apt-get install -y passwd

RUN useradd -ms /bin/bash jenkins -d /home/jenkins

RUN echo "jenkins:jenkins" | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]