FROM fgabriel/rpi-home-assistant:0.42.4
MAINTAINER Benoit Louy <benoit.louy@fastmail.com>

RUN [ "cross-build-start" ]

RUN pip3 install psycopg2

RUN [ "cross-build-end" ]

CMD [ "python3", "-m", "homeassistant", "--config", "/config" ]
