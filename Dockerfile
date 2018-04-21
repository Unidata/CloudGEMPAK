#####
# Copyright Unidata 2018
# Used to generate the 'unidata/cloudgempak' docker container.
# Visit us on the web at https://www.unidata.ucar.edu
#####

FROM unidata/cloudstream:centos7
MAINTAINER Michael James <mjames@ucar.edu>

###
# Install latest EL7 GEMPAK RPM
###

USER root
RUN useradd gempak
RUN yum install -y openmotif libX11 libXt libXext libXp libXft libXtst xorg-x11-xbitmaps csh gtk2 mesa-libGLU mesa-libGL mesa-dri-drivers
RUN rpm -ivh http://www.unidata.ucar.edu/downloads/gempak/latest/gempak-latest.el7.centos.x86_64.rpm
RUN chown -R ${CUSER}:${CUSER} ${HOME} /home/gempak
RUN yum install -y xorg-x11-fonts*
USER ${CUSER}
RUN echo ". /home/gempak/GEMPAK7/Gemenviron.profile" >> ~/.bash_profile

# Desktop environment
RUN echo "session.screen0.toolbar.visible: false" >> ~/.fluxbox/init
RUN echo "/usr/bin/fluxbox -log ~/.fluxbox/log" > ~/.fluxbox/startup

COPY bootstrap.sh ${HOME}/
COPY start.sh ${HOME}/
COPY Dockerfile ${HOME}/
COPY menu ${HOME}/.fluxbox/menu
COPY README.md ${HOME}/
COPY COPYRIGHT.md ${HOME}/
ENV COPYRIGHT_FILE COPYRIGHT.md
ENV README_FILE README.md

###
# Add the version number to the version file
###

RUN echo "CloudGEMPAK Version: $(rpm -qa |grep gempak| cut -d "-" -f 2) $(date)" >> $VERSION_FILE
USER root
RUN chown -R ${CUSER}:${CUSER} ${HOME}
RUN echo "#!/bin/bash -v" > ${HOME}/.bash_profile
RUN echo ". /home/gempak/GEMPAK7/Gemenviron.profile" >> ${HOME}/.bash_profile
USER ${CUSER}

###
# Override default windows session geometry and color depth.
###
ENV SIZEW 1280
ENV SIZEH 768
ENV CDEPTH 24

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG IMAGE
ARG VCS_REF
ARG VCS_URL
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$IMAGE \
      org.label-schema.description="An image based on centos 7 containing Unidata GEMPAK and an X_Window_System" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.schema-version="1.0"
