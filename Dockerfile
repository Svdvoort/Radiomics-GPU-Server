FROM ubuntu:18.04

WORKDIR /home/test/
RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get autoremove
RUN apt-get autoclean
RUN apt-get install -y git

RUN git clone https://github.com/Svdvoort/Radiomics-GPU-Server /home/test/Radiomics-GPU-Server
WORKDIR /home/test/Radiomics-GPU-Server

RUN ./First_setup.sh
RUN ./Install_modules.sh
