FROM ubuntu:18.04

WORKDIR /home/test/
RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get autoremove
RUN apt-get autoclean
RUN apt-get install -y git wget

# Need timezone for tzdata install
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD . /home/test/Radiomics-GPU-Server
WORKDIR /home/test/Radiomics-GPU-Server

RUN ./First_setup.sh
RUN ./Set-Up/Install_modules.sh
RUN ./Install_Modules/Install_python_2.7.15.sh
