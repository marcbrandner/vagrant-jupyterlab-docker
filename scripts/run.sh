#!/bin/bash

echo -e "\n--- Delete Existing JupyterLab Container"
docker inspect jupyterlab &> /dev/null
if [ $? -eq 0 ]; then
    docker rm -f jupyterlab || true > /dev/null
else
    echo "No running container 'jupyterlab' found."
fi

echo -e "\n--- Run Image"

JLAB_IMAGE='jupyterlab-custom:latest'

if docker images | grep jupyterlab-custom.*latest &> /dev/null; [ $? -ne 0 ]; then
    echo "Docker image '$JLAB_IMAGE' not available yet. Skip attempt to run the image."
    exit 0
fi

docker run \
    -d \
    --restart=always \
    -p 8888:8888 \
    -v /data:/home/jovyan/work \
    --env JUPYTER_ENABLE_LAB=yes \
    --name jupyterlab \
    $JLAB_IMAGE

echo -e "\n--- Cleanup Docker environment"
docker system prune -a -f