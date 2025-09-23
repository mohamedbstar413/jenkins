#Docker file for docker container as a jenkins agent
FROM ubuntu

RUN apt-get update -y
RUN apt-get install -y nodejs
RUN apt-get install -y openjdk-17-jdk
RUN apt-get install -qy git
RUN apt-get install openssh-server -qy
RUN sed -i 's|session    required   pam_loginuid.so|session    optional   pam_loginuid.so|g' /etc/pam.d/sshd 
RUN mkdir -p /var/run/sshd

RUN apt-get install -y passwd

RUN useradd -ms /bin/bash jenkins -d /home/jenkins

RUN echo "jenkins:jenkins" | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]