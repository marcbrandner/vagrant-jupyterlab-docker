#!/bin/bash

echo -e "\n--- Build a Custom JupyterLab Image"
sudo mkdir -p /tmp/empty_build_context
sudo docker buildx build \
    -t jupyterlab-custom \
    -f /vagrant/Dockerfile /tmp/empty_build_context

echo -e "\n--- Delete Existing JupyterLab Container"
sudo docker inspect jupyterlab > /dev/null
if [ $? -eq 0 ]; then
    sudo docker rm -f jupyterlab || true > /dev/null
fi

echo -e "\n--- Run Image"
sudo docker run \
    -d \
    --restart=always \
    -p 8888:8888 \
    -v /data:/home/jovyan/work \
    --env JUPYTER_ENABLE_LAB=yes \
    --name jupyterlab \
    jupyterlab-custom:latest

echo -e "\n--- Cleanup Docker environment"
sudo docker system prune -a -f