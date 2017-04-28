FROM fgabriel/rpi-home-assistant:0.43.0
MAINTAINER Benoit Louy <benoit.louy@fastmail.com>

RUN [ "cross-build-start" ]

RUN set -x && apt-get update && apt-get -y --no-install-recommends install libpq-dev && apt-get clean && rm -rf /var/lib/apt/lists/ /tmp/ /var/tmp/*
RUN set -x && pip3 install --no-cache-dir psycopg2 && rm -rf /tmp/*

RUN [ "cross-build-end" ]

CMD [ "python3", "-m", "homeassistant", "--config", "/config" ]
