#/bin/bash

brew install postgresql --with-python

source ./default/bin/activate

pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.6.1#egg=ckan'

pip install -r ./default/src/ckan/requirements.txt

docker run -d --name db ckan/postgresql
docker run -d --name solr ckan/solr
docker run -d --name redis redis


