FROM python:3.5
MAINTAINER Nic Roland <nicroland9@gmail.com>

COPY ./requirements.txt /opt/requirements.txt
RUN pip install -r /opt/requirements.txt

ENTRYPOINT python /opt/flaskapp/app.py
