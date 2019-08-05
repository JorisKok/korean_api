FROM debian:jessie

WORKDIR /usr/local/src

RUN apt-get update && apt-get install -y \
    libpq5 \
    libpq-dev \
    python \
    python-dev \
    python-pip \
    && pip install powa-web==3.2.0 \
    && apt-get purge -y --auto-remove libpq-dev python-dev python-pip \
    && rm -rf /var/lib/apt/lists/*

COPY powa-web.conf /etc/

EXPOSE 8888
CMD ["powa-web"]
