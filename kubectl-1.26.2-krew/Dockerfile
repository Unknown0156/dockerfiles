FROM kubectl:1.26.2
USER root
RUN apt update && apt install -y curl && rm -rf /var/lib/apt/lists/*
RUN curl -fsSLO https://github.com/kubernetes-sigs/krew/releases/latest/download/krew-linux_amd64.tar.gz
RUN tar zxvf krew-linux_amd64.tar.gz
RUN ./krew-linux_amd64 install krew
ENV KREW_ROOT=/.krew
ENV PATH ${KREW_ROOT}/bin:$PATH
RUN rm -f krew-linux_amd64.tar.gz && rm -rf krew-linux_amd64