FROM benoitlouy/rpi-python:3.5.2
MAINTAINER Benoit Louy <benoit.louy@fastmail.com>

VOLUME /config

RUN [ "cross-build-start" ]

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN pip3 install --no-cache-dir colorlog cython

# For the nmap tracker
RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends nmap net-tools cython3 libudev-dev sudo git && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN set -x && \
    git clone --branch python3 --recursive --depth 1 https://github.com/OpenZWave/python-openzwave.git && \
    cd python-openzwave && \
    pip3 install --upgrade cython==0.24.1 && \
    PYTHON_EXEC=`which python3` make build && \
    PYTHON_EXEC=`which python3` make install && \
    mkdir -p /usr/local/share/python-openzwave && \
    cp -r /usr/src/app/python-openzwave/openzwave/config /usr/local/share/python-openzwave/config

ENV HASS_VERSION 0.39.1
RUN set -x && \
    git clone https://github.com/home-assistant/home-assistant.git && \
    cd home-assistant && \
    git checkout $HASS_VERSION && \
    rm -rf .git

RUN set -x && \
    pip3 install --no-cache-dir -r home-assistant/requirements_all.txt && \
    pip3 install mysqlclient psycopg2 uvloop

RUN [ "cross-build-end" ]

WORKDIR /usr/src/app/home-assistant
CMD [ "python", "-m", "homeassistant", "--config", "/config" ]
