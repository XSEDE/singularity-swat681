BootStrap: docker
From: library/debian:stable-20211011-slim@sha256:edb0a5915350ee6e2fedd8f9d0fe2e7f956f7a58f7f41b5e836e0bb7543e48a1

%files

  ./checksum.txt /tmp/checksum.txt
  ./Makefile /tmp/Makefile
  
%post
  mkdir /tmp/build
  mkdir /usr/local/swat681
  mv /tmp/checksum.txt /tmp/Makefile /tmp/build

  apt update
  apt install -y gcc \
                 gcc-gfortran \
                 dos2unix

  wget -O /tmp/build/rev_681_source.zip https://swat.tamu.edu/media/116557/rev681_source.zip
  cd /tmp/build 
  md5sum checksum.txt 
  unzip rev681_source.zip 

  cd /tmp/build/
  dos2unix * 
  make debug64 
  cp swat_debug64 /usr/local/swat681/swat

# SWAT is a bit unusual in that it requires input files reside in the same directory as the executable!
#  So, we're putting the final binary in an unusual place to avoid mounting problems


%runscript
  /usr/local/swat681/swat

%help
 This container includes the Soil and Water Assessment Tool (https://swat.tamu.edu/software/)
 revision 681,
 built for use on amd64 Linux systems. The binary is installed at /usr/local/swat681/swat.
 At run-time, any input files MUST be bind-mounted to /usr/local/swat681 - for example:
