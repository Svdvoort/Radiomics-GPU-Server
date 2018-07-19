FROM ubuntu:18.04

# Following is needed because of bug in Docker
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

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

RUN ./Set-Up/First_setup.sh
#RUN ./Set-Up/Install_modules.sh
#RUN ./Install_Modules/Install_python_general.sh 2.7.13
#RUN ./Install_Modules/Install_python_general.sh 2.7.15
#RUN ./Install_Modules/Install_python_general.sh 3.7.0

RUN ./Set-Up/Install_slurm.sh
