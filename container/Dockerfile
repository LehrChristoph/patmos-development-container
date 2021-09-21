# Step 1: Fetch OS container
FROM ubuntu:focal

#########################
# Bring Container up to date
#########################
# Step 2: install basics
RUN apt-get update && \ 
    apt-get upgrade -y && \
    apt-get install -y wget curl tar gnupg2 wget nano vim emacs \
    locales-all psmisc
# Step 3: install timezone utilities, required for adding new repositoreis
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

#########################
# Install Quartus dependencies
#########################
# Step 4: install quartus dependencies
RUN apt update && apt-get install -y libc6 libncurses6 \ 
    libxtst6 libxft2 libstdc++6 libc6-dev lib32z1 lib32ncurses6  \ 
    libbz2-1.0 libpng16-16 libpng-dev

#########################
# Instal Verilator dependencies
#########################
# Step 5: Verilator dependencies
RUN apt-get install -y gdb graphviz cmake clang clang-format-11 \
    lcov autoconf flex bison perl libgoogle-perftools-dev numactl \
    perl-doc ccache zlib1g zlib1g-dev libfl-dev

#########################
# Install Patmos Dependencies
#########################

# Add repository of sbt
# Step 6: add new sbt repository
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list && \
    echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list
# Step 7: add keys for repository
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add
# Step 8: install patmos dependencies
RUN apt-get update && apt-get install -y git openjdk-8-jdk gitk cmake make g++ texinfo flex bison \
    subversion libelf-dev graphviz libboost-dev libboost-program-options-dev ruby-full \
    liblpsolve55-dev python zlib1g-dev gtkwave gtkterm scala autoconf libfl2 expect sbt verilator

#########################
# Install Quartus
#########################

# Step 9: Set download link
# Quartus 20.1 does not work good with patmos, hello_puts example ends with an exception
# additonal version 20.1 has a very slow fitting process 7s vs 17 minutes using version 19.1 on my 5800X
#ARG URL=https://download.altera.com/akdlm/software/acdsinst/20.1std.1/720/ib_tar/Quartus-lite-20.1.1.720-linux.tar
ARG URL=http://download.altera.com/akdlm/software/acdsinst/19.1std/670/ib_tar/Quartus-lite-19.1.0.670-linux.tar

# Step 10: Downlaod and install Quartus
#    curl -O $URL && \
RUN mkdir /tmp/intelFPGA && cd /tmp/intelFPGA && \ 
    wget -nv $URL && \
    tar -xf *.tar -C /tmp/intelFPGA && \
    /tmp/intelFPGA/setup.sh --mode unattended --unattendedmodeui minimal --accept_eula 1 --installdir /opt/intel_FPGA && \
    rm -rf /tmp/intelFPGA 
    #&& \
    #echo "\nexport PATH=\$PATH:/opt/intel_FPGA/quartus/bin:/opt/intel_FPGA/modelsim_ase/bin" >> ~/.bashrc
ENV PATH=/opt/intel_FPGA/quartus/bin:/opt/intel_FPGA/modelsim_ase/bin:$PATH

#########################
# Setup Patmos
#########################

# Step 11: clone patmos installer
RUN mkdir  /opt/t-crest && cd /opt/t-crest && \
    git clone https://github.com/t-crest/patmos-misc.git misc
# Step 12: config patmos
RUN cd /opt/t-crest/misc && \
    sed -i "s/MAKEJ=-j2/MAKEJ=-j/" /opt/t-crest/misc/build.cfg.dist && \
    sed -i "s/INSTALL_SYMLINKS=false/INSTALL_SYMLINKS=true/" /opt/t-crest/misc/build.cfg.dist 
    #&& \
    #echo "\nexport PATH=\$PATH:/opt/t-crest/local/bin" >> ~/.bashrc
# Set Path variable for patmos tools
ENV PATH=/opt/t-crest/local/bin:$PATH

# Step 13: Build llvm
RUN cd /opt/t-crest/misc && \
    cp build.cfg.dist build.cfg && \
    sed -i "s/BUILDSH_TARGETS=\"gold llvm newlib compiler-rt pasim poseidon aegean\"/BUILDSH_TARGETS=\"llvm\"/" ./build.cfg && \
    cd .. && ./misc/build.sh
# Step 14: Build gold 
RUN cd /opt/t-crest/misc && \
    cp build.cfg.dist build.cfg && \
    sed -i "s/BUILDSH_TARGETS=\"gold llvm newlib compiler-rt pasim poseidon aegean\"/BUILDSH_TARGETS=\"gold\"/" ./build.cfg && \
    cd .. && ./misc/build.sh
# Step 15: Build newlib 
RUN cd /opt/t-crest/misc && \
    cp build.cfg.dist build.cfg && \
    sed -i "s/BUILDSH_TARGETS=\"gold llvm newlib compiler-rt pasim poseidon aegean\"/BUILDSH_TARGETS=\"newlib\"/" ./build.cfg && \
    cd .. && ./misc/build.sh
# Step 16: Build compiler-rt 
RUN cd /opt/t-crest/misc && \
    cp build.cfg.dist build.cfg && \
    sed -i "s/BUILDSH_TARGETS=\"gold llvm newlib compiler-rt pasim poseidon aegean\"/BUILDSH_TARGETS=\"compiler-rt\"/" ./build.cfg && \
    cd .. && ./misc/build.sh
# Step 17: Build poseidon 
RUN cd /opt/t-crest/misc && \
    cp build.cfg.dist build.cfg && \
    sed -i "s/BUILDSH_TARGETS=\"gold llvm newlib compiler-rt pasim poseidon aegean\"/BUILDSH_TARGETS=\"poseidon\"/" ./build.cfg && \
    cd .. && ./misc/build.sh
# Step 18: Build aegen 
RUN cd /opt/t-crest/misc && \
    cp build.cfg.dist build.cfg && \
    sed -i "s/BUILDSH_TARGETS=\"gold llvm newlib compiler-rt pasim poseidon aegean\"/BUILDSH_TARGETS=\"aegean\"/" ./build.cfg && \
    cd .. && ./misc/build.sh
# Step 19: Build platin 
RUN cd /opt/t-crest/misc && \
    cp build.cfg.dist build.cfg && \
    sed -i "s/BUILDSH_TARGETS=\"gold llvm newlib compiler-rt pasim poseidon aegean\"/BUILDSH_TARGETS=\"platin\"/" ./build.cfg && \
    cd .. && ./misc/build.sh
# Step 20: Build simulator
RUN cd /opt/t-crest/misc && \
    cp build.cfg.dist build.cfg && \
    sed -i "s/BUILDSH_TARGETS=\"gold llvm newlib compiler-rt pasim poseidon aegean\"/BUILDSH_TARGETS=\"simulator\"/" ./build.cfg && \
    cd .. && ./misc/build.sh
# Step 21: Build patmos 
RUN cd /opt/t-crest/misc && \
    cp build.cfg.dist build.cfg && \
    sed -i "s/BUILDSH_TARGETS=\"gold llvm newlib compiler-rt pasim poseidon aegean\"/BUILDSH_TARGETS=\"patmos\"/" ./build.cfg && \    
    cd .. && ./misc/build.sh && \
    rm -rf patmos

    
