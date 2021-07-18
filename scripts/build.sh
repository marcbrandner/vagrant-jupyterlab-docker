#!/bin/bash

echo -e "\n--- Build a Custom JupyterLab Image"
sudo mkdir -p /tmp/empty_build_context
sudo docker buildx build \
    -t jupyterlab-custom \
    -f /vagrant/Dockerfile /tmp/empty_build_context