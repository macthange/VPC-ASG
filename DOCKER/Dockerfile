FROM alpine:3.10

ENV DOCKER_CHANNEL=stable \
    DOCKER_VERSION=19.03.2 \
    DOCKER_COMPOSE_VERSION=1.24.1 \
    DOCKER_SQUASH=0.2.0

# Install Docker, Docker Compose, Docker Squash
RUN apk update

# Install base and dev packages
RUN apk add --no-cache --virtual .build-deps bash make && apk add curl && apk add openssh git nodejs yarn


# Set timezone to UTC by default
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Install aws-cli
RUN apk -Uuv add groff less python py-pip
RUN pip install awscli
RUN apk --purge -v del py-pip
RUN rm /var/cache/apk/*
RUN apk -v --no-cache --update add musl-dev gcc python3 python3-dev        
RUN python3 -m ensurepip --upgrade && pip3 install --upgrade pip
RUN pip3 install --upgrade awscli aws-sam-cli
RUN pip3 uninstall --yes pip && apk del python3-dev gcc musl-dev

RUN apk --update --no-cache add device-mapper iptables util-linux ca-certificates libc-dev  libffi-dev openssl-dev \
         
    make &&  apk upgrade && \
    curl -fL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" | tar zx && \
    mv /docker/* /bin/ && chmod +x /bin/docker* && \
    pip install docker-compose==${DOCKER_COMPOSE_VERSION} && \
    curl -fL "https://github.com/jwilder/docker-squash/releases/download/v${DOCKER_SQUASH}/docker-squash-linux-amd64-v${DOCKER_SQUASH}.tar.gz" | tar zx && \
    mv /docker-squash* /bin/ && chmod +x /bin/docker-squash* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache

COPY entrypoint.sh /bin/entrypoint.sh
CMD ["/bin/bash"]
ENTRYPOINT ["entrypoint.sh"]
