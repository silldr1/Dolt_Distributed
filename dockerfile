FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
  curl unzip git sqlite3 && \
  curl -L https://github.com/dolthub/dolt/releases/latest/download/install.sh | bash

ENV PATH="/root/bin:$PATH"

CMD ["bash"]
