FROM arm32v7/python:3.9-alpine

RUN apk update \
  && apk add --no-cache --virtual build-tools gcc g++ bash openssh git make \
  && apk add --no-cache --virtual build-headers postgresql-dev python3-dev musl-dev jpeg-dev zlib-dev libffi-dev freetype-dev czmq-dev lcms2-dev openjpeg-dev tiff-dev tk-dev tcl-dev \
  && apk add --no-cache --virtual runtime-deps busybox-extras czmq libzmq uwsgi-logzmq py-cffi gettext postgresql-client gnupg \
  && python -m pip install --upgrade pip \
  && pip install -r /requirements/local.txt \
  && apk del build-tools \
  && apk del build-headers \
  && rm -rf /root/.cache \
  && rm -rf /usr/lib/python3.8 \
  && rm -f /usr/lib/libpython3.* \
  && rm -f /usr/lib/libxml2.* \
  && rm -f /usr/lib/libstdc++.*

RUN mkdir -p /app/config
RUN mkdir -p /app/host

ENV YES_YOU_ARE_IN_A_CONTAINER=True

COPY requirements.txt /app/
RUN pip install -r /app/requirements.txt

COPY src/ /app/
RUN chmod a+x /app/bin/system_sensors.sh

CMD /app/bin/system_sensors.sh
