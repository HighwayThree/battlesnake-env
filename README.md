# Battlesnake Env
This repo is an experiment to developing in a docker environment.

Intended use is for a local ckan env, to have a cross-platform dev env for battlesnake.

Currently there is a docker-compose file, but hasn't been used or tested.


# Info
* Ckan v2.6.1

## Docker Images used
* ckan/postgresql:dev-v2.6
* ckan/solr:dev-v2.6
* redis:latest


# Developing with Docker
## Mac & Linux
There's a setup script included, simiply run the following:

	```
	$ bash setup.sh
	```

## Windows
