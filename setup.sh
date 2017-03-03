#/bin/bash

mkdir etc src

# Ckan Extensions
git clone https://github.com/jared-n-sams-fun-playhouses/ckanext-battlesnake.git ./src/ckanext-battlesnake

# Build
echo ""
echo "Building ckan image..."
docker build --rm --no-cache -t bs_ckan .

echo ""
echo "Stopping running containers..."
docker stop bs_ckan db solr redis

echo ""
echo "Removing containers..."
docker rm bs_ckan db solr redis

echo ""
echo "Running containers..."
docker run -d --name db ckan/postgresql:dev-v2.6
docker run -d --name solr ckan/solr:dev-v2.6
docker run -d --name redis redis

echo ""
echo "Running Ckan container..."
# Mac and Windows requires a full bath for the volume share
docker run -it -p 5000:5000 -v /Users/jared/h3/battlesnake-env/src:/usr/src --link db:db --link solr:solr --link redis:redis --name bs_ckan bs_ckan
