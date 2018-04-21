#####
# Copyright Unidata 2018 (www.unidata.ucar.edu)
# Used to generate the 'unidata/cloudgempak' docker container.
# Based on the GEMPAK Dockerfile 
#    https://github.com/Unidata/gempak/blob/master/build/docker/Dockerfile.gempak
#####

FROM unidata/cloudstream:centos7
MAINTAINER Michael James <mjames@ucar.edu>

###
# Install latest EL7 GEMPAK RPM and dependencies
###

USER root
RUN yum install -y openmotif libX11 libXt libXext libXp libXft libXtst xorg-x11-xbitmaps xorg-x11-fonts* \
  csh \
  which \
  libgfortran \
  python-pip \
  gtk2 \
  mesa-libGLU \
  mesa-libGL \
  mesa-dri-drivers 
RUN useradd -ms /bin/bash gempak
RUN rpm -ivh http://www.unidata.ucar.edu/downloads/gempak/latest/gempak-latest.el7.centos.x86_64.rpm
RUN pip install python-awips six shapely numpy
RUN chown -R ${CUSER}:${CUSER} ${HOME} /home/gempak

###
# Environment
###

USER ${CUSER}
RUN echo "#!/bin/bash -v" > ~/.bash_profile
RUN echo ". /home/gempak/GEMPAK7/Gemenviron.profile" >> ~/.bash_profile
RUN echo "session.screen0.toolbar.visible: false" >> ~/.fluxbox/init
RUN echo "/usr/bin/fluxbox -log ~/.fluxbox/log" > ~/.fluxbox/startup
RUN echo "CloudGEMPAK Version: $(rpm -qa |grep gempak| cut -d "-" -f 2) $(date)" >> $VERSION_FILE

### 
# Files from this repo
###

COPY bootstrap.sh ${HOME}/
COPY start.sh ${HOME}/
COPY rungempak.sh ${HOME}/
COPY Dockerfile ${HOME}/
COPY menu ${HOME}/.fluxbox/menu
COPY README.md ${HOME}/
COPY COPYRIGHT.md ${HOME}/
ENV COPYRIGHT_FILE COPYRIGHT.md
ENV README_FILE README.md
USER root
RUN chown -R ${CUSER}:${CUSER} ${HOME}
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
