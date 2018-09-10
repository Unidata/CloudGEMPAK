
# CloudStream GEMPAK <IMG SRC="https://travis-ci.org/mjames-upc/CloudGEMPAK.svg?branch=master"/> <IMG SRC="https://img.shields.io/docker/pulls/unidata/cloudgempak.svg"/>

This [docker image](https://hub.docker.com/r/unidata/cloudgempak/) contains an instance of Unidata GEMPAK/NAWIPS running in a virtual X11 environment provided by [CloudStream](https://github.com/Unidata/cloudstream). In this way, GEMPAK GUI and command line programs can be run through a browser, with `/data/ldm/gempak` being mounted from the host machine.

#### Run GEMPAK Docker Image

From the command line:

    docker run -p 6080:6080 -it unidata/cloudgempak

and then open [http://localhost:6080](http://localhost:6080)

![](https://www.unidata.ucar.edu/software/gempak/images/CloudGEMPAK.png)

#### Build GEMPAK Image

    git clone https://github.com/Unidata/CloudGEMPAK.git
    cd CloudGEMPAK
    make build

## Real-Time Data

To run CloudGEMPAK with a local data directory:

    docker run -p 6080:6080 -it -v /data/ldm/gempak:/data/ldm/gempak unidata/cloudgempak

The directory `/data/ldm/gempak` can be supplied either by a local LDM installation or by leveraging the [LDM Docker](https://github.com/Unidata/ldm-docker) project:

    git clone https://github.com/Unidata/ldm-docker.git 
    cd ldm-docker
    mv 
    



### Notes

* Specify the width and height on the command line:

      docker run -p 6080:6080 -e SIZEW=1024 -e SIZEH=768 unidata/cloudgempak

* The script `rungempak.sh` is included from the standalone GEMPAK Docker image ([hub.docker.com/r/unidata/gempak/](https://hub.docker.com/r/unidata/gempak/))
* This repository uses a modified `bootstrap.sh` which overrides the `unidata/cloudstream:centos7` file of the same name.
* If you wish to run multiple sessions, or leverage dynamic port mapping, you would start CloudGEMPAK as follows:

      docker run -P -it unidata/cloudgempak

* By default, CloudGEMPAK does not use a password. You may secure your CloudGEMPAK session with a password by using the `USEPASS` environmental variable to set a password for the session.  

      docker run -e USEPASS="password" -P -it unidata/cloudgempak

