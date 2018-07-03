build:
	# build the docker image
	@sudo docker build -t ${USER}/tasrcloud . 2>&1 | tee build.log

run: build
	# Run docker container for debugging purpose locally
	@sudo docker run --rm -ti \
	    -v ${PWD}/experiment:/experiment \
	    -v ${PWD}/app:/app \
	    ${USER}/tasrcloud  /bin/bash
