
# CloudStream GEMPAK <IMG SRC="https://travis-ci.org/mjames-upc/CloudGEMPAK.svg?branch=master"/>

This docker image contains an instance of Unidata GEMPAK/NAWIPS running in a virtual X11 environment, accessed via a web browser.   

#### Build GEMPAK Docker image

    git clone https://github.com/Unidata/CloudGEMPAK.git
    cd CloudGEMPAK
    make build

#### Run GEMPAK

From the command line, run

    docker pull unidata/cloudstream:centos7
    docker run -p 6080:6080 -it unidata/cloudgempak

and then open [http://localhost:6080](http://localhost:6080)

![](https://www.unidata.ucar.edu/software/gempak/images/CloudGEMPAK.jpg)

### Notes

* This repository uses a modified `bootstrap.sh` which overrides the `unidata/cloudstream:centos7` file of the same name.
* If you wish to run multiple sessions, or leverage dynamic port mapping, you would start CloudGEMPAK as follows:

      docker run -P -it unidata/cloudgempak

* By default, CloudGEMPAK does not use a password. You may secure your CloudGEMPAK session with a password by using the `USEPASS` environmental variable to set a password for the session.  

      docker run -e USEPASS="password" -P -it unidata/cloudgempak

