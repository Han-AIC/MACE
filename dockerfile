FROM ubuntu:latest

LABEL Name=MACE Version=1.0

RUN apt-get update
RUN apt-get -qq update
RUN apt-get install -y nodejs python3.6

RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 10

RUN apt-get install python-dev -y
RUN apt-get install curl -y
RUN apt install python3-distutils -y
RUN curl https://bootstrap.pypa.io/get-pip.py | python

RUN apt-get install npm -y
RUN npm install -g webppl
RUN npm install --prefix ~/.webppl webppl-csv
RUN webppl --version

EXPOSE 80
ADD ./MACE /MACE/
ADD ./MACEControlCenter /MACEControlCenter/
RUN chmod 0644 /MACEControlCenter/*
RUN chmod +x /MACEControlCenter/*

CMD ["bash"]
