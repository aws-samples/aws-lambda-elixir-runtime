# Start from base Amazon Linux 2 Docker image
FROM amazonlinux:2

ENV ERLANG_VERSION="24.3.4.1-1"
ENV ELIXIR_VERSION="v1.13.0"
ENV LANG=C.UTF-8

RUN yum -y install zip

# Install EPEL repo
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E '%{rhel}').noarch.rpm

# Install required package for building
RUN yum -y install --setopt=tsflags=nodocs epel-release wget unzip uuid less bzip2 git-core inotify-tools gcc make tar awscli

# Install Erlang (modify the version as you wish)
RUN yum -y install https://packages.erlang-solutions.com/erlang/rpm/centos/7/x86_64/esl-erlang_${ERLANG_VERSION}~centos~7_amd64.rpm

# Install Elixir
# Download the official precompiled version
RUN wget https://github.com/elixir-lang/elixir/releases/download/${ELIXIR_VERSION}/Precompiled.zip

# Create a folder to unzip the contents
RUN mkdir /opt/elixir
RUN cd /opt/elixir/ && mv /Precompiled.zip . && unzip Precompiled.zip && rm Precompiled.zip 

# Build the symbolic link
RUN ln -s /opt/elixir/bin/iex /usr/local/bin/iex
RUN ln -s /opt/elixir/bin/mix /usr/local/bin/mix
RUN ln -s /opt/elixir/bin/elixir /usr/local/bin/elixir
RUN ln -s /opt/elixir/bin/elixirc /usr/local/bin/elixirc

RUN mix local.hex --force && \
    mix local.rebar --force