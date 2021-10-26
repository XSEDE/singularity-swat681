#Using a slim Debian base image tagged at a specific date
FROM debian:stable-20211011-slim@sha256:edb0a5915350ee6e2fedd8f9d0fe2e7f956f7a58f7f41b5e836e0bb7543e48a1

#The next two steps install OS-level dependencies
RUN apt update

#Need to pin these versions down!
RUN apt install -y gcc-9 \
                   gfortran-9 \
                   dos2unix \
                   unzip \
                   wget \
                   make \
                   patch

#Interactive tools for testing - comment/uncomment as needed!
RUN apt install -y vim \
                   strace \
                   lsof 

RUN mkdir /tmp/build/ && \
    mkdir /usr/local/swat681/  
# SWAT is a bit unusual in that it requires input files reside in the same directory as the executable!
#  So, we're putting the final binary in an unusual place to avoid mounting problems

COPY ./checksum.txt /tmp/build/checksum.txt
COPY ./Makefile /tmp/build/Makefile
COPY ./swat_code_mods.patch /tmp/build/swat_code_mods.patch

RUN wget -O /tmp/build/rev_681_source.zip https://swat.tamu.edu/media/116557/rev681_source.zip &&  \
    cd /tmp/build && \
    md5sum checksum.txt && \
    unzip rev_681_source.zip 
#I do NOT understand why the resultant file from the download has a different name than the request file...

RUN cd /tmp/build/ && \
    dos2unix * && \
    patch -p0 < swat_code_mods.patch 

#Actual build steps
RUN cd /tmp/build/ && \
    make debug64 && \
    cp swat_debug64 /usr/local/swat681/swat

##Actual build steps
#RUN cd /tmp/build/ && \
#    make rel64 && \
#    cp swat_rel64 /usr/local/swat681/swat


ENTRYPOINT ["/usr/local/swat681/swat"]
