FROM  openjdk:8

ENV SCALA_VERSION 2.13.3
ENV SBT_VERSION 1.3.13

# Install Scala
## Piping curl directly in tar
RUN \
  curl -fsL http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb http://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

# Install build tools
RUN \
  apt-get update && \
  apt-get install -y cmake software-properties-common g++ clang-7 libxtst6 libxrender1 libxext6 && \
  ln -s /usr/bin/clang-7 /usr/bin/clang && \
  ln -s /usr/bin/clang-cpp-7 /usr/bin/clang++

# Copy AMD APP SDK into container
COPY AMD-APP-SDKInstaller-v3.0.130.136-GA-linux64.tar.bz2 /data/AMD-APP-SDKInstaller-v3.0.130.136-GA-linux64.tar.bz2

# Install OpenCL
RUN \
  cd /data && \
  tar xf AMD-APP-SDKInstaller-v3.0.130.136-GA-linux64.tar.bz2 && \
  ./AMD-APP-SDK-v3.0.130.136-GA-linux64.sh -- -s true -a yes && \
  export LD_LIBRARY_PATH="/opt/AMDAPPSDK-3.0/lib/x86_64/sdk/:/opt/AMDAPPSDK-3.0/lib/x86_64/:$LD_LIBRARY_PATH" && \
  clinfo


ENV LIBRARY_PATH="/opt/AMDAPPSDK-3.0/lib/x86_64/sdk/:/opt/AMDAPPSDK-3.0/lib/x86_64/:$LIBRARY_PATH"
ENV LD_LIBRARY_PATH="/opt/AMDAPPSDK-3.0/lib/x86_64/sdk/:/opt/AMDAPPSDK-3.0/lib/x86_64/:$LD_LIBRARY_PATH"
ENV CPATH="/opt/AMDAPPSDK-3.0/include/"
