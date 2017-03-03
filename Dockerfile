# docker build . -t ckan && docker run -d -p 80:5000 --link db:db --link redis:redis --link solr:solr ckan

FROM debian:jessie
MAINTAINER Open Knowledge

ENV CKAN_HOME /usr/lib/ckan/default
ENV CKAN_CONFIG /etc/ckan/default
ENV CKAN_STORAGE_PATH /var/lib/ckan
ENV CKAN_EXT_PATH /usr/src
ENV CKAN_SITE_URL http://localhost:5000

# Install required packages
RUN apt-get -q -y update && apt-get -q -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
		python-dev \
        python-pip \
        python-virtualenv \
        libpq-dev \
        git-core \
	&& apt-get -q clean

# SetUp Virtual Environment CKAN
RUN mkdir -p $CKAN_HOME $CKAN_CONFIG $CKAN_STORAGE_PATH $CKAN_EXT_PATH
RUN virtualenv $CKAN_HOME
RUN ln -s $CKAN_HOME/bin/pip /usr/local/bin/ckan-pip
RUN ln -s $CKAN_HOME/bin/paster /usr/local/bin/ckan-paster

RUN ckan-pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.6.1#egg=ckan'
RUN ckan-pip install --upgrade -r $CKAN_HOME/src/ckan/requirements.txt

ADD ./src $CKAN_EXT_PATH
RUN find $CKAN_EXT_PATH -maxdepth 1 -mindepth 1 -type d -exec ckan-pip install -e {} \;

# SetUp CKAN
RUN ln -s $CKAN_HOME/src/ckan/ckan/config/who.ini $CKAN_CONFIG/who.ini

# Volumes
VOLUME /etc/ckan/default /var/lib/ckan /usr/src

# SetUp EntryPoint
COPY ./docker/ckan-entrypoint.sh /
RUN chmod +x /ckan-entrypoint.sh
ENTRYPOINT ["/ckan-entrypoint.sh"]

EXPOSE 5000

CMD ["ckan-paster","serve","--reload","--reload-interval=2","/etc/ckan/default/ckan.ini"]
