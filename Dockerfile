#Using a slim Debian base image tagged at a specific date
FROM debian:stable-20211011-slim@sha256:edb0a5915350ee6e2fedd8f9d0fe2e7f956f7a58f7f41b5e836e0bb7543e48a1

#The next two steps install OS-level dependencies
RUN apt update

RUN apt install -y gcc \
                   gcc-gfortran \
                   dos2unix

RUN mkdir /tmp/build/ && \
    mkdir /usr/local/swat681/  
# SWAT is a bit unusual in that it requires input files reside in the same directory as the executable!
#  So, we're putting the final binary in an unusual place to avoid mounting problems

COPY ./checksum.txt /tmp/build/checksum.txt
COPY Makefile /tmp/build/Makefile

RUN wget -O /tmp/build/rev_681_source.zip https://swat.tamu.edu/media/116557/rev681_source.zip &&  \
    cd /tmp/build && \
    md5sum checksum.txt && \
    unzip rev681_source.zip 

RUN cd /tmp/build/ && \
    dos2unix * && \
    make debug64 && \
    cp swat_debug64 /usr/local/swat681/swat

ENTRYPOINT ["/usr/local/swat681/swat"]
