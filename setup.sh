#/bin/bash

brew install postgresql --with-python

source ./default/bin/activate

pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.6.1#egg=ckan'

pip install -r ./default/src/ckan/requirements.txt

docker run -d -p 5432:5432 --name db ckan/postgresql
docker run -d -p 8983:8983 --name solr ckan/solr
docker run -d -p 6379:6379 --name redis redis


