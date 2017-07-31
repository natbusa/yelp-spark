FROM python:latest

COPY requirements.txt /root/
RUN pip install -r /root/requirements.txt

ADD .hdfscli.cfg /root/

COPY app /srv
WORKDIR  /srv

ENTRYPOINT ["python"]
CMD ["app.py"]
