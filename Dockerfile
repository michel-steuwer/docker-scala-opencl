FROM  openjdk:8

MAINTAINER Michel Steuwer (michel.steuwer@glasgow.ac.uk)

ENV SCALA_VERSION 2.12.10
ENV SBT_VERSION 1.3.5

# Scala expects this file
RUN touch /usr/lib/jvm/java-8-openjdk-amd64/release

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

# Install OpenCL
RUN \
  echo "deb http://apt.llvm.org/jessie/ llvm-toolchain-jessie-8 main" >> /etc/apt/sources.list && \
  echo "deb-src http://apt.llvm.org/jessie/ llvm-toolchain-jessie-8 main" >> /etc/apt/sources.list && \
  wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key| apt-key add - && \
  apt-get update && apt-get install -y clang-8 cmake software-properties-common && \
  ln -s /usr/bin/clang-8 /usr/bin/clang && \
  ln -s /usr/bin/clang++-8 /usr/bin/g++ && \
  apt-add-repository non-free && \
  apt-get update && \
  apt-get install -y amd-opencl-dev
