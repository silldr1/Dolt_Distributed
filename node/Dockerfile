FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl unzip git gnupg \
  && curl -L https://github.com/dolthub/dolt/releases/latest/download/install.sh | bash \
  && apt-get clean

COPY init.sh /init.sh
RUN chmod +x /init.sh
