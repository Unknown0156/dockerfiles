FROM debian:11.7
RUN apt update && \
    apt install -y \
    lsb-release \
    gnupg2 \
    git \
    curl \
    wget \
    htop \
    nano \
    rsync \
    fio \
    iputils-ping \
    net-tools\
    dnsutils \
    netcat \
    nmap && \
    rm -rf /var/lib/apt/lists/*
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt update && \
    apt install -y \
    postgresql-client-14 && \
    rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/bin/bash", "-c", "--"]
CMD ["while true; do sleep 30; done;"]